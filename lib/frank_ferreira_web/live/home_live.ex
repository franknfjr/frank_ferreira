defmodule FrankFerreiraWeb.HomeLive do
  use FrankFerreiraWeb, :live_view
  alias FrankFerreira.Blog

  def mount(_params, session, socket) do
    locale = Map.get(session, "locale", socket.assigns[:locale] || "en")
    posts = Blog.published_posts(locale) |> Enum.take(3)
    if connected?(socket), do: Process.send_after(self(), :tick, 60_000)
    {:ok, assign(socket, posts: posts, locale: locale, now: format_local_time())}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 60_000)
    {:noreply, assign(socket, :now, format_local_time())}
  end

  defp format_local_time do
    Timex.now("America/Belem") |> Timex.format!("%H:%M", :strftime)
  end

  def render(assigns) do
    ~H"""
    <div class="ff-page">
      <%!-- Hero --%>
      <section class="ff-section" style="padding-top: 72px;">
        <div class="ff-grid-hero">
          <div>
            <div class="ff-eyebrow" style="margin-bottom: 18px;">
              № 001 — <%= gettext("Hello, World.") %>
            </div>
            <h1 class="ff-hero-title">
              <%= gettext("Software,") %><br />
              <em><%= gettext("quietly") %></em> <%= gettext("built") %><br />
              <%= gettext("from Belém.") %>
            </h1>
            <p style="font-size: 19px; line-height: 1.55; max-width: 540px; color: var(--ink-2); margin-top: 28px;">
              <%= gettext("I'm") %> <strong style="font-weight:600;">Frank Ferreira</strong>, <%= gettext(
                "a backend engineer in the Amazon. I work in Elixir & Phoenix, and write here about the long way from a Christmas Pentium to LiveView in production."
              ) %>
            </p>
            <div style="display:flex; gap: 12px; margin-top: 32px; flex-wrap: wrap;">
              <a href="/blog" class="ff-btn"><%= gettext("Read the journal") %> →</a>
              <a href="/projects" class="ff-btn ghost"><%= gettext("See projects") %></a>
            </div>
          </div>

          <aside style="display:flex; flex-direction: column; gap: 18px;">
            <div class="ff-card" style="padding: 20px;">
              <div class="ff-eyebrow" style="margin-bottom: 12px;">
                <%= gettext("Now / Status") %>
              </div>
              <div style="display:flex; align-items:center; gap: 10px; margin-bottom: 12px;">
                <span style="width:8px;height:8px;border-radius:99px;background:var(--good);box-shadow:0 0 0 4px color-mix(in oklch, var(--good) 25%, transparent);">
                </span>
                <span class="ff-mono" style="font-size:12px;">
                  <%= gettext("open to interesting work") %>
                </span>
              </div>
              <ul
                class="ff-mono"
                style="font-size:12px; color:var(--ink-2); line-height:1.8; padding-left:0; list-style:none; margin:0;"
              >
                <li>→ <%= gettext("remote · backend · elixir") %></li>
                <li>
                  → <%= gettext("shipping") %>
                  <a
                    href="https://agendaletiva.com.br"
                    target="_blank"
                    style="color:var(--accent);text-decoration:none;"
                  >
                    agendaletiva.com.br
                  </a>
                </li>
                <li>→ <%= gettext("teaching scratch on weekends") %></li>
              </ul>
              <div class="ff-rule" style="margin: 16px 0;"></div>
              <div class="ff-mono" style="font-size:11px; color: var(--ink-3);">
                <div>Belém · Pará · BR</div>
                <div>
                  <%= gettext("local time") %> <span style="color:var(--ink);"><%= @now %></span>
                  · UTC−03
                </div>
              </div>
            </div>

            <div style="aspect-ratio: 4/5; border-radius: 12px; overflow: hidden; background: var(--paper-2); border: 1px solid var(--rule);">
              <img
                src="/images/avatar.png"
                alt="Frank Ferreira"
                style="width:100%;height:100%;object-fit:cover;display:block;"
              />
            </div>
          </aside>
        </div>
      </section>

      <%!-- Latest writing --%>
      <section class="ff-section" style="border-top: 1px solid var(--rule); padding-top: 32px;">
        <div style="display:flex; justify-content: space-between; align-items: baseline; margin-bottom: 18px; gap: 16px; flex-wrap: wrap;">
          <div>
            <div class="ff-eyebrow">02 — <%= gettext("Latest writing") %></div>
            <h2
              class="ff-serif"
              style="font-size: clamp(24px, 5vw, 32px); font-weight:500; margin:6px 0 0; letter-spacing:-0.01em;"
            >
              <%= gettext("From the journal") %>
            </h2>
          </div>
          <a
            href="/blog"
            class="ff-mono"
            style="font-size:12px; color: var(--accent); text-decoration:none;"
          >
            <%= gettext("all posts") %> →
          </a>
        </div>

        <%= for {post, i} <- Enum.with_index(@posts) do %>
          <a
            href={~p"/blog/#{post.language}/#{post.id}"}
            class="ff-post-row"
            style={if i == 0, do: "border-top: 1px solid var(--rule);", else: ""}
          >
            <div class="ff-idx">№ <%= String.pad_leading("#{length(@posts) - i}", 3, "0") %></div>
            <div>
              <div class="ff-serif" style="font-size:22px; font-weight:500; line-height:1.2;">
                <%= post.title %>
              </div>
              <div style="color: var(--ink-3); font-size:14px; margin-top:4px;">
                <%= post.description %>
              </div>
            </div>
            <div class="ff-post-meta">
              <span class="date"><%= mono_date(post.created_at) %></span>
              <span class="mins">
                <%= String.pad_leading("#{post.read_minutes}", 2, "0") %> <%= gettext("min") %>
              </span>
            </div>
          </a>
        <% end %>
      </section>

      <%!-- Recently shipped --%>
      <section class="ff-section">
        <div style="display:flex; justify-content: space-between; align-items: baseline; margin-bottom: 18px; gap: 16px; flex-wrap: wrap;">
          <div>
            <div class="ff-eyebrow">03 — <%= gettext("Shipping") %></div>
            <h2
              class="ff-serif"
              style="font-size: clamp(24px, 5vw, 32px); font-weight:500; margin:6px 0 0; letter-spacing:-0.01em;"
            >
              <%= gettext("Recently shipped") %>
            </h2>
          </div>
          <a
            href="/projects"
            class="ff-mono"
            style="font-size:12px; color: var(--accent); text-decoration:none;"
          >
            <%= gettext("all projects") %> →
          </a>
        </div>

        <div class="grid gap-4" style="grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));">
          <%= for {img, name, blurb, date, url} <- [
            {"agendaletiva.png", "Agenda Letiva", gettext("School management. Phoenix · LiveView."), "25·12·01", "https://agendaletiva.com.br"},
            {"entregadordasgalaxias.png", "Entregador das Galáxias", gettext("A space delivery game for my niece."), "26·03·06", "https://entregadordasgalaxias.frankferreira.com.br"},
            {"tarefinhas.png", "Tarefinhas", gettext("Task manager for Android. RN · Expo."), "26·02·14", "https://tarefinhas.frankferreira.com.br"}
          ] do %>
            <a
              href={url}
              target="_blank"
              rel="noopener"
              class="ff-card"
              style="padding:18px; display:flex; flex-direction:column; gap:14px; text-decoration:none; color: inherit;"
            >
              <div style="aspect-ratio: 2 / 1; border-radius:8px; overflow:hidden; background: var(--paper-2);">
                <img
                  src={"/images/projects-card/" <> img}
                  alt=""
                  style="width:100%; height:100%; object-fit:cover; display:block;"
                />
              </div>
              <div>
                <div class="ff-serif" style="font-size:19px; font-weight:500;"><%= name %></div>
                <div style="font-size:13px; color: var(--ink-3); margin-top:4px;"><%= blurb %></div>
              </div>
              <div
                class="ff-mono"
                style="font-size:11px; color: var(--ink-4); display:flex; justify-content:space-between;"
              >
                <span><%= date %></span>
                <span style="color: var(--accent);"><%= gettext("open") %> ↗</span>
              </div>
            </a>
          <% end %>
        </div>
      </section>
    </div>
    """
  end

  defp mono_date(%Date{} = d) do
    FrankFerreiraWeb.Format.mono_date(d) |> String.replace("·", " · ")
  end
end
