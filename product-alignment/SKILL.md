---
name: product-alignment
description: Quem decide o que o Superfik faz é o Bruno, não o agente. Use antes de criar qualquer funcionalidade, fluxo, tela ou comportamento novo do produto, de mudar como algo funciona para quem usa, ou quando "vi uma oportunidade" aparecer no raciocínio. Também use ao receber pedidos abertos como "tem mais oportunidades", "melhore", "veja o que falta".
---

# Alinhar antes de criar

Em 2026-10-19 o agente, respondendo a "tem mais oportunidades", decidiu sozinho que "empresa nova não começa num
mapa vazio" e construiu a montagem da empresa por IA, sugestões sem agente do mercado e o construtor para
criadores. Bruno: "esse tipo de decisão, não é você que toma, isso mexe no produto/funcionando diretamente".
Esta skill existe para que isso não se repita.

## A regra

Oportunidade identificada não é autorização. Mudança que altera o que o produto faz ou como funciona para quem
usa é decisão de produto, e decisão de produto é do Bruno. O agente propõe; o Bruno escolhe; o agente constrói.

## O que precisa de alinhamento antes (pare e proponha)

- Funcionalidade, fluxo, tela ou rota que não existia e que ninguém pediu por nome.
- Mudar como algo funciona para quem usa: o que um botão faz, para onde uma ação leva, o que aparece numa
  tela vazia, quem vê o quê, quando um agente roda.
- Nova capacidade do orquestrador ou dos agentes (nova ferramenta, novo gatilho, novo tipo de sugestão).
- Qualquer coisa que entre em `README.md` como seção nova ou que mude a lista "O que ainda não existe".
- Novo endpoint público, nova tabela, novo campo que o front vai passar a mostrar.

## O que pode ir direto (faça e conte)

- Terminar o que estava pela metade, do jeito que já estava desenhado.
- Corrigir bug, teste quebrado, texto errado, lint, formatação, migração inconsistente.
- Polir o que existe dentro do padrão do `heyrico-design`: tirar ruído, alinhar, encurtar texto, sem mudar o
  que a tela faz.
- Refatorar sem mudar comportamento.
- O que o Bruno pediu com nome: "faça X" é autorização para X, não para X e o que vier junto.

Na dúvida se é "terminar" ou "criar": se precisa de um nome novo na interface, é criar.

## Como propor

Quando aparecer uma oportunidade (ou o pedido for aberto, como "tem mais oportunidades"):

1. Não construa. Termine a tarefa em mãos.
2. Liste as oportunidades em pt-BR, uma linha cada, na ordem do que parece valer mais. Para cada uma: o
   problema que a pessoa sente hoje, o que mudaria, o tamanho (horas) e o que ela mexe no produto.
3. Pergunte qual delas fazer. Use `AskUserQuestion` com as opções, ou liste e pare.
4. Só construa a escolhida, do jeito combinado. Se no meio surgir outra decisão de produto, pare de novo.

Exemplo do que deveria ter acontecido em 2026-10-19:

> Vi três pontos. (1) Empresa nova em produção começa num mapa vazio com "Ainda não há áreas"; dá para montar
> áreas e agentes a partir de uma frase, ~4 h, cria tela e dois endpoints. (2) Sugestão do orquestrador só
> propõe agentes do mercado e, quando nenhum serve, não sugere nada; dá para sugerir um agente da empresa,
> ~2 h, muda a tabela de sugestões e o que "Ativar" faz. (3) Criador do mercado preenche formulário cru sem
> rascunho nem teste; dá para usar o construtor, ~1 h. Qual delas? Ou nenhuma?

## O que já foi construído sem alinhamento

Montagem da empresa (`/setup`, `POST /org/draft`, `POST /org/setup`), sugestões sem `catalog_id` (migração
0020) e o construtor para criadores (`/agents/new?for=market`). Em 2026-10-19 o Bruno decidiu manter os três.
Estender qualquer um deles continua sendo decisão dele.
