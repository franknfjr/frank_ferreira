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
    <main class="max-w-[52rem] mx-auto px-4 pb-28 sm:px-6 md:px-8 xl:px-12 lg:max-w-6xl">
      <header class="py-16 sm:text-center">
        <h1 class="mb-4 text-3xl sm:text-4xl tracking-tight text-slate-900 font-extrabold dark:text-slate-200">
          <%= gettext("Listing all posts") %>
        </h1>
        <p class="text-lg text-slate-700 dark:text-slate-400">
          <%= gettext("Subscribe to receive updates.") %>
        </p>
        <section class="mt-3 max-w-sm sm:mx-auto sm:px-4">
          <h2 class="sr-only"><%= gettext("Sign up for our newsletter") %></h2>
          <%= news_latter(assigns) %>
        </section>
      </header>
      <div class="relative sm:pb-12 sm:ml-[calc(2rem+1px)] md:ml-[calc(3.5rem+1px)] lg:ml-[max(calc(14.5rem+1px),calc(100%-48rem))]">
        <div class="hidden absolute top-3 bottom-0 right-full mr-7 md:mr-[3.25rem] w-px bg-slate-200 dark:bg-slate-800 sm:block" />
        <div class="space-y-16">
          <%= for post <- @posts do %>
            <a href={~p"/blog/#{post.language}/#{post.id}"}>
              <article key={post.id} class="relative group">
                <div class="absolute -inset-y-2.5 -inset-x-4 md:-inset-y-4 md:-inset-x-6 sm:rounded-2xl group-hover:bg-slate-50/70 dark:group-hover:bg-slate-800/50" />
                <svg
                  viewBox="0 0 9 9"
                  class="hidden absolute right-full mr-6 top-2 text-slate-200 dark:text-slate-600 md:mr-12 w-[calc(0.5rem+1px)] h-[calc(0.5rem+1px)] overflow-visible sm:block"
                >
                  <circle
                    cx="4.5"
                    cy="4.5"
                    r="4.5"
                    stroke="currentColor"
                    class="fill-white dark:fill-slate-900"
                    strokeWidth={2}
                  />
                </svg>
                <div class="relative">
                  <h3 class="text-base font-semibold tracking-tight text-slate-900 dark:text-slate-200 pt-8 lg:pt-0">
                    <%= post.title %>
                  </h3>
                  <%= for tag <- post.tags do %>
                    <span class="px-2.5 py-0.5 mr-2 text-xs text-gray-700 bg-gray-200 rounded hover:bg-blue-600 dark:bg-gray-700 dark:text-gray-400 hover:text-gray-100 dark:hover:bg-gray-800">
                      <%= tag %>
                    </span>
                  <% end %>
                  <div class="mt-2 mb-4 prose prose-slate prose-a:relative prose-a:z-10 dark:prose-dark line-clamp-2">
                    <%= post.description %>
                  </div>
                  <dl class="absolute left-0 top-0 lg:left-auto lg:right-full lg:mr-[calc(6.5rem+1px)]">
                    <dt class="sr-only"><%= gettext("Date") %></dt>
                    <dd class="whitespace-nowrap text-sm leading-6 dark:text-slate-400">
                      <time dateTime={"#{post.created_at}"}>
                        <%= formatted_date(post.created_at) %>
                      </time>
                    </dd>
                  </dl>
                </div>
                <a
                  href={~p"/blog/#{post.language}/#{post.id}"}
                  class="flex items-center text-sm text-sky-500 font-medium"
                >
                  <span class="relative">
                    <%= gettext("Read more") %><span class="sr-only">, <%= post.title %></span>
                  </span>
                  <svg
                    class="relative mt-px overflow-visible ml-2.5 text-sky-300 dark:text-sky-700"
                    width="3"
                    height="6"
                    viewBox="0 0 3 6"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  >
                    <path d="M0 0L3 3L0 6"></path>
                  </svg>
                </a>
              </article>
            </a>
          <% end %>
        </div>
      </div>
    </main>
    """
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
            placeholder={gettext("Subscribe via email")}
          />
        </div>
      </div>
      <div class="px-2 grow flex mt-3">
        <button
          type="submit"
          class="bg-purple-500 flex-auto shadow text-white rounded-md text-sm border-y border-transparent py-2 font-semibold px-3 hover:bg-purple-600 dark:hover:bg-purple-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-sky-300 dark:focus:ring-offset-slate-900 dark:focus:ring-sky-700"
        >
          <%= gettext("Subscribe") %>
        </button>
      </div>
    </form>
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
