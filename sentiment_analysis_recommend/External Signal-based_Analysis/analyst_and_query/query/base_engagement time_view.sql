-- avg 말고 sum 위주로 재집계 가능하게
-- post_id unique (captions)
-- engagement : commentsCount, likesCount
-- first sentiment, sentiment도 나중에 점수별 분류로 쓸거
create or replace view `project.mydataset.view_base_engagement_time` as
select 
b.date as kst_date,
b.sentiment_score as caption_sentiment_score_2dp,
ROUND(b.first_sentiment_score, 2) as first_sentiment_score_2dp,
extract(hour from b.time) as kst_hour,
b.id as post_id,
sum(coalesce(b.commentsCount,0)) as commentsCount_sum,
sum(coalesce(b.likesCount,0)) as likesCount_sum,
count(*) as post_count
from `project.mydataset.captions` b
group by 1,2,3,4,5;