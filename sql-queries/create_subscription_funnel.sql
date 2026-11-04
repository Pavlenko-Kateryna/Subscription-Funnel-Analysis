WITH flags AS ( 
SELECT 
 u.country 
 ,u.user_id 
 , MAX(CASE WHEN t.transaction_type = 'trial_start' THEN 1 ELSE 0 END) as trial 
 , MAX(CASE WHEN t.transaction_type = 'first_payment' THEN 1 ELSE 0 END) as first_payment 
 , MAX(CASE WHEN t.transaction_type = 'renewal' THEN 1 ELSE 0 END) as renewal 
 , MAX(CASE WHEN t.transaction_type = 'upgrade' THEN 1 ELSE 0 END) as upgrade 
from users u 
LEFT JOIN transactions t ON u.user_id = t.user_id 
GROUP BY u.country, u.user_id 
) 
SELECT 
 f.country 
 , COUNT( f.user_id) as total_signups 
 , SUM(f.trial) as total_trial 
 , SUM(f.first_payment) as total_first_payments 
 -- через trial 
 , SUM(CASE WHEN f.trial = 1 AND f.first_payment = 1 THEN 1 ELSE 0 END) as 
payments_after_trial 
 , SUM(CASE WHEN f.trial = 1 AND f.renewal  = 1 THEN 1 ELSE 0 END) as renewal_after_trial 
 , SUM(CASE WHEN f.trial = 1 AND f.upgrade = 1 THEN 1 ELSE 0 END) as upgrade_after_trial 
 -- без trial (прямі оплати) 
 , SUM(CASE WHEN f.trial = 0 AND f.first_payment = 1 THEN 1 ELSE 0 END) as 
direct_payments 
 , SUM(CASE WHEN f.trial = 0 AND f.renewal  = 1 THEN 1 ELSE 0 END) as direct_renewals 
 , SUM(CASE WHEN f.trial = 0 AND f.upgrade = 1 THEN 1 ELSE 0 END) as direct_upgrades 
  
 , SUM(f.renewal) as total_renewal 
 , SUM(f.upgrade) as total_upgrade 
FROM flags f 
GROUP BY f.country 
