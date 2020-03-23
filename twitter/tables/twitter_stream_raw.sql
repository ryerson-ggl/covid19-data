CREATE OR REPLACE FUNCTION get_tweet_timestamp(text)
RETURNS timestamptz AS 'SELECT $1::timestamptz' LANGUAGE SQL immutable RETURNS NULL ON NULL INPUT;

CREATE OR REPLACE FUNCTION get_tweet_dayofweek(text)
RETURNS smallint AS 'SELECT EXTRACT(ISODOW FROM $1::timestamptz)::smallint' LANGUAGE SQL immutable RETURNS NULL ON NULL INPUT;

CREATE OR REPLACE FUNCTION get_tweet_day(text)
RETURNS smallint AS 'SELECT EXTRACT(DAY FROM $1::timestamptz)::smallint' LANGUAGE SQL immutable RETURNS NULL ON NULL INPUT;

CREATE OR REPLACE FUNCTION get_tweet_month(text)
RETURNS smallint AS 'SELECT EXTRACT(MONTH FROM $1::timestamptz)::smallint' LANGUAGE SQL immutable RETURNS NULL ON NULL INPUT;

CREATE OR REPLACE FUNCTION get_tweet_year(text)
RETURNS smallint AS 'SELECT EXTRACT(YEAR FROM $1::timestamptz)::smallint' LANGUAGE SQL immutable RETURNS NULL ON NULL INPUT;

CREATE OR REPLACE FUNCTION get_tweet_hour(text)
RETURNS smallint AS 'SELECT EXTRACT(HOUR FROM $1::timestamptz)::smallint' LANGUAGE SQL immutable RETURNS NULL ON NULL INPUT;

CREATE OR REPLACE FUNCTION get_tweet_minute(text)
RETURNS smallint AS 'SELECT EXTRACT(MINUTE FROM $1::timestamptz)::smallint' LANGUAGE SQL immutable RETURNS NULL ON NULL INPUT;

CREATE OR REPLACE FUNCTION get_tweet_second(text)
RETURNS smallint AS 'SELECT EXTRACT(SECOND FROM $1::timestamptz)::smallint' LANGUAGE SQL immutable RETURNS NULL ON NULL INPUT;

CREATE OR REPLACE FUNCTION get_tweet_geom(text)
RETURNS geometry AS 'SELECT ST_GeomFromGeoJSON($1)::geometry' LANGUAGE SQL immutable RETURNS NULL ON NULL INPUT;

CREATE TABLE twitter_stream_raw (
	tweet jsonb,
	tweet_id text GENERATED ALWAYS AS ((tweet ->> 'id_str')::text) STORED,
	tweet_timestamp timestamptz GENERATED ALWAYS AS (get_tweet_timestamp((tweet ->> 'created_at')::text)) STORED,
	tweet_dayofweek smallint GENERATED ALWAYS AS (get_tweet_dayofweek((tweet ->> 'created_at')::text)) STORED,
	tweet_day smallint GENERATED ALWAYS AS (get_tweet_day((tweet ->> 'created_at')::text)) STORED,
	tweet_month smallint GENERATED ALWAYS AS (get_tweet_month((tweet ->> 'created_at')::text)) STORED,
	tweet_year smallint GENERATED ALWAYS AS (get_tweet_year((tweet ->> 'created_at')::text)) STORED,
	tweet_hour smallint GENERATED ALWAYS AS (get_tweet_hour((tweet ->> 'created_at')::text)) STORED,
	tweet_minute smallint GENERATED ALWAYS AS (get_tweet_minute((tweet ->> 'created_at')::text)) STORED,
	tweet_second smallint GENERATED ALWAYS AS (get_tweet_second((tweet ->> 'created_at')::text)) STORED,
	is_retweet boolean GENERATED ALWAYS AS ((CASE WHEN (tweet ->> 'retweeted_status')::text is NOT NULL THEN true ELSE false END)::boolean) STORED,
	has_coordinates boolean GENERATED ALWAYS AS ((CASE WHEN (tweet -> 'coordinates' ->> 'coordinates')::text is NOT NULL THEN true ELSE false END)::boolean) STORED,
	has_place boolean GENERATED ALWAYS AS ((CASE WHEN (tweet ->> 'place')::text is NOT NULL THEN true ELSE false END)::boolean) STORED,
	tweet_text text GENERATED ALWAYS AS (CASE WHEN tweet -> 'extended_tweet' ->> 'full_text' IS NOT NULL THEN
		(tweet -> 'extended_tweet' ->> 'full_text')::text
	 ELSE
		(tweet ->> 'text')::text
	 END
	) STORED,
	tweet_language varchar(5) GENERATED ALWAYS AS ((tweet ->> 'lang')::text) STORED,
	tweet_favourites integer GENERATED ALWAYS AS ((tweet ->> 'favorite_count')::integer) STORED,
	tweet_retweets integer GENERATED ALWAYS AS ((tweet ->> 'retweet_count')::integer) STORED,
	tweet_quotes integer GENERATED ALWAYS AS ((tweet ->> 'quote_count')::integer) STORED,
	tweet_country text GENERATED ALWAYS AS ((tweet -> 'place' ->> 'country')::text) STORED,
	tweet_country_code varchar(5) GENERATED ALWAYS AS ((tweet -> 'place' ->> 'country_code')::text) STORED,
	tweet_place text GENERATED ALWAYS AS ((tweet -> 'place' ->> 'full_name')::text) STORED,
	tweet_place_type text GENERATED ALWAYS AS ((tweet -> 'place' ->> 'place_type')::text) STORED,
	tweet_place_01_longitude numeric GENERATED ALWAYS AS ((tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 0 ->> 0)::numeric) STORED,
	tweet_place_01_latitude numeric GENERATED ALWAYS AS ((tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 0 ->> 1)::numeric) STORED,
    tweet_place_02_longitude numeric GENERATED ALWAYS AS ((tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 1 ->> 0)::numeric) STORED,
	tweet_place_02_latitude numeric GENERATED ALWAYS AS ((tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 1 ->> 1)::numeric) STORED,
    tweet_place_03_longitude numeric GENERATED ALWAYS AS ((tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 2 ->> 0)::numeric) STORED,
	tweet_place_03_latitude numeric GENERATED ALWAYS AS ((tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 2 ->> 1)::numeric) STORED,
    tweet_place_04_longitude numeric GENERATED ALWAYS AS ((tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 3 ->> 0)::numeric) STORED,
	tweet_place_04_latitude numeric GENERATED ALWAYS AS ((tweet -> 'place' -> 'bounding_box' -> 'coordinates' -> 0 -> 3 ->> 1)::numeric) STORED,
	tweet_place_geometry geometry GENERATED ALWAYS AS (CASE WHEN (tweet -> 'place' -> 'bounding_box' ->> 'coordinates')::text IS NOT NULL THEN
	 	get_tweet_geom((tweet -> 'place' ->> 'bounding_box')::text)
	 ELSE
	 	null
	 END
	) STORED,
	tweet_longitude numeric GENERATED ALWAYS AS ((tweet -> 'coordinates' -> 'coordinates' ->> 0)::numeric) STORED,
	tweet_latitude numeric GENERATED ALWAYS AS ((tweet -> 'coordinates' -> 'coordinates' ->> 1)::numeric) STORED,
	tweet_geometry geometry GENERATED ALWAYS AS (CASE WHEN (tweet ->> 'coordinates')::text IS NOT NULL THEN
	 	get_tweet_geom((tweet ->> 'coordinates')::text)
	 ELSE
	 	null
	 END
	) STORED,
	user_id text GENERATED ALWAYS AS ((tweet -> 'user' ->> 'id_str')::text) STORED,
	user_create_timestamp timestamptz GENERATED ALWAYS AS (get_tweet_timestamp((tweet -> 'user' ->> 'created_at')::text)) STORED,
	user_is_verified boolean GENERATED ALWAYS AS ((tweet -> 'user' ->> 'verified')::boolean) STORED,
	user_has_place boolean GENERATED ALWAYS AS ((CASE WHEN tweet -> 'user' ->> 'location' is NOT NULL THEN true ELSE false END)::boolean) STORED,
	user_favourites integer GENERATED ALWAYS AS ((tweet -> 'user' ->> 'favourites_count')::integer) STORED,
	user_followers integer GENERATED ALWAYS AS ((tweet -> 'user' ->> 'followers_count')::integer) STORED,
	user_friends integer GENERATED ALWAYS AS ((tweet -> 'user' ->> 'friends_count')::integer) STORED,
	user_tweets integer GENERATED ALWAYS AS ((tweet -> 'user' ->> 'statuses_count')::integer) STORED,
	user_place text GENERATED ALWAYS AS ((tweet -> 'user' ->> 'location')::text) STORED,
	retweet_id text GENERATED ALWAYS AS ((tweet -> 'retweeted_status' ->> 'id_str')::text) STORED,
	retweet_user_id text GENERATED ALWAYS AS ((tweet -> 'retweeted_status' -> 'user' ->> 'id_str')::text) STORED
);