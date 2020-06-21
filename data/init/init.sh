#!/bin/bash 

set -e

echo "Init tables"
cat /data/init/create_tables.sql | clickhouse-client --host server_1 -nm
echo "[Server #1] done"
cat /data/init/create_tables.sql | clickhouse-client --host server_2 -nm
echo "[Server #2] done"

echo "Create MV '#1. Average incoming transactions amount by month by user'"
cat /data/init/create_mv_1.sql | clickhouse-client --host server_1 -nm
echo "[Server #1] done"
cat /data/init/create_mv_1.sql | clickhouse-client --host server_2 -nm
echo "[Server #2] done"

echo "Create MV '#4. The number of outcoming transactions by month by user'"
cat /data/init/create_mv_4.sql | clickhouse-client --host server_1 -nm
echo "[Server #1] done"
cat /data/init/create_mv_4.sql | clickhouse-client --host server_2 -nm
echo "[Server #2] done"

echo "Create MV '#5. The sum of incoming and outcoming transactions by month by user'"
cat /data/init/create_mv_5.sql | clickhouse-client --host server_1 -nm
echo "[Server #1] done"
cat /data/init/create_mv_5.sql | clickhouse-client --host server_2 -nm
echo "[Server #2] done"

echo "Upload data"
cat /data/init/transactions_12M.parquet | clickhouse-client --host server_1 --query "insert into data.transactions_distributed format Parquet"
echo "done"

echo "Init tables successfully finished"
