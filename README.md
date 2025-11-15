# ERPNext Docker Setup

Production-ready Docker setup for ERPNext with proper service architecture.

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- 4GB RAM minimum (8GB recommended)
- 20GB disk space minimum

## Quick Start

1. Clone this repository or copy the files
2. Edit `.env` file with your passwords and site name
3. Run the containers:

```bash
docker compose up -d
```

4. Wait 5-10 minutes for initial setup
5. Access ERPNext at http://localhost:8080

Default credentials:
- Username: Administrator
- Password: admin (or what you set in .env)

## Services Architecture

- **backend**: Main ERPNext application server
- **frontend**: Nginx reverse proxy serving static files
- **websocket**: Real-time communication via Socket.IO
- **scheduler**: Background job scheduler
- **worker**: Default queue worker
- **worker-short**: Short-running tasks worker
- **worker-long**: Long-running tasks worker
- **db**: MariaDB database
- **redis-cache**: Redis for caching
- **redis-queue**: Redis for job queues
- **redis-socketio**: Redis for Socket.IO

## Configuration

Edit `.env` file before deployment:

- `SITE_NAME`: Your site domain (default: erp.localhost)
- `DB_ROOT_PASSWORD`: Database root password
- `ADMIN_PASSWORD`: ERPNext admin password

## Production Deployment

For production use:

1. Change all passwords in `.env`
2. Set proper domain in `SITE_NAME`
3. Configure SSL/TLS (add reverse proxy like Traefik or Nginx)
4. Set up regular backups
5. Configure firewall rules

### SSL Setup

For production, use a reverse proxy with SSL:

```yaml
services:
  nginx-proxy:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./certs:/etc/nginx/certs
```

## Commands

### View logs
```bash
docker compose logs -f [service-name]
```

### Stop all services
```bash
docker compose down
```

### Restart services
```bash
docker compose restart
```

### Backup
```bash
docker compose exec backend bench backup
```

### Update ERPNext
```bash
docker compose pull
docker compose up -d
```

### Access bench console
```bash
docker compose exec backend bash
bench console
```

## Volumes

Data is persisted in Docker volumes:
- `db-data`: MariaDB database files
- `sites`: ERPNext sites and uploads
- `logs`: Application logs
- `redis-*-data`: Redis persistence

## Troubleshooting

### Site creation fails
Check logs: `docker compose logs create-site`

### Cannot access on port 8080
Check if frontend service is running: `docker compose ps frontend`

### Database connection issues
Verify MariaDB is healthy: `docker compose ps db`

### Reset everything
```bash
docker compose down -v
docker compose up -d
```

## Custom Apps

To add custom apps, create a custom Dockerfile:

```dockerfile
FROM frappe/erpnext:latest

USER frappe
WORKDIR /home/frappe/frappe-bench

RUN bench get-app --branch version-15 https://github.com/your/custom-app
```

Then build and update docker-compose.yml to use your image.

## Resources

- [Official ERPNext Documentation](https://docs.erpnext.com)
- [Frappe Docker Repository](https://github.com/frappe/frappe_docker)
- [ERPNext GitHub](https://github.com/frappe/erpnext)

## License

This setup is provided as-is. ERPNext is licensed under GPL v3.
"# Docker-ERPNext" 
"# Docker-ERPNext" 
"# Docker-ERPNext" 
