# DfE: Complete conversions, transfers and changes

[![Continuous integration](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration.yml/badge.svg)](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration.yml)

## Getting started

### Setup Microsoft SQL Server

As we run Microsoft SQL Server, we have to run it inside a container. To make
this as simple as we can we use docker-compose to launch an appropriate
instance.

Duplicate `.env.database.example` as `.env.database` and set:

```
ACCEPT_EULA=Y
SA_PASSWORD=<database_password>
```

Where `<database_password>` is at least 8 characters including uppercase,
lowercase letters, base-10 digits and/or non-alphanumeric symbols, see the
[image docs](https://hub.docker.com/_/microsoft-mssql-server).

These are then used by the `docker-compose-database.local.yml` to launch and
instance of SQL Server.

Create `.env.development.local` and `.env.test.local` and add:

```
DATABASE_PASSWORD=<database_password>
```

Where `<database_password>` is the same as in `.env.database`.

The applicaiton will use these credentials to access the database and so must
all be the same.

### Setup everything else

This repository follows the
[Scripts To Rule Them All](https://github.com/dxw/tech-team-rfcs/blob/main/rfc-023-use-scripts-to-rule-them-all.md)
pattern. To get started with development (or to restore your environment to a
clean state):

1. Make sure you have [Homebrew](https://brew.sh/) installed
1. Run `script/setup`.

This will handle installing various dependencies, and run application setup
tasks.

### Add yourself as a user

The service will need to recognise you as a user, use the `users:create` task to
add your DfE email address.

```bash
bin/rails users:create EMAIL_ADDRESS=you@education.gov.uk
```

## Running a server

To start a local server, run `script/server`. Once started the application is
available at [`http://localhost:3000/`](http://localhost:3000/).

## Testing

To run the test suite, run `script/test`.

## Environment variables

See .env.example

## Release process

Use the [release process template in Trello](https://trello.com/c/8enGdMyy) to
start a new release.

## ADRs

You can find the [ADRs](https://adr.github.io/) for this project in the
[`doc/decisions`](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/tree/develop/doc/decisions)
folder.
