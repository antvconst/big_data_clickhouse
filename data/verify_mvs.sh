#!/bin/bash

set -e

echo "Materialized View #1"
echo "Server #1"
cat queries/select_from_mv_1.sql | clickhouse-client --host server_1
echo 
echo "Server #2"
cat queries/select_from_mv_1.sql | clickhouse-client --host server_2
echo
echo
echo "Materialized View #4"
echo "Server #1"
cat queries/select_from_mv_4.sql | clickhouse-client --host server_1
echo "Server #2"
cat queries/select_from_mv_4.sql | clickhouse-client --host server_2
echo
echo
echo "Materialized View #5"
echo "Server #1"
cat queries/select_from_mv_5.sql | clickhouse-client --host server_1
echo "Server #2"
cat queries/select_from_mv_5.sql | clickhouse-client --host server_2