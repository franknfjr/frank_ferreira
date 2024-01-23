defmodule FrankFerreiraWeb.BlogLive do
  use FrankFerreiraWeb, :live_view
  alias FrankFerreira.Blog

  def mount(_params, _session, socket) do
    posts = Blog.all_posts()
    socket = assign(socket, posts: posts)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="flex items-center font-poppins">
      <div class="justify-center flex-1 max-w-4xl px-4 py-4 mx-auto text-left lg:py-10 ">
        <div class="mb-10 text-center">
          <h1 class="text-3xl font-bold capitalize dark:text-white">Listing all Posts</h1>
        </div>
        <%= for post <- @posts do %>
          <div class="grid grid-cols-1  mb-6 lg:grid-cols-[1fr,70%]   gap-4">
            <div>
              <img
                src="/images/avatar.png"
                alt="avatar"
                class="object-cover w-full rounded-md h-80 lg:h-44"
              />
            </div>
            <div class="px-4 py-4 lg:px-0">
              <a href={~p"/blog/#{post.id}"}>
                <%= for tag <- post.tags do %>
                  <span class="px-2.5 py-0.5 mr-2 text-xs text-gray-700 bg-gray-200 rounded hover:bg-blue-600 dark:bg-gray-700 dark:text-gray-400 hover:text-gray-100 dark:hover:bg-gray-800">
                    <%= tag %>
                  </span>
                <% end %>
              </a>
              <a href={~p"/blog/#{post.id}"}>
                <h2 class="mt-3 mb-3 text-xl font-semibold text-gray-600 hover:text-blue-600 dark:text-gray-400">
                  <%= post.title %>
                </h2>
              </a>
              <p class="mb-3 text-sm text-gray-500 dark:text-gray-400">
                <%= raw(post.description) %>
              </p>
              <span class="text-xs font-medium text-gray-700 dark:text-gray-400">
                <time><%= post.created_at %></time> by <%= post.author %>
              </span>
            </div>
          </div>
        <% end %>
        <hr />
      </div>
    </section>
    """
  end
end
