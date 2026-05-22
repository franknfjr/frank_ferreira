defmodule Mix.Tasks.Blog.GenCover do
  @shortdoc "Generate a 1200x630 cover image for a blog post via Gemini (Nano Banana)"

  @moduledoc """
  Generates a cover image for a blog post using Gemini 2.5 Flash Image
  ("Nano Banana") and writes it to `priv/static/images/blog/{post-id}.png` at
  the OG/Twitter standard 1200x630.

  The same file is served as the post cover **and** as `og:image` /
  `twitter:image` — `lib/frank_ferreira_web/seo.ex` already points both at
  `/images/blog/{post.id}.png`, so we only generate one size.

  ## Usage

      # Generate from a known post id (looks up the EN markdown to derive prompt)
      GEMINI_API_KEY=... mix blog.gen_cover welcome-to-my-blog

      # Pass a markdown file path explicitly
      GEMINI_API_KEY=... mix blog.gen_cover priv/posts/2026/03-12-on-boring-backends-en_US.md

      # Override the auto-built prompt
      GEMINI_API_KEY=... mix blog.gen_cover welcome-to-my-blog --prompt "editorial illustration of a vintage Pentium tower on a warm cream background, terracotta accent"

      # Don't overwrite an existing file (default overwrites)
      GEMINI_API_KEY=... mix blog.gen_cover welcome-to-my-blog --no-force

  ## Style

  Cover art follows the editorial dev-journal direction: warm paper background,
  deep ink, terracotta accent, no text in the image. The prompt is built from
  the post's title + description + tags unless overridden via `--prompt`.
  """

  use Mix.Task

  @target_w 1200
  @target_h 630
  @output_dir "priv/static/images/blog"

  @model "gemini-2.5-flash-image"

  @style_suffix """
  Editorial dev-journal illustration. Warm cream paper background (#f4efe6), \
  deep ink details, a single terracotta accent (#c0532c). \
  Hand-drawn feel, hairline rules, subtle texture. No text, no letters, no logos. \
  Wide 1200x630 composition with clear breathing room. \
  Minimal, contemplative, slightly nostalgic.\
  """

  @impl Mix.Task
  def run(args) do
    {opts, rest, _} =
      OptionParser.parse(args,
        strict: [prompt: :string, force: :boolean, model: :string],
        aliases: [p: :prompt]
      )

    target = List.first(rest) || Mix.raise("Usage: mix blog.gen_cover <post-id|markdown-path> [--prompt …]")

    api_key =
      System.get_env("GEMINI_API_KEY") ||
        System.get_env("GOOGLE_API_KEY") ||
        Mix.raise("GEMINI_API_KEY (or GOOGLE_API_KEY) env var is required")

    Mix.Task.run("app.start")

    {post_id, md_path} = resolve_target(target)

    prompt =
      case Keyword.get(opts, :prompt) do
        nil -> build_prompt_from_markdown(md_path)
        custom -> custom <> "\n\n" <> @style_suffix
      end

    Mix.shell().info("→ Post: #{post_id}")
    Mix.shell().info("→ Prompt:\n#{prompt}\n")

    siblings = find_siblings(md_path)
    primary = Path.join(@output_dir, "#{post_id}.png")

    if File.exists?(primary) and Keyword.get(opts, :force, true) == false do
      Mix.raise("#{primary} already exists. Re-run with --force to overwrite.")
    end

    model = Keyword.get(opts, :model, @model)
    png = generate_image!(api_key, model, prompt)

    File.mkdir_p!(@output_dir)
    File.write!(primary, png)
    Mix.shell().info("✓ Wrote #{byte_size(png)} bytes to #{primary}")

    case verify_dimensions(primary) do
      {:ok, {w, h}} ->
        Mix.shell().info("✓ Dimensions: #{w}×#{h}")
        if {w, h} != {@target_w, @target_h}, do: resize_to_target!(primary)

      :unknown ->
        Mix.shell().info("  (skipping dimension check)")
    end

    # Mirror the PNG under every sibling id so SEO og:image works in every
    # locale, and inject the markdown image at the top of each translation
    # if it isn't there yet.
    web_path = "/images/blog/#{post_id}.png"

    for {sib_id, sib_md, sib_title} <- siblings do
      sib_png = Path.join(@output_dir, "#{sib_id}.png")

      unless sib_id == post_id do
        File.cp!(primary, sib_png)
        Mix.shell().info("✓ Copied → #{sib_png}")
      end

      case inject_cover_markdown(sib_md, web_path, sib_title) do
        :already_present ->
          Mix.shell().info("  · #{sib_md} already references a cover, skipped")

        :ok ->
          Mix.shell().info("✓ Injected cover into #{sib_md}")
      end
    end
  end

  # Sibling = .md files in the same year directory sharing the `MM-DD-` prefix.
  # Returns [{post_id, md_path, title}] including the original.
  defp find_siblings(md_path) do
    dir = Path.dirname(md_path)
    base = Path.basename(md_path)

    prefix =
      case Regex.run(~r/^(\d+-\d+-)/, base) do
        [_, p] -> p
        _ -> base
      end

    Path.wildcard("#{dir}/#{prefix}*.md")
    |> Enum.map(fn p ->
      id =
        p
        |> Path.basename(".md")
        |> String.replace(~r/^\d+-\d+-/, "")
        |> String.replace(~r/-en_US$/, "")

      title = read_title(p) || id
      {id, p, title}
    end)
  end

  defp read_title(path) do
    case File.read(path) do
      {:ok, body} ->
        case Regex.run(~r/title:\s*"([^"]+)"/, body) do
          [_, t] -> t
          _ -> nil
        end

      _ ->
        nil
    end
  end

  # Insert `![title](web_path)` immediately after the `---` front-matter terminator.
  defp inject_cover_markdown(md_path, web_path, title) do
    body = File.read!(md_path)

    if String.contains?(body, web_path) do
      :already_present
    else
      img = "![#{title}](#{web_path})"

      new_body =
        case String.split(body, "\n---\n", parts: 2) do
          [front, rest] ->
            front <> "\n---\n\n" <> img <> "\n\n" <> String.trim_leading(rest)

          _ ->
            img <> "\n\n" <> body
        end

      File.write!(md_path, new_body)
      :ok
    end
  end

  defp resize_to_target!(path) do
    cond do
      System.find_executable("sips") ->
        # macOS: resize so the *shortest* side fits, then crop to 1200×630
        {_, 0} =
          System.cmd("sips", [
            "-z",
            to_string(@target_h),
            to_string(@target_w),
            "--padToHeightWidth",
            to_string(@target_h),
            to_string(@target_w),
            path
          ])

        Mix.shell().info("✓ Resized to #{@target_w}×#{@target_h} via sips")

      System.find_executable("magick") ->
        {_, 0} =
          System.cmd("magick", [
            path,
            "-resize",
            "#{@target_w}x#{@target_h}^",
            "-gravity",
            "center",
            "-extent",
            "#{@target_w}x#{@target_h}",
            path
          ])

        Mix.shell().info("✓ Resized to #{@target_w}×#{@target_h} via ImageMagick")

      true ->
        Mix.shell().info("  ⚠ Neither sips nor ImageMagick available — install one to auto-resize.")
    end
  end

  defp resolve_target(target) do
    cond do
      File.exists?(target) and String.ends_with?(target, ".md") ->
        {derive_id_from_filename(target), target}

      true ->
        case find_markdown_for_id(target) do
          nil ->
            Mix.raise(
              "No markdown found for post id #{inspect(target)} under priv/posts/. " <>
                "Pass the path to the .md file directly."
            )

          path ->
            {target, path}
        end
    end
  end

  defp find_markdown_for_id(id) do
    "priv/posts/**/*#{id}*.md"
    |> Path.wildcard()
    # Prefer the EN variant (clearer prompts for the image model)
    |> Enum.sort_by(fn p -> if String.contains?(p, "-en_US"), do: 0, else: 1 end)
    |> List.first()
  end

  defp derive_id_from_filename(path) do
    path
    |> Path.basename(".md")
    |> String.replace(~r/^\d+-\d+-/, "")
    |> String.replace(~r/-en_US$/, "")
  end

  defp build_prompt_from_markdown(path) do
    body = File.read!(path)

    {attrs, prose} =
      case String.split(body, "\n---\n", parts: 2) do
        [front, rest] ->
          attrs =
            try do
              {parsed, _} = Code.eval_string(front)
              parsed
            rescue
              _ -> %{}
            end

          {attrs, rest}

        _ ->
          {%{}, body}
      end

    title = Map.get(attrs, :title, "")
    description = Map.get(attrs, :description, "")
    tags = Map.get(attrs, :tags, [])

    intro =
      prose
      |> String.split("\n\n")
      |> Enum.reject(&(String.starts_with?(&1, "#") or String.starts_with?(&1, "!") or &1 == ""))
      |> List.first()
      |> Kernel.||("")
      |> String.slice(0, 280)

    """
    Generate a cover illustration for a blog post.

    Title: #{title}
    Summary: #{description}
    Tags: #{Enum.join(tags, ", ")}

    Article opens with: #{intro}

    #{@style_suffix}
    """
  end

  # ── Gemini call ────────────────────────────────────────────────

  defp generate_image!(api_key, model, prompt) do
    url =
      "https://generativelanguage.googleapis.com/v1beta/models/#{model}:generateContent?key=#{api_key}"

    body =
      Jason.encode!(%{
        contents: [%{parts: [%{text: prompt}]}],
        generationConfig: %{
          responseModalities: ["IMAGE"],
          imageConfig: %{aspectRatio: "16:9"}
        }
      })

    case HTTPoison.post(url, body, [{"content-type", "application/json"}],
           recv_timeout: 120_000,
           timeout: 30_000
         ) do
      {:ok, %{status_code: 200, body: resp}} ->
        extract_image!(resp)

      {:ok, %{status_code: status, body: resp}} ->
        Mix.raise("Gemini returned HTTP #{status}:\n#{resp}")

      {:error, err} ->
        Mix.raise("HTTP error: #{inspect(err)}")
    end
  end

  defp extract_image!(resp_body) do
    parsed = Jason.decode!(resp_body)

    parts =
      parsed
      |> get_in(["candidates", Access.at(0), "content", "parts"])
      |> Kernel.||([])

    inline =
      Enum.find_value(parts, fn part ->
        get_in(part, ["inlineData", "data"]) || get_in(part, ["inline_data", "data"])
      end)

    case inline do
      nil ->
        Mix.raise("Gemini response had no inline image data:\n#{inspect(parsed, pretty: true)}")

      b64 ->
        Base.decode64!(b64)
    end
  end

  # ── Dimension verification ─────────────────────────────────────

  defp verify_dimensions(path) do
    case File.open(path, [:read, :binary], fn file ->
           IO.binread(file, 24)
         end) do
      {:ok, <<137, 80, 78, 71, 13, 10, 26, 10, _len::32, "IHDR", w::32, h::32>>} ->
        {:ok, {w, h}}

      _ ->
        :unknown
    end
  end
end
