# UI Redesign: Minimal Tech Aesthetic

## Overview

Redesign do site/blog para uma estética mais sofisticada e tech, removendo elementos "cartunesco" e implementando um visual minimalista profissional com dark mode e light mode bem executados.

## Sistema de Cores

### Dark Mode (principal)
- Background: `#0a0a0a`
- Surface/cards: `#141414` com borda `#1f1f1f`
- Texto principal: `#fafafa`
- Texto secundário: `#a1a1a1`
- Accent: `#3b82f6` (blue-500)

### Light Mode
- Background: `#fafafa`
- Surface/cards: `#ffffff` com borda `#e5e5e5`
- Texto principal: `#0a0a0a`
- Texto secundário: `#525252`
- Accent: `#2563eb` (blue-600)

### Remoções
- Gradiente violeta do body
- Roxo/purple como cor principal
- Cores saturadas

## Tipografia

- **Fonte principal:** Inter (mantém)
- **Código:** Fira Code (apenas em code blocks)
- **Remove:** Source Sans Pro, Ubuntu Mono do uso geral

### Hierarquia
- H1: `text-4xl font-medium tracking-tight`
- H2: `text-2xl font-medium`
- H3: `text-lg font-medium`
- Body: `text-base font-normal` (line-height 1.6)
- Small/meta: `text-sm` cor secundária

### Remoções
- `font-extrabold`
- `uppercase`
- Tamanhos exagerados (`text-7xl`)

## Espaçamento

- Entre seções: `py-24`
- Max-width texto: `max-w-2xl` (672px)
- Max-width container: `max-w-5xl` (1024px)

## Componentes

### Header
- Sticky com `backdrop-blur-sm` no scroll
- Altura: `h-14`
- Layout: `[Avatar 32px + Nome] [Nav links] [Dark toggle + Lang]`
- Links: `text-sm`, hover com underline animado
- Remove: backgrounds coloridos no hover

### Home
```
[py-24]
Hey, I'm Frank ← text-sm secundário
Software Engineer ← h1 text-4xl
[Descrição 1-2 linhas, max-w-xl]
[Links sociais inline, ícones pequenos]
```
- Remove: avatar gigante centralizado, uppercase, emoji bandeira

### Blog
```
[Data] text-sm secundário
[Título] text-lg font-medium link
[Descrição] text-secondary truncado
[Tags] pills neutras
```
- Remove: timeline com círculos, newsletter inline

### About
```
[h1 About]
[Avatar w-20 rounded-lg]
[Bio 2-3 parágrafos]
[Seção Connect - links texto]
```
- Remove: clone do GitHub, contribution graph, badges

### Projects
```
[Nome projeto] → link externo
[Descrição 1-2 linhas]
[Tech stack texto]
```
- Remove: imagens grandes, categorias separadas

### Footer
```
[Linha divisória]
© 2024 · [Twitter] · [GitHub] · [LinkedIn]
```
- Remove: links duplicados, emoji coração, espaçamento excessivo

## Interações

- Transições: `transition-colors duration-200`
- Links: underline no hover
- Focus: `focus-visible:ring-2 ring-blue-500 ring-offset-2`

## Arquivos a Modificar

1. `assets/css/app.css` - cores, variáveis
2. `root.html.heex` - remove gradiente body
3. `header.html.heex` - novo layout
4. `footer.html.heex` - simplificar
5. `home.html.heex` - novo layout
6. `blog_live.ex` - remove timeline
7. `about_live.ex` - remove clone GitHub
8. `projects.ex` - simplificar cards
