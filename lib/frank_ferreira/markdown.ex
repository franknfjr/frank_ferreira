defmodule FrankFerreira.Markdown do
  def post_processor(
        {"blockquote", _attrs, [{_tag, [{"class", admonition}], _children, _meta} | _],
         _meta_diff} =
          line
      )
      when admonition in ["warning", "info", "error", "neutral", "tip"] do
    class =
      case admonition do
        "warning" -> "admonition-warning"
        "info" -> "admonition-info"
        "error" -> "admonition-error"
        "neutral" -> "admonition-neutral"
        _ -> "admonition-tip"
      end

    Earmark.AstTools.merge_atts_in_node(line, class: "admonition #{class}")
  end

  # Add link for `## Heading`
  def post_processor({"h2", attrs, children, meta}) do
    id = children |> get_text() |> format_id()
    attrs = [{"id", id}, {"class", "section-heading"} | attrs]
    {"h2", attrs, nil, meta}
  end

  # Update <code> for code highlighting
  def post_processor({"code", attrs, _children, meta}) do
    attrs =
      case attrs do
        [{"class", "inline"}] ->
          attrs

        [{"class", "mermaid language-mermaid"}] ->
          id = "Markdown_diagram_#{:erlang.unique_integer([:positive])}"
          [{"id", id} | attrs]

        _ ->
          attrs = if attrs == [], do: [{"class", "language-plain"}], else: attrs
          id = "Markdown_code_#{:erlang.unique_integer([:positive])}"
          [{"id", id} | attrs]
      end

    {"code", attrs, nil, meta}
  end

  # Update <pre> for code mermaid
  def post_processor(
        {"pre", attrs, [{"code", [{"class", "mermaid language-mermaid"}], _, _}], meta}
      ) do
    id = "Markdown_pre_#{:erlang.unique_integer([:positive])}"

    attrs = [
      {"id", id},
      {"class", "language-mermaid"},
      {"phx-update", "ignore"} | attrs
    ]

    {"pre", attrs, nil, meta}
  end

  # Update <pre> for code highlighting
  def post_processor({"pre", attrs, _children, meta}) do
    {show_line_numbers, attrs} =
      Enum.split_with(attrs, fn {k, _v} -> k == "show_line_numbers" end)

    {selected_lines, attrs} = Enum.split_with(attrs, fn {k, _v} -> k == "selected_lines" end)

    attrs =
      case show_line_numbers do
        [{"show_line_numbers", "true"}] ->
          [{"class", "line-numbers"} | attrs]

        _ ->
          attrs
      end

    attrs =
      case selected_lines do
        [{"selected_lines", value}] ->
          [{"data-line", value} | attrs]

        _ ->
          attrs
      end

    id = "Markdown_pre_#{:erlang.unique_integer([:positive])}"
    attrs = [{"id", id}, {"id", "test"}, {"phx-update", "ignore"} | attrs]
    {"pre", attrs, nil, meta}
  end

  # Update <img> for code highlighting
  def post_processor({"img", attrs, _children, meta}) do
    class =
      "relative not-prose [a:not(:first-child)]:mt-12 [a:not(:last-child)]:mb-12 my-12 first:mt-0 last:mb-0 rounded-2xl overflow-hidden [figure]:my-0 absolute inset-0 rounded-2xl ring-1 ring-inset ring-slate-900/10 dark:ring-white/10"

    attrs = [{"class", class} | attrs]

    {"img", attrs, nil, meta}
  end

  def post_processor(node) do
    node
  end

  defp get_text([]) do
    ""
  end

  defp get_text([node | nodes]) when is_binary(node) do
    node <> get_text(nodes)
  end

  defp get_text([{_, _, children, _} | nodes]) do
    get_text(children) <> get_text(nodes)
  end

  defp format_id(value) do
    value
    |> String.trim()
    |> String.replace(" ", "-")
    |> String.downcase()
  end

  def to_html(text, opts \\ [])

  def to_html(nil, _opts) do
    ""
  end

  def to_html(text, opts) do
    strip = Keyword.get(opts, :strip, false)
    class = Keyword.get(opts, :class, "content")

    markdown =
      text
      |> HtmlEntities.decode()
      |> String.trim_leading()

    html =
      case Earmark.as_html(markdown, smartypants: false) do
        {:ok, html, messages} ->
          Enum.each(messages, fn msg -> IO.warn(msg) end)
          html

        {:error, html, messages} ->
          Enum.each(messages, fn
            {:warning, _line, msg} ->
              message = """
              #{msg}

              Original code:

              #{text}
              """

              IO.warn(message)

            msg ->
              IO.warn(msg)
          end)

          html
      end

    if strip do
      html = html |> String.trim_leading("<p>") |> String.trim_trailing("</p>")
      {:safe, html}
    else
      {:safe, ~s(<div class="#{class}">#{html}</div>)}
    end
  end
end
