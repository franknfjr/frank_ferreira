defmodule FrankFerreira.Blog.Post do
  @words_per_minute 200

  @enforce_keys [
    :id,
    :author,
    :title,
    :body,
    :description,
    :tags,
    :created_at,
    :updated_at,
    :published,
    :twitter,
    :language,
    :read_minutes,
    :cover_image
  ]
  defstruct [
    :id,
    :author,
    :title,
    :body,
    :description,
    :tags,
    :created_at,
    :updated_at,
    :published,
    :twitter,
    :language,
    :read_minutes,
    :cover_image
  ]

  def build(filename, attrs, body) do
    body = highlight_code(body)
    {:ok, document} = Floki.parse_document(body)

    word_count = Floki.text(document) |> String.split(" ") |> Enum.count()
    read_minutes = ceil(word_count / @words_per_minute)

    cover_image =
      case Floki.find(document, "img") do
        [{_, attrs, _} | _] -> List.keyfind(attrs, "src", 0, {"src", nil}) |> elem(1)
        _ -> nil
      end

    [year, month_day_id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    created_at = Date.from_iso8601!("#{year}-#{month}-#{day}")

    {id, language} =
      cond do
        String.ends_with?(id, "-en_US") ->
          id = String.replace(id, "-en_US", "")
          {id, "en"}

        true ->
          {id, "br"}
      end

    struct!(
      __MODULE__,
      [
        id: id,
        created_at: created_at,
        body: body,
        language: language,
        read_minutes: read_minutes,
        cover_image: cover_image
      ] ++
        Map.to_list(attrs)
    )
  end

  # Syntax highlighting for published posts. NimblePublisher's built-in makeup
  # highlighter only matches a bare `<pre><code class="elixir">` and only knows
  # Elixir/Erlang, while our Markdown post-processor rewrites code blocks to
  # `<pre id=… phx-update="ignore"><code class="…language-X">` and the posts
  # compare many languages (Python, JS, Ruby, Go, bash). So we highlight every
  # block here with MDEx (autumnus), which supports them all, and inject the
  # coloured spans back into the existing <code>, keeping the copy button and ids.
  @code_block_regex ~r{(<code[^>]*\bclass="[^"]*language-(\w+)[^"]*"[^>]*>)(.*?)(</code>)}s
  @skip_highlight ~w(plain text mermaid)
  @highlight_theme "gruvbox_light"

  defp highlight_code(body) do
    Regex.replace(@code_block_regex, body, fn full, open_tag, lang, code, close_tag ->
      with false <- lang in @skip_highlight,
           spans when is_binary(spans) <- highlight_inner(code, lang) do
        open_tag <> spans <> close_tag
      else
        _ -> full
      end
    end)
  end

  defp highlight_inner(escaped_code, lang) do
    code = escaped_code |> HtmlEntities.decode() |> String.trim_trailing()
    fenced = "```" <> lang <> "\n" <> code <> "\n```"

    html =
      case MDEx.to_html(fenced, features: [syntax_highlight_theme: @highlight_theme]) do
        {:ok, html} -> html
        html when is_binary(html) -> html
        _ -> ""
      end

    case Regex.run(~r{<code[^>]*>(.*)</code>}s, html) do
      [_, inner] -> inner
      _ -> nil
    end
  rescue
    _ -> nil
  end
end
