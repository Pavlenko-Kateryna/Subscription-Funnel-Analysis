with cohort_month as ( 
 SELECT 
  DATE_FORMAT(u.signup_date, "%Y-%m") as cohort_month 
  , COUNT(u.user_id) as total_users 
  FROM users u 
  GROUP BY cohort_month 
), 
fact_transactions as ( 
 SELECT 
  DATE_FORMAT(u.signup_date, "%Y-%m") as cohort_month 
  , (YEAR(t.`date`) - YEAR(u.signup_date )) * 12 + MONTH(t.`date`) - 
MONTH(u.signup_date) as month_index 
  , COUNT(DISTINCT u.user_id) as total_paying_users 
 FROM users u 
 JOIN transactions t ON u.user_id = t.user_id 
 GROUP BY 1,2 
 ORDER BY 2 
) 
SELECT 
 t.cohort_month
