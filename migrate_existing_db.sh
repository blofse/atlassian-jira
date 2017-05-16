#!/bin/bash

if [ ! -f imports/xml-backup.zip ]; then
  echo File imports/xml-backup.zip not found, please export your existing JIRA into this file for import
  exit 0
fi

echo About to copy file
docker cp imports/xml-backup.zip atlassian-jira:/var/atlassian/jira/import/xml-backup.zip

echo Done!
