# UI Redesign Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Transform the site from cartoonish to sophisticated minimal tech aesthetic with polished dark/light modes.

**Architecture:** Update Tailwind config with new color tokens, then systematically update each component (header, home, blog, about, projects, footer) to use the new design system.

**Tech Stack:** Phoenix LiveView, Tailwind CSS, HEEx templates

---

## Task 1: Update Tailwind Config with New Colors

**Files:**
- Modify: `assets/tailwind.config.js`

**Step 1: Add new color tokens**

```javascript
// In theme.extend.colors, replace existing with:
colors: {
  brand: "#3b82f6",
  primary: "#0a0a0a",
  // Dark mode
  dark: {
    bg: "#0a0a0a",
    surface: "#141414",
    border: "#1f1f1f",
    text: "#fafafa",
    muted: "#a1a1a1",
  },
  // Light mode
  light: {
    bg: "#fafafa",
    surface: "#ffffff",
    border: "#e5e5e5",
    text: "#0a0a0a",
    muted: "#525252",
  },
  accent: {
    DEFAULT: "#3b82f6",
    dark: "#2563eb",
  },
},
```

**Step 2: Verify config is valid**

Run: `cd assets && npm run deploy`
Expected: Build succeeds

**Step 3: Commit**

```bash
git add assets/tailwind.config.js
git commit -m "feat: add new color tokens for minimal design system"
```

---

## Task 2: Update Root Layout and Body Styles

**Files:**
- Modify: `lib/frank_ferreira_web/components/layouts/root.html.heex`
- Modify: `assets/css/app.css`

**Step 1: Update body class in root.html.heex**

Replace line 41:
```html
<body class="antialiased bg-gradient-to-r from-violet-800/5 via-violet-800/20 to-violet-800/5 dark:bg-[#111] dark:text-gray-100">
```

With:
```html
<body class="antialiased bg-light-bg text-light-text dark:bg-dark-bg dark:text-dark-text">
```

**Step 2: Update base typography in app.css**

After the font-face declarations, add:
```css
body {
  font-feature-settings: "cv02", "cv03", "cv04", "cv11";
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
```

**Step 3: Verify app loads**

Run: `mix phx.server`
Expected: Site loads with new background colors

**Step 4: Commit**

```bash
git add lib/frank_ferreira_web/components/layouts/root.html.heex assets/css/app.css
git commit -m "feat: update root layout with new color system"
```

---

## Task 3: Redesign Header

**Files:**
- Modify: `lib/frank_ferreira_web/components/layouts/header.html.heex`

**Step 1: Replace entire header.html.heex**

```heex
<header class="sticky top-0 z-50 backdrop-blur-sm bg-light-bg/80 dark:bg-dark-bg/80 border-b border-light-border dark:border-dark-border">
  <nav class="mx-auto max-w-5xl px-4 sm:px-6 lg:px-8">
    <div class="flex h-14 items-center justify-between">
      <%!-- Logo/Name --%>
      <a href="/" class="flex items-center gap-3 text-light-text dark:text-dark-text">
        <img class="w-8 h-8 rounded-full" src="/images/avatar.png" alt="Frank" />
        <span class="text-sm font-medium hidden sm:block">Frank Ferreira</span>
      </a>

      <%!-- Desktop Nav --%>
      <div class="hidden sm:flex items-center gap-6">
        <a href="/" class="text-sm text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
          <%= gettext("Home") %>
        </a>
        <a href="/about" class="text-sm text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
          <%= gettext("About") %>
        </a>
        <a href="/blog" class="text-sm text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
          <%= gettext("Blog") %>
        </a>
        <a href="/projects" class="text-sm text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
          <%= gettext("Projects") %>
        </a>
      </div>

      <%!-- Right side: theme toggle + language --%>
      <div class="flex items-center gap-4">
        <button phx-click={JS.dispatch("toogle-darkmode")} class="p-2 text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
          <svg class="w-5 h-5 hidden dark:block" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v2.25m6.364.386-1.591 1.591M21 12h-2.25m-.386 6.364-1.591-1.591M12 18.75V21m-4.773-4.227-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0Z" />
          </svg>
          <svg class="w-5 h-5 block dark:hidden" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21.752 15.002A9.72 9.72 0 0 1 18 15.75c-5.385 0-9.75-4.365-9.75-9.75 0-1.33.266-2.597.748-3.752A9.753 9.753 0 0 0 3 11.25C3 16.635 7.365 21 12.75 21a9.753 9.753 0 0 0 9.002-5.998Z" />
          </svg>
        </button>

        <.language_select
          current_locale={Gettext.get_locale(FrankFerreiraWeb.Gettext)}
          language_options={FrankFerreira.config(:language_options)}
        />

        <%!-- Mobile menu button --%>
        <button
          phx-click={JS.toggle(to: "#mobile-menu", in: "fade-in", out: "fade-out")}
          class="sm:hidden p-2 text-light-muted dark:text-dark-muted"
        >
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>
      </div>
    </div>
  </nav>

  <%!-- Mobile menu --%>
  <div id="mobile-menu" class="hidden sm:hidden border-t border-light-border dark:border-dark-border">
    <div class="px-4 py-4 space-y-3">
      <a href="/" class="block text-sm text-light-muted dark:text-dark-muted"><%= gettext("Home") %></a>
      <a href="/about" class="block text-sm text-light-muted dark:text-dark-muted"><%= gettext("About") %></a>
      <a href="/blog" class="block text-sm text-light-muted dark:text-dark-muted"><%= gettext("Blog") %></a>
      <a href="/projects" class="block text-sm text-light-muted dark:text-dark-muted"><%= gettext("Projects") %></a>
    </div>
  </div>
</header>
```

**Step 2: Verify header renders**

Run: `mix phx.server`
Expected: New minimal header with sticky blur effect

**Step 3: Commit**

```bash
git add lib/frank_ferreira_web/components/layouts/header.html.heex
git commit -m "feat: redesign header with minimal sticky nav"
```

---

## Task 4: Redesign Home Page

**Files:**
- Modify: `lib/frank_ferreira_web/controllers/page_html/home.html.heex`

**Step 1: Replace entire home.html.heex**

```heex
<.flash_group flash={@flash} />
<main class="mx-auto max-w-2xl px-4 sm:px-6 lg:px-8">
  <section class="py-24">
    <p class="text-sm text-light-muted dark:text-dark-muted mb-4">
      Hey, I'm Frank
    </p>
    <h1 class="text-4xl font-medium tracking-tight text-light-text dark:text-dark-text mb-6">
      <%= gettext("Software Engineer") %>
    </h1>
    <p class="text-light-muted dark:text-dark-muted max-w-xl leading-relaxed">
      <%= gettext("Building software in Brazil. Passionate about creating tools that make life easier.") %>
    </p>

    <div class="flex items-center gap-4 mt-8">
      <a href="https://github.com/franknfjr" target="_blank" class="text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
          <path fill-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z" clip-rule="evenodd" />
        </svg>
      </a>
      <a href="https://twitter.com/franknfjr" target="_blank" class="text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
          <path d="M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84" />
        </svg>
      </a>
      <a href="https://www.linkedin.com/in/franknferreira/" target="_blank" class="text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
          <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z" />
        </svg>
      </a>
    </div>
  </section>
</main>
```

**Step 2: Verify home page**

Run: `mix phx.server`
Navigate to: http://localhost:4000
Expected: Clean minimal home with left-aligned content

**Step 3: Commit**

```bash
git add lib/frank_ferreira_web/controllers/page_html/home.html.heex
git commit -m "feat: redesign home page with minimal layout"
```

---

## Task 5: Redesign Footer

**Files:**
- Modify: `lib/frank_ferreira_web/components/layouts/footer.html.heex`

**Step 1: Replace entire footer.html.heex**

```heex
<footer class="border-t border-light-border dark:border-dark-border">
  <div class="mx-auto max-w-5xl px-4 sm:px-6 lg:px-8 py-8">
    <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
      <p class="text-sm text-light-muted dark:text-dark-muted">
        © <%= Timex.now().year %> Frank Ferreira
      </p>
      <div class="flex items-center gap-4">
        <a href="https://twitter.com/franknfjr" target="_blank" class="text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
            <path d="M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84" />
          </svg>
        </a>
        <a href="https://github.com/franknfjr" target="_blank" class="text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
            <path fill-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z" clip-rule="evenodd" />
          </svg>
        </a>
        <a href="https://www.linkedin.com/in/franknferreira/" target="_blank" class="text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
            <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z" />
          </svg>
        </a>
      </div>
    </div>
  </div>
</footer>
```

**Step 2: Verify footer**

Expected: Minimal single-line footer

**Step 3: Commit**

```bash
git add lib/frank_ferreira_web/components/layouts/footer.html.heex
git commit -m "feat: redesign footer with minimal layout"
```

---

## Task 6: Redesign Blog List

**Files:**
- Modify: `lib/frank_ferreira_web/live/blog_live.ex`

**Step 1: Replace render function**

Replace the entire `render(assigns)` function:

```elixir
def render(assigns) do
  ~H"""
  <main class="mx-auto max-w-2xl px-4 sm:px-6 lg:px-8 py-24">
    <h1 class="text-4xl font-medium tracking-tight text-light-text dark:text-dark-text mb-4">
      <%= gettext("Blog") %>
    </h1>
    <p class="text-light-muted dark:text-dark-muted mb-16">
      <%= gettext("Thoughts on software, technology, and life.") %>
    </p>

    <div class="space-y-12">
      <%= for post <- @posts do %>
        <article>
          <time class="text-sm text-light-muted dark:text-dark-muted">
            <%= formatted_date(post.created_at) %>
          </time>
          <h2 class="mt-2 text-lg font-medium text-light-text dark:text-dark-text">
            <a href={~p"/blog/#{post.language}/#{post.id}"} class="hover:text-accent transition-colors">
              <%= post.title %>
            </a>
          </h2>
          <p class="mt-2 text-light-muted dark:text-dark-muted line-clamp-2">
            <%= post.description %>
          </p>
          <div class="mt-3 flex flex-wrap gap-2">
            <%= for tag <- post.tags do %>
              <span class="px-2 py-1 text-xs bg-light-surface dark:bg-dark-surface border border-light-border dark:border-dark-border rounded text-light-muted dark:text-dark-muted">
                <%= tag %>
              </span>
            <% end %>
          </div>
        </article>
      <% end %>
    </div>
  </main>
  """
end
```

**Step 2: Remove newsletter function**

Delete the `defp news_latter(assigns)` function (lines 99-138) - we're removing inline newsletter.

**Step 3: Verify blog page**

Navigate to: http://localhost:4000/blog
Expected: Clean list without timeline decorations

**Step 4: Commit**

```bash
git add lib/frank_ferreira_web/live/blog_live.ex
git commit -m "feat: redesign blog list with minimal layout"
```

---

## Task 7: Redesign About Page

**Files:**
- Modify: `lib/frank_ferreira_web/live/about_live.ex`

**Step 1: Replace render function**

Replace the entire `render(assigns)` function with:

```elixir
def render(assigns) do
  ~H"""
  <main class="mx-auto max-w-2xl px-4 sm:px-6 lg:px-8 py-24">
    <h1 class="text-4xl font-medium tracking-tight text-light-text dark:text-dark-text mb-8">
      <%= gettext("About") %>
    </h1>

    <img class="w-20 h-20 rounded-lg mb-8" src="/images/avatar.png" alt="Frank Ferreira" />

    <div class="prose prose-neutral dark:prose-invert max-w-none">
      <p class="text-light-muted dark:text-dark-muted leading-relaxed">
        <%= gettext("Hello! I'm an enthusiastic programmer dedicated to exploring and refining my skills in the realm of software development. Throughout my journey, I've found my path in the Elixir ecosystem, where I've been involved in challenging projects that have allowed me to grow as a developer.") %>
      </p>

      <p class="text-light-muted dark:text-dark-muted leading-relaxed mt-4">
        <%= gettext("My passion for solving complex problems and crafting efficient solutions drives me to constantly pursue excellence in my work. I'm always eager to learn new technologies and innovative approaches to further enhance my expertise and make meaningful contributions to the projects I'm engaged in.") %>
      </p>

      <p class="text-light-muted dark:text-dark-muted leading-relaxed mt-4">
        <%= gettext("Whether exploring new concepts, collaborating with teams, or tackling challenges, I am committed to evolving as a professional and making a positive impact on the software development community.") %>
      </p>
    </div>

    <div class="mt-12 pt-8 border-t border-light-border dark:border-dark-border">
      <h2 class="text-lg font-medium text-light-text dark:text-dark-text mb-4">
        <%= gettext("Connect") %>
      </h2>
      <div class="space-y-2">
        <a href="https://twitter.com/franknfjr" target="_blank" class="block text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
          Twitter → @franknfjr
        </a>
        <a href="https://github.com/franknfjr" target="_blank" class="block text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
          GitHub → franknfjr
        </a>
        <a href="https://linkedin.com/in/franknferreira" target="_blank" class="block text-light-muted dark:text-dark-muted hover:text-light-text dark:hover:text-dark-text transition-colors">
          LinkedIn → franknferreira
        </a>
      </div>
    </div>

    <div class="mt-12 pt-8 border-t border-light-border dark:border-dark-border">
      <h2 class="text-lg font-medium text-light-text dark:text-dark-text mb-4">
        <%= gettext("Location") %>
      </h2>
      <p class="text-light-muted dark:text-dark-muted">
        <%= gettext("Ananindeua") %>, <%= gettext("Brazil") %> · <%= @date %>
      </p>
    </div>
  </main>
  """
end
```

**Step 2: Remove unused functions**

Delete the `number_of_days_in_current_year` function - no longer needed.

**Step 3: Remove keyboard event handler (optional, can keep)**

The `handle_event("keyup", ...)` can be removed if you don't want the easter eggs anymore.

**Step 4: Verify about page**

Navigate to: http://localhost:4000/about
Expected: Clean bio page without GitHub clone

**Step 5: Commit**

```bash
git add lib/frank_ferreira_web/live/about_live.ex
git commit -m "feat: redesign about page with minimal layout"
```

---

## Task 8: Redesign Projects Page

**Files:**
- Modify: `lib/frank_ferreira_web/live/projects.ex`

**Step 1: Simplify mount - flatten categories**

```elixir
def mount(_params, _session, socket) do
  projects = [
    %{
      name: gettext("IrriSusten"),
      description: gettext("Information system to manage plantation irrigation with web and mobile interfaces."),
      url: "https://sol.sbc.org.br/index.php/wcama/article/view/2941",
      tech: "Arduino, Sensors, Bluetooth"
    },
    %{
      name: gettext("Introduction to Elixir and Phoenix"),
      description: gettext("Educational repository for Elixir and Phoenix mini-course at UFRA."),
      url: "https://github.com/franknfjr/elixir-phoenix",
      tech: "Elixir, Phoenix"
    },
    %{
      name: "Mdown_ex",
      description: gettext("Converts Markdown files to HTML and Livebook using Elixir."),
      url: "https://github.com/franknfjr/md2livemd",
      tech: "Elixir"
    },
    %{
      name: gettext("Healthcare"),
      description: gettext("Dashboard for patient appointments, medications, and hospital indicators."),
      url: nil,
      tech: "Elixir, Phoenix, LiveView"
    },
    %{
      name: "CDN",
      description: gettext("Internal content delivery network for file management."),
      url: nil,
      tech: "Elixir"
    },
    %{
      name: gettext("Voter Intentions System"),
      description: gettext("Platform for collecting and analyzing voter preference data."),
      url: nil,
      tech: "Elixir, Phoenix"
    }
  ]

  {:ok, assign(socket, projects: projects)}
end
```

**Step 2: Replace render function**

```elixir
def render(assigns) do
  ~H"""
  <main class="mx-auto max-w-2xl px-4 sm:px-6 lg:px-8 py-24">
    <h1 class="text-4xl font-medium tracking-tight text-light-text dark:text-dark-text mb-4">
      <%= gettext("Projects") %>
    </h1>
    <p class="text-light-muted dark:text-dark-muted mb-16">
      <%= gettext("Things I've built and contributed to.") %>
    </p>

    <div class="space-y-8">
      <%= for project <- @projects do %>
        <div class="group">
          <h2 class="text-lg font-medium text-light-text dark:text-dark-text">
            <%= if project.url do %>
              <a href={project.url} target="_blank" class="hover:text-accent transition-colors inline-flex items-center gap-1">
                <%= project.name %>
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 19.5l15-15m0 0H8.25m11.25 0v11.25" />
                </svg>
              </a>
            <% else %>
              <%= project.name %>
            <% end %>
          </h2>
          <p class="mt-1 text-light-muted dark:text-dark-muted">
            <%= project.description %>
          </p>
          <p class="mt-2 text-sm text-light-muted dark:text-dark-muted">
            <%= project.tech %>
          </p>
        </div>
      <% end %>
    </div>
  </main>
  """
end
```

**Step 3: Verify projects page**

Navigate to: http://localhost:4000/projects
Expected: Clean list without image cards

**Step 4: Commit**

```bash
git add lib/frank_ferreira_web/live/projects.ex
git commit -m "feat: redesign projects page with minimal layout"
```

---

## Task 9: Update Base Typography in utils.css

**Files:**
- Modify: `assets/css/utils.css`

**Step 1: Update base layer typography**

Replace the `@layer base` section (lines 15-47):

```css
@layer base {
  h2 {
    @apply my-3 pt-2 text-2xl font-medium text-light-text dark:text-dark-text;
  }

  h3 {
    @apply my-2 pt-2 text-lg font-medium text-light-text dark:text-dark-text;
  }

  h4 {
    @apply my-2 py-2 text-base font-medium text-light-text dark:text-dark-text;
  }

  strong {
    @apply font-semibold text-light-text dark:text-dark-text;
  }

  li {
    @apply leading-7 text-light-muted dark:text-dark-muted;
  }

  p {
    @apply py-2 leading-relaxed text-light-muted dark:text-dark-muted;
  }

  p > img {
    @apply mx-auto;
  }
}
```

**Step 2: Commit**

```bash
git add assets/css/utils.css
git commit -m "feat: update base typography with new color system"
```

---

## Task 10: Final Review and Test

**Step 1: Run full build**

```bash
cd assets && npm run deploy && cd ..
mix phx.server
```

**Step 2: Visual check all pages**

- [ ] Home: minimal, left-aligned, social icons
- [ ] About: clean bio, no GitHub clone
- [ ] Blog: list without timeline
- [ ] Projects: text-only list
- [ ] Header: sticky with blur
- [ ] Footer: single line
- [ ] Dark mode toggle works
- [ ] Light mode looks good

**Step 3: Final commit**

```bash
git add -A
git commit -m "chore: complete UI redesign to minimal tech aesthetic"
```

---

## Summary

| Task | Component | Status |
|------|-----------|--------|
| 1 | Tailwind colors | Pending |
| 2 | Root layout | Pending |
| 3 | Header | Pending |
| 4 | Home | Pending |
| 5 | Footer | Pending |
| 6 | Blog list | Pending |
| 7 | About | Pending |
| 8 | Projects | Pending |
| 9 | Typography | Pending |
| 10 | Final review | Pending |
