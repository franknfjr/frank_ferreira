defmodule FrankFerreiraWeb.RSS do
  @moduledoc "RSS Generator"
  use FrankFerreiraWeb, :verified_routes
  @endpoint FrankFerreiraWeb.Endpoint

  defstruct [:title, :author, :description, :posts, language: "en-US"]

  def generate(rss, opts \\ []) do
    []
    |> open(rss, opts)
    |> add_posts(rss)
    |> close()
  end

  def open(output, rss, opts) do
    locale = Map.get(rss, :language, "en")

    todayer = Keyword.get(opts, :todayer, &Date.utc_today/0)
    year = todayer.().year

    locale =
      case locale do
        "br" -> "pt-BR"
        "en" -> "en-US"
      end

    [
      """
      <?xml version="1.0" encoding="UTF-8"?>
      <rss xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:atom="http://www.w3.org/2005/Atom" version="2.0">
      """,
      "<channel>\n",
      """
      <atom:link href="#{url(@endpoint, ~p"/#{locale}/rss.xml")}" rel="self" type="application/rss+xml" />
      """,
      "<title>#{cdata(rss.title)}</title>\n",
      "<language>#{locale}</language>\n",
      "<description>#{cdata(rss.description)}</description>\n",
      "<pubDate>#{post_date(rss.posts)}</pubDate>\n",
      "<link>#{url(@endpoint, ~p"/")}</link>\n",
      "<copyright>Copyright #{year} #{rss.author}</copyright>\n",
      "<generator>Artisinally Crafted by Yours Truly</generator>\n",
      output
    ]
  end

  def close(output) do
    [output, "</channel>\n", "</rss>\n"]
  end

  def post_date([post | _]), do: post_date(post)
  def post_date([]), do: nil

  def post_date(%{created_at: date}) do
    {:ok, ndt} = NaiveDateTime.new(date, ~T[00:00:00])

    ndt
    |> DateTime.from_naive!("America/New_York")
    |> Calendar.strftime("%a, %d %b %Y %H:%M:%S %z")
  end

  def add_posts(output, rss) do
    [output | Enum.map(rss.posts, &to_item(&1, rss.author))]
  end

  def to_item(post, author) do
    [
      "<item>\n",
      "<title>#{cdata(post.title)}</title>\n",
      "<dc:creator>#{author}</dc:creator>\n",
      "<description>#{cdata(post.description)}</description>\n",
      "<link>#{url(@endpoint, ~p"/blog/#{post.language}/#{post}")}</link>\n",
      "<guid isPermaLink=\"true\">#{url(@endpoint, ~p"/blog/#{post.language}/#{post}")}</guid>\n",
      "<pubDate>#{post_date(post)}</pubDate>\n",
      "<content:encoded>#{cdata(post.body)}</content:encoded>\n",
      "</item>\n"
    ]
  end

  def cdata(content), do: "<![CDATA[#{content}]]>"
end
