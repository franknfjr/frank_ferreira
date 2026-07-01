defmodule FrankFerreiraWeb.BlogLive do
  use FrankFerreiraWeb, :live_view
  alias FrankFerreira.Blog

  def mount(_params, session, socket) do
    locale = Map.get(session, "locale", socket.assigns[:locale] || "en")
    posts = Blog.published_posts(locale)

    tags =
      posts
      |> Enum.flat_map(& &1.tags)
      |> Enum.uniq()
      |> Enum.sort()

    {:ok, assign(socket, posts: posts, all_tags: tags, selected_tag: nil)}
  end

  def handle_event("filter_tag", %{"tag" => tag}, socket) do
    selected = if socket.assigns.selected_tag == tag, do: nil, else: tag
    {:noreply, assign(socket, selected_tag: selected)}
  end

  def render(assigns) do
    ~H"""
    <div class="ff-page">
      <section class="ff-section" style="border-bottom: 1px solid var(--rule);">
        <div class="ff-eyebrow"><%= gettext("The Journal") %> · vol. 03</div>
        <div class="ff-grid-masthead" style="margin-top: 8px;">
          <h1 class="ff-hero-title" style="font-size: clamp(36px, 9vw, 84px);">
            <%= gettext("Writing") %>
          </h1>
          <div
            class="ff-stats-row"
            style="display:flex; gap: 22px; flex-wrap: wrap; justify-content: center;"
          >
            <%= for {n, label} <- [{length(@posts), gettext("posts")}, {2, gettext("languages")}, {3, gettext("since 2023")}] do %>
              <div class="ff-stat">
                <div class="num"><%= String.pad_leading("#{n}", 2, "0") %></div>
                <div class="lbl"><%= label %></div>
              </div>
            <% end %>
          </div>
        </div>
        <p style="font-size:17px; line-height:1.55; color: var(--ink-2); max-width: 560px; margin-top:18px;">
          <%= gettext(
            "Notes on Elixir, Phoenix & LiveView in production, plus the longer story of getting here from a small city in the Amazon."
          ) %>
        </p>
      </section>

      <section style="padding: 20px 24px; border-bottom: 1px solid var(--rule); display: flex; gap: 10px; flex-wrap: wrap; align-items: center;">
        <span class="ff-mono" style="font-size:11px; color: var(--ink-3); margin-right:8px;">
          <%= gettext("topics") %> →
        </span>
        <button
          phx-click="filter_tag"
          phx-value-tag=""
          class={"ff-chip" <> if @selected_tag in [nil, ""], do: " is-active", else: ""}
          style="border:0;cursor:pointer;"
        >
          #<%= gettext("all") %>
        </button>
        <%= for t <- @all_tags do %>
          <button
            phx-click="filter_tag"
            phx-value-tag={t}
            class={"ff-chip" <> if @selected_tag == t, do: " is-active", else: ""}
            style="border:0;cursor:pointer;"
          >
            #<%= t %>
          </button>
        <% end %>
        <span style="flex:1"></span>
        <span class="ff-mono" style="font-size:11px; color: var(--ink-3);">
          <%= gettext("sort") %>: ↓ <%= gettext("newest") %>
        </span>
      </section>

      <% filtered =
        if @selected_tag in [nil, ""],
          do: @posts,
          else: Enum.filter(@posts, &(@selected_tag in &1.tags)) %>
      <% {featured, rest} =
        case filtered do
          [] -> {nil, []}
          [h | t] -> {h, t}
        end %>

      <section class="ff-section ff-grid-bloglist">
        <%= if featured do %>
          <article>
            <div class="ff-eyebrow" style="color: var(--accent); margin-bottom: 10px;">
              ★ <%= gettext("featured · most read") %>
            </div>
            <%= if featured.cover_image do %>
              <img
                src={featured.cover_image}
                alt={featured.title}
                style="width:100%; max-height: 320px; object-fit:cover; border-radius:10px; border:1px solid var(--rule); margin-bottom:18px;"
              />
            <% else %>
              <div class="ff-ph" style="height: 260px; border-radius: 10px; margin-bottom: 18px;">
                cover · <%= featured.id %>
              </div>
            <% end %>
            <div class="ff-mono" style="font-size:11px; color: var(--ink-3);">
              № <%= String.pad_leading("#{length(rest) + 1}", 3, "0") %> · <%= mono_date(
                featured.created_at
              ) %> · <%= featured.read_minutes %> <%= gettext("min") %>
            </div>
            <h2
              class="ff-serif"
              style="font-size: clamp(28px, 6.5vw, 44px); line-height:1.05; font-weight:500; margin:6px 0 10px; letter-spacing:-0.02em;"
            >
              <a
                href={~p"/blog/#{featured.language}/#{featured.id}"}
                style="color:inherit;text-decoration:none;"
              >
                <%= featured.title %>
              </a>
            </h2>
            <p style="font-size:16px; line-height:1.6; color: var(--ink-2); max-width: 620px;">
              <%= featured.description %>
            </p>
            <div style="display:flex; gap:8px; margin-top:14px; flex-wrap: wrap;">
              <%= for t <- featured.tags do %>
                <span class="ff-tag">#<%= t %></span>
              <% end %>
            </div>
          </article>
        <% end %>

        <div>
          <div class="ff-eyebrow" style="margin-bottom: 10px;"><%= gettext("archive") %></div>
          <%= if rest == [] and featured do %>
            <p class="ff-mono" style="font-size:12px; color: var(--ink-3);">
              <%= gettext("nothing else here yet.") %>
            </p>
          <% end %>
          <%= for {post, idx} <- Enum.with_index(rest) do %>
            <a
              href={~p"/blog/#{post.language}/#{post.id}"}
              style="display:flex; gap:16px; align-items:center; padding:20px 0; border-bottom: 1px solid var(--rule); text-decoration:none; color:inherit;"
            >
              <%= if post.cover_image do %>
                <img
                  src={post.cover_image}
                  alt=""
                  style="width:104px; height:70px; flex:none; object-fit:cover; border-radius:8px; border:1px solid var(--rule);"
                />
              <% else %>
                <div class="ff-ph" style="width:104px; height:70px; flex:none; border-radius:8px;">
                </div>
              <% end %>
              <div style="flex:1; min-width:0;">
                <div style="display:flex; justify-content: space-between; align-items: baseline; gap: 12px;">
                  <div class="ff-idx">
                    № <%= String.pad_leading("#{length(rest) - idx}", 3, "0") %>
                  </div>
                  <div class="ff-mono" style="font-size:11px; color: var(--ink-3);">
                    <%= mono_date(post.created_at) %> · <%= post.read_minutes %> <%= gettext("min") %>
                  </div>
                </div>
                <div
                  class="ff-serif"
                  style="font-size:22px; font-weight:500; margin:6px 0 6px; line-height:1.2;"
                >
                  <%= post.title %>
                </div>
                <div style="display:flex; gap:10px; flex-wrap: wrap;">
                  <%= for t <- post.tags do %>
                    <span class="ff-tag">#<%= t %></span>
                  <% end %>
                </div>
              </div>
            </a>
          <% end %>

          <div style="display:flex; align-items:center; gap:14px; margin: 28px 0 6px;">
            <span class="ff-serif" style="font-size:18px; color:var(--ink-3); font-style: italic;">
              2022 — <%= gettext("earlier drafts") %>
            </span>
            <div class="ff-rule" style="flex:1"></div>
          </div>
          <div class="ff-mono" style="font-size:12px; color:var(--ink-3); line-height:1.7;">
            drafts · <%= gettext("subscribe via") %>
            <a
              href={"/" <> Gettext.get_locale(FrankFerreiraWeb.Gettext) <> "/rss.xml"}
              style="color: var(--accent); text-decoration:none;"
            >
              /rss.xml
            </a>
          </div>
        </div>
      </section>
    </div>
    """
  end

  defp mono_date(%Date{} = d), do: FrankFerreiraWeb.Format.mono_date(d)
end
