# Patterns and where they already exist in web/

The platform's CSS modules are copied unchanged into `web/src/app/`. Reuse their classes before writing new ones; a new
class is a sign that the design is drifting.

| Pattern | Use these classes | Notes |
| --- | --- | --- |
| Floating menu | `composer.module.css` `.dropdown`, `.dropdownGroup`, `.dropdownLabel`, `.dropdownItem`, `.dropdownText` | Items that are `<button>` need `text-align: left` (`map.module.css .menuButton`). Register the open state with `useLayer` so Escape closes the menu first. |
| Context menu | `workspace.module.css` `.contextMenu` | Danger item last, after `<hr>`, with `data-danger`. |
| Toolbox chip | `workspace.module.css` `.toolbox`, `.me`, `.avatar`, `.toolDivider` | The account chip is the workspace switcher. |
| Card on canvas | `workspace.module.css` `.territory`, `.deckCard`, `.notice` | 20px radius, 1px outline. |
| Settings shell | `settings.module.css` `.head`, `.menu`, `.menuItem`, `.body`, `.scroll`, `.pageSection`, `.title`, `.lead`, `.card`, `.row`, `.rowText`, `.rowLabel`, `.rowHint`, `.rowControl`, `.field`, `.person*` | Rows are `label + hint | control`. |
| Page with header | `agent-page.module.css` `.page`, `.head`, `.identity`, `.body`, `.activity`, `.group`, `.label`, `.item`, `.row[data-status]` | Status rows: `needs-you`, `running`, `delivered`, `failed`. |
| Area up close | `area.module.css` `.head`, `.title`, `.body`, `.label`, `.card`, `.cardHead`, `.tasks`, `.task[data-status]`, `.flow` | |
| Lists of apps/agents | `store.module.css` `.search`, `.segmented`, `.list`, `.item`, `.row`, `.rowText`, `.connect`, `.connected`, `.state` | Two columns from 760px. |
| Buttons | `ui.module.css` `.primary`, `.secondary`, `.iconButton`, `.link` | 30px tall, radius 9px. |
| Marks | `ui.tsx` `AgentFace`, `AreaBadge`, `AppIcon`, `Spinner` | Pastel tile + filled glyph. |
| Working / shimmer | `Signals.tsx` `Shimmer`, `Orb`, `Skeleton` | |

## Menu anatomy (from `menu-dropdown.png`)

- Card 300px wide, radius ≈ 18px, white, shadow soft and wide, padding 8px.
- Item: 44px tall at Rico's 1.25× zoom (≈ 36px at 1×), icon 18px at the left, 8px gap, label 15px (≈ 14px at 1×).
- Hover: `#F3F3F3`-like fill, radius 10px, no border.
- Icons are outlined, dark grey, except brand icons (Zapier, Drive) in their own colour.
- Final item "··· More" uses the same row, muted.

## Sidebar / switcher anatomy (from `sidebar-list.jpg`)

- Top: square tile 24px (radius 6px) + "Acme Inc" 14px medium + toggle icon at the far right.
- Workspace card under it: avatar 28px, name 14px, "30 MEMBERS" 11px uppercase muted, caret at the right.
- Nav items 32px, icon 16px, label 14px; active = soft fill.
- Section label ("Inbox ⌄") 12.5px muted with a "+" at the right. Count pills 18px, red for unread.
- Conversation rows: avatar 24px with a status dot, name 14px medium, one muted line clamped, time at the right, and up
  to two small uppercase tags under it. Nothing else.

## Things Rico never does

- Centre-aligned menu items or buttons stretched to the card width inside a menu.
- Two actions of equal weight side by side; one is primary, the other a quiet link or ghost.
- Explanatory text under a heading ("Uma rotina inteira em um clique").
- Cards with three rows of metadata; he keeps one and moves the rest.
- Decorative gradients, glows or iridescent effects inside product UI (the brand mark is the only exception).
- Full-width destructive buttons.
