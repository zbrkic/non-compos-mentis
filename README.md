# [Non Compos Mentis](https://blog.asarkar.org)

*Non Compos Mentis* (latin) is the legal term meaning "not of sound mind". It is my awesome blog where I talk about everything under the sun, more specifically about technology and perhaps on good days, photography.

If you are the curious type, check out the [About](site/about.md) page.

## Tech
Local `docker-compose.yml`:
```
docker-compose -f docker/docker-compose.yml up --build -d
```

Go to localhost:4000 once the container starts up.

Remote `docker-compose.yml`:
```
curl -sSL <URL> | docker-compose -f - up -d
```

## License

Copyright 2016-2020 Abhijit Sarkar - Released under the [GPLv3](LICENSE) license.
