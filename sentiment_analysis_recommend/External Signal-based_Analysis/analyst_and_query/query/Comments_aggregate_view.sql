-- 해시화 시켜둔거 너무 길어서 정수화
-- 포스트아이디(PK), 유저아이디, date, weekday 기준으로 집계

create or replace view `project.mydataset.view_Comments_aggregate` as 
select b.post_id as post_id,
ABS(FARM_FINGERPRINT(b.new_ownerUsername)) AS user_id_numeric,
b.date as Comments_date,
b.weekday as Comments_weekday,
  CASE
    WHEN b.weekday = 'Monday' THEN 1
    WHEN b.weekday = 'Tuesday' THEN 2
    WHEN b.weekday = 'Wednesday' THEN 3
    WHEN b.weekday = 'Thursday' THEN 4
    WHEN b.weekday = 'Friday' THEN 5
    WHEN b.weekday = 'Saturday' THEN 6
    WHEN b.weekday = 'Sunday' THEN 7
  END AS weekday_order,
sum(likesCount) as likesCount_sum,
sum(repliesCount) as repliesCount_sum,
round(avg(likesCount),2) as likesCount_avg,
round(avg(repliesCount),2) as repliesCount_avg,
round(avg(sentiment_score),2) as sentiment_score_avg
from project.mydataset.comments as b
group by 1,2,3,4;