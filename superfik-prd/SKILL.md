---
name: superfik-prd
description: Define o escopo de um pedido antes de escrever qualquer código - uma resposta rápida para spikes, um design curto no chat para mudanças pequenas, ou um PRD completo a partir de uma entrevista com uma pergunta por vez para funcionalidades e projetos novos. Use antes de criar ou alterar funcionalidades, ou quando o usuário pedir um PRD, uma especificação ou requisitos.
argument-hint: "[ideia ou funcionalidade]"
metadata:
  superfik-version: "1.0.0"
---

# Definir o escopo e escrever o PRD

Decida quanto processo o pedido precisa, combine o design com o usuário e, para trabalhos maiores, escreva `.superfik/outputs/<project>/prd.md` no formato de [references/prd-format.md](references/prd-format.md). Este skill não escreve código da aplicação: a implementação só começa depois que o usuário aprova o design.

Converse com o usuário e escreva tudo em português do Brasil.

## Escolha o caminho

Antes da primeira pergunta, classifique o pedido e diga qual caminho vai seguir, para que o usuário possa mudar:

- **Spike**: uma pergunta de viabilidade ("dá para…?", "é possível…?") cuja resposta importa mais que o código. Descreva a pergunta e o que vai tentar em duas ou três frases, obtenha um ok, investigue da forma mais barata que a correção permitir e relate uma recomendação. O que você construir é descartável. Sem PRD.
- **Mudança pequena**: uma mudança bem delimitada num fluxo que já existe neste repositório (uma flag, um endpoint, uma correção em um arquivo). Faça as perguntas que importam, apresente um design curto no chat (abordagem, arquivos, como será testado) e espere um sim explícito. Depois implemente direto, com teste primeiro. Sem PRD, sem plano.
- **Completo**: um projeto ou subsistema novo, ou uma mudança em como os componentes se encaixam ou em interfaces das quais outros dependem. Siga o resto deste skill: entrevista, abordagens, PRD, depois `/superfik-plan`.

Na dúvida, escolha o caminho mais pesado. O caminho só sobe: se o trabalho se revelar maior do que parecia, pare, diga isso e passe para o caminho mais pesado. Conhecer bem o tipo de aplicação não torna uma mudança pequena; o fluxo que você está mudando precisa já existir aqui.

## Antes de perguntar qualquer coisa

Se for uma base de código existente, passe um minuto conhecendo-a: manifestos, estrutura de alto nível, a área que a funcionalidade vai tocar. O que você puder descobrir assim, não pergunte. Suas perguntas técnicas devem ser sobre decisões, não fatos ("Isto deve reaproveitar o `JobQueue` existente ou precisa de um worker próprio?" em vez de "Em que linguagem é o projeto?").

Procure em `.superfik/outputs/` um PRD existente sobre o mesmo tema. Se houver, ofereça o `superfik-refine` em vez de começar do zero.

## A entrevista

Faça **uma pergunta por vez** e construa sobre cada resposta. Quando a resposta for uma escolha entre opções, use sua ferramenta de perguntas de múltipla escolha se tiver uma (`AskUserQuestion` no Claude Code; `request_user_input` no Codex, disponível só no modo Plan). Caso contrário, e para perguntas abertas, pergunte em texto simples e espere a resposta.

Cubra estas áreas, mais ou menos nesta ordem. Pule as que o usuário já respondeu.

1. **Problema e objetivo**: o que está errado hoje, para quem, e que resultado querem. Você precisa de um problema e de um objetivo antes de seguir. Se a resposta for uma solução ("um dashboard"), pergunte que decisão ou dor ela resolve.
2. **Usuários**: quem usa e em que situação.
3. **Capacidades principais**: as 3–5 coisas que precisa fazer. Se a lista ficar longa, pergunte quais são necessárias na primeira versão.
4. **Fora do escopo**: pelo menos uma exclusão explícita. Sugira candidatos prováveis se o usuário travar (ferramentas de admin, mobile, autenticação, pagamentos, notificações, migrações).
5. **Decisões técnicas**: só as que estão em aberto, com base no que você encontrou no código.
6. **Critérios de sucesso**: como vão saber que funcionou.
7. **Algo mais**: prazos, compliance, acessibilidade, localização.

Quando a resposta for "não sei", ofereça duas ou três opções concretas com uma recomendação em vez de insistir. Se a ideia ainda estiver vaga demais para este tipo de entrevista, sugira o `superfik-start` para explorá-la numa conversa primeiro.

## Abordagens

Quando o objetivo e os requisitos obrigatórios estiverem claros, proponha duas ou três formas de construir, com os prós e contras e sua recomendação, e deixe o usuário escolher. Registre a escolha em Decisões de design.

## Antes de escrever

Repita um resumo curto (objetivo, obrigatórios, exclusões, abordagem escolhida) e o nome de projeto que pretende usar. Separe o que o usuário disse do que você assumiu. Pergunte se algo está errado ou faltando. Ajuste e então escreva.

## Escreva o PRD

- Caminho: `.superfik/outputs/<project>/prd.md` (crie o diretório)
- Formato: [references/prd-format.md](references/prd-format.md), com `source: prd`
- Os requisitos são numerados `R1…Rn` e escritos de forma verificável
- Use as palavras do usuário onde foram precisas; aperte-as onde não foram
- Preencha "Questões em aberto" com honestidade em vez de disfarçar lacunas

Antes de entregar, releia uma vez: sem placeholders, sem requisitos que se contradizem, nada vago o bastante para ser lido de dois jeitos, escopo que cabe num plano (sugira dividir se não couber). Corrija o que encontrar.

Depois peça ao usuário que leia o PRD e o aprove. O plano só começa depois dessa aprovação; concordar antes na conversa cobriu a direção, não este documento.

> PRD salvo em `.superfik/outputs/<project>/prd.md`. Leia e me diga o que mudar. Quando estiver bom, o `/superfik-plan` o transforma num plano de implementação.

Quando o PRD inclui telas ou componentes novos, acrescente uma frase oferecendo o `/superfik-prototype`: ele constrói variantes da peça principal na página real para o usuário aprovar uma direção antes do plano. Nomeie a peça que você sugeriria prototipar primeiro. É uma oferta, não um passo obrigatório; o usuário decide.
