# Contributing

Thanks for your interest in this project. This is a personal site, so most
changes are scoped to bug fixes, small improvements, and content corrections.
Larger feature work is generally not accepted unless discussed first.

## Reporting issues

- Search existing issues before opening a new one.
- Use the issue templates (bug report / feature request) when possible.
- Include reproduction steps, expected vs. actual behavior, and environment
  details (browser, OS, locale) for bugs.

## Development setup

Requires Elixir, Erlang/OTP, and Node (see `mix.exs` and `package.json` for
versions).

```bash
mix setup            # deps + assets
mix phx.server       # http://localhost:4000
```

## Before submitting a PR

1. Fork and create a topic branch off `main`.
2. Make focused, atomic commits with clear messages.
3. Run the checks the CI will run:
   ```bash
   mix format --check-formatted
   mix test
   ```
4. If you touch user-facing strings, update both locales in
   `priv/gettext/en/LC_MESSAGES/default.po` and
   `priv/gettext/br/LC_MESSAGES/default.po`.
5. For UI changes, manually verify in the browser at common viewports
   (mobile, tablet, desktop) before requesting review.
6. Use the pull request template and describe **what** and **why** — not just
   the diff.

## Coding style

- Elixir/HEEx code must pass `mix format`.
- Follow existing conventions in the file you're editing.
- Prefer small, reviewable PRs over large ones.

## Code of Conduct

Participation is governed by [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md).

## Security

Please do **not** open public issues for security vulnerabilities. See
[`SECURITY.md`](./SECURITY.md) for the disclosure process.

## License

By contributing, you agree that your contributions will be licensed under the
project's [MIT License](./LICENSE).
