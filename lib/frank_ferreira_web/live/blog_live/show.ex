defmodule FrankFerreiraWeb.BlogLive.Show do
  use FrankFerreiraWeb, :live_view
  alias FrankFerreira.Blog

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <main role="main" class="container mx-auto px-4 sm:px-6 lg:px-8 py-14 md:py-20">
      <header class="max-w-[55rem] 2xl:max-w-3xl mx-auto mb-14 sm:mb-16">
        <h1 class="relative w-full font-heading text-navy-900 leading-tight sm:leading-tight lg:leading-tight 2xl:leading-tight text-3xl sm:text-4xl lg:text-[2.75rem]">
          <%= @post.title %>
        </h1>
      </header>
      <article class="xl:grid grid-cols-auto-span-auto items-start sm:text-lg leading-relaxed">
        <section class="relative max-w-[55rem] 2xl:max-w-3xl mx-auto">
          <%= raw(@post.body) %>
        </section>
        <!--Next & Prev Links-->
        <div class="font-sans flex justify-between content-center px-4 pb-12 text-sm font-medium">
          <div class="text-left">
            <span class="text-navy-900 mb-1">← Previous Post</span>
            <br />
            <p>
              <a href="#" class="line-clamp-2 text-violet-500 hover:text-violet-700 transition-colors">
                Blog title
              </a>
            </p>
          </div>
          <div class="text-right">
            <span class="text-navy-900 mb-1">Next Post  →</span>
            <br />
            <p>
              <a href="#" class="line-clamp-2 text-violet-500 hover:text-violet-700 transition-colors">
                Blog title
              </a>
            </p>
          </div>
        </div>
      </article>
    </main>
    """
  end

  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:post, Blog.get_post_by_id!(id))}
  end

  # @split_pattern [" ", "\n", "\r", "\t"]
  # @words_per_minute 200

  # defp time(string, opts \\ []) do
  #   words_per_minute = Keyword.get(opts, :words_per_minute, @words_per_minute)
  #   split_pattern = Keyword.get(opts, :split_pattern, @split_pattern)

  #   words =
  #     string
  #     |> String.split(split_pattern, trim: true)
  #     |> length

  #   minutes =
  #     Float.ceil(words / words_per_minute)
  #     |> trunc

  #   minutes
  # end
end
