-- trends랑 pre_date_captions
CREATE OR REPLACE VIEW `project.mydataset.view_hashtag_trend_line` AS
SELECT
  a.date  AS kst_date,
  a.value AS trend_score,
  b.hashtags
FROM `project.mydataset.trends` AS a
LEFT JOIN `project.mydataset.pre_date_captions_df` AS b
  ON a.date = b.date
ORDER BY kst_date;
