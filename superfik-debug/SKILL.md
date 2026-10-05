---
name: superfik-debug
description: Encontra a causa raiz de um bug, teste falhando, falha de build ou comportamento inesperado antes de mudar qualquer código, depois corrige com um teste de regressão. Use sempre que algo estiver quebrado ou se comportar de forma inesperada, antes de propor uma correção - principalmente sob pressão de tempo ou depois que uma correção já falhou.
argument-hint: "[sintoma ou teste falhando]"
metadata:
  superfik-version: "1.0.0"
---

# Depurar de forma sistemática

Descubra por que está quebrado antes de mudar qualquer coisa. Uma correção sem explicação é um chute, e chutes se acumulam: cada um acrescenta uma mudança, esconde a causa real e torna a próxima falha mais difícil de ler. Isso é mais rápido que tentativa e erro, inclusive para bugs que parecem simples.

Fale com o usuário em português do Brasil.

Passe por quatro fases, em ordem.

## 1. Investigue

- **Leia o erro inteiro.** Stack traces, números de linha, códigos de erro e avisos muitas vezes apontam o problema exato.
- **Reproduza.** Encontre passos exatos que o disparam toda vez. Se não conseguir reproduzir, reúna mais dados; não chute.
- **Veja o que mudou.** `git log`, `git diff`, dependências atualizadas recentemente, configuração, ambiente.
- **Encontre onde quebra em sistemas com várias partes.** Quando os dados atravessam vários componentes (CI → script de build → assinatura, API → serviço → banco de dados), acrescente logs temporários em cada fronteira — o que entra, o que sai, qual configuração está visível —, rode uma vez e veja qual fronteira está errada. Depois investigue esse componente.
- **Rastreie para trás.** Quando o erro aparece fundo na pilha de chamadas, siga o valor errado para cima pelos chamadores até onde ele foi criado, e corrija lá. Veja [references/root-cause-tracing.md](references/root-cause-tracing.md).

## 2. Compare

- Encontre código parecido no mesmo projeto que funciona.
- Se estiver aplicando um padrão conhecido, leia a implementação de referência inteira.
- Liste todas as diferenças entre a versão que funciona e a quebrada, inclusive as que "não podem importar".
- Anote do que o código quebrado depende: configuração, ambiente, ordem de execução, estado compartilhado.

## 3. Teste uma hipótese por vez

- Enuncie: "Acho que X é a causa porque Y."
- Faça a menor mudança que confirmaria ou refutaria a hipótese — uma variável.
- Confirmada: vá para a fase 4. Refutada: forme uma hipótese nova com o que aprendeu. Não empilhe uma segunda mudança sobre a primeira.
- Se não entender algo, diga isso e investigue ou pergunte. Não finja.

## 4. Corrija

1. **Escreva um teste que falha reproduzindo o bug** — automatizado se o projeto tem testes, um script pequeno se não. Veja [references/test-first.md](references/test-first.md).
2. **Faça uma única mudança** que ataque a causa raiz. Nada de melhorias "já que estou aqui".
3. **Verifique**: o teste novo passa, a suíte completa passa, o sintoma original sumiu.
4. Se dados inválidos causaram o bug, considere validar em cada camada por onde eles passam, para que o bug fique impossível, e não só corrigido. Veja [references/defense-in-depth.md](references/defense-in-depth.md).

### Quando as correções continuam falhando

Conte suas tentativas. Depois de uma correção que falhou, volte à fase 1 com o que aprendeu. **Depois de três correções que falharam, pare.** Quando cada correção expõe um problema novo em outro lugar, o problema costuma ser o design, não o sintoma mais recente. Diga ao usuário o que tentou, o que cada tentativa revelou e o que você acha que está estruturalmente errado, e decidam juntos antes de tentar de novo.

## Casos especiais

- **Testes instáveis ou dependentes de tempo**: troque esperas fixas por esperar a condição real; veja o item sobre esperas em [references/test-first.md](references/test-first.md).
- **Um teste deixa arquivos ou estado para trás** e você não sabe qual: `bash scripts/find-polluter.sh <caminho-que-aparece> '<glob dos testes>'` roda os arquivos de teste um a um até o culpado aparecer.
- **Várias falhas independentes** (arquivos diferentes, subsistemas diferentes): investigue-as em paralelo com o `/superfik-parallel`.
- **Realmente do ambiente** (serviço externo, tempo que você não controla): documente o que descartou, acrescente tratamento (retry, timeout, erro claro) e logs para a próxima vez. A maioria das conclusões "sem causa raiz" são investigações incompletas, então tenha certeza antes.

## Sinais de que você está chutando

"Correção rápida agora, investigo depois." "Deixa eu só tentar mudar X." Várias mudanças antes de rodar os testes. Propor uma correção antes de rastrear os dados. "Mais uma tentativa" depois de duas falhas. Quando notar esses sinais, volte à fase 1.

## Conclua

Relate a causa raiz em uma ou duas frases, a correção, o teste de regressão e a saída da verificação. Depois sugira o `/superfik-verify` se o bug pertencia a um projeto planejado, ou o `/superfik-finish` para integrar a correção.
