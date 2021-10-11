# irods-frontend

Docker container that runs:
* iRODS-REST API; developed by DICE-UNC and [maintained by irods-contrib](https://github.com/irods-contrib/irods-rest/releases)

## Usage
This container is part of the [docker-dev](https://github.com/MaastrichtUniversity/docker-dev) infrastructure and will be deployed using the respective **docker-compose** file.
However, you can also `build` and `run` the container manually using the commands below.
```
docker build -t irods-frontend .
docker run \
    -e "PACMAN_HOST=http://INSERT_URL_TO_PACMAN_INSTANCE_HERE" \
    --name irods-frontend \
    -p 80:80 \
    irods-frontend
```

### iRODS SSL/TLS
Configure the client-side SSL setting by editing the `irods-rest.properties` file.

When connecting to iRODS servers that have SSL **disabled**:
```
    ssl.negotiation.policy=CS_NEG_REFUSE
```

When connecting to iRODS servers that have SSL **enabled**:
```
    ssl.negotiation.policy=CS_NEG_REQUIRE
```

Or, when you don't want to enforce this on the client side and just connect to whatever the server is offering, use:
```
    ssl.negotiation.policy=CS_NEG_DONT_CARE
  