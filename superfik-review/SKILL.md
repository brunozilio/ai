---
name: superfik-review
description: Revisa um branch, pull request ou conjunto de mudanças segundo critérios escolhidos (segurança, arquitetura, padrões, desempenho, testes, interface) e salva um relatório de achados sem modificar o código. Use quando o usuário pedir para revisar um PR, branch, diff ou as mudanças de um colega.
argument-hint: "[branch | número do PR | URL]"
metadata:
  superfik-version: "1.0.0"
---

# Revisar mudanças

Revise as mudanças de alguém e produza um relatório sobre o qual ele possa agir. Você relata; não edita o código em revisão.

Fale com o usuário e escreva o relatório em português do Brasil.

## 1. Defina o que revisar

Descubra o alvo pelos argumentos ou pergunte:

- **Número ou URL do PR**: se a CLI do GitHub (`gh`) estiver disponível, use-a para buscar a descrição do PR, o branch base e o diff. Senão, peça o nome do branch.
- **Branch**: faça o diff contra o merge base com o branch padrão: `git diff $(git merge-base origin/<base> <branch>)..<branch>`.
- **Nada especificado**: revise o branch atual contra o branch padrão, ou as mudanças sem commit se o branch não tiver nenhuma.

Faça fetch antes se o branch puder estar desatualizado. Se o diff estiver vazio, diga isso e confira os nomes dos branches com o usuário.

## 2. Combine o foco

Pergunte quais critérios importam (dá para escolher vários) e se há convenções do time a aplicar. Ofereça estes presets, com **geral** como padrão se o usuário não se importar:

- **Segurança**: autenticação/autorização, validação de entrada, segredos, injeção, XSS/CSRF, desserialização insegura, risco de dependências
- **Arquitetura**: camadas, acoplamento, consistência com os padrões existentes
- **Padrões**: nomes, duplicação, mensagens de erro, logs, código morto
- **Desempenho**: consultas N+1, cargas sem limite, I/O bloqueante, vazamentos
- **Testes**: comportamento novo coberto, casos de borda e de erro, testes que verificam algo real
- **Interface**: acessibilidade, layout, texto, tipografia, cores e motion das telas que a mudança toca, contra os gatilhos e princípios de [references/interface-craft.md](references/interface-craft.md); inclua-o por padrão quando o diff muda componentes ou estilos

O checklist detalhado está em [references/review-criteria.md](references/review-criteria.md).

## 3. Revise

Leia primeiro a descrição do PR, depois o diff, depois código ao redor o suficiente para julgar cada mudança no contexto. Antes de apontar um padrão, veja se a base de código já faz a mesma coisa em outro lugar; se faz, é uma convenção, não um achado (mencione só se for um risco real).

Para um diff grande, dá para dividir os arquivos entre subagentes por área ou por critério e juntar os achados; revise a lista combinada atrás de duplicatas e falsos positivos antes de relatar.

Todo achado precisa de `arquivo:linha`, uma severidade, o que está errado e uma correção concreta. Aponte também o que está bom; isso diz ao autor o que continuar fazendo.

| Severidade | Significado |
|---|---|
| Crítico | Precisa corrigir antes do merge: problema de segurança, perda de dados, comportamento quebrado |
| Grave | Deveria corrigir: risco significativo de bug, falta de testes para comportamento novo, problema de design claro |
| Menor | Opcional: legibilidade, pequenas inconsistências |

## 4. Relate

Salve em `.superfik/outputs/reviews/<branch-ou-pr>-<AAAA-MM-DD>.md`:

```markdown
# Revisão: <branch ou título do PR>

<origem> → <base> · <N> arquivos · Critérios: <lista> · <data>

**Recomendação:** aprovar | aprovar com mudanças | pedir mudanças

## Resumo
Duas ou três frases sobre o que a mudança faz e sua qualidade geral.

## Achados
| # | Severidade | Local | Problema | Correção sugerida |
|---|---|---|---|---|

## Pontos positivos
- <coisas específicas bem feitas, com localização>
```

Mostre ao usuário a recomendação e os achados críticos e graves. Se ele quiser os achados publicados no PR, pergunte antes de publicar qualquer coisa.

Se depois o autor pedir para tratar os achados, isso é o `/superfik-feedback`.
