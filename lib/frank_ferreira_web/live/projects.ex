defmodule FrankFerreiraWeb.ProjectsLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket) do
    projects = [
      %{
        name: gettext("IrriSusten"),
        description: gettext("Information system to manage plantation irrigation with web and mobile interfaces."),
        url: "https://sol.sbc.org.br/index.php/wcama/article/view/2941",
        tech: "Arduino, Sensors, Bluetooth"
      },
      %{
        name: gettext("Introduction to Elixir and Phoenix"),
        description: gettext("Educational repository for Elixir and Phoenix mini-course at UFRA."),
        url: "https://github.com/franknfjr/elixir-phoenix",
        tech: "Elixir, Phoenix"
      },
      %{
        name: "Mdown_ex",
        description: gettext("Converts Markdown files to HTML and Livebook using Elixir."),
        url: "https://github.com/franknfjr/md2livemd",
        tech: "Elixir"
      },
      %{
        name: gettext("Healthcare"),
        description: gettext("Dashboard for patient appointments, medications, and hospital indicators."),
        url: nil,
        tech: "Elixir, Phoenix, LiveView"
      },
      %{
        name: "CDN",
        description: gettext("Internal content delivery network for file management."),
        url: nil,
        tech: "Elixir"
      },
      %{
        name: gettext("Voter Intentions System"),
        description: gettext("Platform for collecting and analyzing voter preference data."),
        url: nil,
        tech: "Elixir, Phoenix"
      }
    ]

    {:ok, assign(socket, projects: projects)}
  end

  def render(assigns) do
    ~H"""
    <main class="mx-auto max-w-2xl px-4 sm:px-6 lg:px-8 py-24">
      <h1 class="text-4xl font-medium tracking-tight text-light-text dark:text-dark-text mb-4">
        <%= gettext("Projects") %>
      </h1>
      <p class="text-light-muted dark:text-dark-muted mb-16">
        <%= gettext("Things I've built and contributed to.") %>
      </p>

      <div class="space-y-8">
        <%= for project <- @projects do %>
          <div class="group">
            <h2 class="text-lg font-medium text-light-text dark:text-dark-text">
              <%= if project.url do %>
                <a href={project.url} target="_blank" class="hover:text-accent transition-colors inline-flex items-center gap-1">
                  <%= project.name %>
                  <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 19.5l15-15m0 0H8.25m11.25 0v11.25" />
                  </svg>
                </a>
              <% else %>
                <%= project.name %>
              <% end %>
            </h2>
            <p class="mt-1 text-light-muted dark:text-dark-muted">
              <%= project.description %>
            </p>
            <p class="mt-2 text-sm text-light-muted dark:text-dark-muted">
              <%= project.tech %>
            </p>
          </div>
        <% end %>
      </div>
    </main>
    """
  end
end
