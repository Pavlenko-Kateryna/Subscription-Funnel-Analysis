WITH user_transactions AS( 
 SELECT 
  u.user_id 
  , u.acquisition_channel 
  , SUM(t.amount_usd) as total_amount 
  , COUNT(t.amount_usd) as payments_count 
  , t.transaction_type as type 
 FROM users u 
 LEFT JOIN transactions t ON u.user_id = t.user_id 
 GROUP BY u.user_id, u.acquisition_channel, t.transaction_type 
), 
revenue as ( 
 SELECT 
  u.acquisition_channel 
  , COUNT(DISTINCT u.user_id) AS total_users 
  , COUNT(DISTINCT CASE WHEN u.`type` = 'first_payment' THEN u.user_id END) as 
paying_users 
  , COUNT(DISTINCT CASE WHEN u.`type` = 'renewal' THEN u.user_id END) as 
renewal_users 
  , SUM(total_amount) as amount 
 FROM user_transactions u 
 GROUP BY u.acquisition_channel 
), 
spend as ( 
 SELECT 
  ms.channel 
  , SUM(ms.spend_usd ) as spend 
 FROM marketing_spend ms 
 GROUP BY ms.channel 
) 
SELECT 
 r.acquisition_channel 
 , r.total_users 
 , r.paying_users 
 , r.renewal_users 
 , ROUND(s.spend / r.total_users, 2) AS cost_per_registration 
 , ROUND (s.spend/r.paying_users, 2) AS cac 
 , ROUND((r.renewal_users/r.paying_users) * 100,2) as renewal_rate 
 , ROUND (r.amount/r.paying_users, 2) as ltv 
 , ROUND((r.amount/r.paying_users)/ (s.spend/r.paying_users)) as ltv_cac_relation 
FROM revenue r 
JOIN spend s ON r.acquisition_channel = s.channel
