#!/bin/bash
# Railway defaults for pgAdmin, then hand over to the image's own entrypoint.
# Every value can be overridden with a service variable of the same name.
set -euo pipefail

# Railway routes the public domain to $PORT.
export PGADMIN_LISTEN_PORT="${PGADMIN_LISTEN_PORT:-${PORT:-5050}}"

# No local mail server in the container (password-reset mail needs SMTP, see README).
export PGADMIN_DISABLE_POSTFIX="${PGADMIN_DISABLE_POSTFIX:-true}"

# Railway's edge proxy can change the client address between requests,
# which would log users out with the IP-bound session cookie.
export PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION="${PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION:-False}"

# Upstream locks an account after 3 failed logins; on a public URL that lets
# anyone who knows the login email lock the admin out. The password is a
# 24-character random secret, so 10 attempts is still safe.
export PGADMIN_CONFIG_MAX_LOGIN_ATTEMPTS="${PGADMIN_CONFIG_MAX_LOGIN_ATTEMPTS:-10}"

if [[ ! -f /var/lib/pgadmin/pgadmin4.db ]]; then
    echo "railway-start: first boot, creating the pgAdmin login ${PGADMIN_DEFAULT_EMAIL:-<PGADMIN_DEFAULT_EMAIL is not set>}"
else
    echo "railway-start: existing pgAdmin data found on the volume; PGADMIN_DEFAULT_EMAIL/PASSWORD are not re-applied"
fi

exec /entrypoint.sh "$@"
