# Workspaces isolados (git worktrees)

Uma worktree é um segundo checkout do mesmo repositório, em seu próprio branch. Trabalho de implementação numa worktree não atrapalha o branch atual do usuário, e várias worktrees permitem que tarefas independentes rodem em paralelo sem editar os mesmos arquivos.

## 1. Veja se você já está isolado

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
git rev-parse --show-superproject-working-tree 2>/dev/null   # imprime um caminho dentro de um submódulo
git branch --show-current
```

- `GIT_DIR` é diferente de `GIT_COMMON` e você não está num submódulo: você já está numa worktree vinculada. Não crie outra.
- Caso contrário, você está no checkout principal. Se o usuário não disse o que prefere, pergunte antes de criar uma worktree: "Quer que eu trabalhe numa worktree isolada para o seu branch atual ficar intacto?" Se ele recusar, trabalhe no próprio checkout.

Nunca comece a implementação direto em `main`/`master` sem a concordância explícita do usuário.

## 2. Crie uma

**Use primeiro o suporte a worktrees da própria ferramenta.** Ele escolhe o diretório, cria o branch e faz a limpeza, e sabe que a worktree existe:

- **Claude Code**: a ferramenta de worktree (`EnterWorktree`) na sessão, ou subagentes disparados com isolamento em worktree.
- **Codex**: a opção de worktree ao iniciar uma tarefa no app do Codex; na CLI, use o git.

**Alternativa com git**, só quando a ferramenta não tem suporte a worktrees:

1. Escolha o diretório: um que o usuário indicou; senão um `.worktrees/` ou `worktrees/` já existente na raiz do repositório; senão `.worktrees/`.
2. Garanta que ele está ignorado: `git check-ignore -q .worktrees`. Se não estiver, adicione-o ao `.gitignore` e faça commit disso antes, senão os arquivos da worktree acabam dentro do repositório.
3. `git worktree add .worktrees/<branch> -b <branch>` e trabalhe a partir desse diretório.

Se o sandbox recusar a criação da worktree, diga isso e trabalhe no checkout atual.

## 3. Prepare-a

Instale as dependências do jeito que o projeto faz (`npm ci`, `pnpm install`, `uv sync`, `go mod download`, …), depois rode a suíte de testes uma vez. Se a base já falhar, relate e pergunte se deve continuar; caso contrário, toda falha posterior fica ambígua.

## Limpeza

Só remova worktrees que você criou em `.worktrees/` ou `worktrees/`; o resto pertence à ferramenta ou ao usuário. Rode a remoção a partir do checkout principal:

```bash
git worktree remove <path>
git worktree prune
```

Se o git recusar porque a worktree tem arquivos sem commit, nunca force. Mostre ao usuário `git -C <path> status --porcelain -uall` e pergunte se deve fazer commit deles, movê-los ou apagá-los.
