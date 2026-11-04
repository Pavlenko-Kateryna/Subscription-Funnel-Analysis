SELECT 
 t.* 
   , u.country 
FROM transactions t 
JOIN users u ON t.user_id = u.user_id 
GROUP BY 1, 2; 
