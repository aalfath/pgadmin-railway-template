# pgAdmin on Railway

A Railway template for [pgAdmin 4](https://www.pgadmin.org/), the web admin and query tool for PostgreSQL.

- **Version:** pgAdmin 4 **9.19.0**, official image `dpage/pgadmin4:9.19.0` pinned by digest in the [`Dockerfile`](Dockerfile).
- **Services:** one, `pgAdmin`, built from this repo. It doesn't include a database: connect it to any PostgreSQL server, such as a Railway Postgres in the same project.
- **Data:** a volume at `/var/lib/pgadmin` keeps users, saved servers, preferences and query history across redeploys.

## Variables

| Variable | Default | What it does |
|---|---|---|
| `PGADMIN_DEFAULT_EMAIL` | *(asked at deploy)* | Login email of the first admin account |
| `PGADMIN_DEFAULT_PASSWORD` | `${{secret(24)}}` | Password of that account, generated at deploy. Read it in the service's Variables tab |
| `PORT` | `5050` | Port pgAdmin listens on; the public domain points here |

Both login values are used only on the first boot, when the volume is empty. To change the password later, use pgAdmin's own *Change Password* menu.

Settings baked into [`railway-start.sh`](railway-start.sh), each overridable with a service variable of the same name:

- `PGADMIN_DISABLE_POSTFIX=true` (no mail server in the container)
- `PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION=False` (Railway's proxy can change the client address between requests)
- `PGADMIN_CONFIG_MAX_LOGIN_ATTEMPTS=10` (upstream default is 3)

Any other pgAdmin setting can be set as `PGADMIN_CONFIG_<NAME>` (see [pgAdmin's container docs](https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html)). Strings need Python quotes, for example `PGADMIN_CONFIG_MAIL_SERVER='smtp.example.com'`.

## Connecting to a Railway Postgres

Add a server in pgAdmin with host `postgres.railway.internal` (or the Postgres service's `RAILWAY_PRIVATE_DOMAIN`), port `5432`, and the user and password from that service's `PGUSER` and `PGPASSWORD`. Use the database's TCP proxy host and port for databases outside the project.

## Updates

Railway notifies everyone who deployed this template when a change is merged to `main`. Each update bumps the pinned image and adds an entry to [`CHANGELOG.md`](CHANGELOG.md); read it before you apply an update. Your data stays on the volume; pgAdmin migrates its own database on start.
