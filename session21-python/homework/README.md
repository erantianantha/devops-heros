# Session 21 — TaskBoard: manual run + Docker Compose

App: React frontend (Vite → nginx) · FastAPI backend · PostgreSQL 16. Code: [`../frontend`](../frontend), [`../backend`](../backend).

## 1. Run manually (frontend, backend, PostgreSQL)
```bash
docker run -d --name s21-postgres -e POSTGRES_DB=taskboard -e POSTGRES_USER=taskboard \
  -e POSTGRES_PASSWORD=taskboard -p 5433:5432 postgres:16-alpine          # DB
cd backend && python3.13 -m venv .venv && .venv/bin/pip install -r requirements.txt
export DATABASE_URL='postgresql+psycopg://taskboard:taskboard@localhost:5433/taskboard'
.venv/bin/alembic upgrade head && .venv/bin/uvicorn app.main:app --port 8000   # backend
cd ../frontend && npm install && npx vite --config vite.config.local.js         # frontend :5173
```
- Port **5433**: a local PostgreSQL already uses 5432.
- **Bug found:** `vite.config.js` proxies `/api` to `:8080` but the backend is on `:8000` → `/api/tasks` gave **502**. Fixed with [`vite.config.local.js`](../frontend/vite.config.local.js).

![backend](screenshots/01-manual-backend.png)
![frontend](screenshots/02-manual-frontend.png)
![ui](screenshots/03-manual-ui.png)

## 2. Dockerfiles + docker-compose
- [`backend/Dockerfile`](../backend/Dockerfile): python:3.12-slim, non-root user, runs `alembic upgrade head` then uvicorn.
- [`frontend/Dockerfile`](../frontend/Dockerfile): multi-stage, node:22 builds → nginx serves and proxies `/api` to `backend:8000`.
- [`docker-compose.yml`](../docker-compose.yml): postgres + backend + frontend, named volume `postgres-data`.

```bash
docker compose up -d --build
```
- **Bug found:** backend `Exited (1)`: `PermissionError: /app/app/__init__.py`. Source files were mode `600` and the container runs as non-root uid 10001. Fixed with `chmod -R a+rX backend frontend` + rebuild.

![compose up](screenshots/04-compose-up.png)

## 3. Test the application and APIs
| API | Result |
| :--- | :--- |
| `GET /health`, `/ready` | `UP`, `READY` (DB reachable) |
| `POST /api/tasks` | 201, task created |
| `PUT /api/tasks/1` | status → `DONE` |
| `GET /api/tasks/stats` | `{"total":1,"done":1}` |
| `POST localhost:3000/api/tasks` | works through the frontend nginx proxy |
| `DELETE /api/tasks/2` | 204 |

![api](screenshots/05-api-tests.png)
![ui](screenshots/06-compose-ui.png)
![swagger](screenshots/07-swagger-docs.png)
