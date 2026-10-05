# Critérios de revisão

Checklists para cada foco de revisão. A severidade entre colchetes é um ponto de partida; aumente ou diminua conforme o impacto real nesta base de código.

## Segurança

- Toda rota ou handler que exige autenticação a verifica, e as checagens de permissão acontecem antes de ações sensíveis [crítico]
- Entradas não confiáveis são validadas na fronteira; as consultas são parametrizadas; entrada do usuário nunca monta comandos de shell, caminhos de arquivo ou HTML sem escape [crítico]
- Nenhuma credencial, token ou chave em código, configuração ou logs [crítico]
- Endpoints que mudam estado são protegidos contra CSRF quando cookies carregam a sessão [grave]
- Respostas de erro não expõem stack traces, SQL ou identificadores internos [grave]
- Dependências novas são mantidas e livres de vulnerabilidades conhecidas [grave]

Sinais de alerta: `eval` ou código dinâmico com dados do usuário, SQL montado com strings, `innerHTML`/`dangerouslySetInnerHTML` com conteúdo não sanitizado, segredos em testes ou fixtures.

## Arquitetura

- A mudança segue os padrões já usados para o mesmo tipo de código (onde ficam acesso a dados, validação e efeitos colaterais) [grave]
- Camadas não são puladas: a UI não consulta o banco, handlers não contêm regras de negócio que o resto do código mantém em outro lugar [grave]
- Módulos novos têm uma responsabilidade clara; nenhuma dependência circular introduzida [menor]
- Dependências são injetadas onde a base de código faz isso, para o código continuar testável [menor]

Sinais de alerta: um handler que cresce centenas de linhas, cópias de um helper existente com pequenas mudanças, uma abstração nova usada uma única vez.

## Padrões

- Os nomes dizem o que as coisas são e fazem; seguem o vocabulário do código ao redor [menor]
- Nenhuma lógica duplicada que deveria usar uma função existente [grave]
- Mensagens de erro dizem ao leitor o que deu errado e o que fazer [menor]
- Logs usam o logger e os níveis do projeto, e nunca incluem dados pessoais ou segredos [grave]
- Nada de código morto, blocos comentados, saída de debug esquecida ou TODOs sem referência de acompanhamento [menor]

## Desempenho

- Nenhuma chamada ao banco ou à rede dentro de um loop sobre uma coleção que pode crescer (N+1) [grave]
- Listas que podem crescer são paginadas ou limitadas [grave]
- Conexões, arquivos, timers e assinaturas são liberados em todos os caminhos, inclusive de erro [grave]
- Nenhum I/O bloqueante em caminhos de requisição ou na thread da UI [grave]
- Resultados caros pedidos repetidamente ficam em cache onde a base de código já usa cache [menor]

## Testes

- Comportamento novo tem testes, incluindo os caminhos de falha [grave]
- Os testes verificam resultados, não detalhes de implementação ou apenas mocks [menor]
- Os casos de borda citados nos requisitos estão cobertos [menor]
- Os testes são independentes e determinísticos: sem dependência de ordem, relógio real ou rede ao vivo [menor]

Sinais de alerta: testes sem asserções, snapshots que ninguém revisou, um endpoint novo sem nenhum teste.

## Documentação

- APIs públicas, opções de configuração e flags de CLI adicionadas ou alteradas estão documentadas [menor]
- Mudanças incompatíveis são sinalizadas, com o que os usuários precisam fazer [grave]

## Interface (mudanças de UI)

Os gatilhos de escalação de `interface-craft.md` são críticos à primeira vista; os princípios por domínio dão os valores exatos das correções. Leia o lado removido do diff: um `aria-label`, um `:focus-visible` ou um `prefers-reduced-motion` que sumiram sem substituto são regressões, e valem mais que um erro novo do mesmo tamanho. Diga se cada achado foi introduzido pela mudança, é uma regressão ou já existia; só os dois primeiros entram na recomendação.

- Todo controle interativo tem nome acessível, funciona pelo teclado e mostra foco visível [crítico]
- Motion respeita `prefers-reduced-motion`; nenhum estado depende só de cor ou só de animação [crítico]
- Nada corta ou se sobrepõe a 320px de largura ou 200% de zoom; conteúdo truncado continua alcançável [crítico]
- O contraste do par renderizado atende ao WCAG AA; cor semântica usada no próprio significado [crítico]
- Uma variante, tamanho ou tema nova cobre todos os estados (hover, foco, ativo, desabilitado, carregando, vazio, erro) [grave]
- Texto novo segue a voz e a terminologia do produto; erros dizem como corrigir [grave]
- Tokens e passos de espaçamento do projeto em vez de valores soltos; raios aninhados concêntricos [menor]
- Transições nomeiam propriedades exatas, só `transform` e `opacity`, `ease-out`, abaixo de 300ms [menor]

Sinais de alerta: `div` com `onClick`, `outline: none`, `transition: all`, `scale(0)`, `ease-in`, `margin-left` em layout localizável, placeholder como único rótulo. O que depende de runtime e você não conseguiu renderizar é **Não verificado**, não um achado.
