defmodule FrankFerreiraWeb.ProjectsLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket) do
    projects = [
      %{
        id: "serpent",
        name: "Serpent",
        date: ~D[2026-05-23],
        image: "/images/serpent.svg",
        description:
          gettext(
            "Retro 8-bit snake game for Android with skins, ranking, and chiptune soundtrack — currently in Play Store review."
          ),
        full_description:
          gettext(
            "Serpent revisits the classic Nokia snake with chiptune music synthesized in real time, unlockable skins, achievements, and a global ranking. Free, offline-first, no login. Built natively for Android and currently under Play Store review. This entry is the landing page for the game."
          ),
        url: "https://serpent.frankferreira.com.br",
        github: nil,
        tech: [
          %{name: "Android", logo: "android.com"},
          %{name: "Kotlin", logo: "kotlinlang.org"},
          %{name: "HTML", logo: "/images/html5-logo.svg"}
        ]
      },
      %{
        id: "hugo-andre-personal",
        name: "Hugo André Personal",
        date: ~D[2026-03-20],
        image: "/images/hugoandrepersonal.png",
        description:
          gettext("Personal trainer website for body transformation programs for women 40+."),
        full_description:
          gettext(
            "Professional website developed for Hugo André Personal, a personal trainer with 15+ years of experience specializing in body transformation for women 40+. Features training programs, workout details, and WhatsApp integration for client contact. Built with React and Vite, deployed on Vercel."
          ),
        url: "https://hugoandrepersonal.com.br",
        github: nil,
        tech: [
          %{name: "React", logo: "react.dev"},
          %{name: "Vite", logo: "vite.dev"},
          %{name: "JavaScript", logo: "javascript.dev.br"}
        ]
      },
      %{
        id: "entregador-das-galaxias",
        name: "Entregador das Galaxias",
        date: ~D[2026-03-06],
        image: "/images/entregadordasgalaxias.png",
        description:
          gettext(
            "Educational space delivery game built as a fun challenge for kids with trending themes in Brazil."
          ),
        full_description:
          gettext(
            "Entregador das Galaxias is an educational browser game created as a challenge for my niece Sofia, combining trending themes in Brazil 2026 in a playful and non-violent format. Built with pure HTML, CSS, and JavaScript, it features a space delivery adventure designed to be fun and relevant for kids."
          ),
        url: "https://entregadordasgalaxias.frankferreira.com.br",
        github: "https://github.com/franknfjr/entregador-das-galaxias",
        tech: [
          %{name: "HTML", logo: "/images/html5-logo.svg"},
          %{name: "CSS", logo: "/images/css3-logo.svg"},
          %{name: "JavaScript", logo: "javascript.dev.br"}
        ]
      },
      %{
        id: "circuito-das-plantas",
        name: "Circuito das Plantas",
        date: ~D[2026-03-06],
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
          %{name: "JavaScript", logo: "javascript.dev.br"}
        ]
      },
      %{
        id: "bruna-caroline",
        name: "Bruna Caroline",
        date: ~D[2026-03-05],
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
          %{name: "JavaScript", logo: "javascript.dev.br"}
        ]
      },
      %{
        id: "mario-artur",
        name: "Mario Artur",
        date: ~D[2026-03-04],
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
          %{name: "JavaScript", logo: "javascript.dev.br"}
        ]
      },
      %{
        id: "tarefinhas",
        name: "Tarefinhas",
        date: ~D[2026-02-14],
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
        date: ~D[2025-12-01],
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
        id: "voce-decide",
        name: "VoceDecide",
        date: ~D[2024-12-03],
        image: nil,
        description:
          gettext("Real-time interactive voting app for live presentations and talks."),
        full_description:
          gettext(
            "VoceDecide is a real-time interactive voting application designed for live presentations and talks. Built with Elixir, Phoenix, and LiveView, it allows the audience to vote and decide what happens next during a presentation."
          ),
        url: "https://voce-decide.fly.dev",
        github: "https://github.com/franknfjr/voce_decide",
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"},
          %{name: "Phoenix", logo: "phoenixframework.org"},
          %{name: "LiveView", logo: "phoenixframework.org"}
        ]
      },
      %{
        id: "voter-system",
        name: gettext("Voter Intentions System"),
        date: ~D[2024-08-07],
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
      },
      %{
        id: "mdown-ex",
        name: "Mdown_ex",
        date: ~D[2023-09-15],
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
        date: ~D[2019-12-01],
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
        date: ~D[2019-08-01],
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
        id: "elixir-phoenix",
        name: gettext("Introduction to Elixir and Phoenix"),
        date: ~D[2018-06-25],
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
        id: "irrisusten",
        name: gettext("IrriSusten"),
        date: ~D[2018-04-29],
        image: "/images/irrisusten.png",
        description:
          gettext(
            "Information system to manage plantation irrigation with web and mobile interfaces."
          ),
        full_description:
          gettext(
            "The study introduces Irrisusten, an information system to manage plantation irrigation. It automates agricultural production control and reduces water wastage. It features web and mobile interfaces, utilizing physical components like Arduino Uno, sensors, relays, and Bluetooth modules."
          ),
        url: "https://sol.sbc.org.br/index.php/wcama/article/view/2941",
        github: "https://github.com/franknfjr/irrisusten",
        tech: [
          %{name: "Arduino", logo: "arduino.cc"},
          %{name: "Sensors", logo: "sensortechcanada.com"},
          %{name: "Bluetooth", logo: "bluetooth.com"}
        ]
      }
    ]

    has_open_source = Enum.any?(projects, & &1.github)

    all_tags =
      projects
      |> Enum.flat_map(& &1.tech)
      |> Enum.map(& &1.name)
      |> Enum.uniq()
      |> Enum.sort()
      |> then(fn tags -> if has_open_source, do: ["Open Source" | tags], else: tags end)

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
    <div class="ff-page">
      <section class="ff-section" style="border-bottom: 1px solid var(--rule);">
        <div class="ff-eyebrow">№ 03 — <%= gettext("Index of works") %></div>
        <div class="ff-grid-projects-hdr" style="margin-top: 8px;">
          <h1 class="ff-hero-title" style="font-size: clamp(36px, 9vw, 84px);">
            <%= gettext("Projects") %>
          </h1>
          <div
            class="ff-stats-row"
            style="display:flex; gap: 28px; flex-wrap: wrap; justify-content: center;"
          >
            <% has_oss = Enum.count(@projects, & &1.github) %>
            <%= for {n, l} <- [{length(@projects), gettext("shipped")}, {has_oss, gettext("open source")}, {2018, gettext("since")}] do %>
              <div class="ff-stat">
                <div class="num"><%= n %></div>
                <div class="lbl"><%= l %></div>
              </div>
            <% end %>
          </div>
        </div>
        <p style="font-size:17px; line-height:1.55; color: var(--ink-2); max-width: 560px; margin-top:18px;">
          <%= gettext(
            "Things I've built and contributed to — client work, weekend experiments, and the occasional gift for my niece."
          ) %>
        </p>
      </section>

      <section style="padding: 16px 24px; border-bottom: 1px solid var(--rule); display:flex; gap:8px; flex-wrap: wrap; align-items: center;">
        <span class="ff-mono" style="font-size:11px; color: var(--ink-3); margin-right:6px;">
          <%= gettext("filter") %> →
        </span>
        <button
          phx-click="clear_filter"
          class={"ff-chip" <> if @selected_tag in [nil, ""], do: " is-active", else: ""}
          style="border:0;cursor:pointer;"
        >
          <%= gettext("all") %>
        </button>
        <%= for tag <- @all_tags do %>
          <button
            phx-click="filter_tag"
            phx-value-tag={tag}
            class={"ff-chip" <> if @selected_tag == tag, do: " is-active", else: ""}
            style="border:0;cursor:pointer;"
          >
            <%= tag %>
          </button>
        <% end %>
        <span style="flex:1"></span>
        <span class="ff-mono" style="font-size:11px; color: var(--ink-3);">
          <%= gettext("view") %>: <span style="color:var(--ink);"><%= gettext("index") %></span>
        </span>
      </section>

      <% filtered =
        if @selected_tag do
          if @selected_tag == "Open Source" do
            Enum.filter(@projects, & &1.github)
          else
            Enum.filter(@projects, fn p -> Enum.any?(p.tech, &(&1.name == @selected_tag)) end)
          end
        else
          @projects
        end %>

      <section class="ff-section" style="padding-top: 8px;">
        <%= for {project, i} <- Enum.with_index(filtered) do %>
          <button phx-click="open_modal" phx-value-id={project.id} class="ff-project-row">
            <div class="ff-idx">№ <%= String.pad_leading("#{i + 1}", 2, "0") %></div>
            <div class="thumb">
              <img
                src={project.image || "/images/projects/no-preview.svg"}
                alt=""
                style="max-width:85%; max-height:80%; object-fit:contain;"
              />
            </div>
            <div>
              <div style="display:flex; align-items:center; gap:10px; flex-wrap: wrap;">
                <div class="ff-serif" style="font-size: 22px; font-weight: 500; line-height: 1.2;">
                  <%= project.name %>
                </div>
                <%= if i == 0 do %>
                  <span class="ff-chip accent" style="font-size:10px;"><%= gettext("latest") %></span>
                <% end %>
                <%= if project.github do %>
                  <span
                    class="ff-chip"
                    style="font-size:10px; color: var(--good); border-color: color-mix(in oklch, var(--good) 50%, transparent);"
                  >
                    <%= gettext("open source") %>
                  </span>
                <% end %>
              </div>
              <div style="font-size: 14px; color: var(--ink-3); margin-top: 4px; max-width: 540px;">
                <%= project.description %>
              </div>
              <div style="display:flex; flex-wrap: wrap; gap: 6px; margin-top: 10px;">
                <%= for t <- project.tech do %>
                  <span class="ff-chip" style="font-size:10px;"><%= t.name %></span>
                <% end %>
              </div>
            </div>
            <div class="meta">
              <span class="date"><%= mono_date(project.date) %></span>
              <span class="open"><%= gettext("open") %> ↗</span>
            </div>
          </button>
        <% end %>
      </section>

      <%= if @selected_project do %>
        <div
          class="fixed inset-0 z-50 flex items-center justify-center p-4"
          phx-window-keydown="close_modal"
          phx-key="Escape"
        >
          <div
            class="absolute inset-0"
            style="background: rgba(20,17,13,.55); backdrop-filter: blur(4px);"
            phx-click="close_modal"
          >
          </div>
          <div
            class="relative w-full max-w-lg ff-card"
            style="border-radius: 14px; overflow: hidden; box-shadow: var(--shadow-2); animation: modal-in 0.2s ease-out;"
          >
            <div style="padding: 22px 24px; border-bottom: 1px solid var(--rule); display:flex; justify-content: space-between; align-items: flex-start; gap: 12px;">
              <div style="display:flex; align-items:center; gap:12px;">
                <img
                  src={@selected_project.image || "/images/projects/no-preview.svg"}
                  alt=""
                  style="width: 56px; height:56px; border-radius:10px; object-fit:contain; background: var(--paper-3);"
                />
                <h2
                  class="ff-serif"
                  style="font-size: 26px; font-weight: 500; margin:0; letter-spacing:-0.01em;"
                >
                  <%= @selected_project.name %>
                </h2>
              </div>
              <button
                phx-click="close_modal"
                style="background:transparent;border:0;cursor:pointer;color: var(--ink-3); padding: 4px;"
              >
                <svg
                  class="w-5 h-5"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="1.5"
                  viewBox="0 0 24 24"
                >
                  <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
            <div style="padding: 22px 24px;">
              <p style="color: var(--ink-2); line-height: 1.6; font-size: 15px;">
                <%= @selected_project.full_description %>
              </p>
              <div style="margin-top: 18px; display:flex; flex-wrap: wrap; gap: 8px;">
                <%= if @selected_project.github do %>
                  <span class="ff-chip accent"><%= gettext("open source") %></span>
                <% end %>
                <%= for t <- @selected_project.tech do %>
                  <span class="ff-chip"><%= t.name %></span>
                <% end %>
              </div>
              <div style="margin-top: 22px; display:flex; flex-wrap: wrap; gap: 10px;">
                <%= if @selected_project.github do %>
                  <a
                    href={@selected_project.github}
                    target="_blank"
                    rel="noopener"
                    class="ff-btn ghost"
                  >
                    GitHub ↗
                  </a>
                <% end %>
                <%= if @selected_project.url do %>
                  <a href={@selected_project.url} target="_blank" rel="noopener" class="ff-btn accent">
                    <%= gettext("View Project") %> ↗
                  </a>
                <% end %>
                <%= if is_nil(@selected_project.url) and is_nil(@selected_project.github) do %>
                  <span
                    class="ff-mono"
                    style="font-size:12px; color: var(--ink-3); font-style: italic;"
                  >
                    <%= gettext("Private project - no public links available") %>
                  </span>
                <% end %>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    <style>
      @keyframes modal-in {
        from { opacity: 0; transform: scale(0.96) translateY(8px); }
        to   { opacity: 1; transform: scale(1) translateY(0); }
      }
    </style>
    """
  end

  defp mono_date(%Date{year: y, month: m, day: d}) do
    yy = y |> Integer.to_string() |> String.slice(-2..-1)
    "#{yy}·#{String.pad_leading("#{m}", 2, "0")}·#{String.pad_leading("#{d}", 2, "0")}"
  end
end
