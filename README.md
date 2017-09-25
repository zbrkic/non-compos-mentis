# [Non Compos Mentis](https://blog.asarkar.org)

*Non Compos Mentis* (latin) is the legal term meaning "not of sound mind". It is my awesome blog where I talk about everything under the sun, more specifically about technology and perhaps on good days, photography.

If you are the curious type, check out the [About](site/about.md) page.

## Tech
Local `docker-compose.yml`:
```
docker build -f docker/Dockerfile -t asarkar/non-compos-mentis . && \
  docker-compose -f docker/docker-compose.yml up -d
```

Remote `docker-compose.yml`:
```
curl -sSL <URL> | docker-compose -f - up -d
```

Get SSL Cert:

1. Run Certbot Docker image
```
docker run -it --entrypoint=sh certbot/certbot
```

2. Run `certbot` client
```
certbot certonly --manual --agree-tos \
--email <email> --rsa-key-size 4096 \
-d blog.asarkar.org
```
> Say No to the first question that asks for permission for sharing your email. Answer Yes to the second question asking for permission to log your IP publicly.

3. View the certificate and private key
```
cat /etc/letsencrypt/live/blog.asarkar.org/fullchain.pem
cat /etc/letsencrypt/live/blog.asarkar.org/privkey.pem
```
## License

Copyright 2016-2017 Abhijit Sarkar - Released under the [GPLv3](LICENSE) license.
