--  시간 X 요일
create or replace view `project.mydataset.view_sentiment_time` as
select
  kst_hour,
  weekday,
    CASE
    WHEN weekday = 'Monday' THEN 1
    WHEN weekday = 'Tuesday' THEN 2
    WHEN weekday = 'Wednesday' THEN 3
    WHEN weekday = 'Thursday' THEN 4
    WHEN weekday = 'Friday' THEN 5
    WHEN weekday = 'Saturday' THEN 6
    WHEN weekday = 'Sunday' THEN 7
  END AS weekday_order,
  SUM(post_sentiment_score_sum) AS post_sentiment_score_sum,
  SUM(first_sentiment_score_sum) AS first_sentiment_score_sum,
  SUM(comment_sentiment_avg) AS comment_sentiment_avg,
  COUNT(DISTINCT post_id) AS posts
FROM `project.mydataset.view_base_sentiment_time`
GROUP BY 1,2,3;