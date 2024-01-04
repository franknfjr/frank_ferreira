defmodule FrankFerreiraWeb.PageController do
  use FrankFerreiraWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    locale = get_session(conn, :locale)

    conn
    |> put_session(:locale, locale)
    |> render(:home, layout: false)
  end
end
