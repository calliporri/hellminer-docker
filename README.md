# **Hellminer Docker Container**

This repository provides a Docker container for **Hellminer**, an optimized CPU miner for Verus Coin (VRSC). The container is based on Ubuntu and includes all necessary dependencies to start mining immediately.

_________
[![Sponsor](https://img.shields.io/badge/Sponsor-Click%20Here-ff69b4)](https://github.com/sponsors/simeononsecurity) [![DockerHub](https://img.shields.io/badge/DockerHub-View%20Image-blue?logo=docker)](https://hub.docker.com/r/simeononsecurity/hellminer)
_________

## **Features**
- Supports **stratum+tcp** and **stratum+ssl** connections.
- Defaults to **stratum+ssl** with port **3958**.
- Configurable wallet, worker name, CPU count, and pool connection.
- Exposes an optional API for monitoring.
- Includes a built-in health check to ensure the miner is running.
- Allows selection of optimized miner binaries (`AVX` or `AVX2`).
- Lightweight and minimal dependencies.

---

## **Usage**

### **Pull the Docker Image**
```sh
docker pull simeononsecurity/hellminer:latest
```

### **Run the Miner**
```sh
docker run -itd \
  -e STRATUM="stratum+ssl" \
  -e URL="na.luckpool.net" \
  -e PORT=3958 \
  -e WALLET="R9SWmsN6Dq1ocqkeB9GUVwP4RGMXt2mNLf" \
  -e WORKER="SimeononSecurityMadeMe" \
  -e CPU=2 \
  -e API_PORT=8080 \
  -e API_PASS="" \
  -e ARCH_TYPE="hellminer_linux64.tar.gz" \
  --name verusminer \
  simeononsecurity/hellminer:latest
```

---

## **Selecting the Miner Version**
The `ARCH_TYPE` variable allows you to choose between different optimized miner binaries:

| **ARCH_TYPE Value**             | **Description**                                      |
|---------------------------------|------------------------------------------------------|
| `hellminer_linux64.tar.gz`      | **Default** - Standard miner version                |
| `hellminer_linux64_avx.tar.gz`  | AVX-optimized miner for CPUs supporting AVX        |
| `hellminer_linux64_avx2.tar.gz` | AVX2-optimized miner for CPUs supporting AVX2      |

To **use an AVX-optimized version**, set `ARCH_TYPE` like this:
```sh
docker run -itd \
  -e ARCH_TYPE="hellminer_linux64_avx.tar.gz" \
  simeononsecurity/hellminer:latest
```

To **use AVX2**, simply change:
```sh
docker run -itd \
  -e ARCH_TYPE="hellminer_linux64_avx2.tar.gz" \
  simeononsecurity/hellminer:latest
```

If an **invalid value** is provided, the default (`hellminer_linux64.tar.gz`) will be used.

---

## **Configuration Options**
| Environment Variable | Description |
|----------------------|-------------|
| `URL` | Mining pool URL (default: `na.luckpool.net`) |
| `PORT` | Mining pool port (default: `3958`) |
| `STRATUM` | Stratum protocol (`stratum+tcp` or `stratum+ssl`, default: `stratum+ssl`) |
| `STRATUM_URL` | Auto-generated from `STRATUM`, `URL`, and `PORT` |
| `WALLET` | Wallet address for receiving payouts |
| `WORKER` | Worker name for pool tracking |
| `CPU` | Number of CPU cores to use |
| `API_PORT` | Port for the miner's monitoring API |
| `API_PASS` | Password for API authentication (optional) |
| `ARCH_TYPE` | Miner binary selection (`hellminer_linux64.tar.gz`, `hellminer_linux64_avx.tar.gz`, `hellminer_linux64_avx2.tar.gz`) |

---

## **Exposed Ports**
- **`${PORT}`** (Mining Pool Connection)
- **`${API_PORT}`** (Monitoring API, if enabled)

---

## **Health Check**
The container includes a health check that verifies if `hellminer` is running:
- Starts checking **after 60 seconds**.
- Runs **every 5 seconds**.
- If the miner is not running, the container is marked as **unhealthy**.

To check the health status:
```sh
docker inspect --format='{{.State.Health.Status}}' verusminer
```

---

## **Monitoring API**
The miner supports an HTTP API for monitoring when `API_PORT` is set.
```sh
http://localhost:8080/
```
Set `API_PASS` for secured access to `http://localhost:8080/admin`.

---

## **Stopping the Miner**
```sh
docker stop verusminer
```

## **Removing the Container**
```sh
docker rm verusminer
```

---

<a href="https://simeononsecurity.ch" target="_blank" rel="noopener noreferrer">
  <h2>Explore the World of Cybersecurity</h2>
</a>
<a href="https://simeononsecurity.ch" target="_blank" rel="noopener noreferrer">
  <img src="https://simeononsecurity.ch/img/banner.png" alt="SimeonOnSecurity Logo" width="300" height="300">
</a>

### **Links:**
- #### [github.com/simeononsecurity](https://github.com/simeononsecurity)
- #### [simeononsecurity.ch](https://simeononsecurity.ch)
