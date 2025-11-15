# ERPNext Docker Operations Guide

## Daily Operations

### Start Services
```bash
docker compose up -d
```

### Stop Services
```bash
docker compose down
```

### Restart Services
```bash
docker compose restart
```

### View All Logs
```bash
docker compose logs -f
```

### View Specific Service Logs
```bash
docker compose logs -f backend
docker compose logs -f db
docker compose logs -f worker
```

## Maintenance

### Update ERPNext
```bash
docker compose pull
docker compose down
docker compose up -d
```

### Backup
```bash
./backup.sh
```

Manual backup:
```bash
docker compose exec backend bench backup --with-files
```

### Restore Backup
```bash
docker compose exec backend bench restore /path/to/backup.sql --with-files /path/to/files.tar
```

### Access Bench CLI
```bash
docker compose exec backend bash
bench console
```

### Run Bench Commands
```bash
docker compose exec backend bench migrate
docker compose exec backend bench clear-cache
docker compose exec backend bench rebuild-global-search
```

## Database Operations

### Access MariaDB Console
```bash
docker compose exec db mysql -u root -p
```

### Database Backup Only
```bash
docker compose exec db mysqldump -u root -p${DB_ROOT_PASSWORD} --all-databases > backup.sql
```

### Database Restore
```bash
docker compose exec -T db mysql -u root -p${DB_ROOT_PASSWORD} < backup.sql
```

## Site Management

### Create New Site
```bash
docker compose exec backend bench new-site new-site.localhost --admin-password admin --install-app erpnext
```

### List Sites
```bash
docker compose exec backend bench --site all list-apps
```

### Set Default Site
```bash
docker compose exec backend bench use new-site.localhost
```

### Remove Site
```bash
docker compose exec backend bench drop-site site-to-remove.localhost
```

## App Management

### Install App
```bash
docker compose exec backend bench --site site-name install-app app-name
```

### Uninstall App
```bash
docker compose exec backend bench --site site-name uninstall-app app-name
```

### Update Apps
```bash
docker compose exec backend bench update --pull --patch
```

## Performance Tuning

### Monitor Resource Usage
```bash
docker stats
```

### View Worker Status
```bash
docker compose exec backend bench worker --queue default status
```

### Clear Cache
```bash
docker compose exec backend bench clear-cache
```

### Rebuild Assets
```bash
docker compose exec backend bench build
```

## Troubleshooting

### Site Not Loading
1. Check all services are running:
```bash
docker compose ps
```

2. Check frontend logs:
```bash
docker compose logs frontend
```

3. Check backend logs:
```bash
docker compose logs backend
```

### Database Connection Issues
```bash
docker compose exec backend bench doctor
docker compose logs db
```

### Worker Not Processing Jobs
```bash
docker compose exec backend bench worker --queue default
docker compose logs worker
```

### Reset Everything
```bash
docker compose down -v
docker volume prune
docker compose up -d
```

### Check Site Health
```bash
docker compose exec backend bench doctor
```

## Production Checklist

- [ ] Changed default passwords in .env
- [ ] Configured proper domain name
- [ ] Set up SSL/TLS certificates
- [ ] Configured firewall rules
- [ ] Set up automated backups
- [ ] Configured monitoring
- [ ] Set up log rotation
- [ ] Documented recovery procedures
- [ ] Tested backup/restore process
- [ ] Configured email settings
- [ ] Set up reverse proxy
- [ ] Enabled security headers

## Security

### Change Admin Password
```bash
docker compose exec backend bench set-admin-password Administrator
```

### Update Database Password
1. Update in .env file
2. Recreate configurator:
```bash
docker compose up -d configurator
```

### Enable HTTPS
Use a reverse proxy like Nginx or Traefik with Let's Encrypt.

## Monitoring

### Check Disk Usage
```bash
docker system df
docker volume ls
du -sh /var/lib/docker/volumes/
```

### Check Logs Size
```bash
docker compose exec backend du -sh /home/frappe/frappe-bench/logs
```

### Clean Old Logs
```bash
docker compose exec backend find /home/frappe/frappe-bench/logs -name "*.log" -mtime +30 -delete
```

## Common Issues

### Port Already in Use
Change port in docker-compose.yml:
```yaml
ports:
  - "8081:8080"
```

### Out of Memory
Increase resources in docker-compose.prod.yml or add swap space.

### Slow Performance
1. Check worker processes
2. Increase worker replicas
3. Optimize database queries
4. Enable caching

### Cannot Upload Large Files
Update in docker-compose.yml:
```yaml
environment:
  CLIENT_MAX_BODY_SIZE: 100m
```
