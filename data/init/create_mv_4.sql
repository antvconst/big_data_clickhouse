-- First we create local MV for the node to aggregate locally stored data
create materialized view data.outcoming_transactions_count
engine = AggregatingMergeTree
partition by month
order by user_id
as
    select
        user_id_out as user_id,
        toMonth(datetime) as month,
        countState(user_id_out) as out_count -- countState is used to correctly process sharded data
    from data.transactions
    group by
        user_id_out,
        toMonth(datetime);

-- Finally we create a distributed table over our MV to share over the cluster
create table data.outcoming_transactions_count_distributed as data.outcoming_transactions_count
engine = Distributed(clickhouse-cluster, data, outcoming_transactions_count);

-- Note:
--     Requests to this view must be executed
--     with countMerge(out_count) group by used_id, month
--     to ensure correct merging of the partial results
--     from each of the separate shards