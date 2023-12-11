Mix.install([
  {:timex, "~> 3.0"}
])

defmodule SeuModulo do
  use Timex

  def quantidade_de_dias_no_ano_atual do
    formatted_date = Timex.Format.DateTime.Formatter.format!(Timex.now(), "{YYYY}")

    ano_atual = String.to_integer(formatted_date)

    inicio_do_ano = Timex.beginning_of_year({ano_atual, 1, 1})
    fim_do_ano = Timex.end_of_year({ano_atual, 12, 31})

    qt_ano = Timex.diff(fim_do_ano, inicio_do_ano, :days) + 1

    qt_ano
  end
end

IO.inspect(SeuModulo.quantidade_de_dias_no_ano_atual())
