---
name: i18n
description: Todo texto que uma pessoa ou um modelo lê no Superfik vem de um catálogo i18next. Use ao escrever ou mudar qualquer texto de tela, erro, aviso, e-mail, prompt de LLM ou mensagem de agente, em `web/` ou `src/`, e ao revisar código que mostra texto.
---

# Texto vem do catálogo

Em 2026-10-20 o Bruno percebeu que nenhum texto tinha i18n e que corrigir isso seria "um grande trabalho".
Esta skill existe para que todo texto novo já nasça no catálogo.

## A regra

Toda frase que uma pessoa ou um modelo lê sai de um **catálogo**: `locales/<idioma>/<namespace>.json`. O código
guarda só a chave. Hoje só existe `pt-BR`; `en` e `es` virão como pastas novas com os mesmos arquivos. Enquanto
houver um idioma só, não existe seletor de idioma na tela.

O texto dentro do catálogo segue a `heyrico-design`: curto, nas palavras de quem usa. Esta skill diz onde o
texto mora; a outra, o que ele diz.

## Web (`web/src/i18n`)

- Catálogos em `web/src/i18n/locales/pt-BR/`, um namespace por área: `auth`, `map`, `chat`, `decisions`,
  `agents`, `apps`, `settings`, `shell`, mais `common` (o que se repete em várias áreas) e `errors` (erros que
  o próprio web cria: API fora do ar, códigos do Better Auth). Namespace novo entra em `resources` em
  `web/src/i18n/index.ts`.
- Componente: `const { t } = useTranslation('map')` e `t('empty.title')`; de outro namespace,
  `t('common:retry')`. Frase com marcação no meio (link, negrito): `<Trans>`.
- Fora de componente (helpers, hooks de mutação): `import i18n from '@/i18n'` e `i18n.t('errors:unavailable')`,
  sempre dentro de uma função.
- Data, hora, número, lista e dinheiro com `i18n.language` (veja `web/src/lib/format.ts`), nunca `'pt-BR'`
  escrito no componente.
- Erros da API chegam já no idioma da pessoa (o cliente manda `Accept-Language`): mostre `error.message`. O web
  só traduz o que ele mesmo gera.

## API (`src/shared/i18n`)

- Catálogos em `src/shared/i18n/locales/pt-BR/`: `errors` (padrão), `rules`, `apps`, `agents`, `org`,
  `sessions`, `approvals`, `settings`, `market`, `privacy`, `email`.
- `import { t } from '../../shared/i18n'` e `t('agents:notFound')`. O `t` responde no idioma da requisição
  (`Accept-Language`, guardado por `requestLocale` num `AsyncLocalStorage`). Trabalho que ninguém pediu numa
  requisição própria (gatilho, rotina, resposta do worker, alerta, prazo de pergunta, mensagem que chega por WhatsApp ou Instagram) roda no **idioma da empresa** (`organization.locale`,
  gravado de quem criou a empresa): `inCompanyLocale(organizationId, fn)` de `src/modules/org/company-locale.ts`.
  Fora disso, `DEFAULT_LOCALE`.
- Erro: `throw new DomainError('NOT_FOUND', t('agents:notFound'))`. O `code` continua estável e em inglês; só a
  frase vem do catálogo.
- **LLM:** prompts e instruções ao modelo moram no catálogo do módulo que os usa, sob a chave `prompt`
  (`t('rules:prompt.interpret')`). Prompt longo é um array de linhas (o i18next junta com `\n`). Descrições de ferramentas que o modelo lê também são texto de catálogo.

## A armadilha: `t()` cedo demais

`t()` chamado no topo de um módulo roda uma vez, no import, e congela a frase no idioma padrão. Chame `t()` na
hora em que a frase é usada: dentro do componente, da função ou do handler. Constantes de texto viram funções
(`const reasons = () => ({ … t(…) … })`). Mensagem de schema zod usa a forma preguiçosa:
`z.string().min(1, { error: () => t('org:nameRequired') })`.

## Como escrever

- Variáveis por interpolação, `t('people.invited', { email })`. A frase vai inteira para o catálogo; pedaços
  colados com `+` ou template quebram em outro idioma, que muda a ordem das palavras.
- Plural pelo i18next: chaves `_one` / `_other` e `t('tasks', { count })`.
- Chaves semânticas em camelCase, aninhadas por componente ou tela: `decisions.refuse.confirm`.
- `aria-label`, `title`, `placeholder`, `alt`, texto de toast e de `<title>` também são texto de catálogo.

## O código é em inglês

Só o **valor** do catálogo é português. Rota (`/settings/company`), componente, variável, chave de catálogo, valor
guardado ou de enum (`needs_approval`, `mon`), campo de evento (`{{subject}}`), chave JSON que o modelo lê ou
escreve, argumento de ferramenta e exportação: inglês. "É um código estável" não é motivo para ficar em
português.

## Fica fora do catálogo

Exportações (CSV e JSON da auditoria, do resumo e dos dados da empresa e da conta: cabeçalhos, chaves, nomes de arquivo, linhas fixas), sempre em inglês. Logs, comentários, nomes de testes, códigos de erro, descrições do OpenAPI e das ferramentas MCP (documentação em
inglês para quem integra), o `<noscript>` de `web/index.html` (aparece justamente quando o JavaScript não roda) e o
que a própria pessoa escreveu (nome de área, de agente, mensagens do chat).

## Testes

Os testes procuram a frase real em português (`getByRole('button', { name: 'Salvar' })`): `pt-BR` é o padrão e o
setup carrega o i18n. Mudou uma frase no catálogo, ajuste o teste que a procura.

## Pronto quando

- `tsc` passa nos dois lados: as chaves são tipadas (`i18next.d.ts`), então chave errada ou ausente quebra o
  build.
- Nenhuma frase solta sobrou no que você mexeu: JSX sem texto literal; `aria-*`, `placeholder` e `title` sem
  string literal; todo `throw`, `message`, prompt e e-mail apontando para uma chave.
- Nenhum `t()` no topo de módulo.
