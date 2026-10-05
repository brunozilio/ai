# Rastreamento da causa raiz

Bugs muitas vezes aparecem longe de onde começam: um arquivo criado no diretório errado, um banco de dados aberto com o caminho errado, `git init` rodando na árvore de código-fonte. Corrigir a linha onde o erro aparece trata o sintoma. Rastreie para trás até achar o que produziu o valor errado, e corrija lá.

## Passos

1. **Observe o sintoma.** `Error: git init failed in ~/project/packages/core`
2. **Encontre a causa imediata.** O código que fez isso: `execFile('git', ['init'], { cwd: projectDir })`
3. **Pergunte quem chamou, e com o quê.** `WorktreeManager.create(projectDir)` ← `Session.initialize()` ← `Session.create()` ← um teste.
4. **Continue subindo.** `projectDir` era `''`, e um `cwd` vazio significa "diretório atual", que era a árvore de código-fonte.
5. **Encontre a origem.** O teste lia `context.tempDir` no carregamento do módulo, antes de o `beforeEach` defini-lo.

Corrija na origem (faça `tempDir` lançar um erro se for lido cedo demais), depois considere proteções nas camadas intermediárias (veja `defense-in-depth.md`).

## Quando não dá para seguir só lendo

Acrescente instrumentação temporária logo antes da operação perigosa, não depois que ela falha:

```ts
console.error('DEBUG git init', {
  directory,
  cwd: process.cwd(),
  env: process.env.NODE_ENV,
  stack: new Error().stack,
});
```

- Em testes, escreva direto no stderr; o logger da aplicação pode estar silenciado.
- Inclua as entradas, o diretório de trabalho e o ambiente relevante.
- Rode e filtre: `npm test 2>&1 | grep 'DEBUG git init'`. Veja quais arquivo de teste e linha aparecem nas pilhas.

Remova a instrumentação depois de achar a causa.

## Qual teste deixa estado para trás

Se um arquivo ou diretório aparece durante a execução dos testes e você não sabe qual teste o cria, o `scripts/find-polluter.sh` roda os arquivos de teste um de cada vez e para no primeiro que o cria:

```bash
bash scripts/find-polluter.sh '.git' 'src/**/*.test.ts'
```

Ele roda `npm test <arquivo>`; edite essa linha para outros runners.
