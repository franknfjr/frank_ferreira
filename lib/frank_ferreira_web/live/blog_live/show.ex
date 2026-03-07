defmodule FrankFerreiraWeb.BlogLive.Show do
  use FrankFerreiraWeb, :live_view
  alias FrankFerreira.Blog

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <main class="mx-auto max-w-3xl px-4 sm:px-6 lg:px-8 py-12">
      <div class="mb-8">
        <a
          href="/"
          class="group inline-flex items-center text-sm font-medium text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors"
        >
          <svg
            viewBox="0 -9 3 24"
            class="overflow-visible mr-2 text-light-muted/60 dark:text-dark-muted/60 w-auto h-4 group-hover:text-light-text dark:group-hover:text-dark-text transition-colors"
          >
            <path
              d="M3 0L0 3L3 6"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
          </svg>
          <%= gettext("Go back") %>
        </a>
      </div>

      <article>
        <header class="text-center mb-10">
          <h1 class="text-3xl md:text-4xl font-bold tracking-tight text-light-text dark:text-dark-text leading-tight">
            <%= @post.title %>
          </h1>

          <time
            dateTime={@post.created_at}
            class="block mt-4 text-sm text-light-muted dark:text-dark-muted"
          >
            <%= formatted_date(@post.created_at) %>
          </time>

          <div class="flex flex-wrap justify-center gap-2 mt-4">
            <%= for tag <- @post.tags do %>
              <span class="px-3 py-1 text-xs font-medium rounded-full bg-accent/10 text-accent">
                #<%= tag %>
              </span>
            <% end %>
          </div>
        </header>

        <div class="prose prose-slate dark:prose-dark max-w-none">
          <%= {:safe, @post.body} %>
        </div>
      </article>

      <section class="mt-16 pt-8 border-t border-light-border dark:border-dark-border">
        <div id="utterances-container" phx-hook="Utterances" phx-update="ignore"></div>
      </section>
    </main>
    """
  end

  def handle_params(%{"id" => id, "locale" => locale}, _, socket) do
    {:noreply,
     socket
     |> assign(:post, Blog.get_post_by_id!(id, locale))}
  end

  defp formatted_date(%Date{day: day, month: month, year: year} = date) do
    weekday_number = date |> Timex.to_datetime() |> Timex.weekday()

    weekday =
      case weekday_number do
        1 -> gettext("Sunday")
        2 -> gettext("Monday")
        3 -> gettext("Tuesday")
        4 -> gettext("Wednesday")
        5 -> gettext("Thursday")
        6 -> gettext("Friday")
        7 -> gettext("Saturday")
        _ -> gettext("Invalid weekday")
      end

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

    weekday <> ", " <> month_name <> " #{day}, #{year}"
  end

end
