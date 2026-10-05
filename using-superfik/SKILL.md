---
name: using-superfik
description: Use no início de qualquer conversa de desenvolvimento de software e antes de agir sobre um pedido novo - criar uma funcionalidade, corrigir um bug, planejar, revisar ou encerrar um trabalho. Diz qual skill do Superfik se aplica e em que ordem, para que o processo certo rode antes de qualquer código ser escrito.
metadata:
  superfik-version: "1.0.0"
---

# Usando o Superfik

O Superfik é um conjunto de skills que dão um caminho disciplinado da ideia ao código integrado. Antes de responder a um pedido de desenvolvimento — inclusive antes de perguntas de esclarecimento ou de explorar arquivos —, veja se algum destes skills se aplica. Se sim, carregue-o e siga-o. Se, depois de lê-lo, ele não servir, deixe-o de lado.

Se você foi disparado como subagente para fazer uma tarefa específica, ignore este skill e faça a tarefa.

## Idioma

Converse com o usuário e escreva todos os documentos do Superfik (PRDs, planos, relatórios, prompts salvos) em português do Brasil. Nomes de arquivos, caminhos, comandos, identificadores de código e nomes dos skills ficam como estão.

## Qual skill

| O usuário quer… | Use |
|---|---|
| Pensar uma ideia vaga | `/superfik-start` |
| Construir algo novo ou mudar como as partes se encaixam | `/superfik-prd` (ele decide quanto processo o pedido precisa) |
| Registrar uma discussão como requisitos | `/superfik-summarize` |
| Alterar um PRD ou prompt salvo existente | `/superfik-refine` |
| Ver variantes de uma tela e aprovar uma antes de planejar | `/superfik-prototype` (só quando o usuário pedir) |
| Transformar um PRD num plano | `/superfik-plan` |
| Executar um plano ou prompt salvo | `/superfik-implement` (só quando o usuário pedir) |
| Corrigir um bug, um teste falhando ou um comportamento inesperado | `/superfik-debug` |
| Trabalhar em vários problemas independentes ao mesmo tempo | `/superfik-parallel` |
| Conferir se o trabalho bate com o PRD | `/superfik-verify` |
| Revisar o branch ou PR de outra pessoa | `/superfik-review` |
| Agir sobre comentários de revisão que recebeu | `/superfik-feedback` |
| Fazer merge, abrir um PR ou encerrar um branch | `/superfik-finish` |
| Afiar um prompt até virar uma especificação de tarefa | `/superfik-improve` |
| Organizar documentos de projetos concluídos | `/superfik-archive` (só quando o usuário pedir) |

Quando vários se aplicam, os skills de processo vêm primeiro: `superfik-prd` antes de construir, `superfik-debug` antes de corrigir. Depois, os skills que executam o trabalho.

## O caminho

```
ideia ─► superfik-start ─► superfik-summarize ─┐
                                               ├─► (superfik-prototype) ─► superfik-plan ─► superfik-implement ─► superfik-verify ─► superfik-finish
pedido ─► superfik-prd ────────────────────────┘
bug ─► superfik-debug ─► superfik-verify ─► superfik-finish
```

Cada seta é uma passagem que o usuário aprova: o PRD antes do plano, o plano antes da implementação, o merge ou PR no final. Não transforme a aprovação de uma etapa em permissão para a seguinte.

O `superfik-prototype` é opcional e entra quando o PRD tem interface: o usuário vê variantes da peça na página real e aprova uma direção antes do plano. Sugira-o; só rode quando ele pedir.

## Hábitos em que estes skills se apoiam

- **Evidência antes de afirmações.** Diga que algo funciona, passa ou está corrigido só depois de rodar, nesta sessão, o comando que mostra isso, e cite o resultado.
- **Causa raiz antes de correções.** Uma correção sem explicação de por que o bug aconteceu é um chute.
- **Teste primeiro** quando o comportamento muda e o projeto tem testes.
- **Pergunte quando importa, decida quando não importa.** Pergunte sobre intenção, escopo e ações irreversíveis. Tome você mesmo as decisões comuns de engenharia e registre-as.

## Sinais de que você está pulando um skill

| Pensamento | Em vez disso |
|---|---|
| "É uma pergunta simples" | Pedidos simples também têm um skill correspondente; confira a tabela. |
| "Deixa eu dar uma olhada primeiro" | O skill diz o que olhar. Carregue-o, depois explore. |
| "É pequeno demais para precisar de PRD" | O `superfik-prd` encolhe para um design de duas frases no chat em mudanças pequenas. |
| "Estou vendo o bug" | Ver o sintoma não é saber a causa. `superfik-debug`. |
| "Os testes passaram antes" | Antes não é agora. Rode de novo antes de afirmar. |
| "Lembro o que aquele skill diz" | Skills mudam. Carregue a versão atual. |

## Invocando skills

- **Claude Code**: carregue um skill com a ferramenta Skill; o usuário invoca um digitando uma barra e o nome dele.
- **Codex**: os skills carregam quando o pedido bate com a descrição deles; o usuário invoca um com um cifrão e o nome dele, ou o escolhe na lista de skills.

## Precedência

As instruções do usuário — na conversa, no `CLAUDE.md` ou no `AGENTS.md` — têm precedência sobre estes skills. Pule um fluxo só quando o usuário tiver pedido.
