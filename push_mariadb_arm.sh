#!/bin/bash

# Source config
source config.sh

# Dump the MySQL database to a file
docker exec db /usr/bin/mysqldump -u root --password=root cool_db > backup_${DATE}.sql

# Build the Docker image using the MariaDB base image and the database dump
docker build --no-cache -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG -f Dockerfile_arm .

# Login to Docker Hub
docker login --username $DOCKER_HUB_USERNAME --password $DOCKER_HUB_PASSWORD

# Tag the Docker image for deployment to Docker Hub
docker tag $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG $DOCKER_HUB_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG

# Push the Docker image to Docker Hub
docker push $DOCKER_HUB_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG

# Remove the local Docker image
docker rmi $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG

# Remove the database dump fileﬁ
rm backup_${DATE}.sql