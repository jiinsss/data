data source= sentiment_and_etl로 처리한 데이터 (df_info.txt)
1. 분석 (빅쿼리 sql)

# 콘텐츠 반응 패턴 분석

[1]. 트렌드 추세선과 해시태그(가중치)
-> "트렌드 상승시에 어떤 해시태그가 노출이 되는가"

[2]. 시간대에 따른 게시글 참여도, 감정 차이
-> "언제 올려야 반응이 좋은가"

[3]. 게시글과 댓글 감정 일치도 (산점도) - 내용이나 해시태그 내용도 표현
-> "최대 반응 시간대의 사용자 감정 변화와 콘텐츠 전달력"



### 트렌드 변화
![트렌드 변화](./images/trend_dashboard.PNG)

### 시간대 반응
![시간대 반응](./images/likesCount_commentsCount_dashboard.PNG)

### 유저 감정변화, 내용 전달력 (max engagement, max sentiment)
![감정 변화](./images/max_engagement_captions_comments_analysis.PNG)

![감정 변화](./images/max_sentiment_captions_comments_analysis.PNG)


# 분석결과

- **오전·점심·퇴근 시간대**에는
    
    → 감정 진폭이 큰 **공감형·참여형 콘텐츠**를 집중 배치
    
    → 목적: **즉각적 공감·참여 유도 및 트래픽 상승**
    
- **평일 저녁·주말**에는
    
    → 감정 안정성이 높은 **정보형·상품형 콘텐츠**로 지속 노출
    
    → 목적: **브랜드 인지도 강화 및 장기적 신뢰 구축**
    
- **트렌드 상승 시점 대응**
    
    → 실시간 참여 유도형 해시태그를 활용해 감정 진폭이 큰 콘텐츠를 중심으로 단기 확산
    
    → 계절 전환기에는 시즌성 핵심 키워드를 중심으로 감정 안정형 콘텐츠 강화



# 비즈니스적 인사이트

이를 비즈니스 목적이나 전략에 활용한다면, 특정 브랜드의 인기 상승 요인을 분석하고 해당 브랜드의 해시태그와 연관된 제품을 추천시스템에 활용 할 수 있다

특정 브랜드를 예를 든다면, 트래픽 상승 지점의 해시태그 목록을 보고 정보형 콘텐츠인지, 감정 유도형 콘텐츠인지 파악하고 이를 적절한 시간대에 배치해 홍보 효율을 높일 수 있다

혹은 특정 브랜드의 유저들의 반응 정보를 통해 유저들의 관심 해시태그를 파악하고, 타입을 분류할 수 있다

EX

“트래픽 구간동안, 해당 브랜드는 공감형으로 “해시태그A”을, 참여형으로 “해시태그B”, 프로모션성으로 “해시태그C” 사용했고, 계절성 상품으로는 “해시태그D”을 내세웠다 ”

“유저는 공감형 “해시태그A”, 스토리형 “해시태그B”, 상품형 “해시태그C” 콘텐츠를 선호하는 경향을 보였다”


# 추천 우선순위 개선을 위한 피처 가중 분석

외부 플랫폼(인스타그램, 구글 트렌드)에서
특정 브랜드에 대한 해시태그 반응·감성 패턴을 추적한 뒤,
이를 동일 브랜드 상품의 추천 우선순위 조정에 반영 →
“지금 시장에서 뜨는 브랜드 상품을 먼저 보여줄 수 있음”

해시태그 반응·감성 점수
score =
      + a * sentiment_avg
      + b * trend_norm
      + c * normalized_engagement

[1]

#### 분석결과
#### 비즈니스적 인사이트

=========================
#0~1 norm
--engagement = commentsCount + likesCount
normalized_engagement = SAFE_DIVIDE(engagement,MAX(engagement) OVER())
--sentiment_avg = (caption_sentiment + avg_comment_sentiment) / 2
sentiment_norm = SAFE_DIVIDE(sentiment_avg + 1, 2)
trend_norm = SAFE_DIVIDE(
                trend_value - MIN(trend_value) OVER (),
                NULLIF(MAX(trend_value) OVER () - MIN(trend_value) OVER (), 0)
              )

#이거 비율은 corr 해볼거임
score =
      + a * sentiment_avg
      + b * trend_norm
      + c * normalized_engagement


==========================
필요패키지 설치
pip install -r requirements.txt

필요 추가 전처리 테이블 빅쿼리 업로드 

(날짜별 게시글 하나[가중치 두고 계산한 engagement score 기준], 가중치로 중요 해시태그 정제)

preprocessing\preprocessing_hashtag_date_update.ipynb
