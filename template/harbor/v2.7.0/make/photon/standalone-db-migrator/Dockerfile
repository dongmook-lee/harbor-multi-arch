ARG harbor_base_image_version
ARG harbor_base_namespace
FROM ${harbor_base_namespace}/harbor-db-base:${harbor_base_image_version}

ENV EXTERNAL_DB 0

RUN mkdir /harbor/
COPY ./make/migrations /migrations

ARG TARGETARCH
COPY ./make/photon/standalone-db-migrator/binary/migrate-linux-${TARGETARCH:-amd64} /harbor/migrate
COPY ./make/photon/standalone-db-migrator/entrypoint.sh /harbor/

RUN chown -R postgres:postgres /harbor/ \
    && chown -R postgres:postgres /migrations/ \
    && chmod u+x /harbor/migrate /harbor/entrypoint.sh
USER postgres

ENTRYPOINT ["/harbor/entrypoint.sh"]
