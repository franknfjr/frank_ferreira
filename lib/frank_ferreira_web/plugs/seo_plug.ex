defmodule FrankFerreiraWeb.SEOPlug do
  @moduledoc "Sets SEO item on conn for blog post routes."

  def init(opts), do: opts

  def call(%{path_info: ["blog", locale, id]} = conn, _opts) do
    post = FrankFerreira.Blog.get_post_by_id!(id, locale)
    SEO.assign(conn, post)
  rescue
    _ -> conn
  end

  def call(conn, _opts), do: conn
end
