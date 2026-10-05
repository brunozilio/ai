# Teste primeiro

Quando uma mudança altera comportamento e o projeto tem testes, escreva o teste antes do código. Um teste que você nunca viu falhar não prova nada: ele pode estar testando a coisa errada, ou nada.

Pule o teste primeiro apenas em spikes descartáveis, código gerado e configuração pura, e diga isso quando pular.

## O ciclo

1. **Vermelho.** Escreva um teste pequeno para um comportamento, com o nome do comportamento (`rejeita e-mail vazio`, não `test1`). Use código real; faça mock só do que não dá para executar (rede, relógio, APIs pagas).
2. **Veja falhar.** Rode só esse teste. Ele precisa falhar, e pelo motivo esperado: o comportamento não existe. Se passar, está testando algo que já existe; corrija o teste. Se der erro (typo, import), corrija e rode de novo até falhar do jeito certo.
3. **Verde.** Escreva o código mais simples que o faça passar. Sem opções extras, sem refatorar o código vizinho, nada que o teste não peça.
4. **Veja passar**, depois rode o comando de testes completo do projeto, não só o seu arquivo. Qualquer falha nessa execução entra no seu relatório pelo nome, mesmo uma que você não causou.
5. **Refatore** só enquanto estiver verde: remova duplicação, melhore nomes. Rode os testes de novo.

Então o próximo comportamento ganha o próximo teste falhando.

## Testes honestos

- Antes de escrever um teste, diga qual mudança no código de produção o faria falhar. Se não conseguir, o teste não verifica nada.
- Faça asserções sobre resultados que o usuário ou quem chama o código vê, não sobre qual mock foi chamado.
- Um comportamento por teste. Um "e" no nome significa dois testes.
- Mantenha helpers exclusivos de teste no código de teste, nunca em classes de produção.
- Entenda os efeitos colaterais de uma dependência antes de fazer mock dela; um mock que pula um efeito colateral de que o código depende faz o teste mentir.
- Troque esperas fixas por esperar a condição de que você realmente precisa (um estado, um evento, um arquivo). Atrasos fixos passam na sua máquina e falham na CI.

## Quando o código já existe

Se você escreveu o código antes do teste, não cole um teste nele e dê por encerrado: um teste escrito contra código pronto tende a confirmar o que o código faz, não o que ele deveria fazer. Escreva o teste como se o código não existisse, veja-o falhar numa versão sem a mudança (use stash ou reverta), depois restaure o código.

## Correções de bug

Toda correção de bug começa com um teste que reproduz o bug e falha. Ele vira o teste de regressão.
