---
name: heyrico-design
description: Superfik's visual and copy standard, modelled on Rico (@_heyrico, acedesign.io). Use whenever you create, change or review anything a person sees in web/ — a screen, component, menu, list, form, empty state, notice, or any text on screen. Also use when asked to "limpar", "simplificar", "ficou poluído", or to make something "igual ao Rico".
---

# Rico's standard for Superfik

Rico's interfaces look calm because almost everything was removed. The rule is subtraction: a screen is done when nothing
else can be taken out. Bruno called screens with subtitles, counts, badges and three-line rows "poluídas"; this skill
exists so that never happens again.

## Before you add anything

Ask, in this order. If the answer is no, do not add it.

1. Does a lay user need it to act right now? (Not "is it true", not "is it useful someday".)
2. Can it live on the detail page, in a tooltip, or nowhere?
3. Is it already said by an icon, a colour or the position on screen?

Prefer removing over styling. Prefer one line over two. Prefer a word over a sentence.

## Measurements (Rico's own cheat sheet, plus the platform tokens we copied)

- Type: Inter. Body 14/20 regular. Labels and secondary lines 13/16 (`--text-muted`, `#777`-ish). Titles 16/20 medium
  inside cards, 22 semibold for a page title. Numbers that change: `font-variant-numeric: tabular-nums`.
- Text colour `#333` (`--text`); secondary `#777` (`--text-muted`); faint `--text-subtle`. Never pure black on white.
- Controls: buttons 30–32px tall, radius 9–10px. Inputs 36px, radius 8px, soft fill, 1.5px dark ring on focus.
- Rows: 40px for data, 44px when they hold an avatar; one hairline (`--line`) between rows, never boxes inside boxes.
- Cards: radius 12px for settings cards, 14px for notices, 20px for the big panels; outline `0 0 0 1px var(--line)`,
  no drop shadow unless it floats (menus: `0 14px 40px rgb(var(--shade) / 0.18)`).
- Badge: 20px tall, radius 6px, tinted fill + darker text of the same hue (`#CAFACE` + `#15B042` for "on").
- Switch 24×14, blue track `#0077E6`.
- Icons: Phosphor, 14–16px inside controls, `weight="fill"` for marks, regular for actions. One accent per state.
- Space: 8px between related things, 12px between siblings, 24–36px between sections. Whitespace is the hierarchy.

## Components, the way Rico does them

- **Menu / dropdown** (see `references/menu-dropdown.png`): white card, radius 16–20px, padding 6–8px, items 36–40px with
  a 16px icon then a 14px label, **left-aligned**, hover = soft grey rounded 10px. Selected item: check at the far right.
  A section label is 12.5px muted. Last item can be "··· Mais". Never centre text in a menu.
- **Workspace switcher**: a small square tile (logo or initial, radius 30%) + name + caret. The open menu lists
  workspaces with the same tile, the current one checked, then "Nova organização", a divider, then account actions.
- **List row**: `[icon or avatar] [title] …………… [one fact] [chevron]`. One optional muted line under the title. Status
  is a small coloured mark on the left, not a sentence. Counts go in a 20px pill at the right.
- **Score / progress**: a row of 10–12 small segments (5×12px, radius 2px) coloured up to the value, with the number
  beside it in tabular figures. No gauge, no chart.
- **Settings**: page title 22px, pages as a flat tab strip, then cards of rows `label + hint | control`. The control sits
  at the right (320px field, select or switch). Save on blur/Enter or with one small "Salvar" beside the field; show
  "Salvo" quietly for a moment. No big forms.
- **Composer**: a soft outer strip saying who gets the request, a white card with the field and a round send button.
- **Agent / area mark**: pastel tile with a filled glyph (radius 30% of size). Working = small spinner badge; waiting
  for a person = orange count badge.
- **Empty state**: one sentence, muted, where the content would be. Optionally one quiet action. No illustration.
- **Notice / error**: one line, at the top, with a close. Say what failed and what to do: "Não foi possível mover
  Cobrança. Tente de novo."

## Copy (pt-BR)

- Short, concrete, in the user's words. "Esperando você", not "Decisões pendentes de aprovação".
- Button = the verb alone: "Aprovar", "Ativar", "Instalar", "Salvar". No explanation on the button or under it.
- Times and effort as facts: "há 2 h", "~1,5 h por semana", "Trabalhou por 1m 28s".
- One idea per line. If a line needs a comma, try two lines or cut it.
- Titles name the thing ("Mercado", "Financeiro", "Configurações"); no paragraph under a title.
- Numbers only when the person decides with them. "2,1 mil instalações" belongs on the detail page, not the list.
- Never say "Superfik" in a sentence where "ele" or nothing would do.

## Checklist before showing a screen

- [ ] Every list row fits one line plus at most one muted line.
- [ ] No element exists only to look complete (counts, subtitles under headings, decorative icons, "+N" labels).
- [ ] Every button is a single verb; destructive ones are quiet until hovered or confirmed.
- [ ] Menus are left-aligned, with icons, and close on Escape and outside click.
- [ ] At 1280×720 nothing wraps awkwardly; at 390 wide nothing overlaps.
- [ ] Escape goes one level up; Enter submits; the first interactive element has focus when a form opens.
- [ ] Compare against the platform screen it mirrors (`~/Documents/platform/apps/web`) and against `references/`.

## References

- `references/menu-dropdown.png`: Rico's attach menu (card, icon + label, hover, "More").
- `references/sidebar-list.jpg`: workspace tile + name, sidebar sections with count pills, conversation rows.
- Rico's tokens: https://x.com/_heyrico/status/2105335372821790941 (type, buttons, rows, badge, switch, text colours).
- His work: https://x.com/_heyrico/media · https://collectui.com/designers/_heyrico · https://acedesign.io
- `references/patterns.md`: longer notes on each component with the platform classes that already implement them.
