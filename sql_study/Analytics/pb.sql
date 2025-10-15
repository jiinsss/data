SELECT
  user_id,
  created_at,
  amount,
  SUM(amount) OVER (PARTITION BY user_id ORDER BY created_at) AS cumulative_amount
FROM orders
ORDER BY user_id, created_at;
