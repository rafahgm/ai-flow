# ai-flow

## Desenvolvimento com Docker

O projeto usa `docker-compose.yml` para subir a aplicacao Rails, PostgreSQL e o worker do `solid_queue`.

1. Crie o arquivo de ambiente com base no exemplo:

```bash
cp .env.example .env
```

2. Construa as imagens e suba os servicos:

```bash
docker compose up --build
```

3. Se precisar preparar o ambiente manualmente:

```bash
docker compose run --rm web bin/setup --skip-server
```

A aplicacao fica disponivel em `http://localhost:3000` e o PostgreSQL em `localhost:5432`.

## Comandos uteis

```bash
docker compose exec web bin/rails console
docker compose exec web bin/rails test
docker compose exec web bundle exec rubocop
docker compose logs -f worker
```
