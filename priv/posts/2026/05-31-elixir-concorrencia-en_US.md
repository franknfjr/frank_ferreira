%{
  title: "Elixir from scratch, part 3: concurrency and the BEAM way",
  author: "Frank Ferreira",
  tags: ~w(elixir beginner tutorial),
  description: "Final part of the series: processes, messages, Task, Agent, GenServer, links, 'let it crash' and supervision trees. The reason Elixir exists, from scratch and running.",
  published: true,
  updated_at: nil,
  twitter: "franknfjr"
}
---

![Elixir from scratch, part 3: concurrency and the BEAM way](/images/blog/elixir-concorrencia.png)

We've reached the part that, to me, is the heart of Elixir. In [part 1](/blog/en/elixir-do-zero) we saw the fundamentals and in [part 2](/blog/en/elixir-alem-do-basico) the language beyond the basics. Now comes the reason the language exists: doing several things at once without going insane.

Concurrency is doing more than one thing "at the same time": serving many users, downloading many pages, processing a queue while responding to a click. In most languages this is the hard part, full of traps. On the BEAM (the engine that runs Elixir, inherited from Erlang) it's the normal path. I'll show you from scratch, and everything runs in `iex`.

## Process: the fundamental piece

In Elixir, the unit of concurrency is the process. It's not the operating system process, the heavy one that shows up in your task manager. It's a lightweight process of the BEAM itself: you create millions of them without breaking a sweat, each one isolated from the others, no shared memory. If you've heard of goroutines in Go, the idea is similar, except here it's the foundation of everything.

You create a process with `spawn`, which takes a function to run:

```elixir
iex> spawn(fn -> IO.puts("hi from another process") end)
hi from another process
#PID<0.118.0>
```

That `#PID<0.118.0>` is the PID, the process identifier. It's the "address" you send messages to. Each process has its own.

## Talking through messages

Since processes don't share memory, they talk through messages. One sends with `send`, the other waits with `receive`. It's like leaving a note in someone's mailbox.

```elixir
iex> me = self()
iex> spawn(fn -> send(me, {:hi, "how's it going?"}) end)
iex> receive do
...>   {:hi, text} -> text
...> end
"how's it going?"
```

`self()` returns the PID of the current process (here, your `iex`). The new process sends `{:hi, "how's it going?"}` back to you, and `receive` waits for a message that matches the pattern `{:hi, text}`. Did you notice pattern matching from part 1 come back? The mailbox is matched by pattern, just like everything in Elixir.

## Holding state in a process

Here lives the insight that connects with the immutability from part 1. In Elixir nothing changes value. So how does a counter "go up"? The answer: a process that stays standing, in a loop, holding the state and recreating it with each message.

```elixir
defmodule Counter do
  def start(value), do: spawn(fn -> loop(value) end)

  defp loop(value) do
    receive do
      {:add, n} -> loop(value + n)
      {:get, who} -> send(who, value); loop(value)
    end
  end
end
```

```elixir
iex> c("counter.exs")
iex> pid = Counter.start(0)
iex> send(pid, {:add, 5})
iex> send(pid, {:add, 3})
iex> send(pid, {:get, self()})
iex> receive do v -> v end
8
```

Look at what happened: `loop` calls itself (recursion, from part 1) with the new value on each message. The value never changes in place; what changes is which call to `loop` is active. The process is the "little box" that holds the state between one message and the next.

This pattern is so common that Elixir already ships ready-made versions of it, so you don't write that loop by hand every time. The two main ones are `Agent` and `GenServer`.

## Agent: state held, no ceremony

`Agent` is the ready-made version for the simplest case: holding a value and poking at it. Without writing any loop.

```elixir
iex> {:ok, account} = Agent.start_link(fn -> 0 end)
iex> Agent.update(account, fn balance -> balance + 100 end)
iex> Agent.get(account, fn balance -> balance end)
100
```

`start_link` creates the process with the initial state (here, `0`). `update` takes a function that gets the current state and returns the new one. `get` reads. Underneath it's exactly the process-with-a-loop from above, only ready to go.

## Task: run something in parallel and grab the result later

`Task` is for when you want to fire off a piece of work to run alongside and fetch the result later. Great for doing several slow things at once, like calling three APIs without waiting for one to finish before starting the next.

```elixir
iex> task = Task.async(fn -> 2 + 2 end)
iex> Task.await(task)
4
```

`Task.async` starts the work in a separate process and hands you back a reference. `Task.await` waits for it to finish and gives you the result. To run several at once:

```elixir
iex> 1..3
...> |> Enum.map(fn n -> Task.async(fn -> n * n end) end)
...> |> Enum.map(&Task.await/1)
[1, 4, 9]
```

The three computations run in parallel, in three processes, and then you gather the results. If you come from JavaScript, `Task.async` is a lot like creating a promise, and `Task.await` is like `await`.

## GenServer: the workhorse

`GenServer` means "generic server". It's `Agent` all grown up: besides holding state, it neatly organizes how the process responds to each kind of request. Almost every real service in Elixir is a GenServer underneath.

It uses two ideas from part 2: it's a `behaviour` (you implement functions it requires) and it runs in a process. It has two kinds of request. `call` is when you want an answer and wait for it. `cast` is when you just notify it and move on, without waiting.

```elixir
defmodule Vault do
  use GenServer

  # Public API: how others talk to the vault
  def start_link(initial), do: GenServer.start_link(__MODULE__, initial)
  def balance(pid), do: GenServer.call(pid, :balance)
  def deposit(pid, amount), do: GenServer.cast(pid, {:deposit, amount})

  # Callbacks: how the vault responds inside
  @impl true
  def init(initial), do: {:ok, initial}

  @impl true
  def handle_call(:balance, _from, state), do: {:reply, state, state}

  @impl true
  def handle_cast({:deposit, amount}, state), do: {:noreply, state + amount}
end
```

```elixir
iex> c("vault.exs")
iex> {:ok, vault} = Vault.start_link(0)
iex> Vault.deposit(vault, 50)
iex> Vault.deposit(vault, 30)
iex> Vault.balance(vault)
80
```

It's worth separating the two halves. The functions on top (`start_link`, `balance`, `deposit`) are the public part, what the rest of the code calls. The ones below (`init`, `handle_call`, `handle_cast`) are the callbacks, what the GenServer calls inside when a request arrives. `init` sets the initial state. `handle_call` returns `{:reply, answer, new_state}` because the caller is waiting. `handle_cast` returns `{:noreply, new_state}` because no one is waiting. In all of them you return the new state, and the GenServer holds onto it for the next message. Recursion and immutability again, hidden in a comfortable package.

## Links and "let it crash"

Now the part that made Elixir famous. The philosophy here is different from almost everything you've seen: instead of armoring every function against every possible error, you let the process break when something goes very wrong, and trust another process to bring it back up, clean.

This only works because of the isolation. Since processes don't share memory, one dying doesn't corrupt the others. For them to know about each other's death, there's the link. When two processes are "linked", the death of one notifies the other.

```elixir
iex> spawn_link(fn -> raise "boom" end)
```

`spawn_link` creates a process already linked to yours. When it blows up, yours receives the signal too (in `iex` it recovers and shows you the error). On its own this looks like just "dying together". The magic comes when the process on the other end of the link isn't just any process, but a supervisor.

## Supervisor: the one that lifts what fell

A supervisor is a process whose only job is to look after other processes (called children) and restart them when they die. You say who the children are and what the strategy is, and it does the rest.

```elixir
defmodule Vault do
  use GenServer

  def start_link(initial), do: GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  def balance, do: GenServer.call(__MODULE__, :balance)
  def deposit(amount), do: GenServer.cast(__MODULE__, {:deposit, amount})

  @impl true
  def init(initial), do: {:ok, initial}
  @impl true
  def handle_call(:balance, _from, state), do: {:reply, state, state}
  @impl true
  def handle_cast({:deposit, amount}, state), do: {:noreply, state + amount}
end

children = [
  {Vault, 0}
]

Supervisor.start_link(children, strategy: :one_for_one)
```

```elixir
iex> c("supervised_vault.exs")
iex> Vault.deposit(100)
iex> Vault.balance()
100
```

Two things changed in `Vault`. It got a `name: __MODULE__` (the `__MODULE__` is the module's own name), so instead of carrying the PID around you call it by name. And now it runs under a `Supervisor`. The `:one_for_one` strategy means "if one child dies, restart only that child". If `Vault` breaks because of a bug, the supervisor brings up a new one in its place, with the initial state, and the system keeps standing. Stacking supervisors that look after supervisors forms the supervision tree, and that's how Elixir systems reach those "nine nines" of availability people talk so much about.

## Tail recursion: loops that run forever without blowing up

You noticed that the `Counter` up above calls itself forever. In many languages, a function that calls itself endlessly blows up memory (the famous "stack overflow"). On the BEAM there's tail recursion (tail call): when the call to itself is the last thing the function does, the machine reuses the same space instead of stacking.

```elixir
defmodule Loop do
  def count(0), do: :done
  def count(n) do
    count(n - 1)
  end
end
```

```elixir
iex> c("loop.exs")
iex> Loop.count(10_000_000)
:done
```

Ten million calls and nothing blows up, because each `count(n - 1)` is the last thing that happens. That's why a process can sit in a `receive` loop for its entire life without leaking memory.

## Randomness and the Erlang libraries

To wrap up, two practical things. A random number:

```elixir
iex> Enum.random(1..6)
4
iex> Enum.random(["heads", "tails"])
"tails"
```

And, since Elixir runs on the BEAM, you get free access to the whole Erlang library. You call an Erlang module by writing its name as an atom, with a colon in front:

```elixir
iex> :math.sqrt(144)
12.0
iex> :crypto.hash(:sha256, "frank") |> Base.encode16()
"77646F5A4F3166637627ABE998E7A1470FE72D8B430F067DAFA86263F1F23F94"
```

`:math` and `:crypto` are Erlang modules. You don't need to install anything: decades of production-tested library are already there, at your side.

## Where to go now

You went from `elixir --version` to standing up a stateful service, in parallel, that picks itself back up when it falls. That's a lot. From here, two paths are worth the investment.

If you want to build things for the web, the destination is [Phoenix](https://www.phoenixframework.org), the framework that makes Elixir shine, with LiveView for real-time interfaces almost without JavaScript. If you want to deeply understand the concurrency and fault-tolerance side, the subject is called OTP, and the book everyone recommends is "Elixir in Action", by Saša Jurić.

And that's it. Three parts, from scratch to supervised processes, all really running. Open `iex` one last time, start a `GenServer`, knock it down out of nowhere and watch the supervisor bring it back. When that pulls a smile out of you, you've understood why so many people love it here.
