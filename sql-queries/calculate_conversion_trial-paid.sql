SELECT 
 u.country 
 , u.acquisition_channel 
 , COUNT(DISTINCT u.user_id) as total_users 
 , COUNT(DISTINCT CASE WHEN t.transaction_type = 'trial_start' THEN t.user_id END) as 
trial_users 
 , COUNT(DISTINCT CASE WHEN t.transaction_type = 'first_payment' AND t.user_id IN 
 ( 
  SELECT t2.user_id 
  FROM transactions t2 
  WHERE t2.transaction_type = 'trial_start' 
 ) 
 THEN t.user_id END) as paid_users 
 , ROUND( 
  ( 
   COUNT(DISTINCT CASE WHEN t.transaction_type = 'first_payment' AND 
t.user_id IN 
   ( 
    SELECT t3.user_id 
    FROM transactions t3 
    WHERE t3.transaction_type = 'trial_start' 
   ) 
   THEN t.user_id END) 
    
   / 
   (COUNT(DISTINCT CASE WHEN t.transaction_type = 'trial_start' THEN 
t.user_id END)) 
    
  ) * 100 
 , 2) AS conversion_rate 
FROM users u 
LEFT JOIN transactions t ON u.user_id = t.user_id 
GROUP BY u.country, u.acquisition_channel; 
