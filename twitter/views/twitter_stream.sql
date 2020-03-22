CREATE OR REPLACE VIEW twitter_stream AS
(
SELECT
	tweet ->> 'id' AS tweet_id,
	tweet ->> 'created_at' AS tweet_timestamp,
	(CASE 
	 WHEN tweet -> 'extended_tweet' ->> 'full_text' IS NOT NULL THEN
		tweet -> 'extended_tweet' ->> 'full_text'
	 ELSE
		tweet ->> 'text'::text
	 END
	) AS tweet_text,
	tweet ->> 'lang' AS tweet_langugage,
	tweet ->> 'geo' AS geo,
	tweet -> 'user' ->> 'id' AS user_id,
	tweet -> 'user' ->> 'created_at' AS user_create_timestamp,
	tweet -> 'user' ->> 'friends_count'::numeric AS user_friends,
	tweet -> 'user' ->> ''::
	tweet -> 'user' ->> 'followers_count'::numeric AS user_followers,
	tweet -> 'user' ->> 'favourites_count'::numeric AS user_favourites,
FROM 
	twitter_stream_raw
WHERE 
	tweet ->> 'geo' IS NOT NULL
);