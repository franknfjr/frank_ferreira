defmodule FrankFerreiraWeb.BlogLive do
  use FrankFerreiraWeb, :live_view
  alias FrankFerreira.Blog

  def mount(_params, session, socket) do
    locale = Map.get(session, "locale", socket.assigns[:locale] || "en")
    posts = Blog.published_posts(locale)

    socket = assign(socket, posts: posts)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <main class="mx-auto max-w-3xl px-4 sm:px-6 lg:px-8 py-24">
      <h1 class="text-4xl font-medium tracking-tight text-light-text dark:text-dark-text mb-4">
        Blog
      </h1>
      <p class="text-light-muted dark:text-dark-muted mb-12">
        <%= gettext("Thoughts on software, technology, and life.") %>
      </p>

      <div class="grid gap-6">
        <%= for post <- @posts do %>
          <a href={~p"/blog/#{post.language}/#{post.id}"} class="group block">
            <article class="p-6 rounded-xl bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border hover:border-accent/50 dark:hover:border-accent/50 transition-all duration-300 hover:shadow-lg hover:shadow-accent/5">
              <div class="flex items-center justify-between mb-3">
                <time class="text-sm text-light-muted dark:text-dark-muted">
                  <%= formatted_date(post.created_at) %>
                </time>
                <div class="flex flex-wrap gap-2">
                  <%= for tag <- post.tags do %>
                    <span class="px-2 py-0.5 text-xs bg-light-bg dark:bg-dark-bg rounded-full text-light-muted dark:text-dark-muted">
                      <%= tag %>
                    </span>
                  <% end %>
                </div>
              </div>
              <h2 class="text-xl font-medium text-light-text dark:text-dark-text group-hover:text-accent transition-colors mb-2">
                <%= post.title %>
              </h2>
              <p class="text-light-muted dark:text-dark-muted line-clamp-2 leading-relaxed">
                <%= post.description %>
              </p>
              <div class="mt-4 flex items-center text-sm text-accent font-medium opacity-0 group-hover:opacity-100 transition-opacity">
                <%= gettext("Read more") %>
                <svg
                  class="w-4 h-4 ml-1 group-hover:translate-x-1 transition-transform"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="2"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"
                  />
                </svg>
              </div>
            </article>
          </a>
        <% end %>
      </div>
    </main>
    """
  end

  def formatted_date(%Date{day: day, month: month, year: year} = _date) do
    month_name =
      case Timex.month_name(month) do
        "January" -> gettext("January")
        "February" -> gettext("February")
        "March" -> gettext("March")
        "April" -> gettext("April")
        "May" -> gettext("May")
        "June" -> gettext("June")
        "July" -> gettext("July")
        "August" -> gettext("August")
        "September" -> gettext("September")
        "October" -> gettext("October")
        "November" -> gettext("November")
        "December" -> gettext("December")
        _ -> gettext("Invalid month")
      end

    month_name <> " #{day}, #{year}"
  end
end
