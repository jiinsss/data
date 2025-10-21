-- id로 comments에서 꺼내기
CREATE OR REPLACE VIEW `project.mydataset.view_engagement_top5_hashtag_comments` AS
WITH top5_id AS (
  SELECT id,
  post_datetime,
  first_sentiment_score,
  sentiment_score
  FROM `project.mydataset.view_engagement_top5_hashtag_caption`
)
SELECT
  c.post_id as post_id,
  c.text as text,
  c.new_ownerUsername as pseudonym,
  c.sentiment_score as comments_sentiment_score,
  t.post_datetime as post_datetime,
  t.sentiment_score as caption_sentiment_score,
  t.first_sentiment_score as first_sentiment_score
FROM `project.mydataset.comments` AS c
JOIN top5_id AS t
  ON c.post_id = t.id;
