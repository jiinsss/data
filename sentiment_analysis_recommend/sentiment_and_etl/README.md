data source = apify 스키마 참고 dummy 데이터 생성

1. 필요 패키지 설치
pip install -r requirements.txt

2. 구글 시트 업로드 & 감성분석 (ET)
python data_preprocessing\preprocessing.py --to sheets

- csv 형태보다 중첩 데이터가 있어서 json 형태의 데이터를 파이썬으로 처리
일단 etl로 파이썬에서 Transformation을 한 다음에, 빅쿼리에서 dml만

3. 빅쿼리 업로드 (L)
python data_preprocessing\preprocessing.py --to bq
