defmodule FrankFerreiraWeb.Format do
  @moduledoc """
  Locale-aware formatters for views.

  Date order follows the active Gettext locale:

    * `br` (pt-BR) → `DD·MM·YYYY`
    * everything else (default `en`) → `MM·DD·YYYY`
  """

  @doc """
  Mono-spaced date with the year, locale-aware order.

      iex> mono_date(~D[2026-05-23], "en")
      "05·23·2026"

      iex> mono_date(~D[2026-05-23], "br")
      "23·05·2026"
  """
  def mono_date(date, locale \\ current_locale())
  def mono_date(%Date{} = d, locale), do: format(d, locale, _short_year? = false)

  @doc """
  Mono-spaced date with a 2-digit year (used in dense project lists).
  """
  def mono_date_short(date, locale \\ current_locale())
  def mono_date_short(%Date{} = d, locale), do: format(d, locale, _short_year? = true)

  defp format(%Date{year: y, month: m, day: d}, locale, short_year?) do
    yy =
      if short_year? do
        y |> Integer.to_string() |> String.slice(-2..-1)
      else
        Integer.to_string(y)
      end

    mm = pad(m)
    dd = pad(d)

    case locale do
      "br" -> "#{dd}·#{mm}·#{yy}"
      _ -> "#{mm}·#{dd}·#{yy}"
    end
  end

  defp pad(n), do: String.pad_leading(Integer.to_string(n), 2, "0")

  defp current_locale, do: Gettext.get_locale(FrankFerreiraWeb.Gettext)
end
