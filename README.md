# irods-frontend

### IMPORTANT
The `master` branch uses a precompiled .war file to deploy in Tomcat. <br>
This `build` branch contains the original build steps in the Dockerfile. 

<br><br><br><br><br><br><br><br><br>


Docker container that runs:
* [Research IT iRODS cloudbrowser](https://github.com/MaastrichtUniversity/irods-cloud-browser); forked from [DICE-UNC](https://github.com/DICE-UNC/irods-cloud-browser)
* iRODS-REST API; released by [DICE-UNC](https://github.com/DICE-UNC/irods-rest/releases)

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

  