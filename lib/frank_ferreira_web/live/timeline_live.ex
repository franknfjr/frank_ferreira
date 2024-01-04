defmodule FrankFerreiraWeb.TimelineLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket) do
    histories = build_timeline()
    socket = assign(socket, histories: histories)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <main role="main" class="container mx-auto px-4 sm:px-6 lg:px-8 py-14 md:py-20">
      <header class="max-w-[44rem] 2xl:max-w-3xl mx-auto mb-14 sm:mb-16">
        <article class="xl:grid grid-cols-auto-span-auto items-start sm:text-lg leading-relaxed">
          <section class="relative max-w-[44rem] 2xl:max-w-3xl mx-auto">
            <div class="-my-6">
              <%= for history <- @histories do %>
                <div id={"timeline-" <> history.id} class="relative pl-8 sm:pl-32 py-6 group">
                  <!-- Purple label -->
                  <div class="font-caveat font-medium text-2xl text-indigo-500 mb-1 sm:mb-0">
                    <%= history.h2 %>
                  </div>
                  <!-- Vertical line (::before) ~ Date ~ Title ~ Circle marker (::after) -->
                  <div class="flex flex-col sm:flex-row items-start mb-1 group-last:before:hidden before:absolute before:left-2 sm:before:left-0 before:h-full before:px-px before:bg-slate-300 sm:before:ml-[6.5rem] before:self-start before:-translate-x-1/2 before:translate-y-3 after:absolute after:left-2 sm:after:left-0 after:w-2 after:h-2 after:bg-indigo-600 after:border-4 after:box-content after:border-slate-50 after:rounded-full sm:after:ml-[6.5rem] after:-translate-x-1/2 after:translate-y-1.5">
                    <time class="sm:absolute left-0 translate-y-0.5 inline-flex items-center justify-center text-xs font-semibold uppercase w-20 h-6 mb-3 sm:mb-0 text-gray-600 bg-white dark:text-black rounded-full">
                      <%= history.date %>
                    </time>
                    <div class="text-xl font-bold text-slate-900 dark:text-white">
                      <%= history.point %>
                    </div>
                  </div>
                  <!-- Content -->
                  <div class="text-slate-500">
                    <%= history.description %>
                  </div>
                </div>
              <% end %>
            </div>
          </section>
        </article>
      </header>
    </main>
    """
  end

  defp build_timeline() do
    timeline =
      [
        %{
          id: "1",
          date: "Aug, 1994",
          h2: "Born",
          point: "Hello World!",
          description: "First release in prod."
        },
        %{
          id: "2",
          date: "Dez, 2004",
          h2: "First PC",
          point: "'Santa' gave me a Pentium",
          description:
            "With a lot of sacrifice, my parents gave me a super fast Pentium computer on Christmas Eve.
            I remember putting in a password and forgetting it the next day. lol"
        },
        %{
          id: "3",
          date: "Mai, 2013",
          h2: "Hello World Delphi",
          point: "Yes, my first code was made in Delphi",
          description:
            "It was a gift from my friend, my first DVD course on Hacking!
          I remembered to make a browser at the end and it was amazing, I had no idea what I was writing but I knew what I wanted."
        },
        %{
          id: "4",
          date: "Dez, 2014",
          h2: "Beginning of technical studies",
          point: "Federal Institute of Para - Ananindeua",
          description:
            "One year later of my first code in Delphi, I started studying computing in my hometown, being one of the first graduates in the city's history."
        },
        %{
          id: "5",
          date: "Fev, 2015",
          h2: "Beginning of College",
          point: "Federal Rural University of Amazonia - Belém",
          description:
            "I opted for Information Systems instead of Journalism. I arrived smurfing, already familiar with Portuguese pseudocode and C by that time."
        },
        %{
          id: "6",
          date: "Jun, 2016",
          h2: "Teaching to learn",
          point: "Programming class with Scratch for underprivileged children.",
          description:
            "It was an amazing experience, firstly because I was embraced by a teacher who believed in my potential when everyone raised difficulties. She proposed to teach programming to underprivileged children using the Scratch tool, where they could take their first steps in programming."
        },
        %{
          id: "7",
          date: "Sep, 2016",
          h2: "First apresentation in Seminar",
          point: "The Model City - Castanhal",
          description:
            "I submitted my first academic work entitled 'MOBILE APPLICATION: DEVELOPMENT OF A QUIZ GAME WITH COMPUTER SCIENCE CONTENT' and presented it at the VIII Seminar on Scientific, Technological, and Innovation Initiation."
        },
        %{
          id: "8",
          date: "Out, 2017",
          h2: "Completion of technical studies",
          point: "Technical degree graduation in computer science.",
          description:
            "It was an honor to be one of the first four students to graduate in computer science from the municipality of Ananindeua. I had the opportunity to learn a lot and make great friends."
        },
        %{
          id: "9",
          date: "Jul, 2018",
          h2: "First trip presenting programming",
          point: "XXXVIII Brazilian Computer Society Congress (CSBC 2018)",
          description:
            "I remember that the idea for the scientific article came from a friend in environmental engineering, and simply, me and two other crazy friends embraced the cause and ended up traveling to Rio Grande do Norte - Natal to present a paper on the topic of Applied Computing to Environmental Management and Natural Resources."
        },
        %{
          id: "10",
          date: "Jun, 2019",
          h2: "First Job!",
          point: "On site",
          description:
            "The most amazing experience I've ever had in my life, I was able to connect with various people from different fields, where I could apply my knowledge for a long time and absorb knowledge from others. A journey full of challenges in personal and technical development where I could leave my mark and assist everyone."
        },
        %{
          id: "11",
          date: "Jan, 2020",
          h2: "Completion of College",
          point: "Graduation in Information Systems",
          description:
            "Another graduation, this time from college. This time, distant relatives came to visit me to celebrate this moment. I am very grateful to everyone who, in one way or another, contributed to my journey, and without you, I wouldn't have achieved it. And yes, once again, graduated!"
        },
        %{
          id: "12",
          date: "May, 2022",
          h2: "First Job!",
          point: "Remote",
          description:
            "My first job as a backend developer in Elixir, it was a fantastic few months. I learned the equivalent of 10 years in 1 year, personally met amazing friends who provided great guidance."
        },
        %{
          id: "13",
          date: "Dez, 2023",
          h2: "Official launch of this website",
          point: "Ladies and gentlemen, welcome!",
          description:
            "I finally brought to life this project that I have been thinking about for years but hadn't started. It ended up becoming a goal for 2023 at the last minute. Exciting updates coming soon!!!"
        }
      ]
      |> Enum.sort_by(&String.to_integer(&1.id), :desc)

    timeline
  end
end
