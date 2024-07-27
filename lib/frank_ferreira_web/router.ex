defmodule FrankFerreiraWeb.Router do
  use FrankFerreiraWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FrankFerreiraWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug FrankFerreiraWeb.SetLocalePlug, gettext: FrankFerreiraWeb.Gettext
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FrankFerreiraWeb, log: false do
    get "/:locale/sitemap.xml", RobotController, :sitemap
    get "/robots.txt", RobotController, :robots
    get "/:locale/rss.xml", RobotController, :rss
    get "/site.webmanifest", RobotController, :site_webmanifest
    get "/:locale/browserconfig.xml", RobotController, :browserconfig
  end

  scope "/", FrankFerreiraWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/about", AboutLive
    live "/blog", BlogLive
    live "/blog/:id", BlogLive.Show
    live "/blog/:locale/:id", BlogLive.Show
    live "/timeline", TimelineLive
    live "/uses", UsesLive
    live "/contact", ContactLive
    live "/projects", ProjectsLive
  end

  scope "/admin", FrankFerreiraWeb do
    pipe_through [:browser, :check_auth]
    live "/markdown", MarkdownLive

    live_dashboard "/dashboard", metrics: FrankFerreiraWeb.Telemetry
  end

  def check_auth(conn, _opts) do
    with {user, pass} <- Plug.BasicAuth.parse_basic_auth(conn),
         true <- user == System.get_env("AUTH_USER", "admin"),
         true <- pass == System.get_env("AUTH_PASS", "admin") do
      conn
    else
      _ ->
        conn
        |> Plug.BasicAuth.request_basic_auth()
        |> halt()
    end
  end
end
