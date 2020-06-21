FROM yandex/clickhouse-server

COPY cluster-config.xml /etc/metrika.xml
