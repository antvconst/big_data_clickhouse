select
    user_id, month, avgMerge(avg_amount)
from data.average_incoming_amount_distributed
group by user_id, month
order by user_id, month
limit 10