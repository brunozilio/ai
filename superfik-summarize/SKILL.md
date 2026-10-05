---
name: superfik-summarize
description: Extrai os requisitos discutidos na conversa atual para um arquivo de PRD, marcando o que foi dito e o que foi inferido. Use depois de uma discussão exploratória (por exemplo superfik-start) quando o usuário quiser registrar, resumir ou pôr no papel o que foi decidido.
metadata:
  superfik-version: "1.0.0"
---

# Resumir uma conversa num PRD

Transforme o que foi discutido nesta conversa em `.superfik/outputs/<project>/prd.md`, no formato de [references/prd-format.md](references/prd-format.md), com `source: conversation`. Registre, não invente: cada requisito deve remeter a algo dito aqui.

Converse com o usuário e escreva o PRD em português do Brasil.

## 1. Veja se há o suficiente para registrar

Você precisa de pelo menos:

- um problema ou objetivo,
- duas ou mais capacidades concretas,
- alguma noção de para quem é.

Se faltar algo, diga o que falta e pergunte (até três perguntas de uma vez) antes de escrever. Um PRD feito principalmente de suposições não é útil.

## 2. Extraia

Percorra a conversa e tire dela problema, usuários, requisitos, exclusões, contexto técnico, decisões e critérios de sucesso. Onde a discussão mudou de direção, fique com a posição final e anote a mudança só se ela explicar uma decisão.

Marque cada requisito:

- `(declarado)` — dito explicitamente
- `(inferido)` — claramente implícito no que foi dito
- `(assumido)` — um padrão razoável que você está propondo; liste-o também em Questões em aberto

Se a conversa cobriu vários temas sem relação, pergunte qual registrar, ou escreva um PRD por tema.

## 3. Dê nome e confirme

Proponha um nome de projeto (minúsculas, com hífens, 2–4 palavras). Mostre um esboço breve: objetivo, obrigatórios, exclusões, número de questões em aberto. Peça ao usuário que confirme ou corrija.

## 4. Escreva

Crie `.superfik/outputs/<project>/prd.md`. Se o arquivo já existir, não o sobrescreva; ofereça incorporar o material novo pelo `superfik-refine`.

Diga ao usuário onde foi salvo, quantos itens são `(assumido)` e qual é o próximo passo:

> PRD salvo em `.superfik/outputs/<project>/prd.md` (3 suposições para confirmar em Questões em aberto). Próximo passo: `/superfik-plan` para criar o plano de implementação, ou `/superfik-refine` para ajustá-lo antes.
