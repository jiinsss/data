SELECT
  user_id,
  order_id,
  ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS order_rank
FROM orders;
