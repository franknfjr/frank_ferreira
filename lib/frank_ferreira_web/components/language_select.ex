defmodule FrankFerreiraWeb.Components.LanguageSelect do
  use Phoenix.Component
  import FrankFerreiraWeb.CoreComponents

  attr :current_path, :string
  attr :current_locale, :string
  attr :language_options, :list, doc: "list of maps with keys :locale, :flag (emoji), :label"

  @doc """
  Usage:
  <.language_select
    current_locale={Gettext.get_locale(ClubLMWeb.Gettext)}
    language_options={Application.get_env(:clubl_m, :language_options)}
  />
  """
  def language_select(assigns) do
    assigns =
      assigns
      |> assign_new(:current_path, fn -> "/" end)
      |> assign(:locale_path, fn assigns, locale ->
        path = assigns.current_path

        case Regex.run(~r"^/blog/(br|en)/(.+)$", path) do
          [_, from_locale, slug] ->
            to_locale = if locale == "br", do: "br", else: "en"

            case FrankFerreira.Blog.get_post_translation(slug, from_locale, to_locale) do
              nil -> "/blog?locale=#{locale}"
              post -> "/blog/#{post.language}/#{post.id}?locale=#{locale}"
            end

          _ ->
            "#{path}?locale=#{locale}"
        end
      end)

    ~H"""
    <.dropdown>
      <:trigger_element>
        <div class="inline-flex items-center justify-center w-full gap-1 align-middle focus:outline-none">
          <div class="text-2xl">
            <%= Enum.find(@language_options, &(&1.locale == @current_locale)).flag %>
          </div>
          <svg
            class="w-4 h-4 text-gray-400 dark:text-gray-100"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
            className="w-6 h-6"
          >
            <path
              fillRule="evenodd"
              d="M12.53 16.28a.75.75 0 0 1-1.06 0l-7.5-7.5a.75.75 0 0 1 1.06-1.06L12 14.69l6.97-6.97a.75.75 0 1 1 1.06 1.06l-7.5 7.5Z"
              clipRule="evenodd"
            />
          </svg>
        </div>
      </:trigger_element>

      <%= for language <- @language_options do %>
        <% target_path = @locale_path.(assigns, language.locale) %>
        <a
          href={target_path}
          class="dropdown_menu-item flex items-center px-3 py-2 hover:bg-light-surface dark:hover:bg-dark-surface rounded-lg transition-colors cursor-pointer"
          onclick={"window.location.href='#{target_path}'; return true;"}
        >
          <div class="mr-2 text-2xl leading-none"><%= language.flag %></div>
          <div class="text-sm text-light-text dark:text-dark-text"><%= language.label %></div>
        </a>
      <% end %>
    </.dropdown>
    """
  end
end
