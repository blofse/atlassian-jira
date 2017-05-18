FROM openjdk:8-alpine

# Configuration variables.
ENV JIRA_VERSION=7.3.6 \
    MYSQL_VERSION=5.1.38 \
    POSTGRES_VERSION=9.4.1212 \
    JIRA_HOME=/var/atlassian/application-data/jira \
    JIRA_INSTALL=/opt/atlassian/jira

# Install Atlassian JIRA and helper tools and setup initial home
# directory structure.
RUN set -x
RUN apk add --no-cache wget
RUN apk add --no-cache libressl 
RUN apk add --no-cache tar
RUN apk add --no-cache bash

RUN mkdir -p "${JIRA_HOME}"
RUN mkdir -p "${JIRA_HOME}/caches/indexes"
RUN mkdir -p "${JIRA_INSTALL}/conf/Catalina"

RUN wget -O "atlassian-jira-software-${JIRA_VERSION}.tar.gz" --no-verbose "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}.tar.gz"
RUN wget -O "mysql-connector-java-${MYSQL_VERSION}.tar.gz" --no-verbose "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_VERSION}.tar.gz"
RUN wget -O "postgresql-${POSTGRES_VERSION}.jar" "https://jdbc.postgresql.org/download/postgresql-${POSTGRES_VERSION}.jar"
RUN tar -xzvf "atlassian-jira-software-${JIRA_VERSION}.tar.gz" -C "${JIRA_INSTALL}" --strip-components=1
RUN tar -xzvf "mysql-connector-java-${MYSQL_VERSION}.tar.gz" -C "${JIRA_INSTALL}/lib" --strip-components=1

RUN mv "postgresql-${POSTGRES_VERSION}.jar" "${JIRA_INSTALL}/lib/postgresql-${POSTGRES_VERSION}.jar"
RUN sed --in-place "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh"
RUN echo -e "\njira.home=${JIRA_HOME}" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties"
RUN touch -d "@0" "${JIRA_INSTALL}/conf/server.xml"
RUN rm -f "${JIRA_INSTALL}/lib/postgresql-9.1-903.jdbc4-atlassian-hosted.jar"

# Add jira user and setup permissions
RUN adduser -D -u 1000 jira
RUN chown -R jira "${JIRA_HOME}"
RUN chown -R jira "${JIRA_INSTALL}/conf"
RUN chown -R jira "${JIRA_INSTALL}/logs"
RUN chown -R jira "${JIRA_INSTALL}/temp"
RUN chown -R jira "${JIRA_INSTALL}/work"
RUN chmod -R 700 "${JIRA_HOME}"
RUN chmod -R 700 "${JIRA_INSTALL}/conf"
RUN chmod -R 700 "${JIRA_INSTALL}/logs"
RUN chmod -R 700 "${JIRA_INSTALL}/temp"
RUN chmod -R 700 "${JIRA_INSTALL}/work"

# Expose default HTTP connector port.
EXPOSE 8080

VOLUME [${JIRA_HOME}]

WORKDIR ${JIRA_HOME}

USER jira
ENV JVM_SUPPORT_RECOMMENDED_ARGS -Datlassian.plugins.enable.wait=300
CMD ["sh", "-c", "${JIRA_INSTALL}/bin/catalina.sh run"]
