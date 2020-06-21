-- First we create local MV for the node to aggregate locally stored data
create materialized view data.incoming_outcoming_sum
engine = AggregatingMergeTree
partition by month
order by user_id
as
    (select
        user_id, month, in_count + out_count as total_count
    from (
        select user_id_in as user_id,
            toMonth(datetime) as month,
            countState(user_id_in) as in_count
        from data.transactions
        group by user_id_in, month
    ) A left join (
        select user_id_out as user_id,
            toMonth(datetime) as month,
            countState(user_id_out) as out_count 
        from data.transactions
        group by user_id_out, month
    ) B using user_id, month);

-- Finally we create a distributed table over our MV to share over the cluster
create table data.incoming_outcoming_sum_distributed as data.incoming_outcoming_sum
engine = Distributed(clickhouse-cluster, data, incoming_outcoming_sum);

-- Note:
--     Requests to this view must be executed
--     with countMerge(total_count) group by used_id, month
--     to ensure correct merging of the partial results
--     from each of the separate shards