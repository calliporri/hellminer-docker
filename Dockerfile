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

# Update system and install necessary dependencies
RUN apt-get update && \
    apt-get install -y wget tar libsodium-dev && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /home

# Fetch latest tag and download the latest Hellminer release
RUN LATEST_TAG=$(curl -s https://api.github.com/repos/hellcatz/hminer/releases/latest | jq -r .tag_name) && \
    wget "https://github.com/hellcatz/hminer/releases/download/${LATEST_TAG}/hellminer_linux64.tar.gz" -O hellminer.tar.gz && \
    tar -xvf hellminer.tar.gz && \
    rm hellminer.tar.gz

# Ensure the binary is executable
RUN chmod +x hellminer

# Expose ports (optional, for visibility in container management tools)
EXPOSE ${PORT} ${API_PORT}

# Health check: Verify hellminer is running every 5 seconds after an initial 60-second delay
HEALTHCHECK --interval=5s --timeout=3s --start-period=60s --retries=3 \
  CMD pgrep hellminer > /dev/null || exit 1

# Set the entrypoint to start mining
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["./hellminer -c \"$STRATUM_URL\" -u \"$WALLET.$WORKER\" -p x --cpu \"$CPU\" --api-port=\"$API_PORT\" --api-pass=\"$API_PASS\""]
