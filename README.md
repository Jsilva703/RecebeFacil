# RecebeFacil

Fundacao tecnica de uma API Rails para um SaaS de controle de servicos e cobrancas.

## Stack

- Ruby 3.2.3
- Ruby on Rails 6.1 em modo API
- PostgreSQL
- RSpec
- Docker e Docker Compose

## Configuracao

Copie o arquivo de exemplo de variaveis de ambiente:

```sh
cp .env.example .env
```

As principais variaveis sao:

- `DATABASE_HOST`
- `DATABASE_PORT`
- `DATABASE_USERNAME`
- `DATABASE_PASSWORD`
- `DATABASE_NAME`
- `DATABASE_TEST_NAME`
- `RAILS_MAX_THREADS`

## Executando com Docker

```sh
docker compose build
docker compose up
```

A API ficara disponivel em `http://localhost:3000`.

Health check:

```sh
curl -i http://localhost:3000/health
```

## Rodando testes com Docker

```sh
docker compose run --rm -e RAILS_ENV=test api bash -lc "bundle exec rails db:prepare && bundle exec rspec"
```

## Executando localmente sem Docker

Instale as dependencias Ruby:

```sh
bundle config set path vendor/bundle
bundle install
```

Configure o PostgreSQL e ajuste as variaveis de ambiente conforme necessario. Depois execute:

```sh
bundle exec rails db:prepare
bundle exec rails server
```

## Testes locais

```sh
RAILS_ENV=test bundle exec rails db:prepare
bundle exec rspec
```