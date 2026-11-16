# pgAdmin 4 for Railway: the official image, pinned by version and digest.
FROM dpage/pgadmin4:9.19.0@sha256:3591b3d02910dcd817dec6fcaa681c278ba6966945283dd0ea0042731c330c83

# Start as root so the image's entrypoint can chown the Railway volume
# (/var/lib/pgadmin) and then drop to the pgadmin user (uid 5050) with su-exec.
USER root

COPY railway-start.sh /railway-start.sh
RUN chmod 755 /railway-start.sh

EXPOSE 5050
ENTRYPOINT ["/railway-start.sh"]
