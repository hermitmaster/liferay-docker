FROM openjdk:8-alpine

EXPOSE 8080

ENV LIFERAY_HOME="/opt/liferay" \
  CATALINA_OPTS="-Xms4g -Xmx4g" \
  DOCKERIZE_VERSION="0.6.1" \
  ELASTICSEARCH_CLUSTER_NAME="LiferayElasticsearchCluster" \
  ELASTICSEARCH_HOSTS="localhost:9300" \
  LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_USERNAME="lportal" \
  LIFERAY_DL_PERIOD_STORE_PERIOD_IMPL="com.liferay.portal.store.db.DBStore"
ENV CATALINA_HOME="$LIFERAY_HOME/tomcat-9.0.6"
ENV PATH="$CATALINA_HOME/bin:$PATH"

ADD liferay /opt/liferay

RUN apk add --no-cache fontconfig ttf-dejavu \
  && wget -qO- https://github.com/jwilder/dockerize/releases/download/v$DOCKERIZE_VERSION/dockerize-linux-amd64-v$DOCKERIZE_VERSION.tar.gz | tar xvz -C /usr/local/bin \
  && chmod +x $CATALINA_HOME/bin/docker-entrypoint.sh \
  && chmod +x $CATALINA_HOME/bin/catalina.sh

ENTRYPOINT ["/opt/liferay/tomcat-9.0.6/bin/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]