defmodule FrankFerreiraWeb.BlogLive.Show do
  use FrankFerreiraWeb, :live_view
  alias FrankFerreira.Blog

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <main role="main" class="container mx-auto px-4 sm:px-6 lg:px-8 py-14 md:py-20">
      <%= raw(@post.body) %>
    </main>
    """
  end

  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:post, Blog.get_post_by_id!(id))}
  end

  @split_pattern [" ", "\n", "\r", "\t"]
  @words_per_minute 200

  defp time(string, opts \\ []) do
    words_per_minute = Keyword.get(opts, :words_per_minute, @words_per_minute)
    split_pattern = Keyword.get(opts, :split_pattern, @split_pattern)

    words =
      string
      |> String.split(split_pattern, trim: true)
      |> length

    minutes =
      Float.ceil(words / words_per_minute)
      |> trunc

    minutes
  end
end
