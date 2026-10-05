---
name: superfik-feedback
description: Avalia e age sobre feedback de code review - comentários de PR, achados de revisores ou resultados do superfik-verify - conferindo cada ponto contra o código, perguntando antes sobre itens pouco claros, contestando com motivos quando uma sugestão está errada e corrigindo um item por vez. Use quando o usuário recebeu comentários de revisão ou pedir para tratar, aplicar ou responder a um feedback.
argument-hint: "[número do PR | arquivo de revisão]"
metadata:
  superfik-version: "1.0.0"
---

# Agir sobre feedback de revisão

Feedback de revisão é um conjunto de afirmações sobre o código. Confira cada uma antes de agir. Concordar com tudo é tão inútil quanto descartar tudo: o objetivo é código correto, e o revisor ganha mais com uma resposta técnica clara do que com educação.

Fale com o usuário e escreva as respostas em português do Brasil.

## 1. Reúna o feedback

- **Pull request**: busque os comentários com o `gh`, se disponível: `gh pr view <n> --comments` para a conversa e `gh api repos/{owner}/{repo}/pulls/<n>/comments` para os comentários inline com arquivo e linha.
- **Relatórios do Superfik**: `.superfik/outputs/<project>/verification.md` ou `.superfik/outputs/reviews/*.md`.
- **Texto colado**: use como veio.

Numere os itens para você e o usuário poderem se referir a eles.

## 2. Entenda tudo antes de mudar qualquer coisa

Reescreva cada item como um requisito técnico concreto. Se algum item estiver pouco claro, pergunte sobre ele antes de implementar os outros: os itens muitas vezes estão relacionados, e uma leitura parcial produz a correção errada.

> Entendi 1, 2, 3 e 6. No 4, você quer dizer o limite de retries ou o timeout? E no 5 — o cache deve ser por usuário ou global?

## 3. Confira cada item contra o código

Para cada um:

- Está correto para **esta** base de código, stack e versão?
- Quebraria comportamentos ou chamadores existentes? Confira-os.
- Há um motivo para o código estar do jeito que está (compatibilidade, um bug antigo, uma decisão no PRD ou no plano)?
- Está pedindo algo que ninguém usa? Procure os chamadores. Se não houver nenhum, proponha remover o código em vez de deixá-lo "do jeito certo".
- Contradiz uma decisão que o usuário já tomou? Então pergunte ao usuário, não ao revisor.

Se não conseguir verificar algo sem mais acesso (dados de produção, outro serviço), diga do que precisaria.

## 4. Responda

- **Correto**: corrija e diga o que mudou: "Corrigido: o token agora expira depois de 30 minutos (`auth/reset.ts:22`)."
- **Errado ou não se aplica**: explique por quê, com evidência — código, testes, versões, o PRD. "Mantendo o fallback: o `package.json` tem como alvo o Node 20 e `fs.glob` exige o 22."
- **Parcialmente certo**: diga que parte está aplicando e por que o resto não se encaixa.
- **Você contestou e estava errado**: "Conferi de novo, você tem razão: X faz Y. Corrigindo." E siga em frente.

Dispense concordância teatral ("Ótima observação!", "Você tem toda a razão!") e agradecimentos. A correção, ou um motivo claro, é o reconhecimento.

## 5. Implemente

Ordem: primeiro os problemas bloqueantes (comportamento quebrado, segurança), depois as correções simples, depois as mudanças maiores. Um item por vez: mude, rode os testes que o cobrem, siga. Para um bug que o revisor encontrou, escreva primeiro o teste que falha. Rode a suíte completa depois do último item.

## 6. Dê o retorno

Dê ao usuário uma tabela curta: item, ação (corrigido / recusado / precisa de decisão) e onde. Num PR, ofereça responder na thread de cada comentário (`gh api repos/{owner}/{repo}/pulls/<n>/comments/<id>/replies -f body=...`) em vez de um único comentário geral. Pergunte antes de publicar qualquer coisa.
