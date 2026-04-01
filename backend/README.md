Simple Node.js auth backend for NexusGym

Run (from this folder):

1) Install dependencies

```bash
npm install
```

2) Start server

```bash
npm run start
```

The server listens on `PORT` (default 4000) and exposes:
- `POST /api/auth/register` {email,password,displayName}
- `POST /api/auth/login` {email,password}
- `GET /api/auth/me` (requires `Authorization: Bearer <token>`)

Database: SQLite stored in `backend/data/database.sqlite3`.
