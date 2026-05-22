%{
  title: "On boring backends",
  author: "Frank Ferreira",
  tags: ~w(elixir postgres backend),
  description: "Why I default to Postgres + Elixir for new projects — and how I keep them boring on purpose.",
  published: true,
  updated_at: nil,
  twitter: "franknfjr"
}
---

![On boring backends](/images/blog/on-boring-backends.png)

There's a particular kind of joy in opening a project two years later and remembering exactly how it works. That feeling is the whole product of a boring backend.

## The default stack

For most things I ship, the answer is the same: **PostgreSQL** for storage, **Phoenix** for the web layer, **Oban** for jobs, **LiveView** when the UI deserves it. No queue brokers. No service mesh. No new datastore "just for this feature."

> The best architecture is one that future-you can finish reading on a Sunday afternoon.

It's tempting to reach for cleverness — a sharded eventstore, a streaming SQL engine, an in-memory cache layer. But every additional moving part is one more thing that pages you at 3am.

## What "boring" actually means

Boring doesn't mean stagnant. It means:

- **Predictable failure modes.** When something breaks, I know roughly where to look.
- **One way to do common things.** All background work goes through Oban. All HTTP requests use `Req`. All emails go through one Mailer module.
- **Fewer dependencies.** Each library is a vote of trust — and trust costs maintenance attention.

```elixir
defmodule MyApp.Mailer do
  use Swoosh.Mailer, otp_app: :my_app
end
```

That's it. No abstraction over an abstraction. When a new contributor reads this, they're done in 30 seconds.

## The escape hatch

Boring isn't a religion. When a problem genuinely needs a different shape — a search index, a CRDT, a vector store — you reach for it. But the bar is high, and the cost is real. The default is Postgres until Postgres is the wrong answer.
