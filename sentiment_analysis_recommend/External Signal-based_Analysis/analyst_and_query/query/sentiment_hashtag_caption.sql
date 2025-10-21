-- view_engagement_time_max
-- view_sentiment_time_max

-- view_engagement_time: (weekday, kst_hour, comments_sum, likes_sum, ...)

CREATE OR REPLACE VIEW `project.mydataset.view_sentiment_top5_hashtag_caption` AS
WITH sentiment_scored AS (
  SELECT
    weekday,
    kst_hour,
    COALESCE(comment_sentiment_avg, 0) + COALESCE(first_sentiment_score_sum, 0) AS sentiment_sum
  FROM `project.mydataset.view_sentiment_time`
),
sentiment_max AS (
  SELECT weekday, kst_hour
  FROM (
    SELECT
      weekday,
      kst_hour,
      sentiment_sum,
      ROW_NUMBER() OVER (
        ORDER BY sentiment_sum DESC, weekday, kst_hour DESC
      ) AS rn
    FROM sentiment_scored
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
  ARRAY_TO_STRING(c.hashtags, ' ') AS hashtags_str,
  COALESCE(c.sentiment_score, 0) AS sentiment_score,
  (COALESCE(c.sentiment_score,0) + COALESCE(c.first_sentiment_score,0)) AS sentiment_sum,
  c.first_sentiment_score as first_sentiment_score,
FROM `project.mydataset.captions` c
JOIN sentiment_max m
  ON c.weekday = m.weekday
 AND EXTRACT(HOUR FROM c.time) = m.kst_hour
ORDER BY
  c.sentiment_score DESC,
  (COALESCE(c.sentiment_score,0) + COALESCE(c.first_sentiment_score,0)) DESC,
  c.id
LIMIT 5;
