# Languava

## Project layout

```
Languava/
├── .gitignore
├── README.md
└── backend/
    ├── pyproject.toml
    ├── alembic.ini
    ├── .env.example
    ├── alembic/
    │   ├── env.py
    │   ├── script.py.mako
    │   └── versions/
    ├── app/
    │   ├── main.py
    │   ├── api/
    │   │   ├── deps.py
    │   │   └── v1/
    │   │       ├── router.py
    │   │       └── endpoints/
    │   ├── core/
    │   │   ├── config.py
    │   │   └── security.py
    │   ├── db/
    │   │   ├── base.py
    │   │   └── session.py
    │   ├── models/
    │   ├── schemas/
    │   ├── services/
    │   └── tasks/
    │       ├── celery_app.py
    │       └── worker.py
    ├── scripts/
    └── tests/
        └── conftest.py
```

## Backend

The backend is a [FastAPI](https://fastapi.tiangolo.com/) service. Dependencies are managed
with [uv](https://docs.astral.sh/uv/), background jobs run on [Celery](https://docs.celeryq.dev/)
with [Redis](https://redis.io/) as both broker and result backend, and database migrations are
handled by [Alembic](https://alembic.sqlalchemy.org/).

### Top-level files

| Path | Purpose |
| --- | --- |
| `pyproject.toml` | Project metadata and dependency declarations consumed by `uv`. |
| `alembic.ini` | Alembic CLI configuration (database URL, script location, logging). |
| `.env.example` | Template for the local `.env` file; documents every required variable. |

### `alembic/` — database migrations

| Path | Purpose |
| --- | --- |
| `env.py` | Alembic runtime entry point; wires the SQLAlchemy metadata to the migration context. |
| `script.py.mako` | Template used by `alembic revision` to scaffold new migration files. |
| `versions/` | Generated migration revisions. Each file represents one schema change. |

### `app/` — application package

The package follows a layered structure: HTTP layer (`api/`) → business logic (`services/`) →
persistence (`models/`, `db/`). `schemas/` defines the boundary types between layers, `core/`
holds cross-cutting concerns, and `tasks/` is the asynchronous worker layer.

| Path | Purpose |
| --- | --- |
| `main.py` | Creates the FastAPI application, configures middleware, and mounts routers. |
| `api/` | HTTP layer. Routers, endpoint handlers, and request/response wiring live here. |
| `api/deps.py` | Reusable FastAPI dependencies (DB session, current user, pagination, etc.). |
| `api/v1/router.py` | Aggregates all v1 endpoint routers into a single `APIRouter`. |
| `api/v1/endpoints/` | One module per resource (e.g. `users.py`, `auth.py`). Keeps handlers thin. |
| `core/` | Cross-cutting infrastructure that is not tied to any single feature. |
| `core/config.py` | `Settings` class (pydantic-settings) that reads environment variables. |
| `core/security.py` | Password hashing, JWT encoding/decoding, and auth primitives. |
| `db/` | Database engine, session factory, and SQLAlchemy declarative base. |
| `db/base.py` | Declarative `Base` plus model imports so Alembic autogenerate sees every table. |
| `db/session.py` | SQLAlchemy `engine` and `SessionLocal`; exposes the dependency used by the API. |
| `models/` | SQLAlchemy ORM models. One module per aggregate. |
| `schemas/` | Pydantic schemas used for request validation and response serialization. |
| `services/` | Business logic. Endpoints call into services; services own transactions and rules. |
| `tasks/` | Celery application and task definitions. |
| `tasks/celery_app.py` | Builds the Celery app, configures the Redis broker and result backend. |
| `tasks/worker.py` | Registers Celery tasks. Imported by the Celery worker process at startup. |

### `scripts/` — operational scripts

One-off and maintenance scripts (data backfills, admin utilities, local bootstrap helpers).
Anything not meant to ship as part of the running service belongs here.

### `tests/` — test suite

Pytest test suite. `conftest.py` holds shared fixtures (test client, database, factories).
Test modules mirror the layout of `app/`.
