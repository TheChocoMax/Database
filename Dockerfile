# Base image
FROM alpine:3.22

# Set environment variables
ENV LANG=en_US.UTF-8 \
    PGDATA=/var/lib/postgresql/data \
    POSTGRES_DB=chocomax \
    POSTGRES_USER=postgres

# Install PostgreSQL and required tools
RUN apk add --no-cache bash postgresql postgresql-contrib su-exec tini

# Ensure required directories exist and are owned by the postgres user
RUN mkdir -p /run/postgresql "$PGDATA" && \
    chown -R postgres:postgres /run/postgresql "$PGDATA"

# Copy entrypoint script
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy the SQL scripts
COPY database/ /docker-entrypoint-initdb.d/

# Copy the initialization scripts
COPY scripts/flatten-sql.sh /usr/local/bin/flatten-sql.sh
COPY scripts/rebuild-db.sh /usr/local/bin/init-db.sh
RUN chmod +x /usr/local/bin/flatten-sql.sh
RUN chmod +x /usr/local/bin/init-db.sh

# Use tini for proper signal handling
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]

# Default command
CMD []

# Expose port
EXPOSE 5432/tcp

# Healthcheck to ensure PostgreSQL is ready
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 \
    CMD pg_isready -q -h /run/postgresql -U "$POSTGRES_USER" || exit 1
