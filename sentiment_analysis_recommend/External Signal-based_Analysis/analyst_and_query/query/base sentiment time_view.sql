-- avg 말고 sum 위주로 재집계 가능하게
-- post_id(FK) unique (captions)
-- sentiment : first sentiment, avg sentiment(comment)
-- first sentiment, sentiment(post)도 나중에 점수별 분류로 쓸거
-- comment 테이블에서 avg sentiment 구해야 함
-- 그냥 조인하면 그레인 안맞아서 cte로 두개 객체화 시켜서 1:1로 조인할거임
-- post_id - first sentiment avg

create or replace view `project.mydataset.view_base_sentiment_time` as
WITH comments_per_post AS (
  SELECT
    post_id,
    ROUND(AVG(sentiment_score), 2) AS comment_sentiment_avg,
    FROM `project.mydataset.comments`
    GROUP BY post_id
),
base as (select 
b.date as kst_date,
extract(hour from b.time) as kst_hour,
b.id as post_id,
round(sum(coalesce(b.sentiment_score,0)),2) as post_sentiment_score_sum,
round(sum(coalesce(b.first_sentiment_score,0)),2) as first_sentiment_score_sum,
count(*) as post_count
from `project.mydataset.captions` b
group by 1,2,3)

SELECT
  base.*,
  COALESCE(c.comment_sentiment_avg, 0) AS comment_sentiment_avg
FROM base
LEFT JOIN comments_per_post c
USING (post_id);

