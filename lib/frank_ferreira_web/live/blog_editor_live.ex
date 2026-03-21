defmodule FrankFerreiraWeb.BlogEditorLive do
  use FrankFerreiraWeb, :live_view

  alias FrankFerreira.Drafts

  @default_frontmatter %{
    "title" => "",
    "author" => "Frank Ferreira",
    "tags" => "",
    "description" => "",
    "language" => "br",
    "date" => "",
    "twitter" => "franknfjr"
  }

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Blog Editor")}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    drafts = Drafts.list()

    assign(socket,
      drafts: drafts,
      page_title: "Drafts"
    )
  end

  defp apply_action(socket, :new, _params) do
    today = Date.utc_today() |> Date.to_string()

    assign(socket,
      draft_id: nil,
      frontmatter: Map.put(@default_frontmatter, "date", today),
      body: "",
      show_preview: false,
      flash_msg: nil,
      page_title: "New Post"
    )
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    case Drafts.get(id) do
      {:ok, draft} ->
        assign(socket,
          draft_id: id,
          frontmatter: Map.merge(@default_frontmatter, draft.frontmatter),
          body: draft.body,
          show_preview: false,
          flash_msg: nil,
          page_title: "Edit: #{draft.frontmatter["title"] || id}"
        )

      {:error, :not_found} ->
        socket
        |> put_flash(:error, "Draft not found")
        |> push_navigate(to: ~p"/admin/posts")
    end
  end

  def handle_event("validate", params, socket) do
    frontmatter =
      socket.assigns.frontmatter
      |> Map.put("title", params["title"] || "")
      |> Map.put("author", params["author"] || "")
      |> Map.put("tags", params["tags"] || "")
      |> Map.put("description", params["description"] || "")
      |> Map.put("language", params["language"] || "br")
      |> Map.put("date", params["date"] || "")
      |> Map.put("twitter", params["twitter"] || "")

    body = params["body"] || socket.assigns.body

    {:noreply, assign(socket, frontmatter: frontmatter, body: body)}
  end

  def handle_event("save_draft", _params, socket) do
    %{frontmatter: fm, body: body} = socket.assigns
    title = fm["title"] || ""

    if String.trim(title) == "" do
      {:noreply, put_flash(socket, :error, "Title is required")}
    else
      id = socket.assigns.draft_id || Drafts.generate_id(title)
      Drafts.save(id, fm, body)

      {:noreply,
       socket
       |> assign(draft_id: id)
       |> put_flash(:info, "Draft saved!")}
    end
  end

  def handle_event("publish", _params, socket) do
    %{frontmatter: fm, body: body} = socket.assigns
    id = socket.assigns.draft_id || Drafts.generate_id(fm["title"] || "")

    fm = Map.put(fm, "published", "true")

    {:ok, path} = Drafts.publish(id, fm, body)

    {:noreply,
     socket
     |> put_flash(:info, "Published to #{Path.basename(path)}! Commit and deploy to go live.")
     |> push_navigate(to: ~p"/admin/posts")}
  end

  def handle_event("delete_draft", %{"id" => id}, socket) do
    Drafts.delete(id)

    {:noreply,
     socket
     |> assign(drafts: Drafts.list())
     |> put_flash(:info, "Draft deleted")}
  end

  def handle_event("toggle_preview", _params, socket) do
    {:noreply, assign(socket, show_preview: !socket.assigns.show_preview)}
  end

  def render(%{live_action: :index} = assigns) do
    ~H"""
    <main class="mx-auto max-w-4xl px-4 sm:px-6 lg:px-8 py-12">
      <div class="flex items-center justify-between mb-8">
        <h1 class="text-2xl font-bold text-light-text dark:text-dark-text">Drafts</h1>
        <.link
          navigate={~p"/admin/posts/new"}
          class="px-4 py-2 bg-accent text-white rounded-lg hover:bg-accent/90 transition-colors"
        >
          New Post
        </.link>
      </div>

      <div :if={@drafts == []} class="text-center py-12 text-light-muted dark:text-dark-muted">
        No drafts yet. Create your first post!
      </div>

      <div class="space-y-3">
        <div
          :for={draft <- @drafts}
          class="flex items-center justify-between p-4 rounded-xl bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border"
        >
          <div>
            <.link
              navigate={~p"/admin/posts/#{draft.id}/edit"}
              class="text-lg font-medium text-light-text dark:text-dark-text hover:text-accent transition-colors"
            >
              <%= draft.title %>
            </.link>
            <p class="text-sm text-light-muted dark:text-dark-muted mt-1">
              <%= draft.language %> · Updated <%= Calendar.strftime(draft.updated_at, "%Y-%m-%d %H:%M") %>
            </p>
          </div>
          <button
            phx-click="delete_draft"
            phx-value-id={draft.id}
            data-confirm="Are you sure?"
            class="text-red-500 hover:text-red-700 text-sm"
          >
            Delete
          </button>
        </div>
      </div>

      <div class="mt-8 pt-8 border-t border-light-border dark:border-dark-border">
        <.link
          navigate={~p"/admin/markdown"}
          class="text-sm text-light-muted dark:text-dark-muted hover:text-accent transition-colors"
        >
          Markdown Playground
        </.link>
      </div>
    </main>
    """
  end

  def render(%{live_action: action} = assigns) when action in [:new, :edit] do
    ~H"""
    <main class="mx-auto max-w-5xl px-4 sm:px-6 lg:px-8 py-12">
      <div class="mb-6">
        <.link
          navigate={~p"/admin/posts"}
          class="group inline-flex items-center text-sm font-medium text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors"
        >
          <svg
            viewBox="0 -9 3 24"
            class="overflow-visible mr-2 w-auto h-4"
          >
            <path
              d="M3 0L0 3L3 6"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
          </svg>
          Back to drafts
        </.link>
      </div>

      <form phx-change="validate" phx-submit="save_draft">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
          <div>
            <label class="block text-sm font-medium text-light-muted dark:text-dark-muted mb-1">
              Title
            </label>
            <input
              type="text"
              name="title"
              value={@frontmatter["title"]}
              placeholder="Post title"
              class="w-full px-3 py-2 rounded-lg bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border text-light-text dark:text-dark-text focus:ring-accent focus:border-accent"
            />
          </div>
          <div>
            <label class="block text-sm font-medium text-light-muted dark:text-dark-muted mb-1">
              Author
            </label>
            <input
              type="text"
              name="author"
              value={@frontmatter["author"]}
              class="w-full px-3 py-2 rounded-lg bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border text-light-text dark:text-dark-text focus:ring-accent focus:border-accent"
            />
          </div>
          <div>
            <label class="block text-sm font-medium text-light-muted dark:text-dark-muted mb-1">
              Tags (comma separated)
            </label>
            <input
              type="text"
              name="tags"
              value={@frontmatter["tags"]}
              placeholder="elixir, phoenix, liveview"
              class="w-full px-3 py-2 rounded-lg bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border text-light-text dark:text-dark-text focus:ring-accent focus:border-accent"
            />
          </div>
          <div class="flex gap-4">
            <div class="flex-1">
              <label class="block text-sm font-medium text-light-muted dark:text-dark-muted mb-1">
                Language
              </label>
              <select
                name="language"
                class="w-full px-3 py-2 rounded-lg bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border text-light-text dark:text-dark-text focus:ring-accent focus:border-accent"
              >
                <option value="br" selected={@frontmatter["language"] == "br"}>Portugues</option>
                <option value="en" selected={@frontmatter["language"] == "en"}>English</option>
              </select>
            </div>
            <div class="flex-1">
              <label class="block text-sm font-medium text-light-muted dark:text-dark-muted mb-1">
                Date
              </label>
              <input
                type="date"
                name="date"
                value={@frontmatter["date"]}
                class="w-full px-3 py-2 rounded-lg bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border text-light-text dark:text-dark-text focus:ring-accent focus:border-accent"
              />
            </div>
          </div>
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-light-muted dark:text-dark-muted mb-1">
              Description
            </label>
            <input
              type="text"
              name="description"
              value={@frontmatter["description"]}
              placeholder="Short description for SEO and listing"
              class="w-full px-3 py-2 rounded-lg bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border text-light-text dark:text-dark-text focus:ring-accent focus:border-accent"
            />
          </div>
        </div>

        <div class="mb-4">
          <div class="flex items-center justify-between mb-2">
            <div class="flex gap-2">
              <button
                type="button"
                phx-click="toggle_preview"
                class={"px-3 py-1 text-sm font-medium rounded-lg transition-colors " <>
                  if(!@show_preview,
                    do: "bg-accent text-white",
                    else: "text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text"
                  )}
              >
                Write
              </button>
              <button
                type="button"
                phx-click="toggle_preview"
                class={"px-3 py-1 text-sm font-medium rounded-lg transition-colors " <>
                  if(@show_preview,
                    do: "bg-accent text-white",
                    else: "text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text"
                  )}
              >
                Preview
              </button>
            </div>
            <div class="flex gap-2">
              <button
                type="submit"
                class="px-4 py-2 text-sm bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border text-light-text dark:text-dark-text rounded-lg hover:border-accent transition-colors"
              >
                Save Draft
              </button>
              <button
                type="button"
                phx-click="publish"
                data-confirm="This will move the draft to priv/posts/. Continue?"
                class="px-4 py-2 text-sm bg-accent text-white rounded-lg hover:bg-accent/90 transition-colors"
              >
                Publish
              </button>
            </div>
          </div>

          <div :if={!@show_preview}>
            <textarea
              name="body"
              rows="24"
              class="w-full px-4 py-3 font-mono text-sm rounded-lg bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border text-light-text dark:text-dark-text focus:ring-accent focus:border-accent resize-y"
              placeholder="Write your post in markdown..."
              phx-debounce="300"
            ><%= @body %></textarea>
          </div>

          <div
            :if={@show_preview}
            class="min-h-[400px] px-6 py-4 rounded-lg bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border"
          >
            <article>
              <header class="text-center mb-8">
                <h1 class="text-3xl font-bold text-light-text dark:text-dark-text">
                  <%= @frontmatter["title"] %>
                </h1>
                <p :if={@frontmatter["description"] != ""} class="mt-2 text-light-muted dark:text-dark-muted">
                  <%= @frontmatter["description"] %>
                </p>
                <div :if={@frontmatter["tags"] != ""} class="flex flex-wrap justify-center gap-2 mt-3">
                  <span
                    :for={tag <- String.split(@frontmatter["tags"], ~r/[,\s]+/, trim: true)}
                    class="px-3 py-1 text-xs font-medium rounded-full bg-accent/10 text-accent"
                  >
                    #<%= tag %>
                  </span>
                </div>
              </header>
              <div class="prose prose-slate dark:prose-dark max-w-none">
                <%= @body |> markdown_to_html() |> Phoenix.HTML.raw() %>
              </div>
            </article>
          </div>
        </div>
      </form>
    </main>
    """
  end

  defp markdown_to_html(""), do: ""

  defp markdown_to_html(markdown) do
    MDEx.to_html(markdown,
      features: [syntax_highlight_theme: "github_dark"],
      extension: [
        strikethrough: true,
        underline: true,
        tagfilter: true,
        table: true,
        autolink: true,
        tasklist: true,
        footnotes: true,
        shortcodes: true
      ],
      parse: [
        smart: true,
        relaxed_tasklist_matching: true,
        relaxed_autolinks: true
      ],
      render: [
        github_pre_lang: true,
        escape: true
      ]
    )
  end
end
