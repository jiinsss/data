-- view_engagement_time_max
-- view_sentiment_time_max

-- view_engagement_time: (weekday, kst_hour, comments_sum, likes_sum, ...)

CREATE OR REPLACE VIEW `project.mydataset.view_engagement_top5_hashtag_caption` AS
WITH engagement_scored AS (
  SELECT
    weekday,
    kst_hour,
    COALESCE(likes_sum, 0) + COALESCE(comments_sum, 0) AS engagement_sum
  FROM `project.mydataset.view_engagement_time`
),
engagement_max AS (
  SELECT weekday, kst_hour
  FROM (
    SELECT
      weekday,
      kst_hour,
      engagement_sum,
      ROW_NUMBER() OVER (
        ORDER BY engagement_sum DESC, weekday, kst_hour DESC
      ) AS rn
    FROM engagement_scored
  )
  WHERE rn = 1
)
SELECT
  CONCAT(c.weekday, ' ',m.kst_hour) AS bucket,
  CONCAT(
    FORMAT_DATE('%Y-%m-%d', c.date),
    ' ',
    FORMAT_TIME('%H:%M:%S', c.time)
  ) AS post_datetime,
  c.id,
  c.caption,
  c.first_sentiment_score,
  ARRAY_TO_STRING(c.hashtags, ' ') AS hashtags_str,
  COALESCE(c.sentiment_score, 0) AS sentiment_score,
  (COALESCE(c.likesCount,0) + COALESCE(c.commentsCount,0)) AS engagement_sum
FROM `project.mydataset.captions` c
JOIN engagement_max m
  ON c.weekday = m.weekday
 AND EXTRACT(HOUR FROM c.time) = m.kst_hour
ORDER BY
  c.sentiment_score DESC,
  (COALESCE(c.likesCount,0) + COALESCE(c.commentsCount,0)) DESC,
  c.id
LIMIT 5;
