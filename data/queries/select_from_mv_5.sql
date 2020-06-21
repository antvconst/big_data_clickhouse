select
    user_id, month, countMerge(total_count)
from data.incoming_outcoming_sum_distributed
group by user_id, month
order by user_id, month
limit 10