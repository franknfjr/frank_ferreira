defmodule FrankFerreiraWeb.AboutLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 1000)

    {:ok, put_date(socket)}
  end

  def handle_event("keyup", %{"key" => key} = _params, socket) do
    case key do
      "e" ->
        {:noreply, push_redirect(socket, to: "/elixir")}

      "p" ->
        {:noreply, push_redirect(socket, to: "/pacman")}

      "t" ->
        {:noreply, push_redirect(socket, to: "/tetris")}

      _ ->
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <main class="mx-auto max-w-2xl px-4 sm:px-6 lg:px-8 py-24">
      <h1 class="text-4xl font-medium tracking-tight text-light-text dark:text-dark-text mb-8">
        <%= gettext("About") %>
      </h1>

      <img class="w-20 h-20 rounded-lg mb-8" src="/images/avatar.png" alt="Frank Ferreira" />

      <div class="space-y-4">
        <p class="text-light-muted dark:text-dark-muted leading-relaxed">
          <%= gettext(
            "Hello! I'm an enthusiastic programmer dedicated to exploring and refining my skills in the realm of software development. Throughout my journey, I've found my path in the Elixir ecosystem, where I've been involved in challenging projects that have allowed me to grow as a developer."
          ) %>
        </p>

        <p class="text-light-muted dark:text-dark-muted leading-relaxed">
          <%= gettext(
            "My passion for solving complex problems and crafting efficient solutions drives me to constantly pursue excellence in my work. I'm always eager to learn new technologies and innovative approaches to further enhance my expertise and make meaningful contributions to the projects I'm engaged in."
          ) %>
        </p>

        <p class="text-light-muted dark:text-dark-muted leading-relaxed">
          <%= gettext(
            "Whether exploring new concepts, collaborating with teams, or tackling challenges, I am committed to evolving as a professional and making a positive impact on the software development community."
          ) %>
        </p>
      </div>

      <div class="mt-12 pt-8 border-t border-light-border dark:border-dark-border">
        <h2 class="text-lg font-medium text-light-text dark:text-dark-text mb-4">
          <%= gettext("Connect") %>
        </h2>
        <div class="space-y-2">
          <a
            href="https://twitter.com/franknfjr"
            target="_blank"
            class="block text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors"
          >
            Twitter → @franknfjr
          </a>
          <a
            href="https://github.com/franknfjr"
            target="_blank"
            class="block text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors"
          >
            GitHub → franknfjr
          </a>
          <a
            href="https://linkedin.com/in/franknferreira"
            target="_blank"
            class="block text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors"
          >
            LinkedIn → franknferreira
          </a>
        </div>
      </div>

      <div class="mt-12 pt-8 border-t border-light-border dark:border-dark-border">
        <h2 class="text-lg font-medium text-light-text dark:text-dark-text mb-4">
          <%= gettext("Location") %>
        </h2>
        <p class="text-light-muted dark:text-dark-muted">
          <%= gettext("Ananindeua") %>, <%= gettext("Brazil") %> · <%= @date %>
        </p>
      </div>
    </main>
    """
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, put_date(socket)}
  end

  defp put_date(socket) do
    now_me = Timex.now("America/Belem") |> Timex.format!("%H:%M", :strftime)

    %DateTime{zone_abbr: _zone_me} = Timex.now("America/Belem")
    %DateTime{time_zone: time_zone, zone_abbr: zone_you} = Timex.local()

    assign(socket, date: now_me, time_zone: time_zone, zone_abbr: zone_you)
  end
end
