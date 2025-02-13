# Use a lightweight base image
FROM ubuntu:latest

# Set environment variables
ENV URL=ap.luckpool.net
ENV PORT=3956
ENV STRATUM=stratum+tcp://ap.luckpool.net:3956#xnsub
ENV WALLET=R9SWmsN6Dq1ocqkeB9GUVwP4RGMXt2mNLf
ENV WORKER=AceHellMiner
ENV CPU=2
ENV API_PORT=8080
ENV API_PASS=""

# Update system and install necessary dependencies
RUN apt-get update && \
    apt-get install -y wget tar libsodium-dev && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /home

# Download and extract Hellminer
RUN wget https://github.com/hellcatz/luckpool/raw/master/miners/hellminer_cpu_linux.tar.gz && \
    tar -xvf hellminer_cpu_linux.tar.gz && \
    rm hellminer_cpu_linux.tar.gz

# Ensure the binary is executable
RUN chmod +x hellminer

# Expose ports (optional, for visibility in container management tools)
EXPOSE ${PORT} ${API_PORT}

# Set the entrypoint to start mining
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["./hellminer -c ${STRATUM} -u ${WALLET}.${WORKER} -p x --cpu ${CPU} --api-port=${API_PORT} --api-pass=${API_PASS}"]
