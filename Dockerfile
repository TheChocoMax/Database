FROM postgres:17.5-alpine3.21

RUN apk --no-cache add su-exec tini && \
    chmod 0755 /usr/bin/su-exec && \
    chown -R postgres:postgres /var/lib/postgresql /var/run/postgresql && \
    find / -type f -perm -4000 -exec chmod ug-s {} + 2>/dev/null || true

ENV TEMP_SQL_DIR=/temp-sql-files

ENTRYPOINT ["tini", "--", "/usr/local/bin/docker-entrypoint.sh"]

VOLUME ["/var/lib/postgresql/data"]
VOLUME ["/docker-entrypoint-initdb.d"]

# Copy all initialization files into a temporary location SQL
COPY . ${TEMP_SQL_DIR}/

# Flatten the directory structure and rename files to include folder names
COPY ./scripts/flatten-sql.sh /usr/local/bin/flatten-sql.sh
RUN chmod +x /usr/local/bin/flatten-sql.sh && \
    /usr/local/bin/flatten-sql.sh "${TEMP_SQL_DIR}" "/docker-entrypoint-initdb.d" && \
    rm -rf "${TEMP_SQL_DIR:?}/"

RUN chown -R postgres:postgres /docker-entrypoint-initdb.d

COPY ./conf/postgresql.conf /etc/postgresql/postgresql.conf

USER postgres

EXPOSE 5432

HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD pg_isready -U postgres || exit 1

CMD ["postgres"]
