---
name: superfik-implement
description: Executa um plano de tarefas ou prompt salvo do Superfik - nesta sessão, com um subagente novo por tarefa e revisões, ou com tarefas independentes em paralelo - verificando cada tarefa com comandos reais antes de marcá-la. Invoque com o ID de uma tarefa, "all" ou o ID de um prompt.
argument-hint: "[id-da-tarefa | all | id-do-prompt]"
disable-model-invocation: true
metadata:
  superfik-version: "1.0.0"
---

# Implementar

Construa o que foi planejado: tarefas de `.superfik/outputs/<project>/tasks.md`, ou um prompt salvo de `.superfik/outputs/prompts/`. A regra que mais importa: **uma tarefa só está concluída quando a verificação dela passou nesta sessão e você viu a saída.**

Fale com o usuário, escreva no plano e instrua os subagentes em português do Brasil.

## 1. Escolha a fonte

Use os argumentos, se houver: o ID de uma tarefa (`2.3`) ou `all` significa modo tarefas; o ID de um prompt ou `latest` significa modo prompt.

Caso contrário, procure em `.superfik/outputs/` arquivos `*/tasks.md` com itens não marcados e prompts com `status: pending`. Um candidato óbvio: confirme. Vários: liste e pergunte. Nenhum: sugira `/superfik-plan` ou `/superfik-improve`.

Leia o plano uma vez, incluindo Restrições globais, Pontos de atenção na revisão e Decisões. Se ele citar um PRD, leia-o também: quando o plano se contradiz, o PRD decide.

## 2. Prepare

- **Workspace**: siga [references/worktrees.md](references/worktrees.md). Veja se você já está isolado; se não, ofereça uma worktree. Nunca comece em `main`/`master` sem a concordância do usuário. Rode a suíte de testes uma vez para conhecer a linha de base.
- **Commits**: pergunte se deve fazer commit depois de cada tarefa, depois de cada fase, ou não fazer (o padrão, se o usuário não se importar).
- **Modo de execução**: a menos que o usuário já tenha escolhido, recomende um e pergunte:

| Modo | Como | Quando |
|---|---|---|
| **Na sessão** | Você implementa todas as tarefas e, no fim, um revisor confere o branch inteiro | Poucas tarefas, muito ligadas entre si; o mais barato |
| **Subagentes** | Um implementador novo por tarefa, um revisor depois de cada uma, uma revisão do branch inteiro no fim | Muitas tarefas, ou erros sairiam caros; o mais cuidadoso |
| **Paralelo** | Subagentes como acima, com as tarefas independentes de uma fase rodando ao mesmo tempo, cada uma na sua worktree | Fases com várias tarefas que não compartilham arquivos nem interfaces; o mais rápido |

Antes de começar, percorra o plano atrás de tarefas que se contradizem ou contradizem as Restrições globais. Resolva cada caso com base no PRD e registre na seção **Decisões** do plano.

## 3. Execute as tarefas

O formato das tarefas está em [references/tasks-format.md](references/tasks-format.md). Qualquer que seja o modo, cada tarefa passa pelo mesmo ciclo:

1. **Leia** a tarefa, os requisitos do PRD a que ela se liga, o Usa/Fornece e os arquivos que ela cita. Confira se as dependências estão concluídas. Quando a tarefa toca interface, leia também [references/interface-craft.md](references/interface-craft.md) e, se houver, a referência aprovada em `.superfik/outputs/<project>/prototype/`: o protótipo decide a direção e a referência de craft decide os valores.
2. **Teste primeiro** quando ela muda comportamento e o projeto tem testes: veja [references/test-first.md](references/test-first.md).
3. **Implemente** seguindo os padrões que o plano registrou. Fique dentro da tarefa; anote qualquer outra coisa para o final.
4. **Verifique**: rode a verificação de "Pronto quando" da tarefa e os comandos de teste/typecheck/lint do projeto, e leia a saída.
5. **Se falhar**, encontre a causa (veja `/superfik-debug`), corrija e rode a verificação de novo. Depois de três tentativas sem sucesso na mesma falha, pare e leve o caso ao usuário com o que você tentou.
6. **Marque** (`- [ ]` → `- [x]`) só depois que a verificação passar, faça commit se combinado e relate numa linha: ID da tarefa, o que mudou, a verificação que passou.

Uma tarefa que não pode ser feita (credencial faltando, requisito pouco claro, o plano está errado sobre o código): marque-a `- [~]` com uma linha `Bloqueada:` e passe para a próxima tarefa que não dependa dela. Quando o plano estiver um pouco errado sobre o código, adapte da menor forma razoável e registre em Decisões.

Siga de uma tarefa para a outra sem perguntar "posso continuar?". Pare só diante de: algo irreversível ou destrutivo, algo sensível do ponto de vista de segurança, um efeito fora deste workspace (push, merge, publicação, mandar mensagem para alguém) ou um plano tão quebrado que qualquer caminho seria um chute.

### Modo subagentes

Para cada tarefa:

1. Anote o commit base (`git rev-parse HEAD`).
2. Dispare um implementador com o prompt de [references/subagent-prompts.md](references/subagent-prompts.md): o texto completo da tarefa, as linhas dos requisitos, o Usa/Fornece, as Decisões relevantes e os comandos de verificação. Para uma tarefa de interface, inclua os caminhos da referência do protótipo aprovado e do `references/interface-craft.md` deste skill. Nunca a conversa inteira nem o plano inteiro. Escolha o modelo por tarefa: um rápido para tarefas mecânicas e totalmente especificadas; um mais forte para tarefas que exigem julgamento em vários arquivos.
3. Responda às perguntas dele, se houver. Se ele disser que está bloqueado, mude algo antes de tentar de novo (mais contexto, um modelo mais forte, uma tarefa menor).
4. Dispare um revisor da tarefa com o diff a partir do commit base (`git diff <base>..HEAD`) e o texto da tarefa. Ele devolve um veredito de especificação e um de qualidade.
5. Achados críticos ou importantes voltam para o implementador, seguidos de uma nova revisão da correção. Depois de três rodadas, use um implementador novo com um modelo mais forte; depois de cinco, decida você: registre cada achado restante em Decisões como adiado, com o motivo, ou decida pela menor mudança que destrava as tarefas seguintes.
6. Achados menores vão para Decisões, para a revisão final; eles não bloqueiam a tarefa.

Não corrija achados você mesmo na sessão coordenadora, e não deixe os implementadores dispararem seus próprios revisores.

### Modo paralelo

Dentro de uma fase, agrupe as tarefas que não têm `Depende de`, não compartilham arquivos e não têm vínculo Usa/Fornece entre si. Rode cada grupo com o `/superfik-parallel`: um implementador por tarefa, cada um na sua worktree; depois revise cada tarefa como no modo subagentes, integre os branches um de cada vez e rode a suíte completa no resultado combinado antes de marcar as tarefas. Tarefas que compartilham qualquer coisa rodam uma depois da outra.

## 4. Revisão do branch inteiro

Depois da última tarefa, dispare um revisor com o modelo mais capaz, passando o diff completo desde onde o branch começou (`git diff $(git merge-base <base> HEAD)..HEAD`), o PRD, o plano e as Decisões. Ele confere o que as revisões por tarefa não conseguem: como as peças se encaixam, os Pontos de atenção na revisão e os achados adiados que precisam ser corrigidos antes do merge. Mande todos os achados para um único corretor, revise essa correção uma vez e registre o que sobrar em Decisões.

## 5. Modo prompt

Leia o prompt salvo, confirme qual está executando e trate a seção "Pronto quando" dele como a verificação. Implemente e verifique do mesmo jeito, e ponha `status: done` no frontmatter do prompt.

## 6. Conclua

Resuma: tarefas concluídas (com IDs), o que ficou bloqueado e cada entrada que você acrescentou em Decisões, para que o usuário veja as escolhas feitas em nome dele. Depois sugira o próximo passo:

> As 11 tarefas estão concluídas; testes e typecheck passam. Próximo passo: `/superfik-verify` para auditar contra o PRD, depois `/superfik-finish` para fazer o merge ou abrir um PR.
