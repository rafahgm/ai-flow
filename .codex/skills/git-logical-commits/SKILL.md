---
name: git-logical-commits
description: Use this skill when the user wants an agent to analyze local git changes, split them into logical commits, and create commit messages following Conventional Commits.
---

# Git Logical Commits

Objetivo: analisar as alteracoes locais do repositorio, separa-las em commits logicos e criar commits usando Conventional Commits.

## Quando usar

Use esta skill quando o usuario pedir para:

- separar alteracoes em commits logicos
- criar commits com Conventional Commits
- revisar um diff local e organizar o historico antes de commitar
- propor um plano de commits antes de executar

## Workflow

1. Verifique o estado atual com `git status --short`.
2. Inspecione o escopo com `git diff --stat` e `git diff --cached --stat`.
3. Leia os diffs relevantes por arquivo antes de decidir os agrupamentos.
4. Agrupe por intencao semantica, nao por proximidade de arquivo.
5. Se houver ambiguidade real sobre o agrupamento, apresente primeiro um plano curto de commits.
6. Faca staging seletivo por arquivo ou por hunk.
7. Crie os commits em Conventional Commits.
8. Ao terminar, liste os commits criados e o racional de cada um.

## Regras de agrupamento

- Um commit deve representar uma unica intencao.
- Nao misture `feat`, `fix`, `refactor`, `test`, `docs`, `style`, `perf` ou `chore` no mesmo commit, salvo quando for inseparavel.
- Separe mudancas de infraestrutura ou tooling de mudancas de regra de negocio.
- Separe formatacao incidental de mudancas funcionais quando isso puder ser feito com seguranca.
- Se uma mudanca exigir testes para fazer sentido, os testes podem entrar no mesmo commit da mudanca funcional correspondente.
- Renomeacoes, extracoes e reorganizacoes sem mudanca de comportamento tendem a ser `refactor`.

## Conventional Commits

Formato preferido:

`type(scope): resumo curto no imperativo`

Exemplos:

- `feat(auth): add refresh token rotation`
- `fix(webhooks): handle empty payload`
- `refactor(flows): extract version builder`
- `test(steps): cover invalid transition state`
- `docs(setup): clarify local development steps`
- `chore(docker): align dev container defaults`

## Heuristicas de tipo

- `feat`: nova funcionalidade para usuario, API ou fluxo do sistema
- `fix`: correcao de bug ou regressao
- `refactor`: reorganizacao sem mudanca funcional esperada
- `test`: testes adicionados ou ajustados
- `docs`: documentacao
- `style`: formatacao sem impacto funcional
- `perf`: melhora de performance
- `chore`: manutencao, build, dependencias, configuracao, scripts

## Restricoes

- Nao inclua arquivos nao relacionados no mesmo commit.
- Evite mensagens genericas como `chore: update files` se houver classificacao melhor.
- Nao reescreva ou reverta alteracoes preexistentes do usuario sem necessidade explicita.
- Antes de cada commit, confirme que o diff staged faz sentido isoladamente.

## Checklist

Antes de commitar, confirme:

- O commit representa uma unica intencao?
- A mensagem segue Conventional Commits?
- O diff do commit faz sentido isoladamente?
- O projeto permanece consistente apos esse commit?

## Saida esperada

Ao concluir:

1. Liste os commits criados.
2. Explique em uma linha o racional de cada agrupamento.
3. Aponte qualquer alteracao que ficou sem commit por ambiguidade.

## Prompt recomendado

Use esta skill para analisar minhas alteracoes locais, separar em commits logicos e criar os commits com Conventional Commits. Se houver ambiguidade real, proponha antes um plano curto de commits.
