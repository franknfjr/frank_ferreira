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
    <main class="mx-auto max-w-2xl px-4 sm:px-6 lg:px-8 py-16">
      <section>
        <div class="space-y-10">
          <%= for post <- @posts do %>
            <article>
              <a href={~p"/blog/#{post.language}/#{post.id}"} class="group block">
                <div class="flex items-center gap-3 text-sm text-light-muted dark:text-dark-muted mb-2">
                  <time><%= formatted_date(post.created_at) %></time>
                  <span class="text-light-border dark:text-dark-border">&middot;</span>
                  <span><%= post.read_minutes %> min</span>
                </div>
                <h2 class="text-xl font-semibold text-light-text dark:text-dark-text group-hover:text-accent transition-colors mb-1">
                  <%= post.title %>
                </h2>
                <p class="text-light-muted dark:text-dark-muted leading-relaxed mb-3">
                  <%= post.description %>
                </p>
                <%= if post.cover_image do %>
                  <img src={post.cover_image} alt={post.title} class="w-full rounded-lg mb-3" />
                <% end %>
                <div class="flex flex-wrap gap-2">
                  <%= for tag <- post.tags do %>
                    <span class="text-xs text-accent/80">#<%= tag %></span>
                  <% end %>
                </div>
              </a>
            </article>
          <% end %>
        </div>
      </section>
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
