---
name: superfik-finish
description: Encerra um branch concluído - roda a suíte de testes completa, depois oferece fazer merge local, push e abrir um pull request, ou manter o branch, e limpa a worktree. Use quando a implementação estiver completa e verificada e o usuário quiser integrar, fazer merge, entregar ou abrir um PR.
argument-hint: "[branch base]"
metadata:
  superfik-version: "1.0.0"
---

# Encerrar o branch

Integre o trabalho concluído do jeito que o usuário escolher. Merge e push afetam o histórico compartilhado, então a decisão é sempre dele: apresente as opções e espere.

Fale com o usuário e escreva descrições de PR em português do Brasil.

## 1. Rode a suíte completa

Rode o comando de testes completo do projeto (e typecheck/lint/build, se o projeto os usa) na árvore que você vai integrar. Resultados de antes na sessão não contam; eram outra árvore.

Se algo falhar, mostre as falhas e pare. As opções vêm depois de uma execução verde. Se era um projeto do Superfik e o `/superfik-verify` não foi rodado, sugira-o.

## 2. Entenda o workspace

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
WORKTREE_PATH=$(git rev-parse --show-toplevel)
git branch --show-current
git status --porcelain
```

Anote isso agora; o passo 4 muda de diretório antes que a limpeza precise desses valores.

- `GIT_DIR` igual a `GIT_COMMON`: o checkout principal, sem worktree para limpar.
- Diferentes, num branch nomeado: uma worktree vinculada.
- Diferentes, com HEAD destacado: um workspace gerenciado pela ferramenta (por exemplo uma tarefa do Codex). Não faça merge a partir dele; ofereça um PR ou manter.

Se houver mudanças sem commit, pergunte se deve fazer commit delas antes.

## 3. Confirme o branch base

O branch de onde este trabalho partiu — citado no plano, na conversa ou no upstream do branch. Se não tiver certeza, pergunte: "Este branch saiu da `main`, certo?" Fazer merge na base errada é caro de desfazer.

## 4. Ofereça as opções

```
O trabalho está concluído e a suíte completa passa. O que você quer fazer?

1. Fazer merge em <base> localmente
2. Fazer push e abrir um pull request
3. Manter o branch como está
```

Com HEAD destacado, ofereça só a 2 (push como um branch novo) e a 3. Não ofereça descartar o trabalho; faça isso só se o usuário pedir explicitamente.

### 1. Merge local

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
git checkout <base>
git pull
git merge <branch>
<comando de testes completo>
```

Se o resultado do merge falhar, pare e investigue com o branch e a worktree ainda no lugar; nada foi enviado. Se passar, limpe a worktree (passo 5) e rode `git branch -d <branch>`.

### 2. Push e pull request

```bash
git push -u origin <branch>
# a partir de um HEAD destacado: git push origin HEAD:refs/heads/<novo-branch>
```

Abra o PR contra `<base>` com `gh pr create` se a CLI do GitHub estiver disponível (senão, passe ao usuário a URL que o git imprimiu). Siga o template de PR do repositório, se houver; resuma o que mudou, aponte o PRD ou o plano e liste como foi verificado. Informe a URL do PR. Mantenha a worktree: o feedback da revisão é tratado lá (com o `/superfik-feedback`).

Se o push for rejeitado, o remoto andou. Investigue; faça force-push só se o usuário pedir explicitamente.

### 3. Manter

Informe o nome do branch e o caminho da worktree, e pare.

### Se o usuário pedir para descartar o trabalho

Mostre o que seria perdido (branch, commits de `git log <base>..<branch> --oneline`, caminho da worktree) e peça que ele digite `descartar` para confirmar. Só então limpe a worktree e rode `git branch -D <branch>`.

## 5. Limpe a worktree

Só depois de um merge bem-sucedido ou de um descarte confirmado, e só para worktrees em `.worktrees/` ou `worktrees/`; as outras pertencem à ferramenta ou ao usuário. Siga a seção de limpeza de [references/worktrees.md](references/worktrees.md): rode a partir do checkout principal e nunca force a remoção de uma worktree com arquivos sem commit.

## 6. Arrume a casa

Se o trabalho pertencia a um projeto do Superfik que agora já foi integrado, sugira o `/superfik-archive`.
