defmodule FrankFerreiraWeb.Router do
  use FrankFerreiraWeb, :router

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

  scope "/", FrankFerreiraWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/about", AboutLive
    live "/blog", BlogLive
    live "/blog/:id", BlogLive.Show
    live "/timeline", TimelineLive
    live "/uses", UsesLive
    live "/contact", ContactLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", FrankFerreiraWeb do
  #   pipe_through :api
  # end
end
