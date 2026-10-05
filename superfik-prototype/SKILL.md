---
name: superfik-prototype
description: Constrói duas ou três variantes genuinamente diferentes de uma peça de interface do PRD, cada uma numa direção nomeada, atrás de um seletor na página real, para o usuário comparar ao vivo e aprovar uma antes do plano. A aprovação entra no PRD e vira referência para o plano e a implementação. Invoque com o projeto ou a descrição da peça, "riff <variante>" para outra rodada ou "keep <variante>" para aprovar.
argument-hint: "[projeto | descrição da peça | riff <variante> | keep <variante>]"
disable-model-invocation: true
metadata:
  superfik-version: "1.0.0"
---

# Prototipar para aprovar

Pegue uma peça de interface do PRD, construa três versões que diferem de propósito e ponha-as atrás de um seletor na página que vai contê-las. O usuário compara ao vivo e aprova uma. A escolha entra no PRD, o código da variante aprovada fica guardado como referência, e o `/superfik-plan` planeja a partir dela.

Todos os outros skills julgam. Este produz candidatas e devolve a decisão. Ele não revisa UI existente (isso é o `/superfik-review` com o critério Interface) e não implementa a versão final (isso é o `/superfik-implement`).

Converse com o usuário e escreva os documentos em português do Brasil. Nomes de variantes, slugs e caminhos ficam como estão.

## Invocação

| Argumento | Comportamento |
|---|---|
| nenhum ou `<projeto>` | Fluxo completo a partir do PRD do projeto: peça, terreno, três variantes, seletor, espera a escolha |
| `<descrição da peça>` | O mesmo, sem PRD; o projeto recebe um nome derivado da descrição |
| `<...> x5` | A mesma coisa com até cinco variantes |
| `riff <variante>` | Nova rodada: mantém o harness e gera um conjunto novo em volta da direção dessa variante |
| `keep <variante>` | Aprova a variante: registra no PRD, guarda a referência e apaga o harness |
| `keep <variante>, manter o seletor` | Aprova, mas deixa o harness no lugar |

## 1. Escolha a peça

Procure `.superfik/outputs/<project>/prd.md`. Se houver vários projetos, pergunte qual. Com um PRD, leia os requisitos e o contexto técnico e liste as peças de interface que ele implica. Sem PRD, parta da descrição e diga o nome de projeto que vai usar.

Uma peça por rodada. "O dashboard" não é uma peça; o card de métrica é. Quando o pedido abrange várias, escolha a de que as outras dependem, diga por quê e ofereça as demais como rodadas seguintes. Se já existe um `prototype.md` com uma variante aprovada para essa peça, diga isso e pergunte se é outra peça ou uma nova rodada.

Reescreva o pedido numa frase: o que a peça é, onde renderiza e o que precisa fazer. Nomeie os requisitos (`R1`, `R3`) que ela atende.

## 2. Conheça o terreno

As variantes precisam parecer que poderiam ir para produção amanhã, então leia onde vão pisar:

- O sistema de estilos, a biblioteca de componentes e a biblioteca de motion, se houver.
- Os tokens: cor, espaçamento, raio, escala tipográfica, curvas.
- A densidade e a voz do produto. Uma ferramenta profissional densa limita até onde a variante mais ousada pode ir.
- Onde a peça renderiza: contra que fundo, ao lado de que vizinhos, em que larguras.
- Como o projeto sobe um servidor de desenvolvimento e como adiciona uma rota ou página.

Sem projeto para ler, use cinzas neutros, um acento e a pilha de fontes do sistema, e diga que foi isso que fez.

## 3. Nomeie o eixo antes de escrever código

Três variantes por padrão. Vá a cinco só quando pedido, ou quando o espaço de soluções é genuinamente largo. Acima disso ninguém compara, só rola.

Três variantes que diferem na cor de acento não ensinam nada. Cada variante é uma resposta diferente ao mesmo pedido, num eixo:

| Eixo | O que varia |
|---|---|
| Estrutura | Agrupamento, ordem, número de colunas, o que colapsa |
| Densidade | Escala de espaçamento, áreas de toque, quanto cabe |
| Ênfase | Onde vai a cor preenchida, o que recua |
| Tipo | Passos da escala, contraste de peso, medida |
| Voz | Rótulos, tom, quantidade de texto |
| Interação | Fluxo em passos ou numa tela, revelação progressiva, modelo de edição |

Escolha **um eixo primário** e dê a cada variante uma posição diferente nele. As escolhas secundárias decorrem dele em vez de variar por conta própria. Uma variante densa pode precisar de um passo tipográfico menor, e isso é coerência, não um segundo eixo. Variar tudo de uma vez produz três resultados que não dá para atribuir: o usuário aprende qual gostou, não o que fez funcionar.

Escreva o conjunto antes do código: um nome e uma posição no eixo para cada. Nomes dizem a direção (`Quieta`, `Editorial`, `Densa`), nunca `Opção A`. Este passo termina quando nenhuma dupla divide uma posição e você consegue dizer o eixo de cada uma numa frase.

**O piso que toda variante passa.** Antes de entrar no seletor, cada variante passa pelos gatilhos de escalação de [references/interface-craft.md](references/interface-craft.md): todo controle tem nome acessível, o teclado alcança tudo que o mouse alcança, o foco é visível, nada corta a 320px e nenhum significado depende só da cor. Esse piso é igual para todas, não é um eixo e nunca se troca por um. Onde uma direção só funciona quebrando o piso, diga isso e descarte a direção.

## 4. Construa na página real

Uma variante parece boa isolada, e é por isso que isolamento é o lugar errado para julgá-la. Hospede as variantes na página que vai conter a peça, com o chrome real, os vizinhos reais e dados realistas.

- **Num projeto com servidor de desenvolvimento**: uma rota ou página isolada (`/prototypes/<project>`, ou o equivalente do framework), um arquivo por variante mais um arquivo de harness. Nada do harness importa de produção além do que a página real já usa, e produção nunca importa do harness. O código de produção não muda nesta etapa.
- **Sem página que possa hospedar**: um único HTML autocontido em `.superfik/outputs/<project>/prototype/index.html`, com o mesmo seletor.

A variante ativa vem do parâmetro `?variant=<slug>` na URL, para que cada variante seja um link. O seletor flutuante segue a especificação de [references/picker.md](references/picker.md), sem adaptação ao projeto. Renderize uma variante por vez, em tamanho real. Miniaturas distorcem espaçamento e escala, e espaçamento costuma ser justamente o que se está escolhendo.

Dê conteúdo real a cada variante: texto com cara de produto, nomes plausíveis e a quantidade de itens que a página vai carregar de verdade. Lorem ipsum e três linhas deixam qualquer estrutura bonita. Toda interação funciona e todo motion segue os valores de `references/interface-craft.md`.

Trabalhe no branch atual: o harness é descartável e fica listado no `prototype.md` para ser apagado. Não faça commit dele, a menos que o usuário peça.

## 5. Apresente as trocas e pare

Passe por todas as variantes antes do usuário. Cada uma renderiza, cada interação responde e o console está limpo. Com ferramentas de navegador disponíveis, tire uma captura de cada uma.

Escreva `.superfik/outputs/<project>/prototype.md`:

```markdown
---
project: <project-name>
piece: <nome da peça>
requirements: [R1, R3]
status: pending | approved
created: <ISO 8601>
---

# Protótipo: <peça>

**Pedido:** <a frase do passo 1>
**Terreno:** <stack, tokens e densidade encontrados>
**Onde ver:** <URL ou caminho> · teclas 1–N, ←/→ e R · julgado a <largura>px
**Harness:** <lista de arquivos a apagar>

| Variante | Posição no eixo <eixo> | Certa quando | Custa |
|---|---|---|---|
| Quieta | Menor peso visual | A página é usada todo dia | A menos memorável |
| Editorial | Maior tipo, mais espaço | O momento merece peso | Come espaço vertical |
```

Depois entregue a decisão. Diga onde o seletor está rodando, que teclas trocam e em que largura você julgou; a resposta pode mudar entre 375px e 1440px. Peça a escolha com a ferramenta de múltipla escolha, se houver (`AskUserQuestion` no Claude Code; `request_user_input` no Codex em modo Plan); senão, pergunte em texto e espere.

Nunca marque uma favorita na tabela. Perguntado diretamente, responda pela frequência com que a peça é vista e pela personalidade do produto, não por qual você gostou de construir. Se duas variantes convergiram enquanto você construía, corte uma e diga isso: duas direções distintas valem mais que três preenchidas.

## 6. Aprove uma, ou rode de novo

**`keep <variante>`**:

1. Copie o código-fonte da variante para `.superfik/outputs/<project>/prototype/<slug>.<ext>`, com uma captura ao lado se tiver uma. Essa é a referência que o plano e a implementação vão ler.
2. No `prototype.md`, ponha `status: approved` e acrescente uma linha `**Aprovada:** <variante> em <data>`.
3. No `prd.md`, acrescente em **Decisões de design** uma linha com a variante, o eixo e o motivo numa frase, apontando para a referência, e registre em `## Histórico de alterações`. Sem PRD, diga ao usuário que a decisão está só no `prototype.md`.
4. Apague o harness e as outras variantes, a menos que o usuário tenha pedido para manter o seletor.
5. Sugira o próximo passo:

> Variante `Editorial` aprovada e registrada em `.superfik/outputs/<project>/prd.md`. Referência guardada em `prototype/editorial.tsx`. Rode `/superfik-plan` para transformar o PRD num plano; as tarefas de UI vão partir dessa referência.

**`riff <variante>`**: mantenha o harness e volte ao passo 3, tomando posições novas em volta da direção para a qual o usuário pendeu.

Até a aprovação, a implementação final não começa. Aprovar o protótipo é aprovar uma direção, não um plano.

## Antes de terminar

| Erro | Correção |
|---|---|
| Variantes diferem só na cor de acento ou no texto | Mova uma para outra posição no eixo primário, ou corte |
| Todo eixo varia de uma vez | Varie um; deixe o resto decorrer dele |
| Julgadas numa rota em branco | Hospede na página que vai conter a peça |
| Lorem ipsum, três linhas, "Fulano de Tal" | Texto real e a quantidade de itens que a página vai carregar |
| A variante mais ousada pula teclado ou foco | Passe o piso ou descarte a direção |
| Uma favorita marcada na tabela | Diga o custo de cada uma e deixe o usuário escolher |
| Seletor estilizado com os tokens do projeto | Mantenha-o visivelmente fora do sistema de design |
| Harness deixado para trás depois da aprovação | Apague, a menos que tenham pedido para manter |
| Decisão só na conversa | Registre no `prototype.md` e no PRD |
