select
    user_id, month, countMerge(out_count)
from data.outcoming_transactions_count_distributed
group by user_id, month
order by user_id, month
limit 10