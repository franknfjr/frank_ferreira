%{
  title: "Elixir do zero, parte 2: além do básico",
  author: "Frank Ferreira",
  tags: ~w(elixir iniciante tutorial),
  description: "Segunda parte da série: structs, streams, strings por dentro, datas, regex, arquivos, organização de módulos, documentação, erros, protocols e behaviours. Tudo reproduzível.",
  published: true,
  updated_at: nil,
  twitter: "franknfjr"
}
---

![Elixir do zero, parte 2: além do básico](/images/blog/elixir-alem-do-basico.png)

Na [parte 1](/blog/br/elixir-do-zero) a gente instalou o Elixir e passou pelos fundamentos: tipos, imutabilidade, pattern matching, pipe, `Enum`, controle de fluxo e `mix`. Com isso você já lê e escreve código do dia a dia. Agora vem a camada que transforma "sei a sintaxe" em "consigo construir coisa de verdade".

Vale o mesmo combinado de antes: não preciso que você já saiba programar. Cada ideia eu explico do zero, e quando ajudar eu comparo com outra linguagem pra quem já conhece. Tudo aqui roda no `iex` ou num arquivo `.exs`. Abre o terminal e vem comigo.

## Structs: um mapa com forma e nome

Na parte 1 você viu o mapa, que é o dicionário do Elixir: pares de chave e valor, tipo `%{nome: "Frank"}`. O problema do mapa é que ele aceita qualquer chave. Nada te impede de escrever `:nomee` por engano. Um `struct` resolve isso. Ele é um mapa com nome e com um conjunto fixo de campos, definido dentro de um módulo.

```elixir
defmodule Usuario do
  defstruct nome: "", idade: 0, admin: false
end
```

`defstruct` diz quais campos existem e qual o valor padrão de cada um. A partir daí você cria valores daquele tipo com `%Usuario{}`:

```elixir
iex> u = %Usuario{nome: "Frank", idade: 30}
%Usuario{nome: "Frank", idade: 30, admin: false}
iex> u.nome
"Frank"
iex> %Usuario{email: "x"}
** (KeyError) key :email not found in struct Usuario
```

Repare na última linha: tentar um campo que não existe quebra na hora de compilar, não em produção. Se você quer obrigar alguns campos a virem preenchidos, usa `@enforce_keys`:

```elixir
defmodule Conta do
  @enforce_keys [:dono]
  defstruct [:dono, saldo: 0]
end
```

Atualizar um struct cria um novo, do mesmo jeito que com mapa (nada é mutado):

```elixir
iex> %{u | idade: 31}
%Usuario{nome: "Frank", idade: 31, admin: false}
```

Se você vem do Python, um struct lembra um `@dataclass`. Do TypeScript, lembra uma `interface` com valores padrão. A diferença de fundo é que o struct guarda só dados. O comportamento vai pra funções de módulos, separado do dado.

## Keyword lists: o jeito de passar opções

Você já viu isto sem reparar, lá nas dependências do `mix.exs`. Uma keyword list é uma lista de pares onde a chave é um atom. Ela serve pra passar opções pra uma função, na ordem que você quiser.

```elixir
iex> String.split("a-b-c", "-", parts: 2)
["a", "b-c"]
```

Aquele `parts: 2` é uma keyword list. Quando ela é o último argumento, o Elixir deixa você omitir os colchetes, então `parts: 2` é o mesmo que `[parts: 2]`. Pra ler valores dela, o módulo `Keyword`:

```elixir
iex> opts = [cor: "azul", tamanho: 42]
iex> Keyword.get(opts, :cor)
"azul"
iex> Keyword.get(opts, :peso, 0)
0
```

A regra de bolso: mapa quando você guarda dados, keyword list quando você passa opções.

## Access: cavando dentro de estruturas aninhadas

Quando um dado tem dado dentro de dado, alcançar o que está lá no fundo na mão é chato. O Elixir tem funções pra isso: `get_in`, `put_in` e `update_in`. Você passa o caminho como uma lista de chaves.

```elixir
iex> pessoa = %{nome: "Ana", endereco: %{cidade: "Belém", uf: "PA"}}
iex> get_in(pessoa, [:endereco, :cidade])
"Belém"
iex> put_in(pessoa, [:endereco, :cidade], "Ananindeua")
%{nome: "Ana", endereco: %{cidade: "Ananindeua", uf: "PA"}}
```

`put_in` devolve uma cópia nova com o valor trocado, sem mexer no original.

## Enum, Stream e a diferença entre fazer agora e fazer depois

Na parte 1 você usou o `Enum` pra transformar listas. O `Enum` é apressado: ele percorre tudo e devolve o resultado na hora. Na maioria das vezes é o que você quer. Mas e se a coleção for gigante, ou infinita? Aí entra o `Stream`, que é preguiçoso: ele monta a receita do que fazer e só executa quando você pede o resultado.

Primeiro, um `range`, que é uma faixa de números escrita com dois pontos:

```elixir
iex> 1..5
1..5
iex> Enum.to_list(1..5)
[1, 2, 3, 4, 5]
```

Agora compare. Com `Enum`, cada passo cria uma lista inteira na memória:

```elixir
iex> 1..1_000_000 |> Enum.map(&(&1 * 2)) |> Enum.take(3)
[2, 4, 6]
```

Esse `Enum.map` dobrou um milhão de números só pra você pegar três. Com `Stream`, ele só dobra os que você realmente usa:

```elixir
iex> 1..1_000_000 |> Stream.map(&(&1 * 2)) |> Enum.take(3)
[2, 4, 6]
```

Mesmo resultado, trabalho muito menor. O `Stream` também sabe lidar com sequência infinita, porque ele só gera o necessário:

```elixir
iex> Stream.iterate(1, &(&1 * 2)) |> Enum.take(5)
[1, 2, 4, 8, 16]
```

A regra: comece com `Enum`. Troque pra `Stream` quando a coleção for enorme ou quando você for encadear vários passos antes de pegar só um pedaço.

## Strings por dentro: binaries, charlists e bitstrings

Na parte 1 eu disse que string em Elixir é um binary. Vale entender o que isso quer dizer, porque uma hora você esbarra nisso. Um binary é uma sequência de bytes. Uma string é um binary com texto em UTF-8 dentro.

Isso explica uma pegadinha clássica. `String.length` conta letras, `byte_size` conta bytes, e em UTF-8 uma letra acentuada ocupa mais de um byte:

```elixir
iex> String.length("olá")
3
iex> byte_size("olá")
4
```

Existe também a charlist, que é uma lista de números, cada um o código de um caractere. Você escreve com `~c`. Ela aparece principalmente quando você conversa com bibliotecas do Erlang, que esperam esse formato:

```elixir
iex> ~c"abc"
~c"abc"
iex> [?a, ?b, ?c]
~c"abc"
```

Aquele `?a` devolve o número do caractere `a` (97). Não confunda charlist com string: `"abc"` (aspas duplas) é binary, `~c"abc"` (com o til-cê) é lista de números.

E o bitstring é o binary levado ao osso, onde você mexe bit a bit. Raro no começo, mas bom saber que existe:

```elixir
iex> <<104, 105>>
"hi"
```

Os números 104 e 105 são os códigos de `h` e `i`, então esse bitstring é a string `"hi"`.

## Datas e horas

O Elixir tem tipos próprios pra data e hora, e açúcar de sintaxe (uma escrita curtinha) com til pra criar eles: `~D` pra data, `~T` pra hora, `~U` pra data e hora em UTC.

```elixir
iex> ~D[2026-06-02]
~D[2026-06-02]
iex> Date.diff(~D[2026-06-02], ~D[2026-05-29])
4
iex> DateTime.utc_now()
~U[2026-06-02 23:10:11.482000Z]
```

`Date.diff` deu a diferença em dias entre as duas datas. Pra formatar e converter fuso de um jeito mais confortável, a comunidade usa muito a biblioteca `Timex`, mas pro básico o que vem na linguagem já resolve.

## Regex: procurar padrões em texto

Regex (expressão regular) é uma mini-linguagem pra descrever padrões dentro de texto, tipo "uma sequência de dígitos" ou "algo com @ no meio". Em Elixir você escreve um regex com `~r`.

```elixir
iex> Regex.match?(~r/\d+/, "tenho 3 gatos")
true
iex> Regex.run(~r/\d+/, "tenho 3 gatos")
["3"]
iex> String.replace("a1b2c3", ~r/\d/, "-")
"a-b-c-"
```

`\d` quer dizer "um dígito" e `+` quer dizer "um ou mais". Então `~r/\d+/` casa com "um ou mais dígitos". `match?` responde sim ou não, `run` devolve o que casou, e o `String.replace` troca tudo que casa.

## Arquivos e IO

Ler e escrever arquivo segue o mesmo padrão de retorno que você viu na parte 1: a tupla `{:ok, valor}` ou `{:error, motivo}`.

```elixir
iex> File.write("nota.txt", "comprar café\n")
:ok
iex> File.read("nota.txt")
{:ok, "comprar café\n"}
iex> File.read("nao_existe.txt")
{:error, :enoent}
```

Esse `:enoent` é o código de erro do sistema pra "arquivo não encontrado". Pra arquivo grande, em vez de carregar tudo na memória de uma vez, você usa `File.stream!`, que entrega linha por linha de forma preguiçosa (lembra do `Stream`):

```elixir
iex> File.stream!("nota.txt") |> Enum.count()
1
```

E pra escrever na tela, o velho conhecido `IO.puts`, além do `IO.inspect`, que mostra qualquer valor do jeito que o Elixir o enxerga (ótimo pra espiar o que está acontecendo no meio de um pipe):

```elixir
iex> [1, 2, 3] |> IO.inspect(label: "antes") |> Enum.sum()
antes: [1, 2, 3]
6
```

## MapSet: uma coleção sem repetidos

Um set é uma coleção onde cada valor aparece no máximo uma vez, e onde perguntar "tem isso aqui?" é rápido. No Elixir ele se chama `MapSet`.

```elixir
iex> s = MapSet.new([1, 2, 2, 3])
MapSet.new([1, 2, 3])
iex> MapSet.member?(s, 2)
true
iex> MapSet.put(s, 9)
MapSet.new([1, 2, 3, 9])
```

Repare que o `2` repetido sumiu sozinho. Se você vem de Python, é o mesmo papel do `set`.

## Organizando módulos: alias, import e use

Quando o projeto cresce, os nomes de módulo ficam compridos, tipo `MinhaApp.Contas.Usuario`. Três palavrinhas ajudam a arrumar isso.

`alias` cria um apelido curto:

```elixir
alias MinhaApp.Contas.Usuario
# agora dá pra escrever Usuario em vez do nome inteiro
Usuario.novo()
```

`import` traz as funções de um módulo pra dentro do seu, pra você chamar sem o prefixo. Use com parcimônia, pra não sumir de onde a função veio:

```elixir
import Enum, only: [map: 2]
map([1, 2, 3], &(&1 * 2))
```

`use` é o mais poderoso e o mais mágico. Ele chama um código que o outro módulo definiu pra "te preparar", muitas vezes injetando funções e configuração no seu módulo. Você já usou na parte 1 sem perceber: `use ExUnit.Case` montou toda a estrutura de teste pra você. Por enquanto, basta saber que quando você vê `use AlgumaCoisa`, aquele módulo está te dando um kit pronto.

## Atributos de módulo como constantes

Um atributo de módulo é uma anotação que começa com `@`. O uso mais comum é guardar uma constante, um valor fixo que você não quer repetir:

```elixir
defmodule Circulo do
  @pi 3.14159

  def area(raio), do: @pi * raio * raio
end
```

```elixir
iex> Circulo.area(2)
12.56636
```

O `@pi` é calculado uma vez, na compilação, e fica embutido onde foi usado. Bom pra valores de configuração e números mágicos.

## Documentação e typespecs

Aqui mora um dos motivos pra tanta gente gostar de Elixir. Documentação não é comentário solto, é parte da linguagem. O `@moduledoc` documenta o módulo, o `@doc` documenta a função, e os exemplos `iex>` que você escreve viram teste (você fez isso na parte 1 com `doctest`).

Além disso tem o typespec, que descreve os tipos que uma função recebe e devolve. Ele não muda como o código roda, mas serve de documentação precisa e alimenta o Dialyzer, uma ferramenta que caça incoerências de tipo sem você rodar nada.

```elixir
defmodule Calculo do
  @doc "Soma dois inteiros."
  @spec soma(integer(), integer()) :: integer()
  def soma(a, b), do: a + b

  @type ponto :: {number(), number()}
end
```

`@spec soma(integer(), integer()) :: integer()` se lê assim: `soma` recebe dois inteiros e devolve um inteiro. `@type` cria um apelido pra um tipo, aqui um `ponto` que é uma tupla de dois números.

## Erros: quando levantar e quando devolver

Você tem dois caminhos pra lidar com coisa que dá errado, e a escolha entre eles diz muito sobre o estilo do Elixir.

O primeiro é levantar um erro com `raise`, e capturar com `try`/`rescue`. Isso existe, mas se reserva pro inesperado de verdade, o tipo de coisa que não deveria acontecer:

```elixir
iex> try do
...>   raise "deu ruim"
...> rescue
...>   e -> "peguei: #{e.message}"
...> end
"peguei: deu ruim"
```

O segundo caminho, o do dia a dia, é devolver `{:ok, valor}` ou `{:error, motivo}` e deixar quem chamou decidir. Você combina o resultado com pattern matching, e quando precisa encadear vários passos que podem falhar, usa o `with` da parte 1:

```elixir
with {:ok, conteudo} <- File.read("config.txt"),
     {:ok, numero} <- parse_inteiro(conteudo) do
  numero * 2
else
  {:error, motivo} -> "falhou: #{inspect(motivo)}"
end
```

A ideia geral: erro esperado vira valor de retorno, erro inesperado vira exceção. Na parte 3 você vai ver que o Elixir leva isso longe, deixando processos quebrarem de propósito e serem reiniciados limpos.

## Protocols: a mesma função para tipos diferentes

Às vezes você quer uma função que se comporta diferente conforme o tipo do dado, sem encher tudo de `if`. Um protocol é um contrato que diz "qualquer tipo pode implementar esta função do seu jeito".

```elixir
defprotocol Tamanho do
  @doc "Diz o tamanho de algo."
  def medir(coisa)
end

defimpl Tamanho, for: List do
  def medir(lista), do: length(lista)
end

defimpl Tamanho, for: BitString do
  def medir(texto), do: String.length(texto)
end
```

```elixir
iex> Tamanho.medir([1, 2, 3])
3
iex> Tamanho.medir("olá")
3
```

`defprotocol` declara a função `medir`, e cada `defimpl` ensina um tipo a respondê-la. O `Enum`, que você usa o tempo todo, funciona assim por baixo: ele fala com o protocol `Enumerable`, e por isso percorre lista, mapa, range e até `Stream` com as mesmas funções. Se você vem de uma linguagem orientada a objetos, o protocol faz o papel de uma interface, só que dá pra implementar até pra tipos que não são seus.

## Behaviours: um contrato de funções obrigatórias

Behaviour é primo do protocol, mas com outra pegada. Ele diz "todo módulo que se diz isto aqui precisa ter estas funções". É como a linguagem garante que um plugin tem a cara que o sistema espera.

```elixir
defmodule Saudacao do
  @callback ola(nome :: String.t()) :: String.t()
end

defmodule SaudacaoFormal do
  @behaviour Saudacao

  @impl Saudacao
  def ola(nome), do: "Prezado #{nome}"
end
```

`@callback` lista as funções obrigatórias. `@behaviour Saudacao` no outro módulo promete cumprir o contrato, e `@impl` marca a função que cumpre. Se você esquecer de implementar uma função do contrato, o compilador avisa. É exatamente assim que o `GenServer`, que você vai conhecer na parte 3, pede que você implemente certas funções.

## Próximos passos

Esta parte foi a mais densa da série de propósito, porque é aqui que mora a maior parte do "vocabulário" da linguagem. Você não precisa decorar tudo. Volte quando precisar de cada peça: struct pra dar forma a um dado, `Stream` pra coleção grande, protocol e behaviour quando for organizar código de verdade.

Na [parte 3](/blog/br/elixir-concorrencia) a gente chega no motivo de o Elixir existir: concorrência. Processos, `Task`, `Agent`, `GenServer` e a ideia de deixar as coisas quebrarem e se levantarem sozinhas. É a parte mais divertida.

Como sempre, nada aqui é pra acreditar no escuro. Abre o `iex`, cola os exemplos e mexe neles até quebrar.
