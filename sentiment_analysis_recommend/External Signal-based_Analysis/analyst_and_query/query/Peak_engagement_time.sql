-- 일단 피봇용
-- 시간 × 요일 합계 (전체 기간)
-- engagement=comments_sum, likes_sum
CREATE OR REPLACE VIEW `project.mydataset.view_engagement_time` AS
SELECT
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
  SUM(commentsCount_sum) AS comments_sum,
  SUM(likesCount_sum)    AS likes_sum,
  COUNT(DISTINCT post_id) AS posts
FROM `project.mydataset.view_base_engagement_time`
GROUP BY 1,2,3;
