defmodule FrankFerreiraWeb.AboutLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 60_000)
    {:ok, put_date(socket)}
  end

  def handle_event("keyup", %{"key" => key} = _params, socket) do
    case key do
      "e" -> {:noreply, push_redirect(socket, to: "/elixir")}
      "p" -> {:noreply, push_redirect(socket, to: "/pacman")}
      "t" -> {:noreply, push_redirect(socket, to: "/tetris")}
      _ -> {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="ff-page" phx-window-keyup="keyup">
      <section class="ff-section ff-grid-about">
        <div>
          <div class="ff-eyebrow">№ 04 — <%= gettext("Colophon") %></div>
          <h1 class="ff-hero-title" style="font-size: clamp(36px, 9vw, 80px); margin: 8px 0 24px;">
            <%= gettext("About") %> <em><%= gettext("me") %></em>.
          </h1>

          <div style="font-size:18px; line-height:1.65; color: var(--ink-2); max-width: 580px; display:flex; flex-direction: column; gap: 18px;">
            <p>
              <%= gettext(
                "Hi — I'm an enthusiastic programmer dedicated to exploring and refining my skills in software. Along the way I found my path in the"
              ) %>
              <strong style="color: var(--ink); font-weight: 600;"><%= gettext("Elixir ecosystem") %></strong>, <%= gettext(
                "where I've been involved in challenging projects that have shaped how I think."
              ) %>
            </p>
            <p>
              <%= gettext(
                "I care about solving complex problems and crafting efficient solutions. I'm always eager to learn new technologies and approaches to enhance my expertise and make meaningful contributions to the projects I'm engaged in."
              ) %>
            </p>
            <p>
              <%= gettext(
                "Whether exploring new concepts, collaborating with teams, or tackling challenges, I'm committed to evolving as a professional and making a positive impact on the software development community."
              ) %>
            </p>
          </div>

          <div style="margin-top: 44px;">
            <div class="ff-eyebrow" style="margin-bottom: 14px;">
              <%= gettext("Timeline · selected") %>
            </div>
            <% timeline = [
              {"1994", gettext("Hello, world."),
               gettext("First release in prod. Born in Belém, Pará.")},
              {"2004", gettext("First PC."),
               gettext("'Santa' gave me a Pentium. I set a password and forgot it the next day.")},
              {"2013", gettext("First lines of code."),
               gettext(
                 "A Hacking DVD course. Built a browser in Delphi without understanding a thing."
               )},
              {"2016", gettext("Teaching to learn."),
               gettext("Taught programming to underprivileged kids using Scratch.")},
              {"2018", gettext("First paper."),
               gettext("Presented IrriSusten at the Brazilian Computer Society Congress in Natal.")},
              {"2022", gettext("Elixir."),
               gettext("Started working remotely as a backend developer.")},
              {"2026", gettext("This site."),
               gettext("A redesigned journal — built with Phoenix, LiveView, & Tailwind.")}
            ] %>
            <%= for {{y, t, d}, i} <- Enum.with_index(timeline) do %>
              <div
                class="ff-tl-row"
                style={if i == 0, do: "border-top: 1px solid var(--rule);", else: ""}
              >
                <div class="ff-mono" style="font-size:12px; color: var(--accent);"><%= y %></div>
                <div>
                  <div class="ff-serif" style="font-size:22px; font-weight: 500; line-height: 1.2;">
                    <%= t %>
                  </div>
                  <div style="color: var(--ink-3); font-size: 14px; margin-top: 4px; max-width: 460px;">
                    <%= d %>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </div>

        <aside style="display:flex; flex-direction: column; gap: 22px; align-items: center;">
          <div style="border-radius: 12px; overflow: hidden; aspect-ratio: 1 / 1; background: var(--paper-2); border: 1px solid var(--rule); width: 100%; max-width: 480px;">
            <img
              src="/images/avatar.png"
              alt="Frank Ferreira"
              style="width:100%; height:100%; object-fit:cover; display:block;"
            />
          </div>

          <div class="ff-card" style="padding: 18px; width: 100%; max-width: 480px;">
            <div class="ff-eyebrow" style="margin-bottom: 10px;"><%= gettext("Quick facts") %></div>
            <dl class="ff-mono" style="font-size: 12px; line-height: 1.8; margin: 0;">
              <%= for {k, v, accent} <- [
                {gettext("based in"), "Ananindeua, BR", false},
                {gettext("role"), gettext("backend eng"), false},
                {gettext("stack"), "elixir · pg", false},
                {gettext("writing in"), "en · pt-BR", false},
                {gettext("local time"), @date <> " −03", true}
              ] do %>
                <div style="display:flex; justify-content: space-between; border-bottom: 1px dashed var(--rule); padding: 4px 0;">
                  <dt style="color: var(--ink-3);"><%= k %></dt>
                  <dd style={"margin: 0; color: " <> if(accent, do: "var(--accent)", else: "var(--ink)") <> ";"}>
                    <%= v %>
                  </dd>
                </div>
              <% end %>
            </dl>
          </div>

          <div class="ff-card" style="padding: 18px; width: 100%; max-width: 480px;">
            <div class="ff-eyebrow" style="margin-bottom: 10px;"><%= gettext("Find me") %></div>
            <div class="ff-mono" style="font-size:12px; line-height:2;">
              <%= for {label, handle, url} <- [
                {"github", "@franknfjr ↗", "https://github.com/franknfjr"},
                {"x / twitter", "@franknfjr ↗", "https://twitter.com/franknfjr"},
                {"linkedin", "franknferreira ↗", "https://www.linkedin.com/in/franknferreira/"}
              ] do %>
                <div style="display:flex; justify-content: space-between;">
                  <span style="color: var(--ink-3);"><%= label %></span>
                  <a
                    href={url}
                    target="_blank"
                    rel="noopener"
                    style="color: var(--ink); text-decoration:none;"
                  >
                    <%= handle %>
                  </a>
                </div>
              <% end %>
            </div>
          </div>

          <%!--
          <div style="padding: 18px; border: 1px dashed var(--accent); border-radius: 12px; background: var(--accent-soft); width: 100%; max-width: 480px;">
            <div class="ff-eyebrow" style="color: var(--accent); margin-bottom: 8px;">
              <%= gettext("Easter egg") %>
            </div>
            <div class="ff-mono" style="font-size: 12px; color: var(--ink-2); line-height: 1.7;">
              press <span class="ff-kbd">e</span> for elixir<br />
              <span class="ff-kbd">p</span> for pacman<br />
              <span class="ff-kbd">t</span> for tetris
            </div>
          </div>
          --%>
        </aside>
      </section>
    </div>
    """
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 60_000)
    {:noreply, put_date(socket)}
  end

  defp put_date(socket) do
    now_me = Timex.now("America/Belem") |> Timex.format!("%H:%M", :strftime)
    %DateTime{time_zone: time_zone, zone_abbr: zone_you} = Timex.local()
    assign(socket, date: now_me, time_zone: time_zone, zone_abbr: zone_you)
  end
end
