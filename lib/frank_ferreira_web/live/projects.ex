defmodule FrankFerreiraWeb.ProjectsLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket) do
    projects = [
      %{
        id: "tarefinhas",
        name: "Tarefinhas",
        image: "/images/tarefinhas.png",
        description:
          gettext(
            "Mobile task management app with custom categories, filters, and confetti celebrations."
          ),
        full_description:
          gettext(
            "Tarefinhas is a mobile task management app for Android, designed to organize tasks in a simple and fun way. Built with React Native and Expo, it features custom categories, task filtering, and confetti celebrations for completed tasks."
          ),
        url: "https://tarefinhas.frankferreira.com.br",
        github: nil,
        tech: [
          %{name: "React Native", logo: "reactnative.dev"},
          %{name: "Expo", logo: "expo.dev"},
          %{name: "TypeScript", logo: "typescriptlang.org"}
        ]
      },
      %{
        id: "agenda-letiva",
        name: "Agenda Letiva",
        image: "/images/agendaletiva.png",
        description:
          gettext(
            "School management platform for student assessments, grades, and academic scheduling."
          ),
        full_description:
          gettext(
            "School management platform developed for Agenda Letiva, providing tools for managing student assessments, grades, and academic scheduling. Built with Elixir, Phoenix, and LiveView, offering a real-time, responsive interface for educators and administrators."
          ),
        url: "https://agendaletiva.com.br",
        github: nil,
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"},
          %{name: "Phoenix", logo: "phoenixframework.org"},
          %{name: "LiveView", logo: "phoenixframework.org"}
        ]
      },
      %{
        id: "circuito-das-plantas",
        name: "Circuito das Plantas",
        image: "/images/circuitodasplantas.png",
        description:
          gettext(
            "Product catalog and showcase for requesting plants, seedlings, and gardening products."
          ),
        full_description:
          gettext(
            "Product catalog and showcase developed for Circuito das Plantas, a plant shop offering a wide variety of plants, seedlings, and gardening products. A modern, responsive application built with React and Vite, featuring a product catalog and showcase for requesting products."
          ),
        url: "https://circuitodasplantas.com.br",
        github: nil,
        tech: [
          %{name: "React", logo: "react.dev"},
          %{name: "Vite", logo: "vite.dev"},
          %{name: "JavaScript", logo: "javascript.com"}
        ]
      },
      %{
        id: "bruna-caroline",
        name: "Bruna Caroline",
        image: nil,
        description:
          gettext(
            "Professional website for psychologist Bruna Caroline with online and in-person psychotherapy services."
          ),
        full_description:
          gettext(
            "Professional website developed for psychologist Bruna Caroline, offering online and in-person psychotherapy services. A modern, responsive single-page application built with React and Vite, deployed on Vercel."
          ),
        url: "https://brunacaroline.com.br",
        github: nil,
        tech: [
          %{name: "React", logo: "react.dev"},
          %{name: "Vite", logo: "vite.dev"},
          %{name: "JavaScript", logo: "javascript.com"}
        ]
      },
      %{
        id: "mario-artur",
        name: "Mario Artur",
        image: "/images/marioartur.png",
        description:
          gettext(
            "Landing page for football player Mario Artur with player profile and career info."
          ),
        full_description:
          gettext(
            "Landing page developed for football player Mario Artur (Lateral / Meio Campista). A modern, responsive single-page application built with React and Vite, featuring the player's profile, career highlights, and contact information."
          ),
        url: "https://marioartur.com",
        github: nil,
        tech: [
          %{name: "React", logo: "react.dev"},
          %{name: "Vite", logo: "vite.dev"},
          %{name: "JavaScript", logo: "javascript.com"}
        ]
      },
      %{
        id: "irrisusten",
        name: gettext("IrriSusten"),
        image: nil,
        description:
          gettext(
            "Information system to manage plantation irrigation with web and mobile interfaces."
          ),
        full_description:
          gettext(
            "The study introduces Irrisusten, an information system to manage plantation irrigation. It automates agricultural production control and reduces water wastage. It features web and mobile interfaces, utilizing physical components like Arduino Uno, sensors, relays, and Bluetooth modules."
          ),
        url: "https://sol.sbc.org.br/index.php/wcama/article/view/2941",
        github: nil,
        tech: [
          %{name: "Arduino", logo: "arduino.cc"},
          %{name: "Sensors", logo: "sensortechcanada.com"},
          %{name: "Bluetooth", logo: "bluetooth.com"}
        ]
      },
      %{
        id: "elixir-phoenix",
        name: gettext("Introduction to Elixir and Phoenix"),
        image: nil,
        description:
          gettext("Educational repository for Elixir and Phoenix mini-course at UFRA."),
        full_description:
          gettext(
            "Repository for the Elixir and Phoenix mini-course, provided by the Applied Computing Laboratory at UFRA, functioning as a central repository for educational materials tailored to students and tech enthusiasts keen on exploring the dynamic realms of Elixir and Phoenix development."
          ),
        url: "https://github.com/franknfjr/elixir-phoenix",
        github: "https://github.com/franknfjr/elixir-phoenix",
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"},
          %{name: "Phoenix", logo: "phoenixframework.org"}
        ]
      },
      %{
        id: "mdown-ex",
        name: "Mdown_ex",
        image: nil,
        description: gettext("Converts Markdown files to HTML and Livebook using Elixir."),
        full_description:
          gettext(
            "The Markdown in Elixir project converts Markdown files to HTML and Livebook using the Elixir language, leveraging its efficiency and scalability. It provides a flexible solution for developers to format text quickly and effectively in various online and data development contexts."
          ),
        url: "https://github.com/franknfjr/md2livemd",
        github: "https://github.com/franknfjr/md2livemd",
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"}
        ]
      },
      %{
        id: "healthcare",
        name: gettext("Healthcare"),
        image: nil,
        description:
          gettext("Dashboard for patient appointments, medications, and hospital indicators."),
        full_description:
          gettext(
            "The 'Healthcare' app provides a comprehensive overview of patient appointments, medications, phone calls, surgeries, financial transactions, and other relevant data, offering healthcare professionals a detailed insight into daily hospital indicators for better management and decision-making."
          ),
        url: nil,
        github: nil,
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"},
          %{name: "Phoenix", logo: "phoenixframework.org"},
          %{name: "LiveView", logo: "phoenixframework.org"}
        ]
      },
      %{
        id: "cdn",
        name: "CDN",
        image: nil,
        description: gettext("Internal content delivery network for file management."),
        full_description:
          gettext(
            "The CDN (Content Delivery Network) system developed in Elixir was initially designed for internal file management. Using the Elixir language, the system offered an efficient and scalable solution to manage content distribution, optimizing access and file delivery across a network."
          ),
        url: nil,
        github: nil,
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"}
        ]
      },
      %{
        id: "voter-system",
        name: gettext("Voter Intentions System"),
        image: nil,
        description: gettext("Platform for collecting and analyzing voter preference data."),
        full_description:
          gettext(
            "The Voter Intentions System is a digital platform designed to facilitate the collection and analysis of data related to voters' preferences in a specific political context."
          ),
        url: nil,
        github: nil,
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"},
          %{name: "Phoenix", logo: "phoenixframework.org"}
        ]
      }
    ]

    all_tags =
      projects
      |> Enum.flat_map(& &1.tech)
      |> Enum.map(& &1.name)
      |> Enum.uniq()
      |> Enum.sort()

    {:ok,
     assign(socket,
       projects: projects,
       selected_project: nil,
       all_tags: all_tags,
       selected_tag: nil
     )}
  end

  def handle_event("filter_tag", %{"tag" => tag}, socket) do
    selected_tag = if socket.assigns.selected_tag == tag, do: nil, else: tag
    {:noreply, assign(socket, selected_tag: selected_tag)}
  end

  def handle_event("clear_filter", _params, socket) do
    {:noreply, assign(socket, selected_tag: nil)}
  end

  def handle_event("open_modal", %{"id" => id}, socket) do
    project = Enum.find(socket.assigns.projects, &(&1.id == id))
    {:noreply, assign(socket, selected_project: project)}
  end

  def handle_event("close_modal", _params, socket) do
    {:noreply, assign(socket, selected_project: nil)}
  end

  def render(assigns) do
    ~H"""
    <main class="mx-auto max-w-3xl px-4 sm:px-6 lg:px-8 py-24">
      <h1 class="text-4xl font-medium tracking-tight text-light-text dark:text-dark-text mb-4">
        <%= gettext("Projects") %>
      </h1>
      <p class="text-light-muted dark:text-dark-muted mb-8">
        <%= gettext("Things I've built and contributed to.") %>
      </p>

      <%!-- Tag Filters --%>
      <div class="flex flex-wrap gap-2 mb-8">
        <%= for tag <- @all_tags do %>
          <button
            phx-click="filter_tag"
            phx-value-tag={tag}
            class={"px-3 py-1.5 rounded-lg text-sm font-medium border transition-all duration-200 " <>
              if @selected_tag == tag do
                "bg-accent text-white border-accent"
              else
                "bg-light-surface dark:bg-dark-surface border-light-border dark:border-dark-border text-light-muted dark:text-dark-muted hover:border-accent/50 hover:text-accent"
              end}
          >
            <%= tag %>
          </button>
        <% end %>
        <%= if @selected_tag do %>
          <button
            phx-click="clear_filter"
            class="px-3 py-1.5 rounded-lg text-sm font-medium text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors"
          >
            <%= gettext("Clear") %>
          </button>
        <% end %>
      </div>

      <div class="grid gap-6">
        <% filtered_projects =
          if @selected_tag,
            do: Enum.filter(@projects, fn p -> Enum.any?(p.tech, &(&1.name == @selected_tag)) end),
            else: @projects %>
        <%= for project <- filtered_projects do %>
          <div
            phx-click="open_modal"
            phx-value-id={project.id}
            class="group cursor-pointer p-6 rounded-xl bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border hover:border-accent/50 dark:hover:border-accent/50 transition-all duration-300 hover:shadow-lg hover:shadow-accent/5"
          >
            <div class="flex items-center justify-between">
              <div class="mr-4 flex-shrink-0">
                <%= if project.image do %>
                  <img
                    src={project.image}
                    alt={project.name}
                    class="w-12 h-12 rounded-lg object-contain"
                  />
                <% else %>
                  <div class="w-12 h-12 rounded-lg bg-light-bg dark:bg-dark-bg border border-light-border dark:border-dark-border flex items-center justify-center">
                    <svg
                      class="w-6 h-6 text-light-muted dark:text-dark-muted"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="1.5"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M17.25 6.75L22.5 12l-5.25 5.25m-10.5 0L1.5 12l5.25-5.25m7.5-3l-4.5 16.5"
                      />
                    </svg>
                  </div>
                <% end %>
              </div>
              <div class="flex-1">
                <h2 class="text-xl font-medium text-light-text dark:text-dark-text group-hover:text-accent transition-colors mb-2">
                  <%= project.name %>
                </h2>
                <p class="text-light-muted dark:text-dark-muted leading-relaxed mb-4">
                  <%= project.description %>
                </p>
                <div class="flex flex-wrap gap-3">
                  <%= for tech <- project.tech do %>
                    <div class="flex items-center gap-1.5 text-sm text-light-muted dark:text-dark-muted">
                      <%= if tech.logo do %>
                        <img
                          src={"https://img.logo.dev/#{tech.logo}?token=pk_SV36z4BVSz63N08ZgRSe3A&format=png&size=32"}
                          alt={tech.name}
                          class="w-4 h-4 rounded-sm"
                        />
                      <% else %>
                        <svg
                          class="w-4 h-4"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          stroke-width="2"
                        >
                          <circle cx="12" cy="12" r="10" />
                        </svg>
                      <% end %>
                      <span><%= tech.name %></span>
                    </div>
                  <% end %>
                </div>
              </div>
              <div class="ml-4 text-light-muted dark:text-dark-muted group-hover:text-accent transition-colors">
                <svg
                  class="w-5 h-5"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25"
                  />
                </svg>
              </div>
            </div>
          </div>
        <% end %>
      </div>

      <%!-- Modal --%>
      <%= if @selected_project do %>
        <div
          class="fixed inset-0 z-50 flex items-center justify-center p-4"
          phx-window-keydown="close_modal"
          phx-key="Escape"
        >
          <%!-- Backdrop --%>
          <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" phx-click="close_modal" />

          <%!-- Modal Content --%>
          <div class="relative w-full max-w-lg bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border rounded-2xl shadow-2xl overflow-hidden animate-modal-in">
            <%!-- Header --%>
            <div class="p-6 border-b border-light-border dark:border-dark-border">
              <div class="flex items-start justify-between">
                <div class="flex items-center gap-3">
                  <%= if @selected_project.image do %>
                    <img
                      src={@selected_project.image}
                      alt={@selected_project.name}
                      class="w-10 h-10 rounded-lg object-contain"
                    />
                  <% else %>
                    <div class="w-10 h-10 rounded-lg bg-light-bg dark:bg-dark-bg border border-light-border dark:border-dark-border flex items-center justify-center">
                      <svg
                        class="w-5 h-5 text-light-muted dark:text-dark-muted"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke-width="1.5"
                        stroke="currentColor"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          d="M17.25 6.75L22.5 12l-5.25 5.25m-10.5 0L1.5 12l5.25-5.25m7.5-3l-4.5 16.5"
                        />
                      </svg>
                    </div>
                  <% end %>
                  <h2 class="text-2xl font-medium text-light-text dark:text-dark-text">
                    <%= @selected_project.name %>
                  </h2>
                </div>
                <button
                  phx-click="close_modal"
                  class="p-1 text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors"
                >
                  <svg
                    class="w-6 h-6"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke-width="1.5"
                    stroke="currentColor"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
            </div>

            <%!-- Body --%>
            <div class="p-6">
              <p class="text-light-muted dark:text-dark-muted leading-relaxed mb-6">
                <%= @selected_project.full_description %>
              </p>

              <%!-- Tech Stack --%>
              <div class="mb-6">
                <h3 class="text-sm font-medium text-light-text dark:text-dark-text mb-3">
                  <%= gettext("Tech Stack") %>
                </h3>
                <div class="flex flex-wrap gap-3">
                  <%= for tech <- @selected_project.tech do %>
                    <div class="flex items-center gap-2 px-3 py-1.5 bg-light-bg dark:bg-dark-bg rounded-lg text-sm text-light-muted dark:text-dark-muted">
                      <%= if tech.logo do %>
                        <img
                          src={"https://img.logo.dev/#{tech.logo}?token=pk_SV36z4BVSz63N08ZgRSe3A&format=png&size=32"}
                          alt={tech.name}
                          class="w-5 h-5 rounded-sm"
                        />
                      <% else %>
                        <svg
                          class="w-5 h-5"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          stroke-width="2"
                        >
                          <circle cx="12" cy="12" r="10" />
                        </svg>
                      <% end %>
                      <span><%= tech.name %></span>
                    </div>
                  <% end %>
                </div>
              </div>

              <%!-- Links --%>
              <div class="flex flex-wrap gap-3">
                <%= if @selected_project.github do %>
                  <a
                    href={@selected_project.github}
                    target="_blank"
                    class="inline-flex items-center gap-2 px-4 py-2 bg-dark-bg dark:bg-light-bg text-dark-text dark:text-light-text rounded-lg text-sm font-medium hover:opacity-80 transition-opacity"
                  >
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                      <path
                        fill-rule="evenodd"
                        d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                        clip-rule="evenodd"
                      />
                    </svg>
                    GitHub
                  </a>
                <% end %>
                <%= if @selected_project.url do %>
                  <a
                    href={@selected_project.url}
                    target="_blank"
                    class="inline-flex items-center gap-2 px-4 py-2 bg-accent text-white rounded-lg text-sm font-medium hover:opacity-80 transition-opacity"
                  >
                    <svg
                      class="w-5 h-5"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="1.5"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25"
                      />
                    </svg>
                    <%= gettext("View Project") %>
                  </a>
                <% end %>
                <%= if is_nil(@selected_project.url) and is_nil(@selected_project.github) do %>
                  <span class="text-sm text-light-muted dark:text-dark-muted italic">
                    <%= gettext("Private project - no public links available") %>
                  </span>
                <% end %>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </main>

    <style>
      @keyframes modal-in {
        from {
          opacity: 0;
          transform: scale(0.95) translateY(10px);
        }
        to {
          opacity: 1;
          transform: scale(1) translateY(0);
        }
      }
      .animate-modal-in {
        animation: modal-in 0.2s ease-out;
      }
    </style>
    """
  end
end
