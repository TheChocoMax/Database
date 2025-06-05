FROM alpine:3.22

# Install common tools, PostgreSQL and build tools for pgTAP
RUN apk add --no-cache bash git \
    postgresql postgresql-contrib su-exec tini \
    make gcc musl-dev postgresql-dev perl patch \
    build-base perl-dev openssl-dev \
    && cpan TAP::Parser::SourceHandler::pgTAP

# Build and install pgTAP from source
RUN git clone --depth 1 https://github.com/theory/pgtap && \
    cd pgtap && make && make install && cd .. && rm -rf pgtap

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
