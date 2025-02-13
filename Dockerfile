# Use a lightweight base image
FROM ubuntu:latest

LABEL org.opencontainers.image.source="https://github.com/simeononsecurity/hellminer-docker"
LABEL org.opencontainers.image.description="Hellminer in a Docker Container amd64 Support Only"
LABEL org.opencontainers.image.authors="simeononsecurity"

ENV DEBIAN_FRONTEND=noninteractive
ENV container=docker
ENV TERM=xterm

# Set default environment variables
ENV URL=na.luckpool.net
ENV PORT=3958
ENV STRATUM="stratum+ssl"
ENV WALLET=R9SWmsN6Dq1ocqkeB9GUVwP4RGMXt2mNLf
ENV WORKER=SimeonOnSecuritySentMe
ENV CPU=2
ENV API_PORT=8080
ENV API_PASS=""

# Construct the Stratum URL dynamically
ENV STRATUM_URL="${STRATUM}://${URL}:${PORT}#xnsub"

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y wget tar curl jq libsodium-dev && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /home

# Copy the start script into the container
COPY start.sh /home/start.sh
RUN chmod +x /home/start.sh

# Expose necessary ports
EXPOSE ${PORT} ${API_PORT}

# Health check: Verify hellminer is running every 5 seconds after an initial 60-second delay
HEALTHCHECK --interval=5s --timeout=3s --start-period=60s --retries=3 \
  CMD pgrep hellminer > /dev/null || exit 1

# Set entrypoint to execute the script
ENTRYPOINT ["/bin/bash", "/home/start.sh"]
