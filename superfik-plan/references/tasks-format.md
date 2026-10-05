# Formato do plano de tarefas

O plano fica em `.superfik/outputs/<project>/tasks.md`. O `superfik-implement` o executa e marca os itens; o `superfik-verify` audita com base nele. Escreva para um engenheiro que conhece a linguagem mas nunca viu esta base de código nem o PRD: o que ele não tem como saber é o que você decidiu — quais arquivos, quais nomes e assinaturas, quais valores, quais testes provam cada tarefa.

Escreva o plano em português do Brasil, com os títulos e rótulos exatamente como no template. Caminhos, comandos, identificadores de código e IDs (`R1`, `1.1`) ficam como estão.

## Template

````markdown
---
project: <project-name>
prd: prd.md
created: <ISO 8601>
---

# Plano de implementação: <Título do projeto>

**Objetivo:** uma frase.
**Abordagem:** duas ou três frases sobre a arquitetura.

## Contexto da base de código
- Stack: <framework, linguagem, versões encontradas nos manifestos>
- Convenções: <organização de arquivos, nomenclatura, padrões de estado/estilo/dados realmente usados>
- Verificar com: `<comando de teste>`, `<comandos de typecheck/lint/build>`

## Restrições globais
- <Regra do PRD que vale para o projeto inteiro, com o valor exato: versões, limites, nomes, textos>

## Pontos de atenção na revisão
- <Entrada ou falha que o PRD implica mas que nenhum teste cobriria, e o comportamento que o usuário esperaria> → coberto pela tarefa <id>

## Fase 1: <nome>

- [ ] **1.1 <Título da tarefa>** (R1, R2)
  - Arquivos: `src/path/file.ts` (novo), `src/other.ts:40-80` (editar), `tests/path/file.test.ts`
  - Usa: <o que recebe de tarefas anteriores — nomes e assinaturas exatos>
  - Fornece: <o que tarefas posteriores usam — nomes, parâmetros e tipos de retorno exatos>
  - Teste primeiro: `<nome do teste>` verifica <resultado esperado com os valores exatos do PRD>
  - Fazer: <a decisão que o implementador não consegue tomar sozinho: assinatura, biblioteca, padrão a seguir>
  - Pronto quando: `<comando>` passa

- [ ] **1.2 <Título da tarefa>** (R3)
  - Depende de: 1.1
  - …

## Decisões
- <data> <tarefa>: <o que foi decidido> — <por quê> — <custo se estiver errado>
````

## Regras

- **IDs** seguem `<fase>.<n>` e nunca mudam depois de escritos. Tarefas novas recebem o próximo número livre.
- **Vínculos com requisitos** ligam cada tarefa a IDs do PRD. Todo requisito Obrigatório é coberto por pelo menos uma tarefa.
- **Arquivos** são caminhos reais. Só cite um diretório existente se você o viu.
- **Usa / Fornece** é como um subagente que só vê uma tarefa descobre os nomes que as vizinhas usam. Omita nas tarefas que não compartilham nada.
- **Teste primeiro** vale para tarefas que mudam comportamento quando o projeto tem testes (veja `references/test-first.md` no skill que implementa).
- **Tamanho**: a menor unidade que tem seu próprio teste e poderia ser aprovada ou rejeitada sozinha por um revisor. Inclua setup, configuração e documentação na tarefa que precisa deles.
- **Ordem**: fundações antes de quem as consome — tipos e schemas, acesso a dados, APIs, UI, acabamento.
- **Proporção**: um passo diz o que o implementador não consegue decidir sozinho, não o código em si. Um plano mais longo que o código que descreve escreveu o código no lugar dele; linhas que não decidem nada ("tratar casos de borda", "adicionar validação") são lacunas.
- **Independência**: tarefas da mesma fase sem `Depende de`, sem arquivos em comum e sem vínculo Usa/Fornece podem rodar em paralelo.

## Marcadores de status

- `- [ ]` pendente
- `- [x]` concluída (só depois que a verificação de "Pronto quando" passou)
- `- [~]` bloqueada — acrescente uma linha indentada `Bloqueada:` explicando o motivo

A seção **Decisões** registra cada julgamento feito durante a implementação (um conflito do plano resolvido, um achado adiado). É o que sobrevive quando a conversa não sobrevive, e é como o usuário vê as escolhas feitas em nome dele.
