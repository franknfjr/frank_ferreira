%{
  title: "Elixir from scratch, part 1: installation and fundamentals",
  author: "Frank Ferreira",
  tags: ~w(elixir beginner tutorial),
  description: "First part of a hands-on series: install Elixir and learn the fundamentals (types, immutability, pattern matching, the pipe, Enum and mix), comparing along the way with Python, JavaScript, Ruby and Go.",
  published: true,
  updated_at: nil,
  twitter: "franknfjr"
}
---

![Elixir from scratch, part 1: installation and fundamentals](/images/blog/elixir-do-zero.png)

In February 2026 José Valim published an article with a bold title: ["Why Elixir is the best language for AI"](https://dashbit.co/blog/why-elixir-best-language-for-ai). The number behind the title came from a Tencent study that evaluated more than 20 languages with dozens of models. Elixir had the highest resolution rate of them all: 97.5% of the problems solved by at least one model, with Claude Opus 4 getting 80.3%, ahead of C# (74.9%) and Kotlin (72.5%).

The reason he points to holds both for the machine and for us. Immutable code, no hidden side effects. Pattern matching that keeps the shape of the data in plain sight. A pipe that makes a transformation read top to bottom. Documentation that is testable data, not a loose comment. If an LLM reasons well about the language, that is a good hint that you will too.

This is the first post in a series of three. I don't need you to already know how to program: I'll explain every idea from scratch, in plain words. When it makes sense, I compare with Python, JavaScript, Ruby or Go, but that is a bonus for people who already touched those, not a prerequisite. The whole thing is reproducible: you copy, paste and run. By the end you'll have Elixir installed and the fundamentals at your fingertips. Parts 2 and 3 get into structs, protocols, errors, streams and, at the very end, concurrency and the BEAM way of tolerating failure.

## What you'll need

A terminal and the will to type `iex`. Elixir runs on top of the BEAM, which is the engine that actually executes the code (it comes from Erlang, an older language that Elixir leans on). So installing Elixir means having both Erlang and Elixir on your machine. You can sort out both at once.

## Installing Elixir

There are three paths. I'll recommend one and leave the others handy.

### Recommended: mise (handles versions for you)

[mise](https://mise.jdx.dev) is a version manager, in the spirit of `nvm`, `pyenv` or `rbenv`, but for any language. It pins the Erlang and Elixir versions per project, without messing up the rest of your machine.

```bash
# macOS or Linux
curl https://mise.run | sh

# Reopen the terminal, then:
mise use -g erlang@latest
mise use -g elixir@latest
```

Check that it worked:

```bash
elixir --version
```

You should see something like this:

```
Erlang/OTP 27 [erts-15.2] [source] [64-bit] [smp:8:8]

Elixir 1.18.1 (compiled with Erlang/OTP 27)
```

Already use `asdf`? The flow is the same: `asdf plugin add erlang`, `asdf plugin add elixir`, `asdf install`. And the same `.tool-versions` file serves both.

### Shortcut: your system package manager

Faster, with less version control:

```bash
# macOS
brew install elixir

# Ubuntu/Debian (needs the Erlang Solutions repo for recent versions)
sudo apt install elixir

# Arch
sudo pacman -S elixir
```

### Windows

Download the official installer at [elixir-lang.org/install.html](https://elixir-lang.org/install.html), which already bundles Erlang, or use `scoop`:

```powershell
scoop install erlang elixir
```

On any path the final test is the same: `elixir --version` has to answer. Did it answer? You're ready.

## iex: the REPL where everything happens

Almost everything here you run in `iex`, Elixir's interactive shell. "Interactive shell" means a place where you type a line of code, press Enter and see the result right away, with no file to create and no extra step to run. If you've ever opened `python` or `node` in the terminal and started typing, it's the same idea, with a few extra superpowers: `iex` recompiles code, shows documentation and inspects live processes.

```bash
iex
```

```elixir
iex> 1 + 1
2
iex> "hello" <> " world"
"hello world"
iex> String.upcase("elixir")
"ELIXIR"
```

Two tricks worth gold from day one. `h` shows the documentation for any function right there in the terminal:

```elixir
iex> h String.upcase
```

And `i` inspects a value, telling you its type and what you can do with it:

```elixir
iex> i "elixir"
Term
  "elixir"
Data type
  BitString
...
```

To quit: `Ctrl+C` twice, or `Ctrl+\`.

## Basic types and the idea that changes everything: immutability

The types won't scare you:

```elixir
iex> 42                    # integer
iex> 3.14                  # float
iex> "text"                # string (really, a UTF-8 binary)
iex> true                  # boolean
iex> :ok                   # atom (I'll explain shortly)
iex> [1, 2, 3]             # list
iex> {:ok, "value"}        # tuple
iex> %{name: "Frank"}      # map (dictionary)
```

The surprise is right there: none of this can be mutated. In JavaScript or Python you're used to changing a collection in place:

```javascript
// JavaScript: push mutates the original array
const list = [1, 2, 3];
list.push(4);   // list is now [1, 2, 3, 4]
```

In Elixir there is no `push`. Instead of changing the list, you create a new one from it:

```elixir
iex> list = [1, 2, 3]
[1, 2, 3]
iex> [0 | list]           # a NEW list with 0 in front
[0, 1, 2, 3]
iex> list                 # the original stays intact
[1, 2, 3]
```

It looks like a detail, but it's the foundation of everything. If a value never changes after it's created, you never have to ask "who touched this?". A function takes a piece of data and returns another; the input stays the same. Valim's article calls this *local reasoning*, and it's why shared-state bugs drop off the map.

### Atoms: Elixir's "symbol"

An `atom` is a fixed value that works as a label: its name is its own value. You write it with a colon in front, like `:ok` or `:error`. Think of a tag that never changes and that you use to mark a situation. Anyone coming from Ruby already knows this as `:symbol`:

```ruby
# Ruby
status = :ok
```

```elixir
# Elixir, identical
iex> status = :ok
:ok
```

Atoms show up everywhere. `true` and `false` are atoms, and the pair `{:ok, value}` / `{:error, reason}`, which you'll see all the time, uses atoms to mark how an operation ended.

### Lists and tuples

The distinction is the same as in Python (`list` and `tuple`), with a rule of thumb: a list for a collection you walk through and that grows or shrinks; a tuple to group a fixed number of elements, usually a return value.

```elixir
iex> {:ok, content} = {:ok, "file read"}
iex> content
"file read"
```

### Maps

Elixir's dictionary. Compare it to Python's `dict` or a JS object:

```elixir
iex> user = %{name: "Frank", age: 30}
iex> user.name
"Frank"
iex> user[:age]
30
# updating means creating a new map (again, nothing mutates)
iex> %{user | age: 31}
%{name: "Frank", age: 31}
```

Structs (a map with a name and fixed fields) and keyword lists are left for part 2, along with the rest of the language beyond the basics.

## Pattern matching: `=` is not what you think

Here is the heart of Elixir. In almost every language, `=` means "assign". In Elixir, `=` means "force both sides to match". It's a *match* operator, not an assignment.

```elixir
iex> x = 1     # matches: the variable x takes the value 1
1
iex> 1 = x     # matches: is 1 equal to x? it is. ok.
1
iex> 2 = x     # does NOT match, blows up
** (MatchError) no match of right hand side value: 1
```

The trick is using this to take structures apart. JavaScript and Python have *destructuring*, which looks similar:

```javascript
// JavaScript
const [first, second] = [10, 20];
const { name } = user;
```

Elixir does the same and goes further: it also checks the shape and the content while it takes things apart.

```elixir
iex> [first, second] = [10, 20]
iex> first
10

# takes apart AND requires the first element to be the atom :ok
iex> {:ok, result} = {:ok, "it worked"}
iex> result
"it worked"
```

That's why handling errors in Elixir comes out so clean. You match the result straight against the expected shape:

```elixir
case File.read("config.txt") do
  {:ok, content} -> IO.puts("Read: #{content}")
  {:error, reason} -> IO.puts("Failed: #{reason}")
end
```

No `try/catch` for the normal flow and no checking `if err != nil` on every line. The shape of the data is the control flow.

## Functions, modules and this thing called "arity"

A function is a named piece of code that takes input values and returns a result. A module is just a box that groups similar functions under one name. In Elixir, every named function lives inside a module. Create a file `math.exs`:

```elixir
defmodule Math do
  # full form: body between `do ... end`
  def double(n) do
    n * 2
  end

  # short form: `do:` when the body fits on one line
  def add(a, b), do: a + b
end
```

The two functions above do the same thing, they just change clothes: `do ... end` for multi-line bodies and `, do:` for one line. You'll see both forms all the time.

Run it with `elixir math.exs` or load it in `iex`:

```elixir
iex> c("math.exs")
iex> Math.double(21)
42
iex> Math.add(2, 3)
5
```

A difference in vocabulary: in Elixir a function is identified by its name and by how many arguments it takes, its *arity*. `add/2` (read "add slash two") is a different function from `add/3`. Where in Python or JS you'd use an optional argument or `*args`, in Elixir you write separate clauses and let pattern matching pick which one runs:

```elixir
defmodule Greeting do
  def hello(:morning), do: "Good morning!"
  def hello(:night), do: "Good night!"
  def hello(_anything), do: "Hello!"
end
```

```elixir
iex> Greeting.hello(:morning)
"Good morning!"
iex> Greeting.hello(:afternoon)
"Hello!"
```

Notice there's no `if`. Each case is a clause of the function, and the runtime (the program that executes your code) picks which one runs based on the shape of the argument.

Beyond named functions, there's the *anonymous function*: a function with no name, that you store in a variable and pass around like any other value. It's for when you need a small bit of logic on the spot and it isn't worth giving it a name (soon, with `Enum`, you'll use this a lot). Since it has no name, when you call it you put a dot before the parentheses:

```elixir
iex> triple = fn n -> n * 3 end
iex> triple.(10)
30
# shortcut with the capture &
iex> square = &(&1 * &1)
iex> square.(9)
81
```

## The pipe |>: read the code in the order it happens

If you take a single thing from this post, take the pipe. Say you want to grab a sentence, split the words and count how often each one shows up. Without the pipe, it turns into a nesting you read from the inside out:

```elixir
iex> Enum.frequencies(String.split(String.downcase("Elixir is elixir")))
```

To follow it, your eye has to jump to the core and back. With the pipe, the value on the left becomes the first argument of the function on the right:

```elixir
iex> "Elixir is elixir"
...> |> String.downcase()
...> |> String.split()
...> |> Enum.frequencies()
%{"elixir" => 2, "is" => 1}
```

It reads top to bottom, in the order things happen. Anyone who's used a pipe in the Unix shell recognizes the idea instantly:

```bash
cat sentence.txt | tr 'A-Z' 'a-z' | tr ' ' '\n' | sort | uniq -c
```

It's the bash `|`, inside the language. JavaScript's method chaining (`arr.map().filter().reduce()`) solves something similar, but only works with methods of the object itself. Elixir's pipe connects any function from any module, as long as it takes the value as its first argument.

## Enum: map, filter and reduce without a loop

When you have a collection (a list, for example) and want to transform it, the `Enum` module is the pocketknife. Three operations show up all the time: `map` applies a function to each element and returns the transformed list; `filter` lets through only the elements that pass a test; `reduce` walks the list accumulating everything into a single result (a sum, for example). Anyone who's used `map`/`filter`/`reduce` in JavaScript recognizes it instantly:

```elixir
iex> Enum.map([1, 2, 3], fn n -> n * 2 end)
[2, 4, 6]
iex> Enum.filter([1, 2, 3, 4], fn n -> rem(n, 2) == 0 end)
[2, 4]
iex> Enum.reduce([1, 2, 3, 4], 0, fn n, acc -> n + acc end)
10
```

Put it together with the pipe and it flows:

```elixir
iex> 1..10
...> |> Enum.filter(&(rem(&1, 2) == 0))
...> |> Enum.map(&(&1 * &1))
...> |> Enum.sum()
220
```

Elixir also has a comprehension, quite close to Python's:

```python
# Python
[n * n for n in range(1, 5)]   # [1, 4, 9, 16]
```

```elixir
# Elixir
iex> for n <- 1..4, do: n * n
[1, 4, 9, 16]
# with a built-in filter, like the "if" in Python's comprehension
iex> for n <- 1..10, rem(n, 2) == 0, do: n
[2, 4, 6, 8, 10]
```

## case, cond, with: decisions without scattered ifs

`case` compares a value against patterns (again, pattern matching):

```elixir
case System.get_env("ENVIRONMENT") do
  "prod" -> "careful!"
  "dev" -> "go ahead and play"
  nil -> "not set"
  other -> "environment: #{other}"
end
```

`cond` is the `else if` ladder you already know, testing conditions in order:

```elixir
cond do
  age < 13 -> "child"
  age < 18 -> "teenager"
  true -> "adult"
end
```

And there's `with`, which has no direct equivalent and is a lifesaver. It chains several matches and keeps going while each step matches. It's the antidote to the "pyramid of doom" of nested `if` or stacked `try/except`:

```elixir
with {:ok, user} <- find_user(id),
     {:ok, account} <- find_account(user),
     {:ok, balance} <- check_balance(account) do
  "Balance: #{balance}"
else
  {:error, reason} -> "Something broke: #{reason}"
end
```

If any step returns `{:error, ...}`, the flow jumps straight to the `else`. The happy path stays flat, with no infinite indentation.

## Recursion instead of loops

The mental leap here is bigger, and it comes straight from immutability. In Python or Go you write a `for` with a counter that changes each pass:

```go
// Go
total := 0
for _, n := range numbers {
    total += n   // total is mutated
}
```

In Elixir nothing changes, so a loop with a control variable doesn't exist. In its place comes recursion: a function that calls itself to repeat the work, handling one piece at a time until nothing is left. Day to day you'll almost always use the `Enum.reduce` you already saw (which is recursion wrapped in a nice name), but it's worth seeing recursion by hand at least once, because pattern matching shines here:

```elixir
defmodule MyList do
  # base case: an empty list sums to 0
  def sum([]), do: 0
  # general case: head + the sum of the rest
  def sum([head | rest]), do: head + sum(rest)
end
```

```elixir
iex> c("my_list.exs")
iex> MyList.sum([1, 2, 3, 4])
10
```

Two clauses, no `if`, no mutable variable. The `[head | rest]` takes the list apart in the match: `head` is the first element and `rest` is what's left. When the list empties, it matches `[]` and the recursion stops. Day to day you'd use `Enum.sum/1`, but now you know what's underneath.

## mix: creating a real project

So far we've run loose scripts. For a real project comes `mix`, the tool that ships with Elixir to take care of the whole project: it creates the folder structure, downloads dependencies (the third-party libraries you use), runs the tests and compiles the code. If you know `npm`, `cargo` or `pip`, it's all of that in one command.

```bash
mix new counter
cd counter
```

That generates a lean structure:

```
counter/
├── lib/counter.ex        # your code
├── test/counter_test.exs # your tests
├── mix.exs               # config + dependencies
└── README.md
```

Open `lib/counter.ex` and write a real function:

```elixir
defmodule Counter do
  @doc """
  Counts how many times each word shows up in a sentence.

      iex> Counter.words("hi hi bye")
      %{"hi" => 2, "bye" => 1}
  """
  def words(sentence) do
    sentence
    |> String.downcase()
    |> String.split()
    |> Enum.frequencies()
  end
end
```

That `@doc` with the `iex>` example is not decoration. It's testable documentation, exactly the point Valim raises as Elixir's edge. Open `test/counter_test.exs` and add a line:

```elixir
defmodule CounterTest do
  use ExUnit.Case
  doctest Counter   # runs the @doc examples as tests!

  test "counts repeated words" do
    assert Counter.words("a a b") == %{"a" => 2, "b" => 1}
  end
end
```

Run the tests:

```bash
mix test
```

```
....
Finished in 0.03 seconds
2 tests, 0 failures
```

The `doctest` turned the documentation example into a real test. If you change the function and break the example, the test fails. Documentation that lies won't compile, and that's what keeps the ecosystem (and the AI models) always right about how things work.

Two more everyday commands:

```bash
mix format     # formats the code in the official style, no debate
mix deps.get   # downloads the dependencies listed in mix.exs
```

A dependency goes into `mix.exs`, similar to `package.json` or `Cargo.toml`:

```elixir
defp deps do
  [
    {:req, "~> 0.5"}   # an HTTP client, for example
  ]
end
```

One `mix deps.get` and it's available. The whole ecosystem is documented in one place, [HexDocs](https://hexdocs.pm). It's one more thing Valim cites as an advantage: you don't hunt across ten blogs for the right version.

## Concurrency: the appetizer

You can't talk about Elixir without mentioning why it exists. The BEAM was built for concurrency, and the model is different from what you've probably seen. In Java you deal with threads and locks. In Go, with goroutines and channels, already much lighter. Elixir has the process: not the operating system one, but a lightweight process of the VM itself. You create millions of them without breaking a sweat, each one isolated, no shared memory, talking only through messages.

```elixir
iex> pid = spawn(fn -> IO.puts("running in another process!") end)
running in another process!
#PID<0.123.0>

# sending and receiving a message
iex> sender = self()
iex> spawn(fn -> send(sender, {:hi, "from the other process"}) end)
iex> receive do
...>   {:hi, msg} -> msg
...> end
"from the other process"
```

Since nothing is shared or mutable, one process can't corrupt another's state. That's where "let it crash" comes from: instead of armoring every function against every possible error, you let the process die when something goes very wrong and a *supervisor* brings it back up, clean. That's how the language reaches those "nine nines" of availability.

That's the whole of part 3: processes, `Task`, `Agent`, `GenServer` and the supervision tree. For now, it's enough to know it's all there, for free, in the foundation.

## Next steps

You installed Elixir, opened `iex`, got immutability, pattern matching and the pipe, created a project with `mix` and ran a test. You can already read real Elixir code and write your first modules. To go further:

- [Elixir School](https://elixirschool.com): a free tutorial, from basic to advanced.
- [Official guide](https://elixir-lang.org/getting-started/introduction.html): the language reference.
- [HexDocs](https://hexdocs.pm): the documentation for everything in one place.
- [Livebook](https://livebook.dev): interactive notebooks in the Jupyter style, to experiment without creating a project.

In [part 2](/blog/en/elixir-alem-do-basico) we go beyond the basics: structs, protocols, behaviours, errors and `with`, streams, dates, regex and reading files. [Part 3](/blog/en/elixir-concorrencia) closes with concurrency and the BEAM way of tolerating failure.

And everything here really runs, no hidden magic. Open `iex` again and break things; that's how you learn.
