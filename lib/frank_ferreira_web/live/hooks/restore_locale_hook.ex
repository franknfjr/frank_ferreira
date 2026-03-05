defmodule FrankFerreiraWeb.RestoreLocaleHook do
  import Phoenix.Component, only: [assign: 3]

  # Priority: URL params > session > default
  def on_mount(:default, %{"locale" => locale} = _params, _session, socket)
      when is_binary(locale) and locale in ["en", "br"] do
    Gettext.put_locale(FrankFerreiraWeb.Gettext, locale)
    {:cont, assign(socket, :locale, locale)}
  end

  def on_mount(:default, _params, %{"locale" => locale} = _session, socket)
      when is_binary(locale) do
    Gettext.put_locale(FrankFerreiraWeb.Gettext, locale)
    {:cont, assign(socket, :locale, locale)}
  end

  def on_mount(:default, _params, _session, socket) do
    {:cont, assign(socket, :locale, "en")}
  end
end
