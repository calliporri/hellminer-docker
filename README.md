# Hellminer Docker Container

This repository provides a Docker container for **Hellminer**, an optimized CPU miner for Verus Coin (VRSC). The container is based on Ubuntu and includes all necessary dependencies to start mining immediately.

## Features
- Supports **stratum+tcp** and **stratum+ssl** connections.
- Configurable wallet, worker name, CPU count, and pool connection.
- Exposes an optional API for monitoring.
- Lightweight and minimal dependencies.

## Usage

### Pull the Docker Image
```
docker pull simeononsecurity/hellminer:latest
```

### Run the Miner
```
docker run -itd \
  -e STRATUM="stratum+ssl"
  -e URL="na.luckpool.net" \
  -e PORT=3958 \
  -e WALLET="R9SWmsN6Dq1ocqkeB9GUVwP4RGMXt2mNLf" \
  -e WORKER="SimeononSecurityMadeMe" \
  -e CPU=2 \
  -e API_PORT=8080 \
  -e API_PASS="" \
  --name verusminer \
  simeononsecurity/hellminer:latest
```

### Configuration Options
| Environment Variable | Description |
|----------------------|-------------|
| `URL` | Mining pool URL (default: `ap.luckpool.net`) |
| `PORT` | Mining pool port (default: `3956`) |
| `STRATUM` | Stratum protocol URL (supports `stratum+tcp` and `stratum+ssl`) |
| `WALLET` | Wallet address for receiving payouts |
| `WORKER` | Worker name for pool tracking |
| `CPU` | Number of CPU cores to use |
| `API_PORT` | Port for the miner's monitoring API |
| `API_PASS` | Password for API authentication (optional) |

### Exposed Ports
- **${PORT}** (Mining Pool Connection)
- **${API_PORT}** (Monitoring API, if enabled)

## Monitoring API
The miner supports an HTTP API for monitoring when `API_PORT` is set.
```
http://localhost:8080/
```
Set `API_PASS` for secured access to `http://localhost:8080/admin`.

## Stopping the Miner
```
docker stop verusminer
```

## Removing the Container
```
docker rm verusminer
```

