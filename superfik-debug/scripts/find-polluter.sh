#!/usr/bin/env bash
# Descobre qual arquivo de teste cria um arquivo ou diretório indesejado.
# Roda os arquivos de teste um de cada vez e para no primeiro depois do qual o caminho existe.
#
# Uso: bash find-polluter.sh <caminho-a-observar> <glob-dos-testes>
# Exemplo: bash find-polluter.sh '.git' 'src/**/*.test.ts'
#
# Roda cada arquivo com `npm test <arquivo>`. Mude TEST_CMD para outros runners,
# p. ex. TEST_CMD="pytest" ou TEST_CMD="npx vitest run".

set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Uso: $0 <caminho-a-observar> <glob-dos-testes>"
  echo "Exemplo: $0 '.git' 'src/**/*.test.ts'"
  exit 1
fi

WATCH="$1"
PATTERN="${2#./}"
TEST_CMD="${TEST_CMD:-npm test}"

# find -path não casa '**/' com zero diretórios, então tenta também o padrão sem ele
FILES=$(find . \( -path "./$PATTERN" -o -path "./${PATTERN//\*\*\//}" \) -not -path './node_modules/*' | sort -u)
if [ -z "$FILES" ]; then
  echo "Nenhum arquivo de teste casa com $PATTERN"
  exit 1
fi

TOTAL=$(printf '%s\n' "$FILES" | wc -l | tr -d ' ')
echo "Observando:        $WATCH"
echo "Arquivos de teste: $TOTAL"
echo

COUNT=0
for FILE in $FILES; do
  COUNT=$((COUNT + 1))
  if [ -e "$WATCH" ]; then
    echo "$WATCH já existe antes do teste $COUNT/$TOTAL; remova-o e rode de novo."
    exit 1
  fi

  echo "[$COUNT/$TOTAL] $FILE"
  $TEST_CMD "$FILE" >/dev/null 2>&1 || true

  if [ -e "$WATCH" ]; then
    echo
    echo "Encontrado: $FILE cria $WATCH"
    ls -la "$WATCH"
    exit 1
  fi
done

echo
echo "Nenhum arquivo de teste criou $WATCH."
