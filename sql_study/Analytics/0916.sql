-- CTE (임시객체): common Table Expression 구문으로 정의하는 임시 이름있는 서브쿼리

-- 쿼리 실행할 때 한번 만들어지고, 그 쿼리 안에서만 유효함
-- view랑 다른게, view는 db에 저장된 노트같은거고, CTE는 메모같은거임
-- 따라서 가독성이나 구조화로 깐 쓸때는 CTE, 
-- 성능 최적화 목적으로 여러번 돌려봐야할 때는 view(피벗테이블 공식)나 서브쿼리(즉석계산), 테이블 물리화(create view ~ as select.., 계산결과 값으로 복붙)가 필요하다

--약간 묶고 묶고 합치는 느낌임
-- 서브쿼리도 () x 이렇게 변수에 저장 가능한데, 이건 with x as () 하고 x x1, x x2 이런식으로 담아서 여러변수로 호출 가능
--with by_month as (),
--cut as ( select ~ from a),
--tag as ( select ~ from a join b)
--select
--from tag;


-- 각 월마다 상위 3% 컷을 계산하고
-- 그 컷 이상 주문한 유니크 유저수 / 월 활성 유저수

with by_month as (
    select FORMAT_TIMESTAMP('%Y-%m') as ym,
    user_id,
    amount
    from orders
),
cut as (
    select ym,
    APPROX_QUANTILES(amount,100)[OFFSET(97)] as p97
    from by_month
    group by ym
),
tag as (
    select
    b.ym, b.user_id, b.amount, c.p97,
    case when b.amount >= c.p97 then 1 else 0 end as is_top3p
    from by_month b
    join cut c using(ym)
)
select
ym,
count(
    distinct case when is_top3p =1 then user_id end
) as ratio_high_spender_users,
count(distinct user_id) as monthly_active_users,
SAFE_DIVIDE(
count(distinct case when is_top3p=1 then user_id end),
count(distinct user_id)
) as ratio_high_spender_users
from tag
group by ym
order by ym;


