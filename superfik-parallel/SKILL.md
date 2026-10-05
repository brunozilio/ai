---
name: superfik-parallel
description: Divide o trabalho em partes independentes e as executa em subagentes paralelos, cada um com instruções focadas e, quando edita código, sua própria git worktree, depois integra e verifica os resultados. Use diante de duas ou mais tarefas ou falhas independentes - subsistemas separados, arquivos de teste falhando sem relação entre si, tarefas do plano sem arquivos em comum - que não dependem umas das outras.
argument-hint: "[tarefas ou falhas]"
metadata:
  superfik-version: "1.0.0"
---

# Trabalhar em paralelo

Problemas independentes não precisam esperar uns pelos outros. Entregue cada um a um subagente próprio, com exatamente o contexto de que ele precisa, e rode todos ao mesmo tempo. Você continua coordenando: divide o trabalho, escreve as instruções, integra os resultados e verifica o todo.

Fale com o usuário e escreva as instruções dos subagentes em português do Brasil.

Claude Code e Codex rodam subagentes. No Claude Code, vários disparos de subagentes na mesma resposta rodam simultaneamente.

## 1. Decida se o trabalho é mesmo independente

Paralelo é o certo quando cada parte pode ser entendida e concluída sem as outras:

- testes falhando em arquivos diferentes, com causas diferentes;
- subsistemas separados;
- tarefas do plano na mesma fase sem `Depende de`, sem arquivos em comum e sem vínculo Usa/Fornece (veja o `tasks.md`).

Mantenha sequencial quando:

- corrigir uma parte pode corrigir as outras, ou você ainda não sabe o que está quebrado — investigue primeiro (`/superfik-debug`);
- as partes editam os mesmos arquivos, as mesmas interfaces ou estado compartilhado (um schema de banco, um lockfile, uma configuração global);
- entender uma parte exige ver o sistema inteiro.

Na dúvida, rode menos partes em paralelo. Um conflito de merge custa mais que o tempo economizado.

## 2. Isole as mudanças de código

Trabalho somente leitura (investigar, revisar, auditar) pode compartilhar o checkout atual.

Todo subagente que **edita código** ganha sua própria worktree e branch, para que um não sobrescreva o outro. No Claude Code, dispare o subagente com isolamento em worktree; caso contrário, crie uma worktree por parte como descrito em [references/worktrees.md](references/worktrees.md). Anote o commit base antes de disparar.

## 3. Escreva uma instrução por subagente

Os subagentes não veem sua conversa. Cada instrução é autossuficiente:

- **Escopo**: um domínio de problema — um arquivo de teste, um subsistema, o ID de uma tarefa.
- **Contexto**: as mensagens de erro exatas, nomes de testes, caminhos de arquivos e, para tarefas do plano, o texto completo da tarefa, as linhas dos requisitos e o Usa/Fornece.
- **Restrições**: o que não tocar ("não mude código de produção", "só arquivos em `src/billing/`"), e não disparar subagentes próprios.
- **Verificação**: os comandos a rodar antes de relatar.
- **Saída**: o que devolver — causa raiz, arquivos alterados, commits, resultados dos testes, questões em aberto.

Para tarefas do plano, use o prompt do implementador em `references/subagent-prompts.md` do `superfik-implement`.

Amplo demais ("corrija todos os testes") e o agente se perde; sem restrições e ele refatora tudo; sem saída exigida e você não sabe o que ele fez.

## 4. Dispare todos juntos, depois integre um por vez

Envie todos os disparos de uma vez. Enquanto rodam, prepare os próximos passos em vez de ficar consultando.

Quando voltarem:

1. Leia cada relatório. Trate as afirmações como não verificadas até olhar o diff.
2. Integre um branch por vez no branch de trabalho (merge ou cherry-pick), rodando os testes relevantes depois de cada um. Se duas partes conflitarem, pare e resolva com cuidado; as partes não eram tão independentes quanto pareciam, então registre isso em Decisões no plano.
3. Rode a suíte **completa** no resultado combinado. Partes verdes isoladamente ainda podem quebrar umas às outras.
4. Limpe as worktrees que você criou (veja [references/worktrees.md](references/worktrees.md)).

## 5. Relate

Liste cada parte: o que foi encontrado, o que mudou, quais commits e o resultado final da suíte completa. Para tarefas do plano, marque-as no `tasks.md` só depois que a suíte combinada passar.
