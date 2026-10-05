# Formato do PRD

Todo PRD do Superfik fica em `.superfik/outputs/<project>/prd.md`. O mesmo formato vale tanto para PRDs vindos do `superfik-prd` (perguntas estruturadas) quanto do `superfik-summarize` (extraídos de uma conversa), para que `superfik-plan`, `superfik-implement` e `superfik-verify` consigam ler qualquer um deles.

## Idioma

Escreva o PRD em português do Brasil, com os títulos exatamente como no template abaixo: os outros skills procuram as seções por esses nomes. Nomes de arquivos, caminhos, identificadores de código, chaves do frontmatter e IDs (`R1`, `R2`) ficam como estão.

## Nome do projeto

Use palavras em minúsculas unidas por hífens, de 2 a 4 palavras, derivadas do objetivo (`painel-funil-vendas`). Diga ao usuário o nome escolhido e deixe-o trocar antes de gravar o arquivo.

## Template

Omita uma seção em vez de preenchê-la com placeholders. Mantenha os requisitos testáveis: deve ser possível dizer se cada um foi atendido.

```markdown
---
project: <project-name>
source: prd | conversation
created: <ISO 8601>
updated: <ISO 8601>
---

# <Título do projeto>

## Problema e objetivo
Quem tem o problema, quanto ele custa hoje e qual resultado este projeto entrega.

## Usuários
Usuários principais e a situação em que usam isto.

## Requisitos

### Obrigatórios
- R1. <Requisito, escrito de forma verificável>
- R2. ...

### Desejáveis
- R3. ...

### Opcionais
- R4. ...

## Fora do escopo
- <Exclusão explícita> — o motivo, se ajudar a evitar aumento de escopo

## Contexto técnico
Stack, integrações, restrições e o código existente em que isto precisa se encaixar. Cite arquivos e pacotes reais quando o projeto já existir.

## Decisões de design
Escolhas de arquitetura já feitas, com um motivo de uma linha para cada. A variante aprovada pelo `superfik-prototype`, quando houver, entra aqui com o eixo, o motivo e o caminho da referência em `prototype/`.

## Critérios de sucesso
- <Sinal observável de que o projeto funciona>

## Questões em aberto
- <Questão sem resposta> — quem pode respondê-la

## Histórico de alterações
- <data>: Criado.
```

## Numeração

Os requisitos têm IDs estáveis (`R1`, `R2`, …). Tarefas e relatórios de verificação se referem a eles, então nunca renumere requisitos existentes. Requisitos novos recebem o próximo número livre; os removidos são riscados (`~~R4. ...~~ removido em <data>`) em vez de apagados.

## Marcadores de confiança (PRDs vindos de conversa)

Quando os requisitos vêm de uma conversa e não de respostas diretas, acrescente um marcador a cada um:

- `(declarado)` — o usuário disse explicitamente
- `(inferido)` — decorre do que ele disse, mas ele não disse
- `(assumido)` — um padrão que você escolheu; o usuário deve confirmar

Liste também cada item `(assumido)` em Questões em aberto.
