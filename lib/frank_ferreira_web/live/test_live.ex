defmodule FrankFerreiraWeb.TestLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Test LiveView</h1>
    """
  end
end
