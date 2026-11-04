WITH revenue as ( 
 SELECT 
  u.country 
  , COUNT(u.user_id) AS total_users 
  , SUM(t.amount_usd ) as amount 
 FROM users u 
 LEFT JOIN transactions t ON u.user_id = t.user_id 
 GROUP BY u.country 
), 
spend as ( 
 SELECT 
  ms.country 
  , SUM(ms.spend_usd ) as spend 
 FROM marketing_spend ms 
 GROUP BY ms.country 
) 
SELECT 
 r.country 
 , r.total_users 
 , r.amount 
 , s.spend 
 , ROUND ((s.spend/r.total_users), 2) AS cac 
 , ROUND ((r.amount/r.total_users), 2) as ltv 
 , ROUND((r.amount/r.total_users) / (s.spend/r.total_users)) AS ltv_cac_relation 
FROM revenue r 
JOIN spend s ON r.country = s.country 
GROUP BY r.country 
