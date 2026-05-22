%{
  title: "Sobre backends chatos",
  author: "Frank Ferreira",
  tags: ~w(elixir postgres backend),
  description: "Por que escolho Postgres + Elixir como padrão para novos projetos — e como mantenho tudo chato de propósito.",
  published: true,
  updated_at: nil,
  twitter: "franknfjr"
}
---

![Sobre backends chatos](/images/blog/on-boring-backends.png)

Existe uma alegria particular em abrir um projeto dois anos depois e lembrar exatamente como ele funciona. Esse sentimento é o produto inteiro de um backend chato.

## A stack padrão

Pra maioria das coisas que eu envio pra produção, a resposta é a mesma: **PostgreSQL** pra armazenamento, **Phoenix** pra camada web, **Oban** pra jobs, **LiveView** quando a UI pede. Sem brokers de fila. Sem service mesh. Sem novo banco "só pra essa feature".

> A melhor arquitetura é aquela que o seu eu-do-futuro consegue ler numa tarde de domingo.

É tentador buscar a esperteza — um eventstore sharded, um SQL streaming, uma camada de cache em memória. Mas cada peça extra é mais uma coisa que vai te chamar às 3 da manhã.

## O que "chato" significa de verdade

Chato não significa estagnado. Significa:

- **Modos de falha previsíveis.** Quando algo quebra, eu sei mais ou menos onde procurar.
- **Um jeito de fazer cada coisa.** Todo trabalho assíncrono passa pelo Oban. Toda requisição HTTP usa `Req`. Todo email passa por um módulo Mailer.
- **Menos dependências.** Cada biblioteca é um voto de confiança — e confiança custa atenção de manutenção.

```elixir
defmodule MyApp.Mailer do
  use Swoosh.Mailer, otp_app: :my_app
end
```

É isso. Sem abstração em cima de abstração. Quando alguém novo lê esse código, entende em 30 segundos.

## A válvula de escape

Chato não é religião. Quando um problema genuinamente precisa de outra forma — um índice de busca, um CRDT, um vector store — você vai lá e pega. Mas a barra é alta, e o custo é real. O padrão é Postgres até Postgres ser a resposta errada.
