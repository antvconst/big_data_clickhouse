FROM yandex/clickhouse-client

RUN mkdir /data
WORKDIR /data

ENTRYPOINT /bin/bash
