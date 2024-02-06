defmodule FrankFerreiraWeb.ProjectsLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket) do
    categories = [
      %{
        name: "Open-source",
        slug: "open-source",
        description: "Open-source projects I've contributed to",
        projects: [
          %{
            name: "IrriSusten",
            description:
              "The study introduces Irrisusten, an information system to manage plantation irrigation. It automates agricultural production control and reduces water wastage. It features web and mobile interfaces, utilizing physical components like Arduino Uno, sensors, relays, and Bluetooth modules.",
            url: "https://sol.sbc.org.br/index.php/wcama/article/view/2941",
            image: "/images/irrisusten.png"
          },
          %{
            name: "Introduction to Elixir and Phoenix",
            description:
              "Repository for the Elixir and Phoenix mini-course, provided by the Applied Computing Laboratory at UFRA, functioning as a central repository for educational materials tailored to students and tech enthusiasts keen on exploring the dynamic realms of Elixir and Phoenix development.",
            url: "https://github.com/franknfjr/elixir-phoenix",
            image: "/images/phx1.png"
          },
          %{
            name: "Mdown_ex",
            description:
              "The Markdown in Elixir project converts Markdown files to HTML and Livebook using the Elixir language, leveraging its efficiency and scalability. It provides a flexible solution for developers to format text quickly and effectively in various online and data development contexts.",
            url: "https://github.com/franknfjr/md2livemd",
            image: "/images/md.png"
          }
        ]
      },
      %{
        name: "Client's projects",
        slug: "clients-projects",
        description: "Freelance projects I've worked on",
        projects: [
          %{
            name: "Healthcare",
            description:
              "
            The 'Healthcare' app provides a comprehensive overview of patient appointments, medications, phone calls, surgeries, financial transactions, and other relevant data, offering healthcare professionals a detailed insight into daily hospital indicators for better management and decision-making.",
            url: nil,
            image: "/images/healthcare.png"
          },
          %{
            name: "CDN",
            description:
              "The CDN (Content Delivery Network) system developed in Elixir was initially designed for internal file management. Using the Elixir language, the system offered an efficient and scalable solution to manage content distribution, optimizing access and file delivery across a network. This platform allowed for the storage, retrieval, and updating of files quickly and reliably, meeting the internal control needs of an organization.",
            url: nil,
            image: "/images/cdn2.png"
          },
          %{
            name: "Voter Intentions System",
            description:
              "The Voter Intentions System is a digital platform designed to facilitate the collection and analysis of data related to voters' preferences in a specific political context.",
            url: nil,
            image: "/images/vote1.png"
          }
        ]
      }
    ]

    {:ok, assign(socket, categories: categories)}
  end

  def render(assigns) do
    ~H"""
    <main>
      <div class="sm:px-8 mt-16 mb-16">
        <div class="mx-auto max-w-7xl lg:px-8">
          <div class="relative px-4 sm:px-8 lg:px-12">
            <div class="mx-auto max-w-2xl lg:max-w-5xl">
              <div class="relative max-w-3xl px-4 sm:px-6 lg:px-8 mx-auto sm:text-center">
                <p class="mt-6 text-[2.5rem] leading-none sm:text-6xl tracking-tight font-bold text-slate-900 dark:text-white">
                  My Journey Through Projects: Where Ideas Become Reality
                </p>
                <p class="mt-4 text-lg text-slate-600 dark:text-slate-400">
                  I've created various projects with the aim of making a positive impact. While I've experimented with numerous endeavors, these particular ones hold a special place in my heart. Most of them are open-source, meaning you're welcome to explore the code and offer suggestions for enhancements if you feel inspired.
                  Below is a <em>list</em>
                  of my current
                  <a class="font-semibold border-b border-sky-300 text-gray-900 hover:border-b-2 dark:text-white dark:border-sky-400">
                    projects
                  </a>
                  .
                </p>
              </div>
              <div class="mt-16 sm:mt-20">
                <div :for={category <- @categories} class="space-y-20">
                  <div>
                    <h2
                      id="category"
                      class="text-3xl font-bold tracking-tight text-zinc-800 dark:text-zinc-100 mt-10"
                    >
                      <a href={"##{category.slug}"}><%= category.name %></a>
                    </h2>
                    <ul
                      role="list"
                      class="grid grid-cols-1 gap-x-12 gap-y-16 sm:grid-cols-2 lg:grid-cols-3 mt-10"
                    >
                      <li
                        :for={project <- category.projects}
                        class="group relative flex flex-col items-start"
                      >
                        <div class="aspect-[672/494] relative rounded-md transform overflow-hidden shadow-[0_2px_8px_rgba(15,23,42,0.08)] bg-slate-200 dark:bg-slate-700 relative z-10 ">
                          <img src={project.image} alt="" />
                        </div>
                        <h2 class="mt-6 text-base font-semibold text-zinc-800 dark:text-zinc-100">
                          <div class="absolute -inset-y-6 -inset-x-4 z-0 scale-95 bg-zinc-50 opacity-0 transition group-hover:scale-100 group-hover:opacity-100 dark:bg-zinc-800/50 sm:-inset-x-6 sm:rounded-2xl">
                          </div>
                          <a href={project.url} target="_blank">
                            <span class="absolute -inset-y-6 -inset-x-4 z-20 sm:-inset-x-6 sm:rounded-2xl">
                            </span>
                            <span class="relative z-10"><%= project.name %></span>
                          </a>
                        </h2>
                        <p class="relative z-10 mt-2 text-sm text-zinc-600 dark:text-zinc-400">
                          <%= project.description %>
                        </p>
                        <p
                          :if={not is_nil(project.url)}
                          class="relative z-10 mt-6 flex text-sm font-medium text-zinc-400 transition group-hover:text-teal-500 dark:text-zinc-200"
                        >
                          <svg viewBox="0 0 24 24" aria-hidden="true" class="h-6 w-6 flex-none">
                            <path
                              d="M15.712 11.823a.75.75 0 1 0 1.06 1.06l-1.06-1.06Zm-4.95 1.768a.75.75 0 0 0 1.06-1.06l-1.06 1.06Zm-2.475-1.414a.75.75 0 1 0-1.06-1.06l1.06 1.06Zm4.95-1.768a.75.75 0 1 0-1.06 1.06l1.06-1.06Zm3.359.53-.884.884 1.06 1.06.885-.883-1.061-1.06Zm-4.95-2.12 1.414-1.415L12 6.344l-1.415 1.413 1.061 1.061Zm0 3.535a2.5 2.5 0 0 1 0-3.536l-1.06-1.06a4 4 0 0 0 0 5.656l1.06-1.06Zm4.95-4.95a2.5 2.5 0 0 1 0 3.535L17.656 12a4 4 0 0 0 0-5.657l-1.06 1.06Zm1.06-1.06a4 4 0 0 0-5.656 0l1.06 1.06a2.5 2.5 0 0 1 3.536 0l1.06-1.06Zm-7.07 7.07.176.177 1.06-1.06-.176-.177-1.06 1.06Zm-3.183-.353.884-.884-1.06-1.06-.884.883 1.06 1.06Zm4.95 2.121-1.414 1.414 1.06 1.06 1.415-1.413-1.06-1.061Zm0-3.536a2.5 2.5 0 0 1 0 3.536l1.06 1.06a4 4 0 0 0 0-5.656l-1.06 1.06Zm-4.95 4.95a2.5 2.5 0 0 1 0-3.535L6.344 12a4 4 0 0 0 0 5.656l1.06-1.06Zm-1.06 1.06a4 4 0 0 0 5.657 0l-1.061-1.06a2.5 2.5 0 0 1-3.535 0l-1.061 1.06Zm7.07-7.07-.176-.177-1.06 1.06.176.178 1.06-1.061Z"
                              fill="currentColor"
                            >
                            </path>
                          </svg>
                          <span class="break-all"><%= project.url %></span>
                        </p>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
    """
  end
end
