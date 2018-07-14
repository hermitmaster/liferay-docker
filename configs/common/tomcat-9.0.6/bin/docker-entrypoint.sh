#!/bin/bash

if [ "$DEBUG" == "true" ] ; then
  set -ex
else
  set -e
fi

main() {
  if [ "$1" = 'catalina.sh' -a "$(id -u)" = '0' ]; then
    configure_elasticsearch
    # Wait for the db to accept connections, fail startup if not available within 120s.
    dockerize -wait tcp://$DB_HOST -timeout 120s
    run_portal "$@"
  else
    # Default command overridden. Allows ENTRYPOINT to be overridden with bash for example.
    exec "$@"
  fi

}

# Write the Elasticsearch configuration to a file. These settings should be passed as environment variables to the container at runtime.
# By default, the embedded Elasticsearch instance is used (only suitable for local development).
configure_elasticsearch() {
  echo -e "operationMode=REMOTE\ntransportAddresses=$ELASTICSEARCH_HOSTS\nclusterName=$ELASTICSEARCH_CLUSTER_NAME" > $LIFERAY_HOME/osgi/configs/com.liferay.portal.search.elasticsearch6.configuration.ElasticsearchConfiguration.cfg
}

run_portal() {
  # We use the same db password variables as the db container for convenience. We export them here using Liferay conventions in order to make them available to Liferay.
  export LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_URL="jdbc:postgresql://$DB_HOST/lportal"
  echo "$(date +%Y-%m-%d\ %H:%M:%S.%m) INFO [PID: $$][${0##*/}] Liferay is starting..."

  if [ "$DEBUG" == "true" ] ; then
    export CATALINA_OPTS="$CATALINA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8000"
  fi

  # Start the portal with the given parameters.
  exec "$@"
}

main "$@"