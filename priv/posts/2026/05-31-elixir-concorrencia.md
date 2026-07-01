%{
  title: "Elixir do zero, parte 3: concorrência e o jeito BEAM",
  author: "Frank Ferreira",
  tags: ~w(elixir iniciante tutorial),
  description: "Parte final da série: processos, mensagens, Task, Agent, GenServer, links, o 'let it crash' e árvores de supervisão. O motivo de o Elixir existir, do zero e rodando.",
  published: true,
  updated_at: nil,
  twitter: "franknfjr"
}
---

![Elixir do zero, parte 3: concorrência e o jeito BEAM](/images/blog/elixir-concorrencia.png)

Chegamos na parte que, pra mim, é o coração do Elixir. Na [parte 1](/blog/br/elixir-do-zero) a gente viu os fundamentos e na [parte 2](/blog/br/elixir-alem-do-basico) a linguagem além do básico. Agora vem o motivo de a linguagem existir: fazer várias coisas ao mesmo tempo sem enlouquecer.

Concorrência é fazer mais de uma coisa "ao mesmo tempo": atender vários usuários, baixar várias páginas, processar uma fila enquanto responde a um clique. Na maioria das linguagens isso é a parte difícil, cheia de armadilha. Na BEAM (o motor que roda o Elixir, herdado do Erlang) é o caminho normal. Vou te mostrar do zero, e tudo roda no `iex`.

## Processo: a peça fundamental

Em Elixir, a unidade de concorrência é o processo. Não é o processo do sistema operacional, aquele pesado que aparece no gerenciador de tarefas. É um processo leve da própria BEAM: você cria milhões deles sem suar, cada um isolado dos outros, sem memória compartilhada. Se você já ouviu falar de goroutine no Go, a ideia é parecida, só que aqui é a base de tudo.

Você cria um processo com `spawn`, que recebe uma função pra rodar:

```elixir
iex> spawn(fn -> IO.puts("oi de outro processo") end)
oi de outro processo
#PID<0.118.0>
```

Aquele `#PID<0.118.0>` é o PID, o identificador do processo. É o "endereço" pra onde você manda mensagem. Cada processo tem o seu.

## Conversando por mensagens

Como os processos não compartilham memória, eles falam por mensagem. Um manda com `send`, o outro espera com `receive`. É como deixar um bilhete na caixa de correio de alguém.

```elixir
iex> eu = self()
iex> spawn(fn -> send(eu, {:oi, "tudo bem?"}) end)
iex> receive do
...>   {:oi, texto} -> texto
...> end
"tudo bem?"
```

`self()` devolve o PID do processo atual (no caso, o seu `iex`). O processo novo manda `{:oi, "tudo bem?"}` de volta pra você, e o `receive` espera por uma mensagem que case com o padrão `{:oi, texto}`. Reparou que voltou o pattern matching da parte 1? A caixa de mensagens é casada por padrão, igual a tudo no Elixir.

## Guardando estado num processo

Aqui mora a sacada que conecta com a imutabilidade da parte 1. Em Elixir nada muda de valor. Então como um contador "aumenta"? A resposta: um processo que fica em pé, num laço, segurando o estado e recriando ele a cada mensagem.

```elixir
defmodule Contador do
  def start(valor), do: spawn(fn -> laco(valor) end)

  defp laco(valor) do
    receive do
      {:soma, n} -> laco(valor + n)
      {:ver, quem} -> send(quem, valor); laco(valor)
    end
  end
end
```

```elixir
iex> c("contador.exs")
iex> pid = Contador.start(0)
iex> send(pid, {:soma, 5})
iex> send(pid, {:soma, 3})
iex> send(pid, {:ver, self()})
iex> receive do v -> v end
8
```

Olha o que aconteceu: `laco` chama a si mesmo (recursão, da parte 1) com o valor novo a cada mensagem. O valor nunca muda no lugar; o que muda é qual chamada de `laco` está ativa. O processo é a "caixinha" que segura o estado entre uma mensagem e outra.

Esse padrão é tão comum que o Elixir já traz versões prontas dele, pra você não escrever esse laço na mão toda vez. As duas principais são o `Agent` e o `GenServer`.

## Agent: estado guardado, sem cerimônia

O `Agent` é a versão pronta pro caso mais simples: guardar um valor e mexer nele. Sem escrever laço nenhum.

```elixir
iex> {:ok, conta} = Agent.start_link(fn -> 0 end)
iex> Agent.update(conta, fn saldo -> saldo + 100 end)
iex> Agent.get(conta, fn saldo -> saldo end)
100
```

`start_link` cria o processo com o estado inicial (aqui, `0`). `update` recebe uma função que pega o estado atual e devolve o novo. `get` lê. Por baixo é exatamente o processo-com-laço de cima, só que pronto.

## Task: rodar algo em paralelo e pegar o resultado depois

`Task` é pra quando você quer disparar um trabalho pra rodar ao lado e buscar o resultado mais tarde. Ótimo pra fazer várias coisas lentas ao mesmo tempo, tipo chamar três APIs sem esperar uma terminar pra começar a outra.

```elixir
iex> tarefa = Task.async(fn -> 2 + 2 end)
iex> Task.await(tarefa)
4
```

`Task.async` começa o trabalho num processo separado e te devolve uma referência. `Task.await` espera ele terminar e te dá o resultado. Pra rodar várias de uma vez:

```elixir
iex> 1..3
...> |> Enum.map(fn n -> Task.async(fn -> n * n end) end)
...> |> Enum.map(&Task.await/1)
[1, 4, 9]
```

Os três cálculos rodam em paralelo, em três processos, e depois você junta os resultados. Se você vem do JavaScript, `Task.async` lembra criar uma promise, e `Task.await` lembra o `await`.

## GenServer: o cavalo de batalha

`GenServer` quer dizer "generic server", servidor genérico. É o `Agent` crescido: além de guardar estado, ele organiza direitinho como o processo responde a cada tipo de pedido. Quase todo serviço de verdade em Elixir é um GenServer por baixo.

Ele usa duas ideias da parte 2: é um `behaviour` (você implementa funções que ele exige) e roda num processo. Tem dois tipos de pedido. `call` é quando você quer uma resposta e espera por ela. `cast` é quando você só avisa e segue a vida, sem esperar.

```elixir
defmodule Cofre do
  use GenServer

  # API pública: como os outros falam com o cofre
  def start_link(inicial), do: GenServer.start_link(__MODULE__, inicial)
  def saldo(pid), do: GenServer.call(pid, :saldo)
  def deposita(pid, valor), do: GenServer.cast(pid, {:deposita, valor})

  # Callbacks: como o cofre responde por dentro
  @impl true
  def init(inicial), do: {:ok, inicial}

  @impl true
  def handle_call(:saldo, _de, estado), do: {:reply, estado, estado}

  @impl true
  def handle_cast({:deposita, valor}, estado), do: {:noreply, estado + valor}
end
```

```elixir
iex> c("cofre.exs")
iex> {:ok, cofre} = Cofre.start_link(0)
iex> Cofre.deposita(cofre, 50)
iex> Cofre.deposita(cofre, 30)
iex> Cofre.saldo(cofre)
80
```

Vale separar as duas metades. As funções de cima (`start_link`, `saldo`, `deposita`) são a parte pública, o que o resto do código chama. As de baixo (`init`, `handle_call`, `handle_cast`) são os callbacks, o que o GenServer chama por dentro quando chega um pedido. `init` define o estado inicial. `handle_call` devolve `{:reply, resposta, novo_estado}` porque quem chamou está esperando. `handle_cast` devolve `{:noreply, novo_estado}` porque ninguém espera. Em todos eles você devolve o estado novo, e o GenServer guarda pra próxima mensagem. Recursão e imutabilidade de novo, escondidas num pacote confortável.

## Links e o "let it crash"

Agora a parte que faz o Elixir famoso. A filosofia aqui é diferente de quase tudo que você já viu: em vez de blindar cada função contra todo erro possível, você deixa o processo quebrar quando algo der muito errado, e confia em outro processo pra levantar ele de novo, limpo.

Isso só funciona por causa do isolamento. Como os processos não compartilham memória, um morrer não corrompe os outros. Pra eles saberem da morte um do outro, existe o link. Quando dois processos estão "linkados", a morte de um avisa o outro.

```elixir
iex> spawn_link(fn -> raise "explodi" end)
```

`spawn_link` cria um processo já linkado ao seu. Quando ele explode, o seu também recebe o sinal (no `iex` ele se recupera e te mostra o erro). Sozinho isso parece só "morrer junto". A mágica vem quando o do outro lado do link não é um processo qualquer, e sim um supervisor.

## Supervisor: quem levanta o que caiu

Um supervisor é um processo cujo único trabalho é cuidar de outros processos (chamados de filhos) e reiniciá-los quando eles morrem. Você diz quem são os filhos e qual a estratégia, e ele faz o resto.

```elixir
defmodule Cofre do
  use GenServer

  def start_link(inicial), do: GenServer.start_link(__MODULE__, inicial, name: __MODULE__)
  def saldo, do: GenServer.call(__MODULE__, :saldo)
  def deposita(valor), do: GenServer.cast(__MODULE__, {:deposita, valor})

  @impl true
  def init(inicial), do: {:ok, inicial}
  @impl true
  def handle_call(:saldo, _de, estado), do: {:reply, estado, estado}
  @impl true
  def handle_cast({:deposita, valor}, estado), do: {:noreply, estado + valor}
end

children = [
  {Cofre, 0}
]

Supervisor.start_link(children, strategy: :one_for_one)
```

```elixir
iex> c("cofre_supervisionado.exs")
iex> Cofre.deposita(100)
iex> Cofre.saldo()
100
```

Duas coisas mudaram no `Cofre`. Ele ganhou um `name: __MODULE__` (o `__MODULE__` é o próprio nome do módulo), então em vez de carregar o PID pra lá e pra cá você chama pelo nome. E agora ele roda debaixo de um `Supervisor`. A estratégia `:one_for_one` quer dizer "se um filho morrer, reinicie só aquele filho". Se o `Cofre` quebrar por um bug, o supervisor sobe um novo no lugar, com o estado inicial, e o sistema segue de pé. Empilhar supervisores cuidando de supervisores forma a árvore de supervisão, e é assim que sistemas em Elixir alcançam aqueles "nove noves" de disponibilidade de que tanto se fala.

## Recursão de cauda: laços que rodam pra sempre sem estourar

Você reparou que o `Contador` lá em cima chama a si mesmo pra sempre. Em muitas linguagens, uma função que se chama sem parar estoura a memória (o famoso "stack overflow"). Na BEAM existe a recursão de cauda (tail call): quando a chamada a si mesmo é a última coisa que a função faz, a máquina reaproveita o mesmo espaço em vez de empilhar.

```elixir
defmodule Loop do
  def conta(0), do: :pronto
  def conta(n) do
    conta(n - 1)
  end
end
```

```elixir
iex> c("loop.exs")
iex> Loop.conta(10_000_000)
:pronto
```

Dez milhões de chamadas e nada estoura, porque cada `conta(n - 1)` é a última coisa que acontece. É por isso que um processo pode ficar num laço de `receive` a vida inteira sem vazar memória.

## Aleatoriedade e as bibliotecas do Erlang

Pra terminar com duas coisas práticas. Número aleatório:

```elixir
iex> Enum.random(1..6)
4
iex> Enum.random(["cara", "coroa"])
"coroa"
```

E, já que o Elixir roda na BEAM, você tem acesso de graça a toda a biblioteca do Erlang. Você chama um módulo do Erlang escrevendo o nome como um atom, com dois-pontos na frente:

```elixir
iex> :math.sqrt(144)
12.0
iex> :crypto.hash(:sha256, "frank") |> Base.encode16()
"77646F5A4F3166637627ABE998E7A1470FE72D8B430F067DAFA86263F1F23F94"
```

`:math` e `:crypto` são módulos do Erlang. Você não precisa instalar nada: décadas de biblioteca testada em produção já estão ali, do seu lado.

## Onde ir agora

Você foi do `elixir --version` até subir um serviço com estado, em paralelo, que se reergue sozinho quando cai. Isso é bastante coisa. Daqui pra frente, dois caminhos valem o investimento.

Se você quer construir coisa pra web, o destino é o [Phoenix](https://www.phoenixframework.org), o framework que faz o Elixir brilhar, com LiveView pra interface em tempo real quase sem JavaScript. Se você quer entender a fundo a parte de concorrência e tolerância a falha, o assunto se chama OTP, e o livro que todo mundo recomenda é o "Elixir in Action", do Saša Jurić.

E foi isso. Três partes, do zero a processos supervisionados, tudo rodando de verdade. Abre o `iex` uma última vez, sobe um `GenServer`, derruba ele no susto e vê o supervisor trazer de volta. Quando isso te arrancar um sorriso, você entendeu por que tanta gente gosta daqui.
