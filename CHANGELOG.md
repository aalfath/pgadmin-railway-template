# Changelog

Each entry is one version of this Railway template. Breaking changes come first.
## Unreleased (2026-11-16)

- README: Deploy on Railway button linking to the published template `pgadmin-1`. No change to the image or the service.


## 9.19.0 (2026-11-16)

- First release: pgAdmin 4 9.19.0 (`dpage/pgadmin4:9.19.0@sha256:3591b3d0…`), built from this repo.
- Data (users, saved servers, settings, query history) lives on a volume at `/var/lib/pgadmin`.
- The admin password is generated at deploy (`PGADMIN_DEFAULT_PASSWORD`); the only prompt is the login email.
- Health check `/misc/ping`; listens on `PORT` (5050).
