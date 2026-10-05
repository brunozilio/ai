# O seletor de variantes

O controle que troca as variantes. A aparência dele não é uma decisão de design, porque ele fica em cima da coisa que está sendo julgada. Construa a especificação abaixo e deixe-a em paz. Adaptado dos seletores de Emil Kowalski e Jakub Krehel (MIT).

## Deliberadamente fora do sistema de design

Nunca estilize o seletor com os tokens, fontes ou cores do projeto. Um seletor que parece nativo do produto vira parte do que você está olhando, e aí você está julgando o harness.

Uma superfície escura neutra, a pilha de fontes do sistema e nenhuma variável do projeto. Escuro lê como chrome sobre páginas claras e escuras, e por isso ele não segue o tema.

## Comportamento

- Ele grava um parâmetro `variant` na URL e lê a variante ativa de volta dele. A URL é a fonte da verdade, e cada variante é um link que dá para mandar para alguém.
- Teclas numéricas `1` a `N` e as setas `←`/`→` trocam a variante; `R` repete a animação de entrada. Ignore teclas quando o foco está num input, textarea, select ou `contenteditable`, ou quando há modificador pressionado.
- Exatamente um item carrega `aria-current="true"` o tempo todo, e o contêiner carrega um rótulo.
- A troca é instantânea. Trocar é a ação mais frequente da rodada, então ela não ganha transição.
- Trocar remonta a variante, para animações de entrada rodarem de novo. Repetir remonta sem trocar.
- Sobrevive a um redimensionamento: dá para segurar uma variante e arrastar a janela em vez de recarregar por largura.

## Estrutura

Um botão por variante, na ordem em que foram nomeadas. Acrescente o botão de repetir, com o divisor, só quando alguma variante tem uma entrada que vale a pena disparar de novo.

```html
<nav class="variant-picker" aria-label="Variantes">
  <button type="button" data-variant="quieta" aria-current="true">Quieta</button>
  <button type="button" data-variant="editorial">Editorial</button>
  <button type="button" data-variant="densa">Densa</button>
  <span class="variant-picker-divider" aria-hidden="true"></span>
  <button type="button" class="variant-picker-replay" aria-label="Repetir animação (R)">↻</button>
</nav>
```

Num framework, mantenha os nomes de classe e a estrutura e mude só a sintaxe de renderização.

## Posição e estilo

Fixo, embaixo no centro, acima de tudo que a página empilha. Fora do caminho da peça em julgamento. Quando as variantes vivem na parte de baixo da viewport (um toast, uma bottom sheet, um dock), use `data-position="top"` e diga isso. Nada mais nele muda.

```css
.variant-picker {
  position: fixed;
  bottom: 24px;
  left: 50%;
  translate: -50% 0;
  z-index: 2147483647;
  display: flex;
  align-items: center;
  gap: 2px;
  padding: 4px;
  border-radius: 999px;
  background: rgb(20 20 20 / 0.9);
  box-shadow: inset 0 0 0 1px rgb(255 255 255 / 0.1), 0 8px 24px rgb(0 0 0 / 0.25);
  font: 13px/1 -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  user-select: none;
}

.variant-picker[data-position="top"] {
  bottom: auto;
  top: 24px;
}

.variant-picker button {
  height: 28px;
  padding: 0 14px;
  border: 0;
  border-radius: 999px;
  background: none;
  color: rgb(255 255 255 / 0.6);
  font: inherit;
  cursor: pointer;
}

.variant-picker button:hover {
  color: rgb(255 255 255 / 0.85);
}

.variant-picker button[aria-current="true"] {
  background: rgb(255 255 255 / 0.14);
  color: rgb(255 255 255);
}

.variant-picker button:focus-visible {
  outline: 2px solid rgb(255 255 255 / 0.7);
  outline-offset: 2px;
}

.variant-picker-divider {
  width: 1px;
  height: 16px;
  margin: 0 4px;
  background: rgb(255 255 255 / 0.12);
}

.variant-picker-replay {
  padding: 0 10px;
  font-size: 14px;
}
```

## Ligação de referência

Literal para o HTML autocontido. Num framework, mantenha o mesmo comportamento e escreva do jeito idiomático: estado em vez de `innerHTML`, remontagem por `key` em vez de `requestAnimationFrame`.

```js
// `variants` mapeia o slug de cada variante a uma função que renderiza o HTML dela, na ordem do seletor.
const stage = document.getElementById('stage');
const picker = document.querySelector('.variant-picker');
const items = [...picker.querySelectorAll('button[data-variant]')];
const replay = picker.querySelector('.variant-picker-replay');
const slugs = items.map((el) => el.dataset.variant);
let current = slugs[0];

function mount(slug) {
  stage.innerHTML = '';
  // Limpa primeiro e renderiza no próximo frame, para a entrada rodar de novo.
  requestAnimationFrame(() => { stage.innerHTML = variants[slug](); });
}

function setActive(slug) {
  if (!variants[slug]) return;
  current = slug;
  items.forEach((el) => {
    if (el.dataset.variant === slug) el.setAttribute('aria-current', 'true');
    else el.removeAttribute('aria-current');
  });
  const url = new URL(location);
  url.searchParams.set('variant', slug);
  history.replaceState(null, '', url);
  mount(slug);
}

items.forEach((el) => el.addEventListener('click', () => setActive(el.dataset.variant)));
replay?.addEventListener('click', () => mount(current));

document.addEventListener('keydown', (e) => {
  if (/^(INPUT|TEXTAREA|SELECT)$/.test(e.target.tagName) || e.target.isContentEditable) return;
  if (e.metaKey || e.ctrlKey || e.altKey) return;
  const i = slugs.indexOf(current);
  const num = parseInt(e.key, 10);
  if (num >= 1 && num <= slugs.length) setActive(slugs[num - 1]);
  else if (e.key === 'ArrowRight') setActive(slugs[(i + 1) % slugs.length]);
  else if (e.key === 'ArrowLeft') setActive(slugs[(i - 1 + slugs.length) % slugs.length]);
  else if (e.key === 'r' || e.key === 'R') mount(current);
});

setActive(new URLSearchParams(location.search).get('variant') || slugs[0]);
```
