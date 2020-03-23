DROP VIEW IF EXISTS twitter_stream;
CREATE VIEW twitter_stream AS
(
SELECT
	tweet ->> 'id_str' AS tweet_id,
	tweet ->> 'created_at' AS tweet_timestamp,
	(CASE WHEN tweet -> 'retweeted_status' is NOT NULL THEN
	 	true
	 ELSE
	 	false
	 END)::boolean AS is_retweet,
	(CASE WHEN tweet -> 'extended_tweet' ->> 'full_text' IS NOT NULL THEN
		tweet -> 'extended_tweet' ->> 'full_text'
	 ELSE
		tweet ->> 'text'::text
	 END
	) AS tweet_text,
	tweet ->> 'lang' AS tweet_language,
	(tweet -> 'favorite_count')::integer AS tweet_favourites,
	(tweet -> 'retweet_count')::integer AS tweet_retweets,
	(tweet -> 'quote_count')::integer AS tweet_quotes,
	tweet -> 'place' ->> 'country' AS tweet_country,
	tweet -> 'place' ->> 'country_code' AS tweet_country_code,
	tweet -> 'place' ->> 'full_name' AS tweet_place,
	tweet -> 'place' ->> 'place_type' AS tweet_place_type,
	(tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 0 -> 0 -> 0)::numeric AS tweet_place_01_longitude,
	(tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 0 -> 0 -> 1)::numeric AS tweet_place_01_latitude,
	(tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 0 -> 1 -> 0)::numeric AS tweet_place_02_longitude,
	(tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 0 -> 1 -> 1)::numeric AS tweet_place_02_latitude,
	(tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 0 -> 2 -> 0)::numeric AS tweet_place_03_longitude,
	(tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 0 -> 2 -> 1)::numeric AS tweet_place_03_latitude,
	(tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 0 -> 3 -> 0)::numeric AS tweet_place_04_longitude,
	(tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 0 -> 3 -> 1)::numeric AS tweet_place_04_latitude,
	(tweet -> 'coordinates' -> 'coordinates' -> 0)::numeric AS tweet_longitude,
	(tweet -> 'coordinates' -> 'coordinates' -> 1)::numeric AS tweet_latitude,
	tweet -> 'user' ->> 'id_str' AS user_id,
	tweet -> 'user' ->> 'created_at' AS user_create_timestamp,
	(tweet -> 'user' -> 'verified')::boolean AS user_verified,
	(tweet -> 'user' -> 'favourites_count')::integer AS user_favourites,
	(tweet -> 'user' -> 'followers_count')::integer AS user_followers,
	(tweet -> 'user' -> 'friends_count')::integer AS user_friends,
	(tweet -> 'user' -> 'statuses_count')::integer AS user_tweets,
	tweet -> 'user' ->> 'location' AS user_place
FROM 
	twitter_stream_raw
);