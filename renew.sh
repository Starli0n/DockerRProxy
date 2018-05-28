# Renew certificate
docker-compose run --rm letsencrypt renew

# Restart the server
docker-compose kill -s SIGHUP rproxy
