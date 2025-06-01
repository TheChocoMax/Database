FROM alpine:3.21

# Install common tools and PostgreSQL
RUN apk add --no-cache bash git \
    postgresql postgresql-contrib su-exec tini

# Setup default user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN addgroup -g $USER_GID -S $USERNAME && \
    adduser -u $USER_UID -S -G $USERNAME -s /bin/bash $USERNAME && \
    mkdir -p /var/lib/postgresql/data /run/postgresql && \
    chown -R $USERNAME:$USERNAME /var/lib/postgresql /run/postgresql

# Set environment variables for PostgreSQL
ENV PGDATA=/var/lib/postgresql/data

# Switch to the default user
USER $USERNAME
