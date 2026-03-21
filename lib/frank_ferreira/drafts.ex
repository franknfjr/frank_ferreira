defmodule FrankFerreira.Drafts do
  @drafts_dir Path.join(:code.priv_dir(:frank_ferreira), "drafts")
  @posts_dir Path.join(:code.priv_dir(:frank_ferreira), "posts")

  def drafts_dir, do: @drafts_dir

  def list do
    @drafts_dir
    |> File.ls!()
    |> Enum.filter(&String.ends_with?(&1, ".md"))
    |> Enum.map(&parse_draft/1)
    |> Enum.sort_by(& &1.updated_at, {:desc, DateTime})
  end

  def get(id) do
    path = draft_path(id)

    if File.exists?(path) do
      content = File.read!(path)
      {frontmatter, body} = split_frontmatter(content)
      {:ok, %{id: id, frontmatter: frontmatter, body: body, path: path}}
    else
      {:error, :not_found}
    end
  end

  def save(id, frontmatter, body) do
    File.mkdir_p!(@drafts_dir)
    content = build_file(frontmatter, body)
    File.write!(draft_path(id), content)
    :ok
  end

  def delete(id) do
    path = draft_path(id)

    if File.exists?(path) do
      File.rm!(path)
      :ok
    else
      {:error, :not_found}
    end
  end

  def publish(id, frontmatter, body) do
    date = frontmatter["date"] || Date.to_string(Date.utc_today())
    [year, month, day] = String.split(date, "-")

    lang_suffix =
      case frontmatter["language"] do
        "en" -> "-en_US"
        _ -> ""
      end

    year_dir = Path.join(@posts_dir, year)
    File.mkdir_p!(year_dir)

    filename = "#{month}-#{day}-#{id}#{lang_suffix}.md"
    post_path = Path.join(year_dir, filename)

    publish_frontmatter =
      frontmatter
      |> Map.put("published", "true")
      |> Map.delete("date")

    content = build_file(publish_frontmatter, body)
    File.write!(post_path, content)

    delete(id)

    {:ok, post_path}
  end

  def generate_id(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[àáâãäå]/, "a")
    |> String.replace(~r/[èéêë]/, "e")
    |> String.replace(~r/[ìíîï]/, "i")
    |> String.replace(~r/[òóôõö]/, "o")
    |> String.replace(~r/[ùúûü]/, "u")
    |> String.replace(~r/[ç]/, "c")
    |> String.replace(~r/[^a-z0-9\s-]/, "")
    |> String.replace(~r/\s+/, "-")
    |> String.trim("-")
  end

  defp draft_path(id), do: Path.join(@drafts_dir, "#{id}.md")

  defp parse_draft(filename) do
    id = String.replace_suffix(filename, ".md", "")
    path = Path.join(@drafts_dir, filename)
    content = File.read!(path)
    {frontmatter, _body} = split_frontmatter(content)
    stat = File.stat!(path, time: :posix)

    %{
      id: id,
      title: frontmatter["title"] || id,
      language: frontmatter["language"] || "br",
      updated_at: DateTime.from_unix!(stat.mtime)
    }
  end

  defp split_frontmatter(content) do
    case String.split(content, "\n---\n", parts: 2) do
      [header, body] ->
        frontmatter = parse_frontmatter(header)
        {frontmatter, body}

      [body] ->
        {%{}, body}
    end
  end

  defp parse_frontmatter(header) do
    header
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
      case String.split(line, ": ", parts: 2) do
        [key, value] ->
          Map.put(acc, String.trim(key), String.trim(value, "\""))

        _ ->
          acc
      end
    end)
  end

  defp build_file(frontmatter, body) do
    header =
      frontmatter
      |> Enum.reject(fn {_k, v} -> v == "" or is_nil(v) end)
      |> Enum.map_join("\n", fn {k, v} -> "#{k}: \"#{v}\"" end)

    "#{header}\n---\n#{body}"
  end
end
