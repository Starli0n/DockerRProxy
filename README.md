# DockerRProxy

## Install

```sh
> git clone https://github.com/Starli0n/DockerRProxy DockerRProxy
> cd DockerRProxy
> mkdir letsencrypt
> chmod +x renew.sh
> cp .env.default .env
```

## Configure

- Customize the `.env` file
- Change `example.com` hostname in `./rproxy/nginx.conf`
- Setup other behind servers
	- Add IP address in `.env`
	- Add `extra_hosts` servers in `docker-compose.yml`
	- Add other servers in `./rproxy/nginx.conf`

## Usage

### First time

- Comment the https server in `./rproxy/nginx.conf`
- Start the server with `docker-compose up -d`
- Generate the certificates with Let's Encrypt
```
docker-compose run --rm letsencrypt
    certonly --webroot --agree-tos --register-unsafely-without-email
    -w /var/www/letsencrypt -d example.com
```
- Stop the server with `docker-compose down`
- Uncomment the https server in `./rproxy/nginx.conf`

### Development

In development, a `ping` server is started behind to test the behavior of the reverse proxy, see `docker-compose.override.yml`

- Start the server
```
# Shortcut for docker-compose -f docker-compose.yml -f docker-compose.override.yml up
> docker-compose up
```
- Stop the server
```
# Shortcut for docker-compose -f docker-compose.yml -f docker-compose.override.yml down
> docker-compose down
```

- `https://example.com` and `https://example.com/ping` should respond.

### Production

In production, the `ping` server is not started and the `restart` policy is activated, see `production.yml`

- Start the server
```
> docker-compose -f docker-compose.yml -f production.yml up -d
```
- Stop the server
```
> docker-compose -f docker-compose.yml -f production.yml down
```

- `https://example.com` should respond.
- `https://example.com/ping` should not respond.

Still, the `ping` server could be started manually

- Start the `ping `server
```
> docker-compose -f ping.yml up
```
- Stop the `ping `server
```
> docker-compose -f ping.yml down
```

Then `https://example.com/ping` should now respond.

### Renew

- Renew the certificates with `./renew.sh`
- Scheduled task for an automatic renew of certificates every 15 days
```
# /etc/crontab
0 0 */15 * * root /usr/local/src/DockerRProxy/renew.sh >/dev/null 2>&1
```

## Debug

- Explore the `rpoxy` container
```
> docker exec -it rproxy /bin/sh
```
- Install `curl` inside the container
```
> apk --no-cache add curl
```
- Explore the `letsencrypt` container
```
> docker-compose run --rm --entrypoint "/bin/sh" letsencrypt
```

## Update

- Update nginx docker image by changing the tag in `.env`
