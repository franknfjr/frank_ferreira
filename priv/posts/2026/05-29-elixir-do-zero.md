%{
  title: "Elixir do zero, parte 1: instalação e fundamentos",
  author: "Frank Ferreira",
  tags: ~w(elixir iniciante tutorial),
  description: "Primeira parte de uma série prática: instale o Elixir e aprenda os fundamentos (tipos, imutabilidade, pattern matching, pipe, Enum e mix), comparando sempre com Python, JavaScript, Ruby e Go.",
  published: true,
  updated_at: nil,
  twitter: "franknfjr"
}
---

![Elixir do zero, parte 1: instalação e fundamentos](/images/blog/elixir-do-zero.png)

Em fevereiro de 2026 o José Valim publicou um artigo de título ousado: ["Why Elixir is the best language for AI"](https://dashbit.co/blog/why-elixir-best-language-for-ai). O número que sustenta o título veio de um estudo da Tencent, que avaliou mais de 20 linguagens com dezenas de modelos. O Elixir teve a maior taxa de resolução de todas: 97,5% dos problemas resolvidos por pelo menos um modelo, com o Claude Opus 4 acertando 80,3%, na frente de C# (74,9%) e Kotlin (72,5%).

O motivo que ele aponta vale tanto pra máquina quanto pra gente. Código imutável, sem efeito colateral escondido. Pattern matching que deixa a forma do dado à mostra. Um pipe que faz a transformação ser lida de cima pra baixo. Documentação que é dado testável, não comentário solto. Se uma LLM raciocina bem sobre a linguagem, é uma boa pista de que você também vai.

Este é o primeiro post de uma série de três. Não preciso que você já saiba programar: vou explicar cada ideia do zero, em português claro. Quando fizer sentido, comparo com Python, JavaScript, Ruby ou Go, mas isso é bônus pra quem já mexeu com elas, não pré-requisito. A proposta é reproduzível: você copia, cola e roda. No fim, vai ter o Elixir instalado e os fundamentos na ponta da língua. As partes 2 e 3 entram em structs, protocolos, erros, streams e, lá no fim, concorrência e o jeito BEAM de tolerar falha.

## O que você vai precisar

Um terminal e vontade de digitar `iex`. O Elixir roda em cima da BEAM, que é o motor que de fato executa o código (ele vem do Erlang, uma linguagem mais antiga em que o Elixir se apoia). Por isso, instalar Elixir quer dizer ter o Erlang e o Elixir na máquina. Dá pra resolver os dois de uma vez só.

## Instalando o Elixir

São três caminhos. Vou recomendar um e deixar os outros à mão.

### Recomendado: mise (cuida das versões pra você)

O [mise](https://mise.jdx.dev) é um gerenciador de versões, no espírito do `nvm`, `pyenv` ou `rbenv`, mas pra qualquer linguagem. Ele fixa a versão de Erlang e de Elixir por projeto, sem bagunçar o resto da máquina.

```bash
# macOS ou Linux
curl https://mise.run | sh

# Reabra o terminal, então:
mise use -g erlang@latest
mise use -g elixir@latest
```

Confere se deu certo:

```bash
elixir --version
```

Você deve ver algo parecido com isto:

```
Erlang/OTP 27 [erts-15.2] [source] [64-bit] [smp:8:8]

Elixir 1.18.1 (compiled with Erlang/OTP 27)
```

Já usa `asdf`? O fluxo é o mesmo: `asdf plugin add erlang`, `asdf plugin add elixir`, `asdf install`. E o mesmo arquivo `.tool-versions` serve pros dois.

### Atalho: gerenciador de pacotes do sistema

Mais rápido, com menos controle de versão:

```bash
# macOS
brew install elixir

# Ubuntu/Debian (precisa do repositório do Erlang Solutions p/ versões novas)
sudo apt install elixir

# Arch
sudo pacman -S elixir
```

### Windows

Baixe o instalador oficial em [elixir-lang.org/install.html](https://elixir-lang.org/install.html), que já traz o Erlang junto, ou use o `scoop`:

```powershell
scoop install erlang elixir
```

Em qualquer caminho o teste final é o mesmo: `elixir --version` precisa responder. Respondeu? Você está pronto.

## iex: o REPL onde tudo acontece

Quase tudo aqui você roda no `iex`, o shell interativo do Elixir. "Shell interativo" quer dizer um lugar onde você digita uma linha de código, aperta Enter e vê o resultado na hora, sem precisar criar arquivo nem rodar nenhum passo extra. Se você já abriu o `python` ou o `node` no terminal e saiu digitando, é a mesma ideia, com alguns superpoderes a mais: o `iex` recompila código, mostra documentação e inspeciona processos vivos.

```bash
iex
```

```elixir
iex> 1 + 1
2
iex> "ola" <> " mundo"
"ola mundo"
iex> String.upcase("elixir")
"ELIXIR"
```

Dois truques que valem ouro desde o primeiro dia. O `h` mostra a documentação de qualquer função ali no terminal:

```elixir
iex> h String.upcase
```

E o `i` inspeciona um valor, dizendo o tipo dele e o que dá pra fazer com ele:

```elixir
iex> i "elixir"
Term
  "elixir"
Data type
  BitString
...
```

Pra sair: `Ctrl+C` duas vezes, ou `Ctrl+\`.

## Tipos básicos e a ideia que muda tudo: imutabilidade

Os tipos não vão te assustar:

```elixir
iex> 42                    # integer
iex> 3.14                  # float
iex> "texto"               # string (na verdade, um binary UTF-8)
iex> true                  # boolean
iex> :ok                   # atom (já já explico)
iex> [1, 2, 3]             # lista
iex> {:ok, "valor"}        # tupla
iex> %{nome: "Frank"}      # mapa (dicionário)
```

A surpresa está logo ali: nada disso pode ser mutado. Em JavaScript ou Python você está acostumado a alterar uma coleção no lugar:

```javascript
// JavaScript: push muta o array original
const lista = [1, 2, 3];
lista.push(4);   // lista agora é [1, 2, 3, 4]
```

Em Elixir não existe `push`. Em vez de alterar a lista, você cria uma nova a partir dela:

```elixir
iex> lista = [1, 2, 3]
[1, 2, 3]
iex> [0 | lista]          # uma lista NOVA com o 0 na frente
[0, 1, 2, 3]
iex> lista                # a original continua intacta
[1, 2, 3]
```

Parece um detalhe, mas é a fundação de tudo. Se um valor nunca muda depois de criado, você nunca precisa perguntar "quem mexeu nisso?". A função recebe um dado e devolve outro; o de entrada continua igual. O artigo do Valim chama isso de *raciocínio local*, e é por isso que bug de estado compartilhado some do mapa.

### Atoms: o "símbolo" do Elixir

Um `atom` é um valor fixo que serve de etiqueta: o nome dele já é o próprio valor. Você escreve com dois-pontos na frente, como `:ok` ou `:erro`. Pense num rótulo que nunca muda e que você usa pra marcar uma situação. Quem vem de Ruby já conhece como `:symbol`:

```ruby
# Ruby
status = :ok
```

```elixir
# Elixir, idêntico
iex> status = :ok
:ok
```

Atoms aparecem em todo lugar. `true` e `false` são atoms, e o par `{:ok, valor}` / `{:error, motivo}`, que você vai ver o tempo todo, usa atoms pra marcar como uma operação terminou.

### Listas e tuplas

A distinção é a mesma de Python (`list` e `tuple`), com uma regra de bolso: lista pra coleção que você percorre e que cresce ou encolhe; tupla pra agrupar um número fixo de elementos, em geral um retorno.

```elixir
iex> {:ok, conteudo} = {:ok, "arquivo lido"}
iex> conteudo
"arquivo lido"
```

### Mapas

O dicionário do Elixir. Compare com o `dict` do Python ou o objeto do JS:

```elixir
iex> usuario = %{nome: "Frank", idade: 30}
iex> usuario.nome
"Frank"
iex> usuario[:idade]
30
# atualizar significa criar um mapa novo (de novo, nada muta)
iex> %{usuario | idade: 31}
%{nome: "Frank", idade: 31}
```

Structs (um mapa com nome e campos fixos) e keyword lists ficam pra parte 2, junto com o resto da linguagem além do básico.

## Pattern matching: o `=` não é o que você pensa

Aqui está o coração do Elixir. Em quase toda linguagem, `=` quer dizer "atribua". Em Elixir, `=` quer dizer "force os dois lados a casarem". É um operador de *match*, não de atribuição.

```elixir
iex> x = 1     # casa: a variável x assume o valor 1
1
iex> 1 = x     # casa: 1 é igual a x? é. ok.
1
iex> 2 = x     # NÃO casa, estoura
** (MatchError) no match of right hand side value: 1
```

O truque é usar isso pra desmontar estruturas. JavaScript e Python têm *destructuring*, que se parece:

```javascript
// JavaScript
const [primeiro, segundo] = [10, 20];
const { nome } = usuario;
```

O Elixir faz o mesmo e vai além: ele também verifica a forma e o conteúdo enquanto desmonta.

```elixir
iex> [primeiro, segundo] = [10, 20]
iex> primeiro
10

# desmonta E exige que o primeiro elemento seja o atom :ok
iex> {:ok, resultado} = {:ok, "deu certo"}
iex> resultado
"deu certo"
```

É por isso que tratar erro em Elixir fica tão limpo. Você casa o resultado direto na forma esperada:

```elixir
case File.read("config.txt") do
  {:ok, conteudo} -> IO.puts("Li: #{conteudo}")
  {:error, motivo} -> IO.puts("Falhou: #{motivo}")
end
```

Não precisa de `try/catch` pro fluxo normal nem de checar `if err != nil` em cada linha. A forma do dado é o controle de fluxo.

## Funções, módulos e a tal da "arity"

Uma função é um pedaço de código com nome que recebe valores de entrada e devolve um resultado. Um módulo é só uma caixa que junta funções parecidas debaixo de um nome. Em Elixir, toda função com nome mora dentro de um módulo. Crie um arquivo `matematica.exs`:

```elixir
defmodule Matematica do
  # forma completa: corpo entre `do ... end`
  def dobro(n) do
    n * 2
  end

  # forma contraída: `do:` quando o corpo cabe numa linha só
  def soma(a, b), do: a + b
end
```

As duas funções acima fazem a mesma coisa, só mudam de roupa: `do ... end` para corpos de várias linhas e `, do:` para uma linha. Você vai ver as duas formas o tempo todo.

Rode com `elixir matematica.exs` ou carregue no `iex`:

```elixir
iex> c("matematica.exs")
iex> Matematica.dobro(21)
42
iex> Matematica.soma(2, 3)
5
```

Uma diferença de vocabulário: no Elixir, a função é identificada pelo nome e pela quantidade de argumentos, a *arity*. `soma/2` (lê-se "soma barra dois") é uma função diferente de `soma/3`. Onde em Python ou JS você usaria argumento opcional ou `*args`, em Elixir você escreve cláusulas separadas e deixa o pattern matching escolher qual roda:

```elixir
defmodule Saudacao do
  def ola(:manha), do: "Bom dia!"
  def ola(:noite), do: "Boa noite!"
  def ola(_qualquer), do: "Olá!"
end
```

```elixir
iex> Saudacao.ola(:manha)
"Bom dia!"
iex> Saudacao.ola(:tarde)
"Olá!"
```

Repare que não tem `if`. Cada caso é uma cláusula da função, e o runtime (o programa que executa seu código) escolhe qual roda pela forma do argumento.

Além das funções com nome, existe a *função anônima*: uma função sem nome, que você guarda numa variável e passa adiante como se fosse qualquer outro valor. Serve pra quando você precisa de um pedacinho de lógica na hora e não vale a pena dar um nome a ele (daqui a pouco, no `Enum`, você vai usar muito isso). Como ela não tem nome, na hora de chamar você põe um ponto antes dos parênteses:

```elixir
iex> triplo = fn n -> n * 3 end
iex> triplo.(10)
30
# atalho com a captura &
iex> quadrado = &(&1 * &1)
iex> quadrado.(9)
81
```

## O pipe |>: leia o código na ordem em que ele acontece

Se você for levar uma única coisa deste post, leve o pipe. Digamos que você queira pegar uma frase, separar as palavras e contar a frequência de cada uma. Sem pipe, vira um aninhamento que se lê de dentro pra fora:

```elixir
iex> Enum.frequencies(String.split(String.downcase("Elixir é elixir")))
```

Pra entender, o olho precisa ir até o miolo e voltar. Com o pipe, o valor da esquerda vira o primeiro argumento da função da direita:

```elixir
iex> "Elixir é elixir"
...> |> String.downcase()
...> |> String.split()
...> |> Enum.frequencies()
%{"elixir" => 2, "é" => 1}
```

Lê de cima pra baixo, na ordem em que as coisas acontecem. Quem já usou pipe no shell Unix reconhece a ideia na hora:

```bash
cat frase.txt | tr 'A-Z' 'a-z' | tr ' ' '\n' | sort | uniq -c
```

É o `|` do bash, dentro da linguagem. O method chaining do JavaScript (`arr.map().filter().reduce()`) resolve algo parecido, mas só funciona com métodos do próprio objeto. O pipe do Elixir liga qualquer função de qualquer módulo, desde que ela receba o valor como primeiro argumento.

## Enum: map, filter e reduce sem loop

Quando você tem uma coleção (uma lista, por exemplo) e quer transformá-la, o módulo `Enum` é o canivete. Três operações aparecem o tempo todo: `map` aplica uma função em cada elemento e devolve a lista já transformada; `filter` deixa passar só os elementos que satisfazem um teste; `reduce` percorre a lista acumulando tudo num único resultado (uma soma, por exemplo). Quem já usou `map`/`filter`/`reduce` no JavaScript reconhece na hora:

```elixir
iex> Enum.map([1, 2, 3], fn n -> n * 2 end)
[2, 4, 6]
iex> Enum.filter([1, 2, 3, 4], fn n -> rem(n, 2) == 0 end)
[2, 4]
iex> Enum.reduce([1, 2, 3, 4], 0, fn n, acc -> n + acc end)
10
```

Junte com o pipe e fica fluido:

```elixir
iex> 1..10
...> |> Enum.filter(&(rem(&1, 2) == 0))
...> |> Enum.map(&(&1 * &1))
...> |> Enum.sum()
220
```

O Elixir também tem comprehension, bem parecida com a do Python:

```python
# Python
[n * n for n in range(1, 5)]   # [1, 4, 9, 16]
```

```elixir
# Elixir
iex> for n <- 1..4, do: n * n
[1, 4, 9, 16]
# com filtro embutido, igual ao "if" da comprehension do Python
iex> for n <- 1..10, rem(n, 2) == 0, do: n
[2, 4, 6, 8, 10]
```

## case, cond, with: decisões sem if espalhado

`case` compara um valor contra padrões (de novo, pattern matching):

```elixir
case System.get_env("AMBIENTE") do
  "prod" -> "cuidado!"
  "dev" -> "pode brincar"
  nil -> "não definido"
  outro -> "ambiente: #{outro}"
end
```

`cond` é a escada de `else if` que você já conhece, testando condições em ordem:

```elixir
cond do
  idade < 13 -> "criança"
  idade < 18 -> "adolescente"
  true -> "adulto"
end
```

E tem o `with`, que não tem equivalente direto e é uma mão na roda. Ele encadeia vários matches e segue enquanto cada passo casa. É o antídoto pro "pyramid of doom" de `if` aninhado ou `try/except` empilhado:

```elixir
with {:ok, usuario} <- busca_usuario(id),
     {:ok, conta} <- busca_conta(usuario),
     {:ok, saldo} <- consulta_saldo(conta) do
  "Saldo: #{saldo}"
else
  {:error, motivo} -> "Deu ruim: #{motivo}"
end
```

Se qualquer passo devolver `{:error, ...}`, o fluxo pula direto pro `else`. O caminho feliz fica reto, sem indentação infinita.

## Recursão no lugar de loops

O salto mental aqui é maior, e vem direto da imutabilidade. Em Python ou Go você escreve um `for` com um contador que muda a cada volta:

```go
// Go
total := 0
for _, n := range numeros {
    total += n   // total é mutado
}
```

Em Elixir nada muda, então loop com variável de controle não existe. No lugar dele entra a recursão: uma função que chama a si mesma pra repetir o trabalho, tratando um pedaço de cada vez até não sobrar nada. No dia a dia você quase sempre usa o `Enum.reduce` que já apareceu (que é recursão embrulhada num nome bonito), mas vale ver a recursão na unha pelo menos uma vez, porque o pattern matching brilha aqui:

```elixir
defmodule MinhaLista do
  # caso base: lista vazia soma 0
  def soma([]), do: 0
  # caso geral: cabeça + soma do resto
  def soma([cabeca | resto]), do: cabeca + soma(resto)
end
```

```elixir
iex> c("minha_lista.exs")
iex> MinhaLista.soma([1, 2, 3, 4])
10
```

Duas cláusulas, nenhum `if`, nenhuma variável mutável. O `[cabeca | resto]` desmonta a lista no match: `cabeca` é o primeiro elemento e `resto` é o que sobra. Quando a lista esvazia, casa com `[]` e a recursão para. No dia a dia você usaria `Enum.sum/1`, mas agora sabe o que tem embaixo.

## mix: criando um projeto de verdade

Até aqui rodamos scripts soltos. Pra um projeto de verdade entra o `mix`, a ferramenta que acompanha o Elixir pra cuidar do projeto inteiro: ela cria a estrutura de pastas, baixa dependências (as bibliotecas de terceiros que você usa), roda os testes e compila o código. Se você conhece `npm`, `cargo` ou `pip`, é tudo isso num comando só.

```bash
mix new contador
cd contador
```

Isso gera uma estrutura enxuta:

```
contador/
├── lib/contador.ex        # seu código
├── test/contador_test.exs # seus testes
├── mix.exs                # config + dependências
└── README.md
```

Abra `lib/contador.ex` e escreva uma função de verdade:

```elixir
defmodule Contador do
  @doc """
  Conta quantas vezes cada palavra aparece numa frase.

      iex> Contador.palavras("oi oi tchau")
      %{"oi" => 2, "tchau" => 1}
  """
  def palavras(frase) do
    frase
    |> String.downcase()
    |> String.split()
    |> Enum.frequencies()
  end
end
```

Aquele `@doc` com o exemplo `iex>` não é enfeite. Ele é documentação testável, justamente o ponto que o Valim levanta como diferencial do Elixir. Abra `test/contador_test.exs` e adicione uma linha:

```elixir
defmodule ContadorTest do
  use ExUnit.Case
  doctest Contador   # roda os exemplos do @doc como teste!

  test "conta palavras repetidas" do
    assert Contador.palavras("a a b") == %{"a" => 2, "b" => 1}
  end
end
```

Rode os testes:

```bash
mix test
```

```
....
Finished in 0.03 seconds
2 tests, 0 failures
```

O `doctest` transformou o exemplo da documentação num teste real. Se você mudar a função e quebrar o exemplo, o teste falha. Documentação que mente não compila, e é isso que mantém o ecossistema (e os modelos de IA) sempre certos sobre como a coisa funciona.

Mais dois comandos do dia a dia:

```bash
mix format     # formata o código no estilo oficial, sem discussão
mix deps.get   # baixa as dependências listadas no mix.exs
```

Dependência entra no `mix.exs`, parecido com `package.json` ou `Cargo.toml`:

```elixir
defp deps do
  [
    {:req, "~> 0.5"}   # cliente HTTP, por exemplo
  ]
end
```

Um `mix deps.get` e ela está disponível. Todo o ecossistema fica documentado num lugar só, o [HexDocs](https://hexdocs.pm). É mais uma coisa que o Valim cita como vantagem: você não fica caçando em dez blogs qual a versão certa.

## Concorrência: o aperitivo

Não dá pra falar de Elixir sem citar o motivo de ele existir. A BEAM foi feita pra concorrência, e o modelo é diferente do que você provavelmente viu. Em Java você lida com thread e lock. Em Go, com goroutine e channel, já bem mais leve. O Elixir tem processo: não o do sistema operacional, mas um processo leve da própria VM. Você cria milhões deles sem suar, cada um isolado, sem memória compartilhada, conversando só por mensagem.

```elixir
iex> pid = spawn(fn -> IO.puts("rodando em outro processo!") end)
rodando em outro processo!
#PID<0.123.0>

# mandando e recebendo mensagem
iex> enviar = self()
iex> spawn(fn -> send(enviar, {:oi, "do outro processo"}) end)
iex> receive do
...>   {:oi, msg} -> msg
...> end
"do outro processo"
```

Como nada é compartilhado nem mutável, um processo não consegue corromper o estado de outro. Daí vem o "let it crash": em vez de blindar cada função contra todo erro possível, você deixa o processo morrer quando algo dá muito errado e um *supervisor* sobe ele de novo, limpo. É assim que a linguagem chega naqueles "nove noves" de disponibilidade.

Isso é a parte 3 inteira: processo, `Task`, `Agent`, `GenServer` e árvore de supervisão. Por ora, basta saber que está tudo ali, de graça, na fundação.

## Próximos passos

Você instalou o Elixir, abriu o `iex`, pegou imutabilidade, pattern matching e pipe, criou um projeto com `mix` e rodou teste. Já dá pra ler código Elixir de verdade e escrever seus primeiros módulos. Pra ir além:

- [Elixir School](https://elixirschool.com/pt): tutorial gratuito, em português, do básico ao avançado.
- [Guia oficial](https://elixir-lang.org/getting-started/introduction.html): a referência da linguagem.
- [HexDocs](https://hexdocs.pm): a documentação de tudo num lugar só.
- [Livebook](https://livebook.dev): cadernos interativos no estilo Jupyter pra experimentar sem criar projeto.

Na [parte 2](/blog/br/elixir-alem-do-basico) a gente vai além do básico: structs, protocolos, behaviours, erros e `with`, streams, datas, regex e leitura de arquivo. A [parte 3](/blog/br/elixir-concorrencia) fecha com concorrência e o jeito BEAM de tolerar falha.

E tudo aqui roda de verdade, sem mágica escondida. Abre o `iex` de novo e quebra as coisas; é assim que se aprende.
