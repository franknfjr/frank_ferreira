defmodule Mix.Tasks.Blog.Rss do
  @shortdoc "Generate the blog RSS feed(s) and write to disk"

  @moduledoc """
  Renders the same RSS feed served at `/{locale}/rss.xml` and writes it to a
  file, so you can inspect or validate it without booting the web server.

      mix blog.rss                          # writes both locales to tmp/rss/
      mix blog.rss --locale en              # only English
      mix blog.rss --locale br --out feed.xml
      mix blog.rss --stdout                 # print to stdout instead of writing

  Options:

    * `--locale`  — `en`, `br`, or `all` (default: `all`)
    * `--out`     — output file (only valid with a single `--locale`)
    * `--dir`     — output directory when generating multiple feeds
                    (default: `tmp/rss`)
    * `--stdout`  — print to stdout instead of writing files
  """

  use Mix.Task

  alias FrankFerreira.Blog
  alias FrankFerreiraWeb.RSS

  @locales ~w[en br]
  @switches [locale: :string, out: :string, dir: :string, stdout: :boolean]

  @impl Mix.Task
  def run(argv) do
    Mix.Task.run("app.start")

    {opts, _rest, _invalid} = OptionParser.parse(argv, switches: @switches)

    locales =
      case opts[:locale] do
        nil -> @locales
        "all" -> @locales
        l when l in @locales -> [l]
        other -> Mix.raise("Unknown --locale #{inspect(other)}. Use: en, br, all.")
      end

    if opts[:out] && length(locales) != 1 do
      Mix.raise("--out requires a single --locale (got #{Enum.join(locales, ", ")}).")
    end

    Enum.each(locales, &emit(&1, opts))
  end

  defp emit(locale, opts) do
    posts = Blog.published_posts(locale)

    xml =
      RSS.generate(%RSS{
        title: "Frank Ferreira Blog",
        author: "Frank Ferreira",
        description:
          "Personal website and blog of Frank Ferreira, a software developer and computer science student.",
        posts: posts,
        language: locale
      })
      |> IO.iodata_to_binary()

    cond do
      opts[:stdout] ->
        Mix.shell().info("# ── #{locale} ── #{length(posts)} posts")
        IO.write(xml)

      opts[:out] ->
        write_file(opts[:out], xml, length(posts), locale)

      true ->
        dir = opts[:dir] || Path.join("tmp", "rss")
        File.mkdir_p!(dir)
        path = Path.join(dir, "#{locale}.xml")
        write_file(path, xml, length(posts), locale)
    end
  end

  defp write_file(path, xml, post_count, locale) do
    File.write!(path, xml)
    Mix.shell().info("✓ #{locale}: wrote #{post_count} posts → #{path}")
  end
end
