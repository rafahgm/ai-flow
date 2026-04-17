# App de Agentes de IA em Fluxos de Automação — Especificação Inicial

## 1. Visão geral do projeto

Construir um aplicativo web em **Ruby on Rails** que permita ao usuário criar, configurar e executar **agentes de IA em formato de fluxos de automação**.

Cada fluxo será composto por **etapas encadeadas**. Cada etapa executa uma ação específica, como por exemplo:

* gerar texto com uma LLM;
* fazer uma pesquisa web;
* resumir conteúdo;
* transformar uma saída anterior;
* classificar ou extrair dados estruturados;
* chamar uma integração externa;
* tomar uma decisão condicional para seguir por caminhos diferentes.

A saída de cada etapa deve poder ser usada como entrada da próxima. Cada etapa terá sua própria configuração, incluindo **prompt**, modelo, variáveis de entrada e regras de execução.

O sistema deve oferecer:

* criação visual de fluxos;
* execução rastreável passo a passo;
* visualização da entrada, saída e status de cada etapa;
* possibilidade de começar com **LLM local**;
* arquitetura preparada para conectar outros provedores de IA no futuro.

---

## 2. Objetivos do produto

### 2.1 Objetivos principais

* Permitir que usuários criem automações com IA sem precisar programar.
* Tornar a execução dos fluxos transparente e auditável.
* Facilitar testes, depuração e evolução dos agentes.
* Suportar diferentes provedores de IA por meio de uma camada de abstração.
* Começar com uma stack simples, mas preparada para escalar.

### 2.2 Objetivos técnicos

* Implementar backend em Ruby on Rails.
* Suportar execução assíncrona de etapas.
* Registrar logs detalhados por execução e por etapa.
* Permitir reexecução de fluxos e etapas.
* Isolar integrações com modelos e ferramentas em adaptadores.

### 2.3 Não objetivos iniciais

* Marketplace público de agentes.
* Colaboração em tempo real entre múltiplos usuários no mesmo fluxo.
* Sistema avançado de billing por uso.
* Orquestração distribuída complexa multi-região.
* Fine-tuning de modelos no MVP.

---

## 3. Conceitos principais do domínio

### 3.1 Workspace / Conta

Unidade organizacional do usuário ou equipe.

### 3.2 Fluxo

Definição de uma automação composta por etapas conectadas.

### 3.3 Etapa

Bloco individual dentro do fluxo. Cada etapa recebe entradas, executa uma ação e produz uma saída.

### 3.4 Execução do fluxo

Instância de execução de um fluxo em um determinado momento.

### 3.5 Execução da etapa

Registro da execução de uma etapa específica dentro de uma execução de fluxo.

### 3.6 Provedor de IA

Integração com uma engine de IA, como:

* LLM local (ex.: Ollama, vLLM, LocalAI);
* OpenAI;
* Anthropic;
* Google;
* provedores compatíveis com OpenAI API.

### 3.7 Ferramenta

Ação não necessariamente ligada a um modelo, por exemplo:

* pesquisa web;
* chamada HTTP;
* leitura de arquivo;
* parser;
* extrator;
* transformador JSON.

---

## 4. Tipos de etapa no MVP

Para o MVP, recomenda-se começar com poucos tipos de etapa bem definidos.

### 4.1 Etapa de prompt LLM

Executa um prompt contra um modelo.

**Entradas possíveis:**

* texto fixo;
* variáveis do fluxo;
* saída de etapas anteriores.

**Saídas possíveis:**

* texto livre;
* JSON estruturado;
* classificação;
* resumo.

### 4.2 Etapa de pesquisa web

Executa uma busca na web com base em um termo ou prompt gerado previamente.

**Entradas possíveis:**

* consulta fixa;
* consulta derivada de etapa anterior.

**Saída esperada:**

* lista de resultados;
* snippets;
* links;
* conteúdo resumido.

### 4.3 Etapa de transformação

Transforma uma entrada em outro formato.

**Exemplos:**

* limpar texto;
* converter para JSON;
* mapear campos;
* normalizar dados.

### 4.4 Etapa condicional

Decide o próximo caminho do fluxo com base em regra ou saída estruturada.

**Exemplos:**

* se score > 0.8;
* se categoria = "lead quente";
* se resultado vazio, seguir para fallback.

### 4.5 Etapa de requisição HTTP

Permite chamar APIs externas.

**Exemplos:**

* webhook;
* CRM;
* Slack;
* banco vetorial;
* ferramenta própria.

---

## 5. Requisitos funcionais

### 5.1 Gestão de usuários e acesso

* O sistema deve permitir cadastro e autenticação de usuários.
* O sistema deve permitir que cada usuário tenha seus próprios fluxos.
* O sistema deve permitir organização por workspaces ou projetos.
* O sistema deve proteger fluxos e execuções por escopo de acesso.

### 5.2 Criação e edição de fluxos

* O usuário deve poder criar um novo fluxo.
* O usuário deve poder editar nome, descrição e status do fluxo.
* O usuário deve poder adicionar, remover, duplicar e reordenar etapas.
* O usuário deve poder conectar a saída de uma etapa à entrada de outra.
* O usuário deve poder definir variáveis globais do fluxo.
* O usuário deve poder salvar rascunhos e publicar versões do fluxo.

### 5.3 Configuração de etapas

* Cada etapa deve ter:

  * nome;
  * tipo;
  * descrição opcional;
  * prompt ou configuração principal;
  * mapeamento de entradas;
  * formato de saída esperado;
  * timeout;
  * política de retry;
  * provedor/modelo associado, quando aplicável.
* O usuário deve poder visualizar variáveis disponíveis ao editar o prompt.
* O usuário deve poder usar saídas anteriores por interpolação.

**Exemplo de interpolação:**

* `{{steps.buscar_termo.output}}`
* `{{flow.input.cliente_nome}}`

### 5.4 Execução do fluxo

* O usuário deve poder executar um fluxo manualmente.
* O usuário deve poder fornecer parâmetros de entrada na execução.
* O sistema deve executar as etapas na ordem definida ou conforme o grafo.
* O sistema deve armazenar status por etapa:

  * pendente;
  * em execução;
  * concluída;
  * falhou;
  * cancelada.
* O sistema deve interromper ou continuar conforme a política de erro do fluxo.

### 5.5 Observabilidade da execução

* O usuário deve poder visualizar a execução do fluxo em tempo real ou quase tempo real.
* O usuário deve poder abrir cada etapa e ver:

  * entrada resolvida;
  * prompt final enviado;
  * parâmetros usados;
  * provedor/modelo usado;
  * duração;
  * saída bruta;
  * saída processada;
  * erro, se houver.
* O sistema deve manter histórico de execuções.
* O sistema deve permitir reexecutar o fluxo inteiro.
* O sistema deve permitir reexecutar uma etapa a partir de um ponto.

### 5.6 Provedores de IA

* O sistema deve ter suporte inicial a uma LLM local.
* O sistema deve abstrair os provedores de IA por interface comum.
* O sistema deve permitir cadastrar credenciais de provedores externos futuramente.
* O sistema deve permitir escolher modelo por etapa.

### 5.7 Ferramentas e integrações

* O sistema deve suportar uma camada de ferramentas separada da camada de modelos.
* O sistema deve permitir adicionar novas ferramentas sem alterar a lógica central do fluxo.
* O sistema deve permitir configurar pesquisa web como ferramenta reutilizável.

### 5.8 Versionamento

* O sistema deve versionar fluxos.
* Cada execução deve apontar para a versão usada.
* O usuário deve poder clonar uma versão anterior para editar.

### 5.9 Segurança e auditoria

* O sistema deve armazenar credenciais de forma segura.
* O sistema deve registrar eventos importantes de auditoria.
* O sistema deve mascarar segredos em logs.
* O sistema deve permitir políticas de acesso por usuário/workspace.

---

## 6. Requisitos não funcionais

### 6.1 Performance

* Execuções assíncronas não devem bloquear a interface.
* O sistema deve suportar múltiplas execuções concorrentes.
* O tempo de atualização da interface de execução deve ser baixo.

### 6.2 Escalabilidade

* O sistema deve separar aplicação web, workers e provedores de IA.
* O sistema deve suportar aumento de workers horizontalmente.
* O sistema deve suportar troca futura para filas e execução distribuída mais robustas.

### 6.3 Confiabilidade

* Etapas devem ter retries configuráveis.
* Execuções devem ser resilientes a falhas transitórias.
* O sistema deve registrar estado suficiente para retomar ou diagnosticar falhas.

### 6.4 Manutenibilidade

* O código deve ser organizado por domínios.
* Adaptadores de IA devem seguir contrato padronizado.
* Ferramentas devem ser plugáveis.
* A modelagem deve favorecer testes automatizados.

### 6.5 Observabilidade

* Logs estruturados.
* Métricas de execução.
* Rastreamento por fluxo, execução e etapa.
* Monitoramento de erros e latência.

---

## 7. Experiência do usuário

## 7.1 Jornada principal

1. Usuário cria um fluxo.
2. Adiciona etapas.
3. Configura prompt e entradas de cada etapa.
4. Conecta as etapas.
5. Salva e publica.
6. Executa manualmente com parâmetros.
7. Acompanha status de cada etapa.
8. Inspeciona saídas.
9. Ajusta prompts e reexecuta.

### 7.2 Telas principais

* Login / cadastro
* Dashboard de fluxos
* Editor visual de fluxo
* Painel de configuração da etapa
* Tela de execução em tempo real
* Histórico de execuções
* Página de detalhes da execução
* Configurações de provedores

### 7.3 Requisitos de UX

* O editor deve ser simples de entender.
* O usuário deve conseguir identificar rapidamente o que cada etapa faz.
* A visualização da execução deve destacar claramente sucesso, erro e tempo gasto.
* A inspeção de entradas/saídas deve ser fácil e detalhada.
* A interface deve facilitar debugging.

---

## 8. Modelo conceitual de dados

### 8.1 Entidades principais

#### users

* id
* name
* email
* password_digest
* created_at
* updated_at

#### workspaces

* id
* name
* owner_id
* created_at
* updated_at

#### workspace_memberships

* id
* workspace_id
* user_id
* role
* created_at
* updated_at

#### flows

* id
* workspace_id
* name
* description
* status
* current_version_id
* created_at
* updated_at

#### flow_versions

* id
* flow_id
* version_number
* definition_json
* published_at
* created_by_id
* created_at
* updated_at

#### steps

* id
* flow_version_id
* key
* name
* step_type
* position
* config_json
* created_at
* updated_at

#### step_connections

* id
* flow_version_id
* source_step_id
* target_step_id
* source_output_path
* target_input_key
* mapping_json
* created_at
* updated_at

#### flow_runs

* id
* flow_id
* flow_version_id
* workspace_id
* triggered_by_id
* status
* input_json
* context_json
* output_json
* error_message
* started_at
* finished_at
* duration_ms
* created_at
* updated_at

#### step_runs

* id
* flow_run_id
* step_id
* status
* attempt_number
* resolved_input_json
* rendered_prompt
* provider_name
* model_name
* request_payload_json
* raw_output
* parsed_output_json
* logs_json
* error_message
* started_at
* finished_at
* duration_ms
* created_at
* updated_at

#### ai_providers

* id
* workspace_id
* provider_type
* name
* slug
* config_json
* encrypted_credentials
* active
* created_at
* updated_at

#### secrets

* id
* workspace_id
* key
* encrypted_value
* description
* created_at
* updated_at

#### run_events

* id
* flow_run_id
* step_run_id
* event_type
* payload_json
* created_at

---

## 9. Schema inicial do banco

Abaixo está uma proposta inicial de schema relacional para o MVP, pensando em **PostgreSQL + Rails**.

### 9.1 Observações de modelagem

* Campos `jsonb` devem ser usados para configurações flexíveis e outputs variáveis.
* Campos de status devem usar enums no Rails, mas armazenados como `string` no banco no início para facilitar evolução.
* Chaves externas devem ter índices.
* Execuções e logs devem ser pensados para alto volume.
* `flow_versions` deve congelar a definição do fluxo no momento da publicação.

### 9.2 Proposta de tabelas

```sql
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  email VARCHAR NOT NULL UNIQUE,
  password_digest VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE workspaces (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  owner_id BIGINT NOT NULL REFERENCES users(id),
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE workspace_memberships (
  id BIGSERIAL PRIMARY KEY,
  workspace_id BIGINT NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  UNIQUE(workspace_id, user_id)
);

CREATE TABLE flows (
  id BIGSERIAL PRIMARY KEY,
  workspace_id BIGINT NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
  name VARCHAR NOT NULL,
  description TEXT,
  status VARCHAR NOT NULL DEFAULT 'draft',
  current_version_id BIGINT,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE flow_versions (
  id BIGSERIAL PRIMARY KEY,
  flow_id BIGINT NOT NULL REFERENCES flows(id) ON DELETE CASCADE,
  version_number INTEGER NOT NULL,
  definition_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  published_at TIMESTAMP,
  created_by_id BIGINT REFERENCES users(id),
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  UNIQUE(flow_id, version_number)
);

ALTER TABLE flows
  ADD CONSTRAINT fk_flows_current_version
  FOREIGN KEY (current_version_id) REFERENCES flow_versions(id);

CREATE TABLE steps (
  id BIGSERIAL PRIMARY KEY,
  flow_version_id BIGINT NOT NULL REFERENCES flow_versions(id) ON DELETE CASCADE,
  key VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  step_type VARCHAR NOT NULL,
  position INTEGER NOT NULL,
  config_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  UNIQUE(flow_version_id, key)
);

CREATE TABLE step_connections (
  id BIGSERIAL PRIMARY KEY,
  flow_version_id BIGINT NOT NULL REFERENCES flow_versions(id) ON DELETE CASCADE,
  source_step_id BIGINT NOT NULL REFERENCES steps(id) ON DELETE CASCADE,
  target_step_id BIGINT NOT NULL REFERENCES steps(id) ON DELETE CASCADE,
  source_output_path VARCHAR,
  target_input_key VARCHAR,
  mapping_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE ai_providers (
  id BIGSERIAL PRIMARY KEY,
  workspace_id BIGINT NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
  provider_type VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  slug VARCHAR NOT NULL,
  config_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  encrypted_credentials TEXT,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  UNIQUE(workspace_id, slug)
);

CREATE TABLE secrets (
  id BIGSERIAL PRIMARY KEY,
  workspace_id BIGINT NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
  key VARCHAR NOT NULL,
  encrypted_value TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  UNIQUE(workspace_id, key)
);

CREATE TABLE flow_runs (
  id BIGSERIAL PRIMARY KEY,
  flow_id BIGINT NOT NULL REFERENCES flows(id),
  flow_version_id BIGINT NOT NULL REFERENCES flow_versions(id),
  workspace_id BIGINT NOT NULL REFERENCES workspaces(id),
  triggered_by_id BIGINT REFERENCES users(id),
  status VARCHAR NOT NULL DEFAULT 'pending',
  input_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  context_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  output_json JSONB,
  error_message TEXT,
  started_at TIMESTAMP,
  finished_at TIMESTAMP,
  duration_ms INTEGER,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE step_runs (
  id BIGSERIAL PRIMARY KEY,
  flow_run_id BIGINT NOT NULL REFERENCES flow_runs(id) ON DELETE CASCADE,
  step_id BIGINT NOT NULL REFERENCES steps(id),
  status VARCHAR NOT NULL DEFAULT 'pending',
  attempt_number INTEGER NOT NULL DEFAULT 1,
  resolved_input_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  rendered_prompt TEXT,
  provider_name VARCHAR,
  model_name VARCHAR,
  request_payload_json JSONB,
  raw_output TEXT,
  parsed_output_json JSONB,
  logs_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  error_message TEXT,
  started_at TIMESTAMP,
  finished_at TIMESTAMP,
  duration_ms INTEGER,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE run_events (
  id BIGSERIAL PRIMARY KEY,
  flow_run_id BIGINT NOT NULL REFERENCES flow_runs(id) ON DELETE CASCADE,
  step_run_id BIGINT REFERENCES step_runs(id) ON DELETE CASCADE,
  event_type VARCHAR NOT NULL,
  payload_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMP NOT NULL
);
```

### 9.3 Índices recomendados

```sql
CREATE INDEX idx_flows_workspace_id ON flows(workspace_id);
CREATE INDEX idx_flow_versions_flow_id ON flow_versions(flow_id);
CREATE INDEX idx_steps_flow_version_id ON steps(flow_version_id);
CREATE INDEX idx_step_connections_flow_version_id ON step_connections(flow_version_id);
CREATE INDEX idx_flow_runs_flow_id ON flow_runs(flow_id);
CREATE INDEX idx_flow_runs_flow_version_id ON flow_runs(flow_version_id);
CREATE INDEX idx_flow_runs_workspace_id ON flow_runs(workspace_id);
CREATE INDEX idx_flow_runs_status ON flow_runs(status);
CREATE INDEX idx_flow_runs_created_at ON flow_runs(created_at DESC);
CREATE INDEX idx_step_runs_flow_run_id ON step_runs(flow_run_id);
CREATE INDEX idx_step_runs_step_id ON step_runs(step_id);
CREATE INDEX idx_step_runs_status ON step_runs(status);
CREATE INDEX idx_step_runs_created_at ON step_runs(created_at DESC);
CREATE INDEX idx_run_events_flow_run_id ON run_events(flow_run_id);
CREATE INDEX idx_run_events_step_run_id ON run_events(step_run_id);
CREATE INDEX idx_ai_providers_workspace_id ON ai_providers(workspace_id);
CREATE INDEX idx_secrets_workspace_id ON secrets(workspace_id);
```

### 9.4 Enums sugeridos no Rails

#### Flow.status

* `draft`
* `published`
* `archived`

#### FlowRun.status

* `pending`
* `running`
* `completed`
* `failed`
* `cancelled`

#### StepRun.status

* `pending`
* `running`
* `completed`
* `failed`
* `skipped`
* `cancelled`

#### Step.step_type

* `llm_prompt`
* `web_search`
* `transform`
* `condition`
* `http_request`

#### WorkspaceMembership.role

* `owner`
* `admin`
* `member`
* `viewer`

### 9.5 Exemplo de config_json por tipo de etapa

#### LLM prompt

```json
{
  "provider_id": 1,
  "model": "llama3",
  "temperature": 0.2,
  "max_tokens": 1200,
  "system_prompt": "Você é um assistente especialista.",
  "prompt_template": "Resuma o conteúdo: {{steps.search.output}}",
  "output_format": "text"
}
```

#### Web search

```json
{
  "engine": "serpapi",
  "query_template": "{{flow.input.topic}}",
  "max_results": 5,
  "return_fields": ["title", "url", "snippet"]
}
```

#### Condition

```json
{
  "expression": "steps.classifier.output.score > 0.8",
  "on_true": "step_aprovado",
  "on_false": "step_revisao"
}
```

---

## 10. Arquitetura lógica recomendada

## 9.1 Camadas principais

### A. Interface web

Aplicação Rails com renderização server-side, Hotwire ou frontend híbrido.

**Sugestão inicial:**

* Rails + Hotwire + Stimulus para MVP
* biblioteca de grafo/diagramas para o editor visual

### B. API interna de orquestração

Responsável por:

* validar definição do fluxo;
* resolver dependências entre etapas;
* iniciar execução;
* despachar jobs;
* atualizar estados;
* persistir logs e resultados.

### C. Engine de execução

Camada responsável por executar as etapas efetivamente.

Responsabilidades:

* montar contexto da execução;
* resolver variáveis;
* renderizar prompt;
* chamar adaptador correto;
* processar resposta;
* salvar resultados;
* acionar próxima etapa.

### D. Adaptadores de IA

Interface comum para provedores.

Exemplo de contrato:

* `generate(prompt:, model:, options:)`
* `embed(text:, model:)`
* `structured_output(prompt:, schema:)`

Implementações possíveis:

* `Providers::OllamaAdapter`
* `Providers::OpenAIAdapter`
* `Providers::AnthropicAdapter`
* `Providers::OpenAICompatibleAdapter`

### E. Ferramentas

Módulos independentes para ações externas.

Exemplos:

* `Tools::WebSearch`
* `Tools::HttpRequest`
* `Tools::JsonTransform`
* `Tools::TextExtract`

### F. Fila e processamento assíncrono

Executa fluxos e etapas em background.

### G. Observabilidade

Logs, métricas, tracing e auditoria.

---

## 10. Arquitetura lógica recomendada

## 10.1 Componentes principais

### A. Rails Web App

Responsável por:

* autenticação;
* CRUD de fluxos;
* editor visual;
* histórico de execuções;
* APIs internas;
* broadcasting em tempo real.

### B. Orchestrator

Responsável por:

* carregar a versão publicada do fluxo;
* validar o DAG;
* resolver dependências;
* decidir quais etapas estão prontas para executar;
* coordenar retries, falhas e conclusão.

### C. Step Executor

Responsável por:

* montar input resolvido da etapa;
* renderizar prompt/template;
* chamar adaptador de IA ou ferramenta;
* normalizar saída;
* persistir `step_run`;
* emitir eventos.

### D. Provider Adapters

Camada responsável por padronizar chamadas para:

* Ollama;
* OpenAI;
* Anthropic;
* provedores compatíveis.

### E. Tools Layer

Camada de ferramentas reutilizáveis:

* pesquisa web;
* requisições HTTP;
* transformações JSON;
* parsing;
* scraping futuro.

### F. Background Jobs

Executam o processamento assíncrono usando Sidekiq.

### G. Realtime Layer

Atualiza a UI via Turbo Streams / Action Cable.

---

## 11. Diagrama da arquitetura

### 11.1 Diagrama de componentes

```text
┌──────────────────────────────┐
│          Usuário             │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       Rails Web App          │
│ - UI de fluxos               │
│ - UI de execuções            │
│ - API interna                │
│ - Auth                       │
└───────┬───────────┬──────────┘
        │           │
        │           ▼
        │   ┌──────────────────┐
        │   │ Realtime Updates │
        │   │ Turbo/ActionCable│
        │   └──────────────────┘
        │
        ▼
┌──────────────────────────────┐
│         PostgreSQL           │
│ flows / versions / runs      │
│ steps / step_runs / events   │
└──────────────────────────────┘
        ▲
        │
        ▼
┌──────────────────────────────┐
│       Sidekiq Workers        │
│ - FlowRunJob                 │
│ - StepRunJob                 │
│ - RetryJob                   │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│     Orchestrator / Engine    │
│ - DAG resolver               │
│ - context builder            │
│ - step dispatcher            │
└──────────────┬───────────────┘
               │
     ┌─────────┴─────────┐
     │                   │
     ▼                   ▼
┌───────────────┐  ┌────────────────┐
│ AI Adapters   │  │ Tools Layer    │
│ Ollama/OpenAI │  │ Web/HTTP/JSON  │
└──────┬────────┘  └───────┬────────┘
       │                   │
       ▼                   ▼
┌───────────────┐   ┌────────────────┐
│ LLM Local     │   │ Serviços Externos│
│ Ollama        │   │ Search/APIs    │
└───────────────┘   └────────────────┘
```

### 11.2 Diagrama de sequência da execução

```text
Usuário
  │
  │ dispara execução
  ▼
Rails Controller
  │ cria flow_run(status=pending)
  │ enfileira FlowRunJob
  ▼
Sidekiq Worker
  │ carrega flow_version
  │ identifica etapas iniciais
  ▼
Orchestrator
  │ cria step_run(status=running)
  │ resolve variáveis
  │ renderiza prompt/configuração
  ▼
Step Executor
  │ chama adapter/tool
  ▼
LLM local / ferramenta externa
  │ retorna resultado
  ▼
Step Executor
  │ persiste output
  │ marca step_run como completed/failed
  │ publica evento realtime
  ▼
Orchestrator
  │ verifica próximas etapas prontas
  │ repete até finalizar
  ▼
flow_run => completed/failed
```

### 11.3 Fluxo interno da engine

```text
[flow_run iniciado]
      ↓
[carregar definição versionada]
      ↓
[montar DAG de etapas]
      ↓
[resolver etapas executáveis]
      ↓
[executar etapa]
      ↓
[persistir step_run + evento]
      ↓
[avaliar dependências satisfeitas]
      ↓
[executar próximas etapas]
      ↓
[encerrar flow_run]
```

---

## 12. Infraestrutura recomendada

## 12.1 Visão geral

A infraestrutura deve separar os seguintes componentes:

* aplicação Rails web;
* banco relacional;
* Redis para filas/cache;
* workers assíncronos;
* serviço de LLM local;
* storage para artefatos e logs, se necessário;
* observabilidade.

## 12.2 Componentes

### Aplicação principal

* Ruby on Rails
* Puma
* Hotwire para atualização da UI
* Action Cable ou Turbo Streams para acompanhar execuções

### Banco de dados

* PostgreSQL

Uso:

* usuários;
* fluxos;
* versões;
* execuções;
* logs resumidos;
* configurações.

### Fila / cache

* Redis

Uso:

* jobs assíncronos;
* locks;
* cache de execução;
* atualização de estado em tempo real.

### Workers

* Sidekiq recomendado para MVP

Uso:

* iniciar execução de fluxo;
* executar etapa;
* retries;
* reprocessamento;
* tarefas agendadas futuras.

### LLM local

Opções recomendadas para início:

* Ollama
* LocalAI
* vLLM, se precisar de mais performance futuramente

**Sugestão prática para MVP:** começar com **Ollama**, por simplicidade operacional.

### Observabilidade

* logs estruturados
* Sentry para exceptions
* Prometheus/Grafana futuramente
* OpenTelemetry se quiser tracing mais robusto

### Armazenamento de arquivos

* local no dev
* S3 compatível em produção, se houver artefatos

## 12.3 Topologia sugerida de ambientes

### Desenvolvimento

* `web` (Rails)
* `worker` (Sidekiq)
* `postgres`
* `redis`
* `ollama`

### Produção inicial

* 1 instância Rails web
* 1 instância Sidekiq worker
* PostgreSQL gerenciado ou dedicado
* Redis gerenciado ou dedicado
* servidor separado para LLM local, se necessário

### Evolução futura

* múltiplos workers por fila
* separação entre filas curtas e longas
* serviços de inferência independentes
* possibilidade de fila dedicada para etapas que usam IA

---

## 13. Fluxo de execução da infraestrutura

### 11.1 Exemplo de execução

1. Usuário dispara uma execução pela interface.
2. Rails cria um `flow_run` com status `pending`.
3. Um job é enviado para a fila.
4. Worker carrega a definição versionada do fluxo.
5. Engine identifica a primeira etapa executável.
6. Cria `step_run` com status `running`.
7. Resolve variáveis e renderiza o prompt.
8. Chama o adaptador correspondente:

   * LLM local; ou
   * ferramenta de pesquisa web; ou
   * integração HTTP.
9. Recebe a saída, persiste no banco e atualiza status.
10. Publica evento para UI atualizar a execução em tempo real.
11. Próxima etapa recebe a saída anterior como entrada.
12. Processo segue até concluir ou falhar.
13. `flow_run` recebe status final e output consolidado.

---

## 14. Estratégia de integração com múltiplos provedores

## 12.1 Objetivo

Evitar acoplamento da lógica do fluxo a um único provedor de IA.

## 12.2 Abordagem

Criar uma camada de abstração com:

* interface comum;
* adaptadores por provedor;
* normalização de respostas;
* tratamento uniforme de erros;
* suporte a capacidades diferentes por modelo.

## 12.3 Exemplo de contrato interno

```ruby
module AiProviders
  class BaseAdapter
    def generate(prompt:, model:, options: {})
      raise NotImplementedError
    end

    def structured_generate(prompt:, schema:, model:, options: {})
      raise NotImplementedError
    end
  end
end
```

## 12.4 Benefícios

* troca de provedor sem alterar a lógica do fluxo;
* escolha de modelo por etapa;
* fallback entre provedores no futuro;
* suporte gradual a recursos avançados.

---

## 15. Estratégia para prompts e contexto

### 13.1 Prompt por etapa

Cada etapa deve possuir:

* prompt base;
* instruções do sistema, se aplicável;
* template com variáveis;
* configuração de saída esperada.

### 13.2 Renderização

A renderização do prompt deve usar um mecanismo claro de interpolação, com contexto previsível.

**Exemplo de contexto disponível:**

```json
{
  "flow": {
    "input": {
      "tema": "IA para vendas"
    }
  },
  "steps": {
    "pesquisa": {
      "output": "..."
    }
  }
}
```

### 13.3 Boas práticas

* armazenar prompt final renderizado na execução;
* versionar prompts junto com o fluxo;
* permitir saída estruturada via JSON schema no futuro.

---

## 16. Estratégia de tempo real na interface

Para que o usuário visualize a execução e saída de cada etapa:

* usar Turbo Streams ou Action Cable;
* atualizar status das etapas em tempo real;
* exibir logs progressivos quando fizer sentido;
* permitir abrir detalhes sem recarregar a página.

**Eventos úteis:**

* execução iniciada;
* etapa iniciada;
* etapa concluída;
* etapa falhou;
* execução concluída.

---

## 17. Segurança

* Criptografar credenciais de provedores.
* Mascarar tokens e segredos em logs.
* Limitar acesso aos recursos por workspace.
* Validar entradas do usuário.
* Definir timeout e limites por etapa.
* Prevenir loops infinitos e execuções descontroladas.
* Registrar auditoria de alterações em fluxos e integrações.

---

## 18. Estratégia de entrega por fases

## Fase 1 — MVP funcional

Objetivo: validar criação e execução de fluxos simples.

Escopo:

* autenticação;
* CRUD de fluxos;
* editor simples de etapas;
* execução linear;
* etapa LLM;
* etapa de pesquisa web;
* visualização de execução;
* histórico básico;
* integração com Ollama;
* Sidekiq + Redis;
* PostgreSQL.

## Fase 2 — Robustez operacional

* reexecução por etapa;
* retries configuráveis;
* melhor observabilidade;
* versionamento mais completo;
* HTTP request step;
* condicionais simples.

## Fase 3 — Plataforma extensível

* múltiplos provedores de IA;
* autenticação por workspace/equipe;
* templates de fluxos;
* biblioteca de ferramentas;
* webhooks e gatilhos externos.

## Fase 4 — Recursos avançados

* fluxos ramificados complexos;
* memória contextual;
* integrações com vetores/RAG;
* agendamentos;
* billing e quotas;
* marketplace interno.

---

## 19. Todo list inicial do projeto

## 17.1 Fundação do projeto

* [ ] Criar aplicação Rails
* [ ] Configurar PostgreSQL
* [ ] Configurar Redis
* [ ] Configurar Sidekiq
* [ ] Configurar autenticação de usuários
* [ ] Definir estrutura inicial de workspaces
* [ ] Configurar ambiente Docker para desenvolvimento
* [ ] Subir instância local do Ollama

## 17.2 Modelagem de domínio

* [ ] Criar models de flows, flow_versions, steps, flow_runs e step_runs
* [ ] Definir schema para `config_json` das etapas
* [ ] Implementar versionamento de fluxos
* [ ] Modelar conexões entre etapas
* [ ] Modelar provedores e segredos

## 17.3 Engine de execução

* [ ] Implementar executor de fluxo linear
* [ ] Implementar executor de etapa
* [ ] Implementar resolução de variáveis
* [ ] Implementar renderização de prompts
* [ ] Persistir logs e outputs por etapa
* [ ] Implementar atualização de status
* [ ] Implementar retries básicos

## 17.4 Camada de IA

* [ ] Criar interface base de adaptadores
* [ ] Implementar adaptador para Ollama
* [ ] Normalizar resposta de geração de texto
* [ ] Definir estratégia para erros e timeouts
* [ ] Preparar estrutura para provedores futuros

## 17.5 Ferramentas

* [ ] Implementar ferramenta de pesquisa web
* [ ] Implementar ferramenta de transformação simples
* [ ] Definir contrato padrão de ferramentas
* [ ] Permitir registrar novas ferramentas no sistema

## 17.6 Interface

* [ ] Criar dashboard de fluxos
* [ ] Criar tela de edição de fluxo
* [ ] Criar componente de criação/edição de etapa
* [ ] Criar visualização de conexões entre etapas
* [ ] Criar tela de execução com atualização em tempo real
* [ ] Criar tela de detalhes da execução
* [ ] Exibir entrada, prompt e saída por etapa

## 17.7 Observabilidade e segurança

* [ ] Estruturar logs JSON
* [ ] Integrar Sentry
* [ ] Proteger segredos com criptografia
* [ ] Mascarar credenciais em logs
* [ ] Implementar trilha de auditoria básica

## 17.8 Qualidade

* [ ] Criar testes de model
* [ ] Criar testes de service objects
* [ ] Criar testes de integração da execução
* [ ] Criar testes dos adaptadores
* [ ] Criar fixtures de fluxos de exemplo

---

## 20. Sugestão de stack inicial

### Backend

* Ruby on Rails
* PostgreSQL
* Redis
* Sidekiq

### Frontend

* Hotwire
* Stimulus
* Tailwind CSS
* biblioteca JS para grafo visual

### IA

* Ollama no início
* adaptadores preparados para OpenAI/Anthropic depois

### Infraestrutura

* Docker Compose para desenvolvimento
* Deploy inicial em VPS ou cloud simples
* app/web + worker + redis + postgres + ollama

---

## 21. Exemplo de fluxo do produto

### Caso: pesquisa e síntese

**Etapa 1 — Gerar consulta**

* prompt: gerar a melhor consulta para pesquisar um tema
* entrada: tema informado pelo usuário
* saída: string de busca

**Etapa 2 — Pesquisar na web**

* entrada: saída da etapa 1
* saída: lista de resultados

**Etapa 3 — Resumir resultados**

* prompt: sintetizar os principais pontos dos resultados
* entrada: saída da etapa 2
* saída: resumo

**Etapa 4 — Gerar resposta final**

* prompt: montar uma resposta final organizada
* entrada: saída da etapa 3
* saída: texto final

O usuário deve conseguir ver claramente cada uma dessas etapas, com sua entrada, prompt utilizado, duração e saída.

---

## 22. Riscos e pontos de atenção

* Complexidade do editor visual pode crescer rápido.
* Fluxos ramificados exigem cuidado no orquestrador.
* Pesquisa web pode depender de APIs externas e políticas de rate limit.
* Modelos locais podem ter limitações de performance e qualidade.
* Logs detalhados podem crescer rapidamente e exigir política de retenção.
* Múltiplos provedores exigem normalização cuidadosa.

---

## 23. Recomendação prática para começar

Para o primeiro ciclo de desenvolvimento, focar em:

1. fluxo linear;
2. editor simples;
3. etapa LLM via Ollama;
4. etapa web search;
5. histórico e inspeção de execuções;
6. arquitetura já separando:

   * orquestração;
   * adaptadores de IA;
   * ferramentas;
   * jobs.

Isso reduz risco de arquitetura prematura, mas já cria uma base sólida para expansão.

---

## 24. Critérios de sucesso do MVP

* Usuário consegue criar um fluxo com 2 a 5 etapas.
* Usuário consegue executar o fluxo manualmente.
* Usuário consegue visualizar a saída de cada etapa.
* Sistema executa com LLM local de forma confiável.
* Estrutura já permite adicionar novo provedor sem reescrever o core.
* Equipe consegue debugar falhas com clareza.

---

## 25. Próximos passos sugeridos

1. Validar esse escopo do MVP.
2. Definir modelo de dados final.
3. Definir UX do editor de fluxo.
4. Implementar engine linear primeiro.
5. Integrar Ollama.
6. Implementar visualização em tempo real.
7. Só depois adicionar ramificações e integrações mais avançadas.
