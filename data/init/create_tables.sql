-- First we need to create the database
CREATE DATABASE data;

-- Next we set up the local table for our transactions data
CREATE TABLE data.transactions(
    amount Float32, 
    datetime Date, 
    important UInt8, 
    user_id_in UInt32, 
    user_id_out UInt32)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(datetime) -- We will partition by date as it should produce even splits
ORDER BY (user_id_in, user_id_out)
SETTINGS index_granularity = 8192;

-- Finally we set up the distributed table to connect our local table with other nodes in the cluster
CREATE TABLE data.transactions_distributed AS data.transactions
ENGINE = Distributed(clickhouse-cluster, data, transactions, xxHash64(user_id_in, user_id_out));
