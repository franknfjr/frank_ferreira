defmodule FrankFerreiraWeb.MarkdownLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, content: "", content_id: "content_textarea", show_write: true)}
  end

  def handle_event("validate", %{"content" => content}, socket) do
    {:noreply, assign(socket, content: content)}
  end

  def handle_event("show_write", %{"show" => show}, socket) do
    show_write = show == "true"
    {:noreply, assign(socket, show_write: show_write)}
  end

  def render(assigns) do
    ~H"""
    <.form phx-change="validate" class="w-full max-w-4xl mx-auto p-4">
      <div class="mb-4">
        <div class="flex justify-between items-center border-b border-gray-300 pb-2 mb-2">
          <div>
            <button
              type="button"
              phx-click="show_write"
              phx-value-show="true"
              class={"font-semibold px-3 py-1 rounded-t-md border-b-2 focus:outline-none " <> if @show_write, do: "border-blue-500 text-blue-500", else: "border-transparent text-gray-600"}
            >
              Write
            </button>
            <button
              type="button"
              phx-click="show_write"
              phx-value-show="false"
              class={"font-semibold px-3 py-1 rounded-t-md border-b-2 focus:outline-none " <> if !@show_write, do: "border-blue-500 text-blue-500", else: "border-transparent text-gray-600"}
            >
              Preview
            </button>
          </div>
          <markdown-toolbar for={@content_id} class="flex space-x-3 text-gray-600">
            <md-header tabindex="0">
              <.icon name="fa-heading-solid" class="w-5 h-5" />
            </md-header>
            <md-bold tabindex="-1">
              <.icon name="fa-bold-solid" class="w-5 h-5" />
            </md-bold>
            <md-italic tabindex="-1">
              <.icon name="fa-italic-solid" class="w-5 h-5" />
            </md-italic>
            <md-quote tabindex="-1">
              <.icon name="fa-quote-right-solid" class="w-5 h-5" />
            </md-quote>
            <md-code tabindex="-1">
              <.icon name="fa-code-solid" class="w-5 h-5" />
            </md-code>
            <md-link tabindex="-1">
              <.icon name="fa-link-solid" class="w-5 h-5" />
            </md-link>
            <span class="text-gray-500">|</span>
            <md-unordered-list tabindex="-1">
              <.icon name="fa-list-ul-solid" class="w-5 h-5" />
            </md-unordered-list>
            <md-ordered-list tabindex="-1">
              <.icon name="fa-list-ol-solid" class="w-5 h-5" />
            </md-ordered-list>
            <md-task-list tabindex="-1">
              <.icon name="fa-list-check-solid" class="w-5 h-5" />
            </md-task-list>
          </markdown-toolbar>
        </div>
        <div :if={@show_write} class="rounded-md shadow-sm">
          <textarea
            id={@content_id}
            name="content"
            phx-hook="ParseHTML"
            rows="10"
            cols="30"
            class="block w-full bg-gray-100 border dark:bg-gray-900 border-gray-300 rounded-md focus:ring focus:ring-opacity-50 focus:ring-blue-300 focus:border-blue-500 sm:text-sm sm:leading-6 p-3 resize-none"
            placeholder="Write your content in markdown here..."
          ><%= @content %></textarea>
        </div>

        <div
          :if={!@show_write}
          class="prose prose-blue max-w-none bg-white dark:bg-gray-900 border border-gray-300 rounded-md p-4"
        >
          <input type="hidden" name="content" value={@content} />
          <%= @content |> markdown_to_html() |> Phoenix.HTML.raw() %>
        </div>
      </div>
    </.form>
    """
  end

  defp markdown_to_html(markdown) do
    markdown
    |> MDEx.to_html(
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
