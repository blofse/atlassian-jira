FROM anapsix/alpine-java:8_jdk-dcevm_unlimited

# Configuration variables.
ENV JIRA_VERSION=7.11.2 \
    MYSQL_VERSION=5.1.38 \
    POSTGRES_VERSION=9.4.1212 \
    JIRA_HOME=/var/atlassian/application-data/jira \
    JIRA_INSTALL=/opt/atlassian/jira 

RUN set -x \
    && apk add --no-cache wget libressl tar tzdata bash \
    && mkdir -p "${JIRA_HOME}" \
    && mkdir -p "${JIRA_HOME}/caches/indexes" \
    && mkdir -p "${JIRA_INSTALL}/conf/Catalina" \
    && wget -O "atlassian-jira-software-${JIRA_VERSION}.tar.gz" --no-verbose "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}.tar.gz" \
    && wget -O "mysql-connector-java-${MYSQL_VERSION}.tar.gz" --no-verbose "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_VERSION}.tar.gz" \
    && wget -O "postgresql-${POSTGRES_VERSION}.jar" "https://jdbc.postgresql.org/download/postgresql-${POSTGRES_VERSION}.jar" \
    && tar -xzvf "atlassian-jira-software-${JIRA_VERSION}.tar.gz" -C "${JIRA_INSTALL}" --strip-components=1 \
    && tar -xzvf "mysql-connector-java-${MYSQL_VERSION}.tar.gz" -C "${JIRA_INSTALL}/lib" --strip-components=1 \
    && mv "postgresql-${POSTGRES_VERSION}.jar" "${JIRA_INSTALL}/lib/postgresql-${POSTGRES_VERSION}.jar" \
    && echo -e "\njira.home=${JIRA_HOME}" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties" \
    && touch -d "@0" "${JIRA_INSTALL}/conf/server.xml" \
    && rm -f "${JIRA_INSTALL}/lib/postgresql-9.1-903.jdbc4-atlassian-hosted.jar" \
    && rm -f "mysql-connector-java-${MYSQL_VERSION}.tar.gz" \
    && rm -f "atlassian-jira-software-${JIRA_VERSION}.tar.gz" \
    && adduser -D -u 1000 jira \
    && chown -R jira "${JIRA_HOME}" \
    && chown -R jira "${JIRA_INSTALL}/conf" \
    && chown -R jira "${JIRA_INSTALL}/logs" \
    && chown -R jira "${JIRA_INSTALL}/temp" \
    && chown -R jira "${JIRA_INSTALL}/work" \
    && chmod -R 700 "${JIRA_HOME}" \
    && chmod -R 700 "${JIRA_INSTALL}/conf" \
    && chmod -R 700 "${JIRA_INSTALL}/logs" \
    && chmod -R 700 "${JIRA_INSTALL}/temp" \
    && chmod -R 700 "${JIRA_INSTALL}/work" \
    && cp /usr/share/zoneinfo/Europe/London /etc/localtime

# Expose default HTTP connector port.
EXPOSE 8080

VOLUME [ ${JIRA_HOME} ]

WORKDIR ${JIRA_HOME}

USER jira
ENV JVM_SUPPORT_RECOMMENDED_ARGS -Datlassian.plugins.enable.wait=300
CMD ["sh", "-c", "${JIRA_INSTALL}/bin/catalina.sh run"]
