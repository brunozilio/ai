---
name: superfik-plan
description: Transforma um PRD do Superfik num plano de implementação em fases (tasks.md) com caminhos de arquivo reais, interfaces entre tarefas, passos com teste primeiro, vínculos com requisitos e uma verificação por tarefa. Use depois que um PRD for aprovado e o usuário quiser a divisão em tarefas, um plano de implementação ou um roadmap para construí-lo.
argument-hint: "[projeto]"
metadata:
  superfik-version: "1.0.0"
---

# Planejar a implementação

Leia o PRD e a base de código, depois escreva `.superfik/outputs/<project>/tasks.md` no formato descrito em [references/tasks-format.md](references/tasks-format.md). Este skill produz o plano; o `/superfik-implement` o executa.

Converse com o usuário e escreva o plano em português do Brasil.

## 1. Encontre o PRD

Procure `.superfik/outputs/<project>/prd.md`. Se houver vários projetos, pergunte qual. Se não houver PRD, diga isso e sugira o `/superfik-prd`, ou ofereça planejar direto a partir de requisitos que o usuário passar agora.

Se o PRD cobrir vários subsistemas independentes, sugira um plano por subsistema; cada plano deve produzir software funcionando e testável por si só.

Procure também `.superfik/outputs/<project>/prototype.md`. Com `status: approved`, leia-o e o arquivo de referência em `prototype/`: a variante aprovada fixa a direção da interface (estrutura, densidade, ênfase, voz) e os valores que ela usa. Se o PRD tem interface e não há protótipo aprovado, diga uma vez que o `/superfik-prototype` existe e siga com o plano.

Se o `tasks.md` já existir, não o sobrescreva em silêncio. Pergunte se deve atualizá-lo (mantendo IDs, itens concluídos e Decisões; acrescentando ou ajustando o resto) ou substituí-lo.

## 2. Conheça a base de código

Um plano só é tão bom quanto seus caminhos de arquivo. Descubra:

- **Stack e versões** pelos manifestos e lockfiles
- **Estrutura e convenções**: onde ficam funcionalidades, componentes, serviços, testes e tipos; como os arquivos são nomeados
- **Padrões em uso**: gerenciamento de estado, estilos, acesso a dados, validação, tratamento de erros. Abra um ou dois arquivos representativos de cada área que o PRD toca.
- **Comandos de verificação**: teste, typecheck, lint, build (de scripts, Makefile, configuração de CI)
- **Peças reaproveitáveis**: componentes, helpers ou serviços existentes que as tarefas devem usar em vez de recriar

Num repositório grande, delegue esse levantamento a um subagente (Claude Code e Codex suportam) e peça que ele devolva os fatos acima com caminhos, para que o conteúdo bruto dos arquivos não encha seu contexto.

Só cite diretórios e bibliotecas que você realmente viu. Se o projeto for novo ou vazio, diga isso e faça a primeira fase montar a estrutura.

## 3. Mapeie os arquivos

Antes de escrever as tarefas, decida quais arquivos serão criados ou alterados e pelo que cada um responde. Prefira arquivos pequenos com uma função clara; mantenha juntas as coisas que mudam juntas; siga a estrutura existente da base de código em vez de reestruturá-la. É neste mapa que o design se fixa, e as tarefas decorrem dele.

## 4. Escreva o plano

- **Restrições globais**: copie as regras do PRD que valem para o projeto todo, com os valores exatos (versões, limites, nomes, textos). Toda tarefa as inclui implicitamente.
- **Fases** que deixam, cada uma, o projeto funcionando. Dentro de uma fase: tipos e schemas, acesso a dados, APIs, UI, acabamento.
- **Tarefas**, cada uma com: um ID estável; os IDs de requisitos que atende; arquivos reais; **Usa/Fornece** (os nomes e assinaturas exatos compartilhados com outras tarefas, porque o implementador só vê a sua tarefa); uma linha **Teste primeiro** quando o comportamento muda e o projeto tem testes (veja [references/test-first.md](references/test-first.md)); a decisão que o implementador não consegue tomar sozinho; um comando **Pronto quando**.
- **Tarefas de interface**: quando há um protótipo aprovado, cite a referência em `prototype/` nos Arquivos da tarefa e copie para o passo Fazer os valores exatos que ela fixou (tokens, espaçamentos, textos, estados). A tarefa implementa a direção aprovada com os testes e as convenções do projeto; o protótipo não é copiado para produção como está. Sem protótipo, aponte [references/interface-craft.md](references/interface-craft.md) como referência de craft para o implementador.
- **Pontos de atenção na revisão**: até cinco entradas ou modos de falha que o PRD implica mas que os testes de nenhuma tarefa exercitariam, os que mais provavelmente prejudicam um usuário (entrada vazia, envio duplicado, rede lenta, arquivo muito grande). Para cada um, adicione o teste à tarefa dona daquele código.

Escreva decisões, não código. Um passo nomeia a assinatura, a biblioteca, os valores e o teste; o implementador escreve o corpo. Inclua código só para um algoritmo que a assinatura e o teste não determinam.

## 5. Revise seu próprio plano

Antes de mostrá-lo, confira com o PRD aberto:

1. **Cobertura**: todo requisito corresponde a uma tarefa. Acrescente as que faltarem.
2. **Passos**: cada passo leva a exatamente uma implementação razoável. Corrija linhas que não decidem nada ("tratar casos de borda", "adicionar validação") e corpos de código que a assinatura e o teste já determinam.
3. **Consistência**: nomes, tipos e assinaturas batem entre as tarefas (`clearLayers()` em 1.3 não é `clearAllLayers()` em 2.1).
4. **Pontos de atenção**: cada item tem um teste na tarefa dona dele.
5. **Proporção**: se o plano for várias vezes mais longo que o PRD, ou for principalmente código, corte até sobrarem as decisões.
6. **Independência**: marque `Depende de` sempre que uma tarefa precisar do resultado de outra, para que a execução em paralelo seja segura.

Corrija o que encontrar diretamente; não precisa de segunda passada.

## 6. Entregue

Salve o plano e dê uma visão geral curta: fases, número de tarefas, a stack que você detectou, requisitos que não conseguiu planejar e quantas tarefas poderiam rodar em paralelo. Peça ao usuário que revise o plano e escolha como executá-lo, com sua recomendação:

> Plano salvo em `.superfik/outputs/<project>/tasks.md`: 3 fases, 11 tarefas, todos os requisitos Obrigatórios cobertos, 4 tarefas podem rodar em paralelo. Planejei com base em Next.js 15 App Router, Drizzle e Tailwind; confere?
>
> Como devo executar? **Na sessão** (mais barato), **subagentes** com revisão depois de cada tarefa (mais cuidadoso) ou **paralelo** para tarefas independentes (mais rápido). Recomendo subagentes: as tarefas 2.x compartilham as interfaces de cobrança, e um erro ali seria caro de encontrar depois. Rode `/superfik-implement` quando estiver pronto.

Registre o modo escolhido em Decisões no `tasks.md` para que o `/superfik-implement` o use.
