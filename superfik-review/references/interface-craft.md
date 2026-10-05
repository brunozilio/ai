# Craft de interface

Referência compartilhada para construir, revisar e aprovar interfaces. Traz o piso que nenhuma tela pode falhar, a ordem de preferência das correções e os princípios de cada domínio com valores exatos. Adaptado das coleções de skills de Jakub Krehel (interfaces.dev) e Emil Kowalski (animations.dev), ambas sob licença MIT; veja `docs/third-party.md` no Superfik.

Como usar: implementando, siga os princípios dos domínios que a tarefa toca. Revisando ou verificando, confira primeiro os gatilhos e depois os princípios. Prototipando, os gatilhos são o piso que toda variante precisa passar antes de entrar no seletor.

Dois hábitos valem para tudo aqui. Escreva cada correção no sistema de estilos do projeto (Tailwind, CSS puro, CSS-in-JS) e com os tokens que ele já tem; nunca imponha outro. E use os valores escritos abaixo, não equivalentes parecidos: `scale(0.96)` não é `scale(0.95)`.

## Gatilhos de escalação (o piso)

Cada item é uma falha independentemente do guia de estilo do projeto. Numa revisão, é **Crítico** à primeira vista, nunca rebaixado porque a tela é secundária. Num protótipo, uma variante que falha um gatilho não é candidata.

- Um controle interativo sem nome acessível.
- Um controle alcançável pelo teclado sem indicador de foco visível.
- Um controle ou caminho alcançável pelo mouse mas não pelo teclado.
- Motion ou conteúdo em reprodução automática que ignora `prefers-reduced-motion`.
- Conteúdo ou controle cortado, sobreposto ou inalcançável a 320px de largura ou 200% de zoom.
- Texto de corpo ou de controle cujo par de contraste renderizado falha a razão exigida.
- Estado ou significado carregado só pela cor.
- Uma ação destrutiva sem confirmação, desfazer ou tratamento distinto.
- Conteúdo truncado sem forma de chegar ao valor completo.
- Conteúdo ou controle alcançável só depois de uma borda de rolagem ou atrás de uma revelação sem pista visível.
- Um erro que não diz como se recuperar dele.
- Uma cor semântica usada contra o seu significado, como o tom de perigo numa ação não destrutiva.
- Uma mudança de estado carregada só por motion, sem cor, ícone ou rótulo quando a animação não roda.

## Prefira a correção mais barata

Quando mais de uma correção resolve, use a primeira que serve:

1. **Apagar.** Um separador que o espaço carregaria, uma animação numa interação frequente, um atributo ARIA que o elemento nativo torna redundante.
2. **Usar a plataforma.** O elemento nativo, o controle nativo, o anel de foco do próprio navegador.
3. **Reaproveitar o que o projeto tem.** Um token, um passo de espaçamento ou uma curva de motion existentes, antes de qualquer valor novo.
4. **Corrigir o valor.** A curva, o raio, o gap ou o par de contraste errados, com o valor exato desta referência.
5. **Acrescentar.** Um token novo, um wrapper, uma media query, um atributo ARIA que a plataforma não fornece.

## Acessibilidade

- **Elementos nativos primeiro.** `<button>` para ações, `<a href>` para navegação, nunca `<div onClick>`. Um link real suporta Cmd/Ctrl e clique do meio. Nenhum ARIA é melhor que ARIA ruim.
- **Foco visível.** Estilize `:focus-visible`, não `:focus`. Prefira o indicador do navegador. Um anel customizado tem pelo menos `2px` sólidos, verificado contra toda cor adjacente. Nunca `outline: none` sem substituto verificado.
- **Teclado completo.** Escape fecha overlays, setas movem dentro de widgets compostos, Tab move entre widgets, Enter e Espaço ativam. Só `tabindex="0"` e `tabindex="-1"`; valores positivos quebram a ordem.
- **Modais.** `inert` no conteúdo de fundo, foco entra ao abrir e volta ao gatilho ao fechar, `overscroll-behavior: contain`.
- **Área de toque.** Mínimo 24×24px CSS (WCAG 2.5.8). Mire 44×44px no toque e 40×40px no desktop. Estenda com pseudo-elemento quando o visual deve ficar menor; áreas estendidas nunca se sobrepõem.
- **Rótulo em todo controle.** `<label for>` ou `<label>` envolvendo. Placeholder nunca é rótulo. Botão só com ícone leva `aria-label` descritivo. Decorativos levam `aria-hidden="true"`, nunca num elemento focável.
- **Formulários.** `autocomplete`, `type` e `inputmode` corretos. Nunca bloqueie colar. Submit fica habilitado até o envio começar; valide no envio, marque `aria-invalid="true"`, aponte `aria-describedby` para o erro e foque o primeiro campo inválido.
- **Cor nunca sozinha.** Status leva ícone, texto ou sublinhado além da cor.
- **Motion opcional.** Envolva motion em `@media (prefers-reduced-motion: no-preference)`. Sob redução, troque deslocamentos e escalas por crossfade de opacidade e elimine parallax e autoplay. Mídia em autoplay precisa de pausa visível; toasts com ação ou erro ficam até serem dispensados.
- **Conteúdo dinâmico.** `role="status"` (polite) para atualizações não urgentes como toasts e contagens; `role="alert"` só para erros urgentes. Região polite repetida precisa existir vazia antes de o texto mudar.
- **Estrutura.** Um `<h1>`, níveis sem pular, um `<main>`, link "Pular para o conteúdo" como primeiro focável quando há navegação repetida antes.
- **Zoom.** A página funciona a 200% de zoom e reflui a 320px sem rolagem horizontal. `min-height` em vez de `height` em contêineres de texto; a meta viewport nunca limita o zoom.

## Layout

- **Agrupe com espaço, não com linhas.** Espaço primeiro, formas de fundo depois, separadores por último. O gap entre grupos é pelo menos 2× o gap interno (`8px` dentro, `16px`+ entre).
- **Controles distintos do conteúdo.** Todo elemento interativo tem forma de fundo, borda ou zona de posicionamento consistente.
- **Bordas alinhadas.** Escolha as bordas de alinhamento e mantenha. Um passo de espaçamento do projeto por nível de subordinação; `16px` é um padrão útil.
- **Propriedades lógicas.** `padding-inline-start`, `margin-inline-end`. Esquerda e direita físicas só para geometria física.
- **Ordem por importância.** O mais importante perto do topo e da borda inicial. Pense em início e fim, não em esquerda e direita.
- **Pista para o oculto.** Revelação progressiva precisa de affordance visível: a pista do projeto, o próximo item espiando `16–32px` além da borda de rolagem, ou um controle de revelação.
- **Respiro entre alvos.** Sem sistema de densidade, `12px` entre controles com borda ou preenchimento e `24px` em volta de controles só com texto ou ícone.
- **Botões dentro das margens.** Botões de largura total ficam dentro das margens do layout com raio visível, a partir de `16px` no mobile.
- **Conteúdo sangra, controles flutuam.** Fundos e mídia vão até a borda; controles e texto respeitam margens e `env(safe-area-inset-*)`.
- **Breakpoints vêm do conteúdo.** Mantenha o layout expandido enquanto cabe e colapse tarde. Prefira container queries; teste o menor e o maior tamanho primeiro.
- **Texto cresce.** Strings traduzidas crescem, e as curtas crescem mais. Nenhuma largura ou altura fixa num contêiner de texto. Nunca deixe uma ação crítica onde redimensionar ou rolar a corta.

## Texto da interface

- **Reconheça a voz.** Leia o texto ao redor antes de escrever: terminologia, convenções de localização, guia de voz. Uma voz de marca deliberada não é defeito.
- **Uma voz, tom pelo risco.** Sucesso e estados vazios podem ser calorosos; ações rotineiras são neutras; erros e confirmações destrutivas são calmos e sem brincadeira; perda de dados e segurança são sérios e explícitos. Se é "Arquivar" no menu, não é "Mover para o armazenamento" no toast.
- **Fale com o leitor.** "você", não "o usuário". Em erros, evite "nós": "Não foi possível carregar" em vez de "Estamos com problemas para carregar".
- **Palavras simples.** Nada de expressões idiomáticas, gírias ou humor que não traduz. "Tocar" no toque, "clicar" com ponteiro, "selecionar" quando os dois servem. Nunca monte frases com fragmentos em volta de uma variável; use uma string completa com plural correto.
- **Botões começam com verbo.** "Enviar", "Salvar rascunho", "Excluir projeto". Nunca "OK!" ou "Sim"/"Não" numa ação com consequência. A confirmação repete a consequência: "Excluir este projeto?" oferece `Excluir projeto` e `Cancelar`.
- **Vocabulário consistente no fluxo.** "Começar" para entrar, "Continuar" ou "Próximo" (um só) para avançar, "Concluir" para terminar.
- **Links descrevem o destino.** "Leia a documentação de cobrança", nunca "clique aqui". Dois "Saiba mais" na mesma página precisam de sufixo.
- **Uma política de capitalização.** Sentence case é o padrão mais seguro. "Salvar Alterações" ao lado de "Descartar alterações" parece descuido.
- **Toggles descrevem o estado ligado.** "Enviar confirmações de leitura", nunca a negativa.
- **Erros dizem como corrigir, ao lado do campo.** "Escolha uma senha com pelo menos 8 caracteres", não "Senha muito curta". Sem culpa, sem "ops", sem exclamação. Quando o mesmo erro se repete, redesenhe a interação.
- **Estados vazios apontam para a frente.** Dizem o que o lugar é, como preenchê-lo e oferecem uma ação. Busca vazia nomeia a consulta e oferece saída: "Nenhum resultado para 'trimestral'. Limpar filtros".
- **Placeholders são exemplos.** `nome@exemplo.com`, `DD/MM/AAAA`. Todo campo mantém um rótulo visível.

## Tipografia

- **Propriedades em vez de tags brutas.** `font-weight: 650`, `font-optical-sizing: auto`, `font-variant-numeric: tabular-nums`. Tags brutas só para eixos customizados.
- **Carregue os pesos reais.** O navegador sintetiza pesos e estilos que a família não tem e distorce a face. Carregue o que o design usa.
- **Poucas fontes, tamanhos e pesos.** Raramente mais de três fontes. Abaixo de `18px`, peso `400` ou mais; pesos abaixo de `300` são só para display a `28px`+.
- **Escala com nomes semânticos.** Um conjunto pequeno de tamanhos, nomeados pelo uso em times (`text-body-sm`). Títulos descem com o nível; um filho nunca supera o pai.
- **Line-height pelo papel.** Títulos em torno de `1.1`; corpo `1.5` a `1.6`; sem unidade. Qualquer texto que quebra em três ou mais linhas usa pelo menos `1.4`.
- **Letter-spacing pelo tamanho.** Levemente negativo em títulos grandes, levemente positivo em rótulos pequenos em maiúsculas, nenhum no corpo.
- **Medida.** Texto longo entre 60 e 75 caracteres por linha.
- **Quebra deliberada.** `text-wrap: balance` em títulos, `text-wrap: pretty` em descrições, `overflow-wrap: break-word` onde um link ou ID pode escapar, `white-space: nowrap` em rótulos e badges.
- **Números tabulares** em todo valor que muda: contadores, preços, timers.
- **Truncar sem perder.** `text-overflow: ellipsis` numa linha, `line-clamp` em várias, e o valor completo alcançável num tooltip ou expansão.
- **Texto natural, estilo no CSS.** `text-transform` em vez de reescrever o texto. Aspas curvas na prosa, travessão en dash em intervalos, o caractere de reticências.
- **Inputs a 16px no mobile.** O iOS Safari dá zoom na página com texto menor. Aumente no mobile (`text-base sm:text-sm`) ou compense com `transform: scale()`.
- **Pisos de tamanho.** Corpo começa em `16px`; UI em `14px` para inputs e menus, `13px` em legendas, raramente abaixo de `12px`.
- **Suavização no root.** `-webkit-font-smoothing: antialiased` e `-moz-osx-font-smoothing: grayscale` uma vez no layout raiz.
- **Idioma.** `lang` no documento, `dir` onde a direção muda, `<bdi>` em valores de direção mista. Texto permanece selecionável; `user-select: none` só em superfícies de arrastar.

## Cores

- **Siga o sistema do projeto.** Reaproveite tokens e notação. Um `oklch()` isolado num código em hex atrapalha mais do que ajuda. Para um sistema novo, `oklch()` é o melhor padrão.
- **Um sistema é rampas.** Uma rampa neutra, uma de acento e só as rampas de status que o produto renderiza. Cada passo existe porque um papel precisa dele: fundo da página, hover, borda, preenchimento sólido, texto.
- **Primitivos por matiz, semânticos por papel.** `--blue-500` nunca aparece num componente; `--color-text-secondary` aponta para ele e é o único nível que componentes usam. É isso que torna o tema escuro possível.
- **Token só no papel dele.** Nunca empreste um token porque o valor serve hoje. Se falta um papel, crie o token.
- **Uma cor, um significado.** Qualquer matiz a menos de `15°` é a mesma cor. Se o acento significa interativo, texto estático nesse matiz pede clique.
- **Um preenchimento de ação por tela.** Uma ação primária leva a cor de fundo; as vizinhas ficam neutras. Cor no fundo, não no rótulo.
- **Meça o par renderizado.** Primeiro plano contra o fundo real em que renderiza, nos dois temas. Um par que falha é relatado com o valor medido e o limite; as cores são decisão de design e só mudam quando pedido.
- **Gradientes** em `in oklab` por padrão; `in oklch` quando um gradiente de dois matizes fica cinza no meio.

## Polimento e motion

- **Raio concêntrico.** Raio externo = raio interno + padding. Raios desencontrados em elementos aninhados são o erro mais comum.
- **Alinhamento óptico.** Ícones assimétricos e triângulos de play precisam de ajuste manual quando o centro geométrico parece errado.
- **Sombras para elevação, bordas para estrutura.** Troque bordas que só criam profundidade por `box-shadow` em camadas transparentes. Mantenha bordas que comunicam estrutura ou estado.
- **Transições para estados, keyframes para sequências.** Transições são interrompíveis; use-as em tudo que o usuário dispara rápido (toasts, toggles). Keyframes só em sequências que rodam uma vez.
- **Entradas e saídas.** Escalone entradas raras em ~100ms por bloco semântico; interações frequentes não escalonam. Saídas são mais sutis que entradas, com `translateY` pequeno e fixo. `ease-out` nos dois sentidos; `ease-in` nunca em UI.
- **Nunca `scale(0)`.** Parta de `scale(0.95)` com `opacity: 0`. Nada no mundo real aparece do nada.
- **Ícones.** Anime com `opacity`, `scale` e `blur`: escala `0.25` a `1`, opacidade `0` a `1`, blur `4px` a `0px`. Com `motion` ou `framer-motion` no projeto, `transition: { type: "spring", duration: 0.3, bounce: 0 }`. Sem biblioteca, os dois ícones no DOM, um absoluto, crossfade com `cubic-bezier(0.2, 0, 0, 1)`. Ícones usam `currentColor` e tomam estados do CSS; contorno é o padrão, preenchido marca o ativo. Traço `1.5px` ao lado de texto `400`, `2px` ao lado de `600`.
- **Pressionar.** `scale(0.96)` no clique, nunca abaixo de `0.95`. Transição de `100–160ms`.
- **Durações.** Tooltips e popovers pequenos `125–200ms`; dropdowns `150–250ms`; modais e drawers `200–500ms`. UI fica abaixo de `300ms`.
- **Origem.** Popovers, dropdowns e tooltips escalam a partir do gatilho (`transform-origin`). Modais ficam centrados.
- **Só `transform` e `opacity`.** `width`, `height`, `margin`, `padding`, `top` e `left` disparam layout. `height` é tolerado só em acordeões.
- **Contorno de imagem.** `1px` a 10% de opacidade: `oklch(0 0 0 / 0.1)` no claro, `oklch(1 0 0 / 0.1)` no escuro. Nunca um cinza tingido.
- **Primeiro render sem animação.** `initial={false}` no `AnimatePresence`. Na troca de tema, injete `*,*::before,*::after{transition:none !important}`, force um reflow e remova no próximo frame.
- **Transicione só o que muda.** `transition-property: scale, opacity`; nunca `all`. `will-change` só para `transform`, `opacity` e `filter`, e só diante de engasgo no primeiro frame.
- **Hover só onde existe.** Motion de hover dentro de `@media (hover: hover) and (pointer: fine)`.
- **Restrição.** Interações de alta frequência recebem feedback instantâneo ou `150ms` ou menos em opacidade e cor. Ações iniciadas pelo teclado não animam. Toda mudança de estado animada tem também uma pista estática.

## Antes de terminar

| Erro | Correção |
|---|---|
| Botão só com ícone sem `aria-label` | Acrescente o nome; esconda o ícone da árvore de acessibilidade |
| Hover preso depois de um toque | `@media (hover: hover)` |
| Submit desabilitado até o formulário ficar válido | Habilitado; valide no envio e foque o primeiro erro |
| `margin-left` num layout localizável | `margin-inline-start` |
| Breakpoints em 768/1024 por padrão | Quebre onde o conteúdo para de caber |
| Largura fixa num contêiner de texto | `max-width` e quebra de linha |
| "Clique aqui" ou "Saiba mais" solto | Link que descreve o destino |
| Erro sem instrução de correção | Diga o que fazer, ao lado do campo |
| `leading-none` numa descrição de três linhas | Pelo menos `1.4` |
| Peso fino em texto de `14px` | `400` ou mais abaixo de `18px` |
| Primitivo `--blue-500` num componente | Token semântico apontando para ele |
| Contraste corrigido mudando o matiz | Mude a luminosidade |
| `transition: all` | Propriedades exatas |
| Entrada com `scale(0)` ou `ease-in` | `scale(0.95)` + opacidade, `ease-out` |
| Popover com `transform-origin: center` | Origem no gatilho; modais ficam centrados |
| Raios aninhados desencontrados | Externo = interno + padding |

## Relato de achados de interface

Numa revisão ou verificação, cada achado cita `arquivo:linha`, mostra o antes e o depois no idioma do projeto e nomeia o princípio e o impacto no usuário. Uma causa raiz é um achado: liste todos os locais na mesma linha em vez de uma linha por ocorrência.

Severidade: um gatilho de escalação confirmado é **Crítico**. Um dano claro à compreensão, à eficiência ou à consistência é **Grave**. Polimento isolado é **Menor**. Dentro de uma severidade, o que alcança mais lugares vem primeiro: um token ou componente compartilhado vale mais que o mesmo sintoma numa folha.

Nunca relate um achado visual só pelo código quando o comportamento em runtime decide, nem um achado de código só pela aparência. O que você não conseguiu verificar é **Não verificado**, nunca um achado.
