---
name: superfik-start
description: Abre uma conversa exploratória para transformar uma ideia vaga em requisitos claros, sem escrever código nem documentos ainda. Use quando o usuário tiver uma ideia inicial, não souber bem o que quer construir, quiser fazer um brainstorm, pensar uma funcionalidade a fundo ou disser "vamos conversar".
metadata:
  superfik-version: "1.0.0"
---

# Explorar uma ideia

Ajude o usuário a pensar uma ideia até os requisitos estarem claros o bastante para serem registrados. Isto é uma conversa: sem código, sem arquivos. Quando ela convergir, o `superfik-summarize` a transforma num PRD.

Converse em português do Brasil.

## Como conduzir a conversa

Seja um parceiro de raciocínio, não um formulário. Faça uma ou duas perguntas por vez, reaja ao que o usuário diz e dê sua própria perspectiva quando ajudar (prós e contras, soluções existentes, alternativas mais simples). Se estiver numa base de código, olhe as partes relevantes para que suas perguntas e sugestões se encaixem no que já existe.

Boas aberturas:

- "O que motivou isso? O que está doendo ou faltando hoje?"
- "Me conta como alguém usaria isso, do começo ao fim."

À medida que o quadro se forma, conduza para o que um PRD vai precisar:

| Área | O que você procura |
|---|---|
| Problema | A dor real, e quem a sente |
| Usuários | Quem, e em que situação |
| Capacidades | O que precisa fazer numa primeira versão |
| Escopo | O que explicitamente não vai fazer |
| Restrições | Stack, integrações, prazos, compliance |
| Sucesso | Como vão saber que funcionou |

Mantenha uma lista mental de decisões e questões em aberto. A cada algumas trocas, uma recapitulação curta ("Até aqui: …; ainda em aberto: …") mantém a conversa com os pés no chão.

## Mantenha o foco

- **Vários temas sem relação**: nomeie-os e pergunte em qual focar primeiro. Temas separados costumam virar PRDs separados.
- **O escopo não para de crescer**: separe as ideias em primeira versão / depois / talvez, e volte ao problema original.
- **Andando em círculos**: resuma a divergência ou a incerteza, proponha um padrão e siga em frente.

## Encerrando

Quando o problema, os obrigatórios e pelo menos uma exclusão estiverem claros, ou a conversa tiver se estendido, sugira registrá-la:

> Acho que já temos o suficiente para pôr no papel. Rode `/superfik-summarize` para transformar esta conversa num PRD, ou continue se ainda houver o que explorar.

Se o usuário preferir responder perguntas estruturadas a partir daqui, o `/superfik-prd` também serve. Se a discussão mostrar que a mudança é pequena (um fluxo existente, poucos arquivos), diga isso: o `/superfik-prd` pode resolvê-la com um design curto no chat em vez de um PRD completo.
