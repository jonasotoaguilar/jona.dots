# Stack operations (production)

Read-only inspection first. Mutate (rebuild, down, prune) only with explicit user approval.

## State and health

docker compose ps # service states and health
docker compose top # processes per service
docker stats # live resource usage
docker compose logs --tail=100 -f <svc> # follow service logs
docker compose exec <svc> sh # shell into a running service

## Networking

docker compose exec <svc> nslookup db # DNS check inside the stack network
docker compose exec <svc> wget -qO- http://app:3000/health
docker network ls
docker network inspect <project>_default

## Rebuild and cleanup (destructive — explicit approval required)

docker compose build --no-cache <svc> # force full rebuild
docker compose down # stop and remove containers
docker compose down -v # ALSO removes volumes — data loss
docker system prune # remove unused images and containers

## Backup and restore volumes

docker run --rm --volumes-from <container>\
-v "$(pwd)":/backup ubuntu \
  tar czf /backup/<name>-$(date +%F).tar.gz /data

docker run --rm -v <fresh-volume>:/data\
-v "$(pwd)":/backup ubuntu\
tar xzf /backup/<name>-<date>.tar.gz --strip 1
