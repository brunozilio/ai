---
name: superfik-archive
description: Move projetos concluídos do Superfik de .superfik/outputs para o arquivo, restaura projetos arquivados e limpa prompts já executados. Invoque com o nome de um projeto, "list" ou "restore <projeto>".
argument-hint: "[projeto | list | restore <projeto>]"
disable-model-invocation: true
metadata:
  superfik-version: "1.0.0"
---

# Arquivar projetos

Mantenha `.superfik/outputs/` restrito ao trabalho ativo. Arquivar move um projeto para `.superfik/outputs/archive/<project>/`; nada é apagado a menos que o usuário peça explicitamente.

Fale com o usuário em português do Brasil.

## Listar

Mostre cada projeto em `.superfik/outputs/` (exceto `archive/`, `prompts/` e `reviews/`) com o progresso do `tasks.md` (marcadas / total), se existe `verification.md` e qual o resultado, e a data da última modificação. Liste também o que há em `archive/`.

## Arquivar

1. Escolha o projeto pelos argumentos, ou mostre a lista e pergunte. Dá para arquivar vários de uma vez.
2. Se o projeto tiver tarefas não marcadas ou uma verificação com falha, mostre-as e pergunte se deve arquivar mesmo assim.
3. Se `archive/<project>` já existir, pergunte se deve usar um nome com data (`<project>-<AAAA-MM-DD>`) ou cancelar.
4. Mova: `mv .superfik/outputs/<project> .superfik/outputs/archive/<project>` (crie `archive/` se precisar).
5. Confirme o novo local.

## Restaurar

Mova `.superfik/outputs/archive/<project>` de volta para `.superfik/outputs/<project>`. Se já houver um projeto ativo com esse nome, pergunte ao usuário como resolver antes de mover qualquer coisa.

## Apagar

Só quando o usuário pedir especificamente para apagar. Mostre o que será removido (arquivos, progresso das tarefas), diga que isso não pode ser desfeito pelo Superfik e peça que ele confirme digitando o nome do projeto. Então rode `rm -rf` nesse único diretório. Nunca apague nada fora de `.superfik/outputs/`.

## Prompts

Os prompts salvos em `.superfik/outputs/prompts/` têm seu próprio ciclo de vida. Depois de arquivar, se houver prompts com `status: done`, ofereça apagá-los (liste-os antes). Deixe os prompts pendentes em paz, a menos que o usuário os indique.
