---
name: superfik-refine
description: Atualiza no próprio arquivo um PRD ou prompt salvo do Superfik, registrando o que mudou e apontando as tarefas que a mudança invalida. Use quando o usuário quiser alterar, ampliar, cortar ou corrigir requisitos ou um prompt salvo em vez de começar do zero.
argument-hint: "[projeto ou id do prompt]"
metadata:
  superfik-version: "1.0.0"
---

# Refinar um PRD ou prompt salvo

Mude o que já existe sem perder o que foi decidido. Este skill edita documentos em `.superfik/outputs/`; ele não altera código da aplicação.

Converse com o usuário e escreva em português do Brasil.

## 1. Encontre o alvo

Procure em `.superfik/outputs/`:

- PRDs: `<project>/prd.md`
- Prompts salvos: `prompts/*.md`

Se o usuário indicou um, use-o. Se houver exatamente um candidato, confirme. Caso contrário, liste-os (nome, tipo, última modificação e, para projetos, se existe `tasks.md`) e pergunte qual. Se não houver nada, indique o `superfik-prd`, o `superfik-improve` ou o `superfik-summarize`.

## 2. Mostre como está

Resuma o conteúdo atual em poucas linhas: objetivo, requisitos (com IDs), exclusões, questões em aberto. Para um prompt, mostre o próprio prompt. Depois pergunte o que deve mudar.

## 3. Faça as mudanças

Converse sobre as mudanças até ficarem claras, depois edite o arquivo:

- **PRD**: siga as regras de numeração de [references/prd-format.md](references/prd-format.md). IDs de requisitos existentes nunca mudam; os novos recebem o próximo número; os removidos são riscados, não apagados. Atualize a data `updated` e resolva as Questões em aberto que a discussão respondeu.
- **Prompt**: reescreva as partes afetadas e volte a pôr `status: pending` se ele já tinha sido executado.

Nunca descarte um requisito existente a menos que o usuário tenha pedido.

Acrescente uma entrada na seção `## Histórico de alterações` do documento:

```markdown
- 2026-09-28: Adicionado R7 (redefinição de senha por e-mail). R2 alterado para usar bcrypt. Removido R4 (movido para um projeto separado). Motivo: feedback da revisão de segurança.
```

## 4. Confira o plano

Se o projeto tiver um `tasks.md`, compare a mudança com ele e liste as tarefas afetadas: tarefas de requisitos removidos, tarefas cuja abordagem mudou e requisitos novos ainda sem tarefa. Depois ofereça as opções:

> Esta mudança afeta as tarefas 2.1 e 2.3, e o R7 ainda não tem tarefa. Rode `/superfik-plan` para atualizar o plano, ou posso editar o `tasks.md` só nesses itens.

Termine dizendo ao usuário o que mudou e onde está o arquivo.
