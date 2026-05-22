defmodule FrankFerreiraWeb.BlogLive.Show do
  use FrankFerreiraWeb, :live_view
  alias FrankFerreira.Blog

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="ff-page">
      <div
        style="padding: 20px 24px 0; display:flex; justify-content: space-between; gap: 16px; flex-wrap: wrap;"
        class="md:!px-10 lg:!px-16"
      >
        <a
          href="/blog"
          class="ff-mono"
          style="font-size:11px; color: var(--ink-3); text-decoration:none;"
        >
          <span style="color: var(--accent);">←</span> /<%= gettext("nav.writing") %>
        </a>
        <div class="ff-mono" style="font-size:11px; color: var(--ink-3);">
          <%= @post.read_minutes %> <%= gettext("min") %>
        </div>
      </div>

      <article class="ff-section ff-grid-article">
        <aside
          class="ff-mono hidden md:block"
          style="font-size:11px; color: var(--ink-3); line-height: 1.8;"
        >
          <div class="ff-idx" style="font-size:14px;">
            № <%= String.pad_leading("#{:erlang.phash2(@post.id, 99) + 1}", 3, "0") %>
          </div>
          <div style="margin-top:14px;"><%= gettext("filed under") %></div>
          <div style="margin-top:6px;">
            <%= for t <- @post.tags do %>
              <span class="ff-tag" style="display:block; margin-bottom:4px;">#<%= t %></span>
            <% end %>
          </div>
          <div style="margin-top: 22px;"><%= gettext("written") %></div>
          <div style="color: var(--ink);"><%= formatted_date(@post.created_at) %></div>
        </aside>

        <div>
          <h1
            class="ff-serif"
            style="font-size: clamp(32px, 8vw, 72px); line-height: 1; font-weight: 500; letter-spacing: -0.025em; margin: 0;"
          >
            <%= @post.title %>
          </h1>
          <p
            class="ff-serif"
            style="font-size: clamp(18px, 2.4vw, 22px); line-height: 1.5; font-style: italic; color: var(--ink-2); max-width: 620px; margin-top: 22px;"
          >
            <%= @post.description %>
          </p>

          <div class="ff-prose ff-prose-article" style="margin-top: 32px; max-width: 680px;">
            <%= {:safe, @body_with_ids} %>
          </div>
        </div>

        <aside class="hidden md:block" style="position: sticky; top: 88px; align-self: start;">
          <div
            class="ff-mono"
            style="font-size: 10px; text-transform: uppercase; letter-spacing: .12em; color: var(--ink-3); margin-bottom: 12px;"
          >
            <%= gettext("On this page") %>
          </div>
          <ul
            id="ff-toc"
            phx-hook="TocSpy"
            class="ff-mono ff-toc"
            style="font-size: 11px; list-style: none; padding: 0; margin: 0; line-height: 1.9; color: var(--ink-3);"
          >
            <%= for {id, text, i} <- @toc do %>
              <li>
                <a
                  href={"#" <> id}
                  class={"ff-toc-link" <> if(i == 0, do: " is-active", else: "")}
                  data-target={id}
                >
                  <span class="bullet">·</span>
                  <span class="arrow">→</span>
                  <span class="label"><%= text %></span>
                </a>
              </li>
            <% end %>
            <%= if @toc == [] do %>
              <li style="color: var(--ink-4);">—</li>
            <% end %>
          </ul>

          <div class="ff-rule" style="margin: 18px 0;"></div>

          <div
            class="ff-mono"
            style="font-size: 10px; text-transform: uppercase; letter-spacing: .12em; color: var(--ink-3); margin-bottom: 12px;"
          >
            <%= gettext("Share") %>
          </div>
          <div class="ff-mono" style="font-size: 11px; color: var(--ink-3); line-height: 1.9;">
            <% share_url =
              "https://frankferreira.dev/blog/" <>
                @post.language <> "/" <> @post.id

            tweet =
              "https://twitter.com/intent/tweet?text=" <>
                URI.encode(@post.title) <> "&url=" <> URI.encode(share_url)

            linkedin =
              "https://www.linkedin.com/sharing/share-offsite/?url=" <>
                URI.encode(share_url) %>
            <div>
              <a
                href={tweet}
                target="_blank"
                rel="noopener"
                style="color: inherit; text-decoration: none;"
              >
                ↗ <%= gettext("x / twitter") %>
              </a>
            </div>
            <div>
              <a
                href={linkedin}
                target="_blank"
                rel="noopener"
                style="color: inherit; text-decoration: none;"
              >
                ↗ linkedin
              </a>
            </div>
            <div>
              <button
                phx-click={JS.dispatch("ff:copy", detail: %{url: share_url})}
                style="background:transparent;border:0;cursor:pointer;color:inherit;font:inherit;padding:0;text-align:left;"
              >
                ↗ <%= gettext("copy link") %>
              </button>
            </div>
          </div>
        </aside>
      </article>

      <section class="ff-section ff-grid-prevnext" style="border-top: 1px solid var(--rule);">
        <%= if @prev_post do %>
          <a
            href={~p"/blog/#{@prev_post.language}/#{@prev_post.id}"}
            style="display:block; padding:18px; background: var(--paper-2); border:1px solid var(--rule); border-radius: 10px; text-decoration:none; color:inherit;"
          >
            <div class="ff-mono" style="font-size:11px; color: var(--ink-3);">
              ← <%= gettext("previous") %>
            </div>
            <div class="ff-serif" style="font-size:20px; font-weight:500; margin-top:6px;">
              <%= @prev_post.title %>
            </div>
          </a>
        <% else %>
          <div style="padding:18px; background: var(--paper-2); border:1px dashed var(--rule); border-radius: 10px; color: var(--ink-3);">
            <div class="ff-mono" style="font-size:11px;">← <%= gettext("previous") %></div>
            <div
              class="ff-serif"
              style="font-size:20px; font-weight:500; margin-top:6px; font-style: italic;"
            >
              <%= gettext("this is the first one") %>
            </div>
          </div>
        <% end %>

        <%= if @next_post do %>
          <a
            href={~p"/blog/#{@next_post.language}/#{@next_post.id}"}
            style="display:block; padding:18px; background: var(--accent-soft); border:1px solid var(--accent); border-radius: 10px; text-decoration:none; color:inherit;"
          >
            <div class="ff-mono" style="font-size:11px; color: var(--accent); text-align: right;">
              <%= gettext("next") %> →
            </div>
            <div
              class="ff-serif"
              style="font-size:20px; font-weight:500; margin-top:6px; text-align: right;"
            >
              <%= @next_post.title %>
            </div>
          </a>
        <% else %>
          <div style="padding:18px; border:1px dashed var(--rule); border-radius: 10px; color: var(--ink-3);">
            <div class="ff-mono" style="font-size:11px; text-align: right;">
              <%= gettext("next") %> →
            </div>
            <div
              class="ff-serif"
              style="font-size:20px; font-weight:500; margin-top:6px; text-align: right; font-style: italic;"
            >
              <%= gettext("you're caught up") %>
            </div>
          </div>
        <% end %>
      </section>

      <section class="ff-section" style="border-top: 1px solid var(--rule);">
        <div id="utterances-container" phx-hook="Utterances" phx-update="ignore"></div>
      </section>
    </div>
    """
  end

  def handle_params(%{"id" => id, "locale" => locale}, _, socket) do
    {:noreply, put_post(socket, id, locale)}
  end

  def handle_params(%{"id" => id}, _, socket) do
    locale = socket.assigns[:locale] || "en"
    {:noreply, put_post(socket, id, locale)}
  end

  defp put_post(socket, id, locale) do
    post = Blog.get_post_by_id!(id, locale)
    {body_with_ids, toc} = build_toc(post.body)
    {prev, next} = neighbors(post, locale)

    socket
    |> assign(:post, post)
    |> assign(:body_with_ids, body_with_ids)
    |> assign(:toc, toc)
    |> assign(:prev_post, prev)
    |> assign(:next_post, next)
  end

  # `published_posts/1` is sorted newest-first.
  # "Next" in the article-reading sense means the one written *after* this one
  # (newer), "previous" means the one written *before* (older).
  defp neighbors(post, locale) do
    posts = Blog.published_posts(locale)
    idx = Enum.find_index(posts, &(&1.id == post.id)) || -1

    next = if idx > 0, do: Enum.at(posts, idx - 1), else: nil
    prev = if idx >= 0, do: Enum.at(posts, idx + 1), else: nil

    {prev, next}
  end

  defp build_toc(body) when is_binary(body) do
    case Floki.parse_fragment(body) do
      {:ok, tree} ->
        {tree, toc} =
          tree
          |> Enum.map_reduce([], fn node, acc ->
            case node do
              {"h2", attrs, children} ->
                text = Floki.text({"h2", attrs, children}) |> String.trim()
                id = slugify(text)
                new_attrs = put_attr(attrs, "id", id)
                {{"h2", new_attrs, children}, [{id, text} | acc]}

              other ->
                {other, acc}
            end
          end)

        html = Floki.raw_html(tree, encode: false)

        toc =
          toc
          |> Enum.reverse()
          |> Enum.with_index()
          |> Enum.map(fn {{id, text}, i} -> {id, text, i} end)

        {html, toc}

      _ ->
        {body, []}
    end
  end

  defp put_attr(attrs, key, val) do
    if Enum.any?(attrs, fn {k, _} -> k == key end) do
      Enum.map(attrs, fn {k, v} -> if k == key, do: {k, val}, else: {k, v} end)
    else
      attrs ++ [{key, val}]
    end
  end

  defp slugify(text) do
    text
    |> String.downcase()
    |> String.normalize(:nfd)
    |> String.replace(~r/[^a-z0-9\s-]/u, "")
    |> String.trim()
    |> String.replace(~r/\s+/, "-")
  end

  defp formatted_date(%Date{day: day, month: month, year: year} = date) do
    weekday_number = date |> Timex.to_datetime() |> Timex.weekday()

    weekday =
      case weekday_number do
        1 -> gettext("Sunday")
        2 -> gettext("Monday")
        3 -> gettext("Tuesday")
        4 -> gettext("Wednesday")
        5 -> gettext("Thursday")
        6 -> gettext("Friday")
        7 -> gettext("Saturday")
        _ -> gettext("Invalid weekday")
      end

    month_name =
      case Timex.month_name(month) do
        "January" -> gettext("January")
        "February" -> gettext("February")
        "March" -> gettext("March")
        "April" -> gettext("April")
        "May" -> gettext("May")
        "June" -> gettext("June")
        "July" -> gettext("July")
        "August" -> gettext("August")
        "September" -> gettext("September")
        "October" -> gettext("October")
        "November" -> gettext("November")
        "December" -> gettext("December")
        _ -> gettext("Invalid month")
      end

    weekday <> ", " <> month_name <> " #{day}, #{year}"
  end
end
