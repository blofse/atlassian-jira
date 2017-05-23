#!/bin/sh

echo Stopping existing container
docker stop atlassian-jira-postgres
docker stop atlassian-jira

echo Copying and running service
yes | cp optional/docker-atlassian-jira-postgres.service /etc/systemd/system/.
yes | cp optional/docker-atlassian-jira.service /etc/systemd/system/.
systemctl daemon-reload

systemctl enable docker-atlassian-jira-postgres
systemctl enable docker-atlassian-jira

systemctl start docker-atlassian-jira-postgres
systemctl start docker-atlassian-jira
echo Done!
