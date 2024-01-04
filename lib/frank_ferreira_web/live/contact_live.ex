defmodule FrankFerreiraWeb.ContactLive do
  use FrankFerreiraWeb, :live_view
  import FrankFerreiraWeb.Components.LanguageSelect

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""

    """
  end
end
