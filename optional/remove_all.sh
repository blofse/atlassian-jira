#!/bin/bash

echo Stopping/removing services
systemctl stop docker-atlassian-jira-postgres
systemctl stop docker-atlassian-jira

systemctl disable docker-atlassian-jira-postgres
systemctl disable docker-atlassian-jira

if [ -f /etc/systemd/system/docker-atlassian-jira.service ]; then
  rm -fr /etc/systemd/system/docker-atlassian-jira.service
fi
if [ -f /etc/systemd/system/docker-atlassian-jira-postgres.service ]; then
  rm -fr /etc/systemd/system/docker-atlassian-jira-postgres.service
fi

systemctl daemon-reload

echo Kill/remove docker images
docker stop atlassian-jira-postgres || true && docker rm atlassian-jira-postgres || true
docker stop atlassian-jira || true && docker rm atlassian-jira || true

echo Removing volumes
docker volume rm atlassian-jira-postgres-data || true
docker volume rm atlassian-jira-home || true

echo Removing networks
docker network rm atlassian-jira-network || true

echo Removing docker image - jira only
#docker rmi atlassian-jira

echo Done!