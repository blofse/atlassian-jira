#!/bin/sh

echo Stopping existing container
docker stop $(docker ps -a -q  --filter ancestor=postgres:9.5.6-alpine)
docker stop $(docker ps -a -q  --filter ancestor=atlassian-jira)

echo Copying and running service
yes | cp docker-atlassian-jira-postgres.service /etc/systemd/system/.
yes | cp docker-atlassian-jira.service /etc/systemd/system/.
systemctl daemon-reload

systemctl start docker-atlassian-jira-postgres
systemctl start docker-atlassian-jira
echo Done!
