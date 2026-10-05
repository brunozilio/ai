# Defesa em profundidade

Depois de corrigir um bug causado por dados inválidos, uma verificação na origem parece suficiente. Mas outros caminhos do código, uma refatoração futura ou um mock podem contorná-la. Quando a consequência de dados ruins é séria (apagar arquivos, gravar no lugar errado, corromper registros), valide em cada camada por onde os dados passam, para que o bug fique impossível e não apenas corrigido.

## Camadas

1. **Ponto de entrada**: rejeite na fronteira entradas obviamente inválidas.

   ```ts
   function createProject(name: string, dir: string) {
     if (!dir.trim()) throw new Error('dir não pode ser vazio');
     if (!existsSync(dir)) throw new Error(`dir não existe: ${dir}`);
   }
   ```

2. **Regra de negócio**: confira se os dados fazem sentido para esta operação específica.

   ```ts
   function initializeWorkspace(projectDir: string) {
     if (!projectDir) throw new Error('projectDir é obrigatório para inicializar um workspace');
   }
   ```

3. **Proteções de ambiente**: recuse operações perigosas em contextos em que elas nunca deveriam acontecer.

   ```ts
   if (process.env.NODE_ENV === 'test' && !resolve(dir).startsWith(resolve(tmpdir()))) {
     throw new Error(`Recusando git init fora do diretório temporário durante os testes: ${dir}`);
   }
   ```

4. **Diagnóstico**: registre o contexto logo antes da operação, para que a próxima falha seja rápida de rastrear.

## Quanto

Nem todo bug precisa de quatro camadas. Use o bom senso: quanto mais destrutiva ou silenciosa a falha, mais camadas. Acrescente um teste para cada proteção, para que ela não seja removida depois como código morto.
