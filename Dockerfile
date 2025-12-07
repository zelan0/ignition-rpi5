# Dockerfile for Ignition 8.1.50 on Raspberry Pi 5 (ARM64)
FROM arm64v8/debian:bullseye

# Install dependencies including unzip for SQLite native library extraction
RUN apt-get update && apt-get install -y \
    procps \
    libsqlite3-0 \
    libc6 \
    libstdc++6 \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/ignition

# Copy local Ignition installation
COPY Ignition-linux-aarch-64-8.1.50/ /opt/ignition/
COPY modules/ /opt/ignition/user-lib/modules/

# Set execute permissions on all scripts and binaries
RUN chmod +x /opt/ignition/*.sh /opt/ignition/ignition-gateway

# Create required directories
RUN mkdir -p /opt/ignition/data /opt/ignition/logs /opt/ignition/temp /opt/ignition/native-lib /opt/ignition/config-templates && \
    chmod 777 /opt/ignition/temp

# Pre-extract SQLite native library for ARM64 (critical for aarch64 compatibility)
RUN cd /opt/ignition/native-lib && \
    unzip -j /opt/ignition/lib/core/gateway/sqlite-jdbc-3.41.2.2.jar \
    "org/sqlite/native/Linux/aarch64/libsqlitejdbc.so" -d . && \
    chmod 755 libsqlitejdbc.so && \
    ls -la /opt/ignition/native-lib/

# Copy ARM64-compatible logback.xml to config-templates (will be copied at startup)
# This avoids SQLite logging which causes native library issues on ARM64
RUN cp /opt/ignition/data/logback.xml /opt/ignition/config-templates/logback.xml

COPY startup.sh /opt/ignition/startup.sh
RUN chmod +x /opt/ignition/startup.sh

EXPOSE 8088 8043

ENV ACCEPT_IGNITION_EULA=Y
ENV GATEWAY_ADMIN_USERNAME=admin
ENV GATEWAY_ADMIN_PASSWORD=password
ENV IGNITION_EDITION=edge

CMD ["/opt/ignition/startup.sh"]
