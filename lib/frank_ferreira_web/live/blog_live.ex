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
    <main class="mx-auto max-w-2xl px-4 sm:px-6 lg:px-8 py-24">
      <h1 class="text-4xl font-medium tracking-tight text-light-text dark:text-dark-text mb-4">
        <%= gettext("Blog") %>
      </h1>
      <p class="text-light-muted dark:text-dark-muted mb-16">
        <%= gettext("Thoughts on software, technology, and life.") %>
      </p>

      <div class="space-y-12">
        <%= for post <- @posts do %>
          <article>
            <time class="text-sm text-light-muted dark:text-dark-muted">
              <%= formatted_date(post.created_at) %>
            </time>
            <h2 class="mt-2 text-lg font-medium text-light-text dark:text-dark-text">
              <a href={~p"/blog/#{post.language}/#{post.id}"} class="hover:text-accent transition-colors">
                <%= post.title %>
              </a>
            </h2>
            <p class="mt-2 text-light-muted dark:text-dark-muted line-clamp-2">
              <%= post.description %>
            </p>
            <div class="mt-3 flex flex-wrap gap-2">
              <%= for tag <- post.tags do %>
                <span class="px-2 py-1 text-xs bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border rounded text-light-muted dark:text-dark-muted">
                  <%= tag %>
                </span>
              <% end %>
            </div>
          </article>
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
