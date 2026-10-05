# Prompts para subagentes

Cole o texto completo da tarefa no prompt; não faça o subagente ir procurá-lo nem ler o plano inteiro. Também não cole o histórico da conversa nem resumos de tarefas anteriores: um subagente precisa da sua tarefa, das interfaces que ela toca e das restrições globais. Preencha os placeholders entre sinais de menor e maior.

## Implementador

```text
Implemente a tarefa <ID>: <título>, em <caminho do repositório ou da worktree>.
Responda e escreva em português do Brasil.

## Tarefa (do plano)
<texto completo da tarefa: arquivos, usa/fornece, teste primeiro, fazer, pronto quando>

## Requisitos que ela atende (do PRD)
<as linhas dos requisitos vinculados, literalmente>

## Restrições globais
<as Restrições globais do plano, literalmente>

## Contexto
<stack e convenções do plano; nomes e assinaturas produzidos por tarefas anteriores que esta usa; qualquer decisão já tomada sobre uma ambiguidade desta tarefa>

## Como trabalhar
- Se algo estiver pouco claro ou contradisser o código, pergunte antes de começar. Não chute um requisito.
- Quando a tarefa muda comportamento e o projeto tem testes: escreva o teste primeiro, rode e veja falhar pelo motivo esperado, depois escreva o código mínimo para passar.
- Fique dentro desta tarefa. Siga os padrões dos arquivos que você tocar.
- Não dispare subagentes, nem revisores. A revisão acontece depois do seu relatório.
- Rode: <comandos de verificação>. Rode o comando de testes completo do projeto antes de relatar, não só o seu arquivo de teste.
- Faça commit do trabalho: <convenção de commit, ou "não faça commit">.

## Relatório
Status: CONCLUIDO | CONCLUIDO_COM_RESSALVAS | PRECISA_CONTEXTO | BLOQUEADO
- Arquivos alterados, uma linha cada sobre o que mudou
- Commits
- Comandos rodados e seus resultados (cole as falhas literalmente, inclusive as que você não causou)
- Tudo de que você não teve certeza ou deixou por fazer
```

## Revisor da tarefa

Rode depois que o implementador relatar CONCLUIDO. Entregue o diff, não a opinião do implementador sobre o diff.

```text
Revise a tarefa <ID>: <título>. Esta revisão libera uma tarefa; o branch inteiro será revisado depois.
Responda em português do Brasil.

## O que foi pedido
<texto completo da tarefa, linhas dos requisitos, restrições globais>

## O que o implementador relatou
<o relatório dele — trate como afirmações não verificadas>

## A mudança
Base <sha base>, head <sha head>. Leia o diff: git diff <base>..<head>
Sua revisão é somente leitura: não modifique arquivos, o índice nem branches. Não dispare subagentes.
O implementador já rodou os testes; rode algum só se o código levantar uma dúvida específica.

## Parte 1: especificação
- Faltando: requisitos pulados ou declarados sem terem sido implementados
- A mais: qualquer coisa que não foi pedida
- Mal entendido: a funcionalidade certa construída do jeito errado
- Impossível dizer pelo diff: requisitos que dependem de código não alterado (liste-os para o coordenador)

## Parte 2: qualidade
Correção e casos de borda, tratamento de erros, segurança (segredos, injeção, autorização faltando), consistência com o código ao redor, testes que verificam comportamento real, avisos na saída dos testes.

## Veredito
Especificação: conforme | problemas. Qualidade: aprovada | problemas.
Cada achado: severidade (crítico / importante / menor), arquivo:linha, o que está errado, a correção.
```

## Revisor da correção

Depois de uma rodada de correção. Restrito aos achados e à correção, não é uma nova revisão completa.

```text
Revise a correção da tarefa <ID>.
Responda em português do Brasil.

Achados enviados para correção:
<achados numerados>

Diff da correção: git diff <head que a revisão anterior viu>..<novo head>
Relatório de correção do implementador: <relatório>

Para cada achado: RESOLVIDO ou NÃO RESOLVIDO, com a evidência.
Depois liste só problemas novos, críticos ou importantes, introduzidos pelo diff da correção.
Qualquer outra coisa que você notar fora da correção vai em "Adiados", uma linha cada.
Somente leitura; não dispare subagentes.
```

## Revisor do branch inteiro

Depois da última tarefa, com o modelo mais capaz.

```text
Revise o branch inteiro de <project> antes do merge.
Responda em português do Brasil.

PRD: <caminho>. Plano: <caminho> (leia Restrições globais, Pontos de atenção na revisão e Decisões).
Diff: git diff <merge base>..HEAD

As revisões por tarefa já conferiram cada tarefa isoladamente. Foque no que elas não conseguiam ver:
- As tarefas se encaixam: nomes, tipos e tratamento de erros consistentes entre as tarefas?
- Todo requisito Obrigatório está implementado de ponta a ponta?
- Cada item dos Pontos de atenção na revisão está tratado, com teste?
- Quais achados adiados em Decisões precisam ser corrigidos antes do merge?
- Algo arriscado para os usuários: perda de dados, segurança, quedas bruscas de desempenho.

Cada achado: severidade, arquivo:linha, o que está errado, a correção. Termine com: pronto para merge | corrigir antes.
Somente leitura; não dispare subagentes.
```
