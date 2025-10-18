data source= sentiment_and_etl로 처리한 데이터 (df_info.txt)

외부 플랫폼(인스타그램, 구글 트렌드)에서
특정 브랜드에 대한 해시태그 반응·감성 패턴을 추적한 뒤,
이를 동일 브랜드 상품의 추천 우선순위 조정에 반영 →
“지금 시장에서 뜨는 브랜드 상품을 먼저 보여줄 수 있음”


2. a/b 테스트 (추천시스템 성능)

추천은 외부신호(감성분석 + 트렌드 + 참여도) 결과로 나온 해시태그와 유사도를 계산한 상품을 추천해줄거 (tf-idf)

# 외부 반응으로 나온 해시태그 추출
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

df["score"] = (
    a * df["sentiment_avg"]
    + b * df["trend_norm"]
    + c * df["normalized_engagement"]
)

#추천 순위로 정렬
df_sorted = df.sort_values("score", ascending=False)

#상위 10개 추천 결과 보기
df_sorted.head(10)


+ 상품 데이터 테이블 (dummy 생성)
# A 그룹 외부신호 반영 X 추천
그냥 추천

# B 그룹 외부신호 반영 O 추천
tf-idf & cosine similarity 추천

==========================
필요패키지 설치
pip install -r requirements.txt
