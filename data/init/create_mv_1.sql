-- First we create local MV for the node to aggregate locally stored data
create materialized view data.average_incoming_amount
engine = AggregatingMergeTree
partition by month
order by user_id
as 
    select
        user_id_in as user_id,
        toMonth(datetime) as month,
        avgState(amount) as avg_amount -- avgState is used to correctly process sharded data
    from data.transactions
    group by 
        user_id_in, toMonth(datetime);

-- Finally we create a distributed table over our MV to share over the cluster
create table data.average_incoming_amount_distributed as data.average_incoming_amount
engine = Distributed(clickhouse-cluster, data, average_incoming_amount); 

-- Note:
--     Requests to this view must be executed
--     with avgMerge(avg_amount) group by used_id, month
--     to ensure correct merging of the partial results
--     from each of the separate shards