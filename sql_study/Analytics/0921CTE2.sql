-- 전처리
-- 집계
-- 조인
with base as(
    select
    brand,
    hashtags,
    DATE_TRUNC(createTimeDATE) as month_date,
    coalesce(likeCount,0) as likeCount
    from my-dbtbq-test.instatest.myinsta
)
,
top5 as(
    select
    brand,
    month_date
    
)

select
