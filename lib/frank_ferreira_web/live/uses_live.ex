defmodule FrankFerreiraWeb.UsesLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket), do: {:ok, socket}

  def render(assigns) do
    ~H"""
    <div class="ff-page">
      <section class="ff-section" style="border-bottom: 1px solid var(--rule);">
        <div class="ff-eyebrow">№ 05 — <%= gettext("The desk") %></div>
        <h1 class="ff-hero-title" style="font-size: clamp(48px, 9vw, 76px); margin: 8px 0 18px;">
          <%= gettext("What I use") %>
        </h1>
        <p style="font-size:17px; line-height:1.55; color: var(--ink-2); max-width: 560px;">
          <%= gettext(
            "The hardware and software I reach for every day — for writing Elixir, shipping Phoenix apps, and the occasional weekend game project."
          ) %>
        </p>
      </section>

      <section class="ff-section ff-grid-uses">
        <div>
          <h2
            class="ff-serif"
            style="font-size: 28px; font-weight: 500; margin: 0 0 4px; letter-spacing: -0.01em;"
          >
            Hardware
          </h2>
          <div class="ff-mono" style="font-size:11px; color: var(--ink-3);">
            06 items · <%= gettext("last updated") %> 2026·03
          </div>
          <%= for {n, k, v} <- [
            {"01", "laptop", "13″ MacBook Air · M2"},
            {"02", "dock", "Dell Universal Dock — UD22"},
            {"03", "display", "Dell P2719H · 27″"},
            {"04", "kbd · mouse", "Dell Pro Wireless · KM5221W"},
            {"05", "mic", "HyperX QuadCast S · RGB"},
            {"06", "headset", gettext("Generic — needs upgrading")}
          ] do %>
            <.row n={n} k={k} v={v} />
          <% end %>
        </div>

        <div>
          <h2
            class="ff-serif"
            style="font-size: 28px; font-weight: 500; margin: 0 0 4px; letter-spacing: -0.01em;"
          >
            Software
          </h2>
          <div class="ff-mono" style="font-size:11px; color: var(--ink-3);">
            08 items · <%= gettext("daily drivers") %>
          </div>
          <%= for {n, k, v} <- [
            {"01", "editor", "Zed"},
            {"02", "terminal", "iTerm 2 · JetBrains Mono"},
            {"03", "browser", "Arc"},
            {"04", "db", "Postgres + Postico"},
            {"05", "notes", "Notion"},
            {"06", "design", "Figma"},
            {"07", "calendar", gettext("Calendar.app")},
            {"08", "mail", gettext("Mail.app")}
          ] do %>
            <.row n={n} k={k} v={v} />
          <% end %>
        </div>
      </section>

      <section class="ff-section" style="padding-top: 0;">
        <div class="ff-card ff-grid-now" style="padding: 24px 28px;">
          <div>
            <div class="ff-eyebrow" style="color: var(--accent);">/now</div>
            <div
              class="ff-serif"
              style="font-size: 36px; font-weight: 500; line-height: 1; margin-top: 6px; letter-spacing: -0.01em;"
            >
              <%= gettext("This month") %>
            </div>
            <div class="ff-mono" style="font-size: 11px; color: var(--ink-3); margin-top: 8px;">
              <%= gettext("updated") %> · 2026·05·20
            </div>
          </div>
          <div
            class="ff-serif"
            style="font-size: 19px; line-height: 1.6; color: var(--ink-2); font-style: italic;"
          >
            <%= gettext("Shipping a new release of") %>
            <span style="color: var(--accent); font-style: normal;">Agenda Letiva</span>
            · <%= gettext("re-reading") %> <em>Designing Elixir Systems with OTP</em>
            · <%= gettext("teaching Scratch on Saturday mornings.") %>
          </div>
        </div>
      </section>
    </div>
    """
  end

  attr :n, :string, required: true
  attr :k, :string, required: true
  attr :v, :string, required: true

  defp row(assigns) do
    ~H"""
    <div style="display:grid; grid-template-columns: 40px 1fr 2fr; gap: 16px; padding: 12px 0; border-top: 1px solid var(--rule); align-items: baseline;">
      <div class="ff-idx"><%= @n %></div>
      <div class="ff-mono" style="font-size:12px; color: var(--ink-3);"><%= @k %></div>
      <div style="font-size:15px; color: var(--ink);"><%= @v %></div>
    </div>
    """
  end
end
