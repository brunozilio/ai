---
name: superfik-verify
description: Audita uma implementação contra o PRD e o plano de tarefas do Superfik lendo o código e rodando as verificações do projeto, depois escreve um relatório de achados. Use depois da implementação, antes do merge, ou quando o usuário perguntar se uma funcionalidade está completa ou atende aos requisitos.
argument-hint: "[projeto]"
metadata:
  superfik-version: "1.0.0"
---

# Verificar contra a especificação

Confira se o que foi construído bate com o que foi pedido. O PRD (`prd.md`) diz **o que** deve ser feito; o plano (`tasks.md`) diz **como** deveria ser construído. Relate o que encontrar; só corrija quando o usuário pedir.

Fale com o usuário e escreva o relatório em português do Brasil.

## 1. Carregue a especificação

Encontre o projeto em `.superfik/outputs/` (pergunte se houver vários). Leia `prd.md` e `tasks.md`. Anote quais tarefas estão marcadas; essas são as afirmações que você está verificando. Se não houver PRD, dá para verificar só contra o `tasks.md`, ou contra a seção "Pronto quando" de um prompt salvo.

## 2. Reúna evidências

- **Rode as verificações**: os comandos registrados no plano (testes, typecheck, lint, build). Anote as falhas exatas.
- **Leia o código** de cada tarefa concluída: abra os arquivos que ela cita e confirme que a mudança está lá e faz o que a tarefa diz. Testes passando não são evidência de que um requisito existe; o código é.
- **Rastreie os requisitos**: para cada requisito Obrigatório e Desejável, encontre onde está implementado. Se der para exercitá-lo (rodar um comando, chamar um endpoint, rodar um teste específico), faça.
- **Confira o protótipo aprovado**: se `.superfik/outputs/<project>/prototype.md` tem `status: approved`, compare a interface construída com a referência em `prototype/`. A direção aprovada (eixo e posição) foi mantida? Os estados que a referência mostra existem? Um desvio sem entrada em Decisões é Grave; com entrada, é Desatualizado no `prototype.md`. Passe as telas pelos gatilhos de [references/interface-craft.md](references/interface-craft.md); um gatilho confirmado é Crítico.

Num projeto grande, divida o rastreamento dos requisitos entre subagentes, um por fase ou área, e junte os achados.

## 3. Classifique os achados

| Severidade | Significado |
|---|---|
| Crítico | Requisito faltando ou quebrado; problema de segurança; verificações falham |
| Grave | Requisito atendido em parte; abordagem do plano não seguida de um jeito que importa; falta tratamento de erro ou de caso de borda |
| Menor | Nomes, pequenas inconsistências, limpeza |
| Desatualizado | O código é razoável, mas o PRD ou o plano não refletem mais o que foi decidido |

Todo achado precisa de uma localização (`arquivo:linha`), do requisito ou tarefa a que se refere e de uma correção concreta sugerida. Não relate preocupações vagas.

## 4. Escreva o relatório

Salve em `.superfik/outputs/<project>/verification.md` (substitua qualquer relatório anterior; o antigo está no git, se precisar):

```markdown
# Verificação: <project>

Data: <ISO 8601> · Resultado: aprovado | aprovado com achados | reprovado

## Verificações
| Comando | Resultado |
|---|---|
| `npm test` | 142 passaram |
| `npm run typecheck` | 2 erros |

## Requisitos
| ID | Status | Evidência |
|---|---|---|
| R1 | atendido | `src/auth/login.ts:40`, teste `login.test.ts` |
| R2 | parcial | e-mail de redefinição enviado, mas o token nunca expira |

## Achados
| # | Severidade | Local | Problema | Correção sugerida |
|---|---|---|---|---|
| 1 | Crítico | `src/auth/reset.ts:22` | Token de redefinição sem expiração (R2) | Guardar `expiresAt`, rejeitar depois de 30 min |
```

Depois resuma para o usuário: o resultado, as contagens por severidade e as opções (corrigir todos os críticos, corrigir números específicos, ou marcar itens como desatualizados e atualizar o PRD ou o plano com o `superfik-refine`).

## 5. Depois das correções

Quando o usuário pedir para corrigir achados, corrija, rode de novo as verificações relevantes e atualize as linhas do relatório com a nova evidência. Um achado só está resolvido quando a verificação que o revelou passa.

Corrigir achados segue a mesma disciplina de qualquer feedback de revisão: veja `/superfik-feedback`.

Quando o relatório estiver limpo, sugira o `/superfik-finish` para fazer o merge ou abrir um pull request, e o `/superfik-archive` quando o projeto estiver encerrado.
