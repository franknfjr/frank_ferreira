defmodule FrankFerreiraWeb.BlogLive.Show do
  use FrankFerreiraWeb, :live_view
  alias FrankFerreira.Blog

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="overflow-hidden">
      <div class="max-w-8xl mx-auto">
        <div class="flex px-4 pt-8 pb-10 lg:px-8">
          <a
            href="/blog"
            class="group flex font-semibold text-sm leading-6 text-slate-700 hover:text-slate-900 dark:text-slate-200 dark:hover:text-white"
          >
            <svg
              viewBox="0 -9 3 24"
              class="overflow-visible mr-3 text-slate-400 w-auto h-6 group-hover:text-slate-600 dark:group-hover:text-slate-300"
            >
              <path
                d="M3 0L0 3L3 6"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </svg>
            <%= gettext("Go back") %>
          </a>
        </div>
      </div>
      <div class="px-4 sm:px-6 md:px-8">
        <div class="max-w-3xl mx-auto">
          <main>
            <article class="relative pt-10">
              <h1 class="text-2xl font-extrabold tracking-tight text-slate-900 dark:text-slate-200 md:text-3xl ">
                <%= @post.title %>
              </h1>
              <div class="text-sm leading-6">
                <dl>
                  <dt class="sr-only">Date</dt>
                  <dd class="absolute top-0 inset-x-0 text-slate-700 dark:text-slate-400">
                    <time dateTime={@post.created_at}>
                      <%= formatted_date(@post.created_at) %>
                    </time>
                  </dd>
                </dl>
              </div>
              <div class="mt-6">
                <ul class="flex flex-wrap text-sm leading-6 -mt-6 -mx-5">
                  <li key="banana" class="flex items-center font-medium whitespace-nowrap px-5 mt-6">
                    <img
                      src="/images/avatar.png"
                      alt=""
                      class="mr-3 w-9 h-9 rounded-full bg-slate-50 dark:bg-slate-800"
                      decoding="async"
                    />
                    <div class="text-sm leading-4">
                      <div class="text-slate-900 dark:text-slate-200"><%= @post.author %></div>
                      <div class="mt-1">
                        <a href="" class="text-sky-500 hover:text-sky-600 dark:text-sky-400">
                          @<%= @post.twitter %>
                        </a>
                      </div>
                    </div>
                  </li>
                </ul>
              </div>
              <div class="mt-12 prose prose-slate dark:prose-dark">
                <%= {:safe, @post.body} %>
              </div>
            </article>
          </main>
          <footer class="mt-16">
            <div class="relative pb-28">
              <section class="relative py-16 border-t border-slate-200 dark:border-slate-200/5">
                <h2 class="text-xl font-semibold text-slate-900 tracking-tight dark:text-white">
                  Get all of our updates directly to your&nbsp;inbox. <br />
                  Sign up for our newsletter.
                </h2>
                <div class="mt-5 max-w-md">
                  <%= news_latter(assigns) %>
                </div>
              </section>
            </div>
          </footer>
        </div>
      </div>
    </div>
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

  defp news_latter(assigns) do
    ~H"""
    <form method="post" class="flex flex-wrap -mx-2">
      <div class="px-2 grow-[9999] basis-64 mt-3">
        <div class="group relative">
          <svg
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            aria-hidden="true"
            class="w-6 h-full absolute inset-y-0 left-3 text-slate-400 pointer-events-none group-focus-within:text-sky-500 dark:group-focus-within:text-slate-400"
          >
            <path d="M5 7.92C5 6.86 5.865 6 6.931 6h10.138C18.135 6 19 6.86 19 7.92v8.16c0 1.06-.865 1.92-1.931 1.92H6.931A1.926 1.926 0 0 1 5 16.08V7.92Z" />
            <path d="m6 7 6 5 6-5" />
          </svg>
          <input
            autocomplete="off"
            name="email_address"
            type="email"
            required
            autoComplete="email"
            aria-label="Email address"
            class="appearance-none shadow rounded-md ring-1 ring-slate-900/5 leading-5 sm:text-sm border border-transparent py-2 placeholder:text-slate-400 pl-12 pr-3 block w-full text-slate-900 focus:outline-none focus:ring-2 focus:ring-sky-500 bg-white dark:bg-slate-700/20 dark:ring-slate-200/20 dark:focus:ring-sky-500 dark:text-white"
            placeholder="Subscribe via email"
          />
        </div>
      </div>
      <div class="px-2 grow flex mt-3">
        <button
          type="submit"
          class="bg-purple-500 flex-auto shadow text-white rounded-md text-sm border-y border-transparent py-2 font-semibold px-3 hover:bg-purple-600 dark:hover:bg-purple-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-300 dark:focus:ring-offset-slate-900 dark:focus:ring-sky-700"
        >
          Subscribe
        </button>
      </div>
    </form>
    """
  end
end
