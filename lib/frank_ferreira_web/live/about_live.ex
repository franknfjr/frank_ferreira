defmodule FrankFerreiraWeb.AboutLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 1000)

    {:ok, put_date(socket)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex mt-6">
      <div class="container mx-auto px-8">
        <div class="flex px-10">
          <div class="w-1/4">
            <div class="mb-4">
              <img class="rounded-lg" src="/images/avatar.png" alt="Avatar Github" />
            </div>
            <div class="mb-4">
              <div class="text-3xl font-medium text-grey-darkest">
                Frank Ferreira
              </div>
              <div class="text-xl text-grey-dark font-light">
                franknfjr
              </div>
            </div>
            <div class="pb-6 border-b">
              <div class="no-underline text-grey-dark text-sm ">
                Software Engineer
              </div>
            </div>

            <div class="flex items-center text-left py-4 mb-4 border-b">
              <ul>
                <li class="pt-1 hide-sm hide-md flex items-center" aria-label="Organization: @nil">
                  <svg
                    class="octicon octicon-organization"
                    viewBox="0 0 16 16"
                    version="1.1"
                    width="16"
                    height="16"
                    aria-hidden="true"
                  >
                    <path d="M1.75 16A1.75 1.75 0 0 1 0 14.25V1.75C0 .784.784 0 1.75 0h8.5C11.216 0 12 .784 12 1.75v12.5c0 .085-.006.168-.018.25h2.268a.25.25 0 0 0 .25-.25V8.285a.25.25 0 0 0-.111-.208l-1.055-.703a.749.749 0 1 1 .832-1.248l1.055.703c.487.325.779.871.779 1.456v5.965A1.75 1.75 0 0 1 14.25 16h-3.5a.766.766 0 0 1-.197-.026c-.099.017-.2.026-.303.026h-3a.75.75 0 0 1-.75-.75V14h-1v1.25a.75.75 0 0 1-.75.75Zm-.25-1.75c0 .138.112.25.25.25H4v-1.25a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 .75.75v1.25h2.25a.25.25 0 0 0 .25-.25V1.75a.25.25 0 0 0-.25-.25h-8.5a.25.25 0 0 0-.25.25ZM3.75 6h.5a.75.75 0 0 1 0 1.5h-.5a.75.75 0 0 1 0-1.5ZM3 3.75A.75.75 0 0 1 3.75 3h.5a.75.75 0 0 1 0 1.5h-.5A.75.75 0 0 1 3 3.75Zm4 3A.75.75 0 0 1 7.75 6h.5a.75.75 0 0 1 0 1.5h-.5A.75.75 0 0 1 7 6.75ZM7.75 3h.5a.75.75 0 0 1 0 1.5h-.5a.75.75 0 0 1 0-1.5ZM3 9.75A.75.75 0 0 1 3.75 9h.5a.75.75 0 0 1 0 1.5h-.5A.75.75 0 0 1 3 9.75ZM7.75 9h.5a.75.75 0 0 1 0 1.5h-.5a.75.75 0 0 1 0-1.5Z">
                    </path>
                  </svg>
                  <span class="p-org">
                    <div>
                      <a class="ml-2" href="https://github.com/nil">
                        @nil
                      </a>
                    </div>
                  </span>
                </li>
                <li
                  class="pt-1 hide-sm hide-md flex items-center"
                  aria-label="Home location: Ananindeua, Brazil"
                >
                  <svg
                    class="octicon octicon-location"
                    viewBox="0 0 16 16"
                    version="1.1"
                    width="16"
                    height="16"
                    aria-hidden="true"
                  >
                    <path d="m12.596 11.596-3.535 3.536a1.5 1.5 0 0 1-2.122 0l-3.535-3.536a6.5 6.5 0 1 1 9.192-9.193 6.5 6.5 0 0 1 0 9.193Zm-1.06-8.132v-.001a5 5 0 1 0-7.072 7.072L8 14.07l3.536-3.534a5 5 0 0 0 0-7.072ZM8 9a2 2 0 1 1-.001-3.999A2 2 0 0 1 8 9Z">
                    </path>
                  </svg>
                  <span class="ml-2">Ananindeua, Brazil</span>
                </li>
                <li class="pt-1 hide-sm hide-md flex items-center">
                  <svg
                    class="octicon octicon-clock"
                    viewBox="0 0 16 16"
                    version="1.1"
                    width="16"
                    height="16"
                    aria-hidden="true"
                  >
                    <path d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0ZM1.5 8a6.5 6.5 0 1 0 13 0 6.5 6.5 0 0 0-13 0Zm7-3.25v2.992l2.028.812a.75.75 0 0 1-.557 1.392l-2.5-1A.751.751 0 0 1 7 8.25v-3.5a.75.75 0 0 1 1.5 0Z">
                    </path>
                  </svg>
                  <span class="ml-2"><%= @date %> - same time</span>
                </li>
                <li class="pt-1 hide-sm hide-md flex items-center">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="16"
                    height="16"
                    viewBox="0 0 16 16"
                    fill="none"
                    role="img"
                    aria-labelledby="a69wvuxxzrxevlkuq1o85jwl5cn2gp6n"
                    class="octicon"
                  >
                    <title id="a69wvuxxzrxevlkuq1o85jwl5cn2gp6n">LinkedIn</title>
                    <g clip-path="url(#clip0_202_91845)">
                      <path
                        d="M14.5455 0H1.45455C0.650909 0 0 0.650909 0 1.45455V14.5455C0 15.3491 0.650909 16 1.45455 16H14.5455C15.3491 16 16 15.3491 16 14.5455V1.45455C16 0.650909 15.3491 0 14.5455 0ZM5.05746 13.0909H2.912V6.18764H5.05746V13.0909ZM3.96291 5.20073C3.27127 5.20073 2.712 4.64 2.712 3.94982C2.712 3.25964 3.272 2.69964 3.96291 2.69964C4.65236 2.69964 5.21309 3.26036 5.21309 3.94982C5.21309 4.64 4.65236 5.20073 3.96291 5.20073ZM13.0938 13.0909H10.9498V9.73382C10.9498 8.93309 10.9353 7.90327 9.83491 7.90327C8.71855 7.90327 8.54691 8.77527 8.54691 9.67564V13.0909H6.40291V6.18764H8.46109V7.13091H8.49018C8.77673 6.58836 9.47636 6.016 10.52 6.016C12.6924 6.016 13.0938 7.44582 13.0938 9.30473V13.0909V13.0909Z"
                        fill="currentColor"
                      >
                      </path>
                    </g>
                  </svg>
                  <a
                    target="_blank"
                    rel="nofollow me"
                    class="ml-2"
                    href="http://linkedin.com/in/franknferreira"
                  >
                    in/franknferreira
                  </a>
                </li>
                <li class="pt-1 hide-sm hide-md flex items-center">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 273.5 222.3"
                    role="img"
                    aria-labelledby="ajvel03u473k5hy6hcik17kz0avpr23"
                    class="octicon"
                    width="16"
                    height="16"
                  >
                    <title id="ajvel03u473k5hy6hcik17kz0avpr23">Twitter</title>
                    <path
                      d="M273.5 26.3a109.77 109.77 0 0 1-32.2 8.8 56.07 56.07 0 0 0 24.7-31 113.39 113.39 0 0 1-35.7 13.6 56.1 56.1 0 0 0-97 38.4 54 54 0 0 0 1.5 12.8A159.68 159.68 0 0 1 19.1 10.3a56.12 56.12 0 0 0 17.4 74.9 56.06 56.06 0 0 1-25.4-7v.7a56.11 56.11 0 0 0 45 55 55.65 55.65 0 0 1-14.8 2 62.39 62.39 0 0 1-10.6-1 56.24 56.24 0 0 0 52.4 39 112.87 112.87 0 0 1-69.7 24 119 119 0 0 1-13.4-.8 158.83 158.83 0 0 0 86 25.2c103.2 0 159.6-85.5 159.6-159.6 0-2.4-.1-4.9-.2-7.3a114.25 114.25 0 0 0 28.1-29.1"
                      fill="currentColor"
                    >
                    </path>
                  </svg>

                  <a target="_blank" class="ml-2" href="https://twitter.com/franknfjr">
                    @franknfjr
                  </a>
                </li>
              </ul>
            </div>
            <div class="">
              <div class="font-medium text-grey-darkest">
                Organizations
              </div>
              <div class="flex items-center mt-2">
                <div class="mr-1">
                  <a target="_blank" href="https://github.com/franknfjr">
                    <img class="w-8 h-8 rounded" src="/images/avatar.png" alt="Avatar Github" />
                  </a>
                </div>
              </div>
            </div>
          </div>
          <div class="w-3/4 ml-6 mt-2">
            <div class="flex items-center font-thin text-grey-dark text-sm border-b">
              <div class="p-4 border-b-2 font-semibold text-grey-darkest border-orange -mb-2px">
                Overview
              </div>
            </div>
            <div class="py-6 border-b md:border md:rounded-lg md:px-8">
              <div class="font-semibold text-black">franknfjr/README.md</div>
              <div class="my-6">
                <img class="w-64" src="" alt="" />
                <p>Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum.</p>
                <div class="flex">
                  <div class="flex mr-2 items-center my-4">
                    <div class="px-1 py-1 text-xs font-semibold text-white leading-none items-center text-white bg-gray-800 rounded-l-md cursor-pointer">
                      <span class="self-center font-medium">Lorem</span>
                    </div>
                    <div class="px-1 py-1 text-xs font-semibold text-white leading-none  bg-green-500 rounded-r-md cursor-pointer">
                      Ipsum
                    </div>
                  </div>
                </div>
                <hr />
              </div>
              <div class="mb-6">
                <div class="flex items-center pb-2 -mx-4 text-lg font-bold leading-normal text-transparent hover:text-gray-700">
                  <svg
                    class="w-4 h-4 mr-1 cursor-pointer"
                    fill="none"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1">
                    </path>
                  </svg>
                  <p class="text-black">Lorem Ipsum</p>
                </div>
                <hr />
                <div class="my-4">
                  Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum
                  <a href="#" class="text-blue-600 hover:underline">Lorem Ipsum</a>
                </div>
              </div>
              <div class="mb-6">
                <div class="flex items-center pb-2 -mx-4 text-lg font-bold leading-normal text-transparent hover:text-gray-700">
                  <svg
                    class="w-4 h-4 mr-1 cursor-pointer"
                    fill="none"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1">
                    </path>
                  </svg>
                  <p class="text-black">Lorem Ipsum</p>
                </div>
                <hr />
                <div class="my-4">
                  Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum:
                </div>
                <a href="#" class="my-4 text-blue-600 hover:underline">
                  Lorem Ipsum Lorem Ipsum Lorem Ipsum
                </a>
                <div class="my-4">Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum:</div>
                <a href="#" class="my-4 text-blue-600 hover:underline">
                  Lorem Ipsum Lorem Ipsum Lorem Ipsum
                </a>
              </div>
              <div class="mb-6">
                <div class="flex items-center pb-2 -mx-4 text-lg font-bold leading-normal text-transparent hover:text-gray-700">
                  <svg
                    class="w-4 h-4 mr-1 cursor-pointer"
                    fill="none"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1">
                    </path>
                  </svg>
                  <p class="text-black">Lorem Ipsum</p>
                </div>
                <hr />
                <div class="my-4">
                  Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum
                  <a href="#" class="text-blue-600 hover:underline">Lorem Ipsum</a>
                  <span class="font-semibold text-black">Lorem Ipsum Lorem Ipsum Lorem Ipsum.</span>
                </div>
              </div>
            </div>
            <div class="flex items-center">
              <div class="w-1/2 pt-6 pb-2 font-normal text-grey-darkest">
                Pinned
              </div>
              <div class="w-1/2 justify-end text-right text-grey-dark text-sm font-light pt-6 pb-2">
                Customize your pinned repositories
              </div>
            </div>
            <div class="flex">
              <div class="w-1/2 border px-4 py-4 mb-4 -mr-2 rounded text-sm">
                <div class="flex">
                  <div class="mr-2">
                    <svg
                      aria-hidden="true"
                      height="16"
                      viewBox="0 0 16 16"
                      version="1.1"
                      width="16"
                      data-view-component="true"
                      class="octicon octicon-repo mr-1 color-fg-muted"
                    >
                      <path d="M2 2.5A2.5 2.5 0 0 1 4.5 0h8.75a.75.75 0 0 1 .75.75v12.5a.75.75 0 0 1-.75.75h-2.5a.75.75 0 0 1 0-1.5h1.75v-2h-8a1 1 0 0 0-.714 1.7.75.75 0 1 1-1.072 1.05A2.495 2.495 0 0 1 2 11.5Zm10.5-1h-8a1 1 0 0 0-1 1v6.708A2.486 2.486 0 0 1 4.5 9h8ZM5 12.25a.25.25 0 0 1 .25-.25h3.5a.25.25 0 0 1 .25.25v3.25a.25.25 0 0 1-.4.2l-1.45-1.087a.249.249 0 0 0-.3 0L5.4 15.7a.25.25 0 0 1-.4-.2Z">
                      </path>
                    </svg>
                  </div>
                  <div>
                    <a
                      target="_blank"
                      href="https://github.com/elixir-lang/elixir"
                      class="no-underline"
                    >
                      elixir-lang/elixir
                    </a>
                  </div>
                </div>
                <div class="flex text-sm mt-6">
                  <div class="mr-1 font-thin text-xs">
                    <span
                      class="inline-block h-3 w-3 rounded-full"
                      style="background-color: #6e4a7e;"
                    />
                  </div>
                  <div class="mr-4 text-grey-dark text-xs">
                    Elixir
                  </div>
                  <div class="mr-1 font-thin text-xs">
                    <svg
                      aria-label="stars"
                      role="img"
                      height="16"
                      viewBox="0 0 16 16"
                      version="1.1"
                      width="16"
                      data-view-component="true"
                      class="octicon octicon-star"
                    >
                      <path d="M8 .25a.75.75 0 0 1 .673.418l1.882 3.815 4.21.612a.75.75 0 0 1 .416 1.279l-3.046 2.97.719 4.192a.751.751 0 0 1-1.088.791L8 12.347l-3.766 1.98a.75.75 0 0 1-1.088-.79l.72-4.194L.818 6.374a.75.75 0 0 1 .416-1.28l4.21-.611L7.327.668A.75.75 0 0 1 8 .25Zm0 2.445L6.615 5.5a.75.75 0 0 1-.564.41l-3.097.45 2.24 2.184a.75.75 0 0 1 .216.664l-.528 3.084 2.769-1.456a.75.75 0 0 1 .698 0l2.77 1.456-.53-3.084a.75.75 0 0 1 .216-.664l2.24-2.183-3.096-.45a.75.75 0 0 1-.564-.41L8 2.694Z">
                      </path>
                    </svg>
                  </div>
                  <div class="mr-4 text-grey-dark text-xs">
                    22.3k
                  </div>
                  <div class="mr-1 font-thin text-xs">
                    <svg
                      aria-label="forks"
                      role="img"
                      height="16"
                      viewBox="0 0 16 16"
                      version="1.1"
                      width="16"
                      data-view-component="true"
                      class="octicon octicon-repo-forked"
                    >
                      <path d="M5 5.372v.878c0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75v-.878a2.25 2.25 0 1 1 1.5 0v.878a2.25 2.25 0 0 1-2.25 2.25h-1.5v2.128a2.251 2.251 0 1 1-1.5 0V8.5h-1.5A2.25 2.25 0 0 1 3.5 6.25v-.878a2.25 2.25 0 1 1 1.5 0ZM5 3.25a.75.75 0 1 0-1.5 0 .75.75 0 0 0 1.5 0Zm6.75.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Zm-3 8.75a.75.75 0 1 0-1.5 0 .75.75 0 0 0 1.5 0Z">
                      </path>
                    </svg>
                  </div>
                  <div class="mr-4 text-grey-dark text-xs">
                    3.2k
                  </div>
                </div>
              </div>
            </div>

            <div class="flex items-center">
              <div class="w-1/2 pt-6 pb-2 font-normal text-grey-darkest">
                1,438 contributions in the last year
              </div>
              <div class="w-1/2 pt-6 pb-2 justify-end text-right text-grey-dark text-sm font-light flex">
                <div>
                  Contribution settings
                </div>
                <div class="">
                  <svg
                    class="fill-current text-grey-dark h-4 w-4"
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                  >
                    <path d="M7.41 7.84L12 12.42l4.59-4.58L18 9.25l-6 6-6-6z" />
                  </svg>
                </div>
              </div>
            </div>

            <style>
              :root {
                --square-size: 10px;
                --square-gap: 5px;
                --week-width: calc(var(--square-size) + var(--square-gap));
              }

              .months { grid-area: months; }
              .days { grid-area: days; }
              .squares { grid-area: squares; }

              .contribuiton-calendar {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
                font-size: 12px;
                padding: 20px;
                border: 1px #e1e4e8 solid;
                margin: 20px;
                display: inline-grid;
                grid-template-areas: "empty months"
                                     "days squares";
                grid-template-columns: auto 1fr;
                grid-gap: 10px;
              }

              .months {
                display: grid;
                grid-template-columns: repeat(4, calc(var(--week-width) * 4))
                                       repeat(5, calc(var(--week-width) * 4))
                                       repeat(3, calc(var(--week-width) * 5));
              }

              .days,
              .squares {
                display: grid;
                grid-gap: var(--square-gap);
                grid-template-rows: repeat(7, var(--square-size));
              }

              .squares {
                grid-auto-flow: column;
                grid-auto-columns: var(--square-size);
              }

              .days li:nth-child(odd) {
                visibility: hidden;
              }

              .squares li {
                border: 0.1rem solid #b3b7bf;
                background-color: #ebedf0;
              }

              .squares li[data-level="1"] {
                border: none;
                background-color: #c48be4;
              }

              .squares li[data-level="2"] {
                border: none;
                background-color: #a96fc9;
              }

              .squares li[data-level="3"] {
                border: none;
                background-color: #3e1961;
              }
            </style>

            <div class="contribuiton-calendar">
              <ul class="months">
                <li>Jan</li>
                <li>Feb</li>
                <li>Mar</li>
                <li>Apr</li>
                <li>May</li>
                <li>Jun</li>
                <li>Jul</li>
                <li>Aug</li>
                <li>Sep</li>
                <li>Oct</li>
                <li>Nov</li>
                <li>Dec</li>
              </ul>
              <ul class="days">
                <li>Sun</li>
                <li>Mon</li>
                <li>Tue</li>
                <li>Wed</li>
                <li>Thu</li>
                <li>Fri</li>
                <li>Sat</li>
              </ul>
              <ul class="squares">
                <%= for _ <- 1..number_of_days_in_current_year() do %>
                  <% level = Enum.random(0..3) %>
                  <li data-level={to_string(level)}></li>
                <% end %>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, put_date(socket)}
  end

  defp put_date(socket) do
    now_me = Timex.now("America/Belem") |> Timex.format!("%H:%M", :strftime)

    %DateTime{zone_abbr: zone_me} = Timex.now("America/Belem")
    %DateTime{time_zone: time_zone, zone_abbr: zone_you} = Timex.local()

    assign(socket, date: now_me, time_zone: time_zone, zone_abbr: zone_you)
  end

  defp number_of_days_in_current_year do
    formatted_date = Timex.Format.DateTime.Formatter.format!(Timex.now(), "{YYYY}")

    current_year = String.to_integer(formatted_date)

    beginning_of_year = Timex.beginning_of_year({current_year, 1, 1})
    end_of_year = Timex.end_of_year({current_year, 12, 31})

    number_of_days = Timex.diff(end_of_year, beginning_of_year, :days) + 1

    number_of_days
  end
end
