DROP VIEW IF EXISTS twitter_stream;
CREATE VIEW twitter_stream AS
(
SELECT
	*
FROM 
	twitter_stream_raw
WHERE is_tweet
);