---
name: superfik-improve
description: Reescreve um prompt vago como uma especificação de tarefa clara, específica e baseada na base de código, e a salva para execução posterior. Use quando o usuário pedir para melhorar, afiar, reescrever ou "deixar melhor" um prompt, ou quiser uma descrição de tarefa bem formada antes de passar o trabalho a um agente.
argument-hint: "[prompt a melhorar]"
metadata:
  superfik-version: "1.0.0"
---

# Melhorar um prompt

Transforme o prompt do usuário num que um agente consiga executar sem chutar, depois salve-o em `.superfik/outputs/prompts/`. Você está escrevendo uma especificação, não fazendo o trabalho: não implemente o que o prompt descreve, mesmo que pareça pequeno. O usuário roda o `superfik-implement` quando estiver pronto.

Fale com o usuário e escreva o prompt melhorado em português do Brasil.

Se nenhum prompt veio junto com a invocação, peça-o.

## 1. Entenda a intenção

Descubra o que o usuário realmente quer que seja feito (construir, corrigir, refatorar, migrar, testar, documentar, investigar, revisar) e o que "pronto" significa para ele. Se o prompt for ambíguo de um jeito que mudaria o resultado, faça até três perguntas focadas, todas de uma vez, e espere as respostas. Não pergunte nada que você consiga descobrir sozinho.

## 2. Baseie-o no projeto

A maioria dos prompts fracos é fraca porque falta um contexto que o repositório já tem. Antes de reescrever, olhe:

- Manifestos (`package.json`, `pyproject.toml`, `go.mod`, …) para stack e versões
- Os arquivos e módulos que o prompt toca, ou tocaria
- Padrões existentes para o mesmo tipo de mudança, e os comandos de teste/lint/build

Ponha o que aprender no prompt como nomes concretos: caminhos, funções, bibliotecas, comandos. Se não estiver numa base de código, pule este passo e anote as suposições.

## 3. Avalie o original

Classifique o prompt original como **forte**, **adequado** ou **fraco** em cada dimensão, com uma linha de justificativa onde não for forte:

| Dimensão | Pergunta |
|---|---|
| Clareza | O objetivo é inequívoco? |
| Especificidade | As coisas concretas estão nomeadas (arquivos, versões, APIs, dados)? |
| Completude | Restrições, entradas e casos de borda estão cobertos? |
| Estrutura | Está organizado de modo que as partes importantes se destaquem? |
| Acionabilidade | Um agente conseguiria começar imediatamente? |
| Verificabilidade | Há um jeito de dizer que está pronto? |

## 4. Reescreva

Escolha uma profundidade:

- **Padrão** (default): objetivo, contexto, requisitos, restrições, critérios de pronto.
- **Detalhada**: quando a tarefa é grande, arriscada ou toca segurança, dados ou APIs públicas, ou quando o usuário pede. Acrescente casos de borda, um plano de verificação, riscos e uma ou duas abordagens alternativas com prós e contras.

Escreva o prompt melhorado em linguagem simples e direta. Mantenha o que o usuário disse; acrescente o que faltava; tire enrolação e rodeios. Não invente requisitos. Se precisou assumir algo, marque como suposição para o usuário poder corrigir.

Um bom prompt melhorado costuma ter estas partes:

```markdown
## Objetivo
Uma ou duas frases sobre o resultado.

## Contexto
O que existe hoje, com caminhos e nomes.

## Requisitos
- Itens específicos e verificáveis

## Restrições
- Bibliotecas/padrões a usar ou evitar, compatibilidade, desempenho, segurança

## Pronto quando
- Comandos que precisam passar, comportamentos a observar
```

## 5. Salve

Escreva `.superfik/outputs/prompts/<id>.md`, em que `<id>` é `AAAAMMDD-HHMM-<slug-curto>` (por exemplo `20260928-1430-limite-tentativas-login`). Crie o diretório se precisar.

```markdown
---
id: <id>
created: <ISO 8601>
depth: standard | thorough
status: pending
original: |
  <o prompt original do usuário, literalmente>
---

<o prompt melhorado>

## Avaliação
<a tabela de dimensões do passo 3>

## Mudanças
- <o que você mudou e por quê, uma linha cada>
```

Depois mostre ao usuário o prompt melhorado, a lista curta de mudanças, o caminho salvo e o próximo passo:

> Salvo em `.superfik/outputs/prompts/<id>.md`. Rode `/superfik-implement` para executá-lo, ou `/superfik-refine` para iterar sobre ele.

Se a tarefa se revelar maior que um único prompt (várias funcionalidades, escopo pouco claro), diga isso e sugira o `superfik-prd`.
