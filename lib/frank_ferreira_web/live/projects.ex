defmodule FrankFerreiraWeb.ProjectsLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket) do
    projects = FrankFerreira.Projects.list()

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
            <div class="ff-idx">№ <%= String.pad_leading("#{length(filtered) - i}", 2, "0") %></div>
            <div class="thumb">
              <%= if project.image do %>
                <img
                  src={project.image}
                  alt=""
                  style="max-width:85%; max-height:80%; object-fit:contain;"
                />
              <% else %>
                <span class="ff-proj-glyph" style="font-size: 34px;" aria-hidden="true">
                  <%= String.first(project.name) %>
                </span>
              <% end %>
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
                <%= if @selected_project.image do %>
                  <img
                    src={@selected_project.image}
                    alt=""
                    style="width: 56px; height:56px; border-radius:10px; object-fit:contain; background: var(--paper-3);"
                  />
                <% else %>
                  <span
                    class="ff-proj-glyph"
                    style="width: 56px; height: 56px; border-radius: 10px; background: var(--paper-3); font-size: 28px; flex: none;"
                    aria-hidden="true"
                  >
                    <%= String.first(@selected_project.name) %>
                  </span>
                <% end %>
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

  defp mono_date(%Date{} = d), do: FrankFerreiraWeb.Format.mono_date_short(d)
end
