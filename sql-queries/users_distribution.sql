SELECT 
 u.country 
 , u.platform 
 , u.acquisition_channel 
 , u.age_group 
 , COUNT(DISTINCT u.user_id) as num_users 
FROM 
 users u 
GROUP BY 
 u.country 
 , u.platform 
 , u.acquisition_channel 
 , u.age_group 
