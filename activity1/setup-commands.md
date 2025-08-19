# Docker Multi-Container Monitoring Setup
## 2110415 Software-defined Systems - Activity 1

### Prerequisites
- Docker installed and running
- Files required:
  - `status.conf` - Apache server status configuration
  - `prometheus.yml` - Prometheus scraping configuration

---

## 1. Network Creation
Create a dedicated network for container communication:
```bash
docker network create monitoring-network
```

---

## 2. Persistent Storage Creation
Create volumes for data persistence across container restarts:
```bash
docker volume create prometheus-data

docker volume create grafana-data
```

---

## 3. Container Deployment Commands

### 3.1 Apache Web Server
```bash
docker run -d \
  --name apache \
  --network monitoring-network \
  -p 8080:80 \
  -v $(pwd)/status.conf:/etc/apache2/mods-enabled/status.conf \
  ubuntu/apache2
```

### 3.2 Apache Exporter
```bash
docker run -d \
  --name apache-exporter \
  --network monitoring-network \
  -p 9117:9117 \
  bitnami/apache-exporter \
  --scrape_uri="http://apache:80/server-status?auto"
```

### 3.3 Node Exporter
```bash
docker run -d \
  --name node-exporter \
  --network monitoring-network \
  -p 9100:9100 \
  prom/node-exporter
```

### 3.4 Prometheus
```bash
docker run -d \
  --name prometheus \
  --network monitoring-network \
  -p 9090:9090 \
  -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
  -v prometheus-data:/prometheus \
  prom/prometheus
```

### 3.5 Grafana
```bash
docker run -d \
  --name grafana \
  --network monitoring-network \
  -p 3000:3000 \
  -v grafana-data:/var/lib/grafana \
  grafana/grafana
```

---

## 4. Verification Commands

### Check all containers are running:
```bash
docker ps
```

### Verify network connectivity:
```bash
docker network inspect monitoring-network
```

### Test endpoints:
- Apache: http://localhost:8080
- Apache Status: http://localhost:8080/server-status
- Apache Exporter: http://localhost:9117/metrics
- Node Exporter: http://localhost:9100/metrics
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (default: admin/admin)

### Run test program:
```bash
./activity1-macos-arm64
```

---

## 5. Grafana Configuration

1. Access Grafana at http://localhost:3000
2. Login with admin/admin
3. Add Prometheus data source:
   - Configuration → Data Sources → Add data source
   - Select Prometheus
   - URL: `http://prometheus:9090`
   - Click "Save & Test"

4. Create dashboards with metrics:
   - **Node Exporter metrics:**
     - `node_cpu_seconds_total` - CPU usage by mode
     - `node_memory_MemAvailable_bytes` - Available memory
     - `node_filesystem_avail_bytes` - Available disk space
   
   - **Apache Exporter metrics:**
     - `apache_up` - Apache server status (up/down)
     - `apache_workers` - Active worker threads
     - `apache_accesses_total` - Total number of accesses
     - `apache_sent_kilobytes_total` - Total data sent

---

## 6. Screenshots Required for Submission

### 2.1 Commands and Results

#### 2.1.1 Network Creation Command
```bash
docker network create monitoring-network
```

#### 2.1.2 Persistent Storage Creation Commands
```bash
docker volume create prometheus-data
docker volume create grafana-data
```

#### 2.1.3 Container Run Commands

**Apache Container:**
```bash
docker run -d --name apache --network monitoring-network -p 8080:80 \
  -v $(pwd)/status.conf:/etc/apache2/mods-enabled/status.conf ubuntu/apache2
```
**Description:** Runs Apache web server with server-status endpoint enabled for metrics collection.

**Apache Exporter Container:**
```bash
docker run -d --name apache-exporter --network monitoring-network -p 9117:9117 \
  bitnami/apache-exporter --scrape_uri="http://apache:80/server-status?auto"
```
**Description:** Collects Apache metrics and exposes them in Prometheus format.

**Node Exporter Container:**
```bash
docker run -d --name node-exporter --network monitoring-network -p 9100:9100 \
  prom/node-exporter
```
**Description:** Collects system-level metrics (CPU, memory, disk, network).

**Prometheus Container:**
```bash
docker run -d --name prometheus --network monitoring-network -p 9090:9090 \
  -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
  -v prometheus-data:/prometheus prom/prometheus
```

**Grafana Container:**
```bash
docker run -d --name grafana --network monitoring-network -p 3000:3000 \
  -v grafana-data:/var/lib/grafana grafana/grafana
```

**Verify All Containers:**
```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

## 7. Cleanup Commands

### Stop all containers:
```bash
docker stop apache apache-exporter node-exporter prometheus grafana
```

### Remove all containers:
```bash
docker rm apache apache-exporter node-exporter prometheus grafana
```

### Remove network:
```bash
docker network rm monitoring-network
```

### Remove volumes:
```bash
docker volume rm prometheus-data grafana-data
```