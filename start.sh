#!/bin/bash

echo "Fetching latest Hellminer release..."
LATEST_TAG=$(curl -s https://api.github.com/repos/hellcatz/hminer/releases/latest | jq -r .tag_name)

# Validate ARCH_TYPE and set the correct filename
case "$ARCH_TYPE" in
  hellminer_linux64.tar.gz|hellminer_linux64_avx.tar.gz|hellminer_linux64_avx2.tar.gz)
    echo "Using miner variant: $ARCH_TYPE"
    ;;
  *)
    echo "Invalid ARCH_TYPE specified. Falling back to default: hellminer_linux64.tar.gz"
    ARCH_TYPE="hellminer_linux64.tar.gz"
    ;;
esac

echo "Downloading Hellminer version: $LATEST_TAG ($ARCH_TYPE)"
wget -q "https://github.com/hellcatz/hminer/releases/download/${LATEST_TAG}/${ARCH_TYPE}" -O hellminer.tar.gz

echo "Extracting Hellminer..."
tar -xvf hellminer.tar.gz
rm hellminer.tar.gz

# Ensure the binary is executable
chmod +x hellminer

# Construct the stratum URL dynamically
STRATUM_URL="${STRATUM}://${URL}:${PORT}#xnsub"

echo "Stratum URL: $STRATUM_URL"

# Start mining with provided environment variables
echo "Starting Hellminer..."
exec ./hellminer -c "$STRATUM_URL" -u "$WALLET.$WORKER" -p x --cpu "$CPU" --api-port="$API_PORT" --api-pass="$API_PASS"
