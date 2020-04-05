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

CREATE OR REPLACE FUNCTION get_tweet_tsvector(text)
RETURNS tsvector AS 'SELECT to_tsvector(''english'', $1)' LANGUAGE SQL immutable RETURNS NULL ON NULL INPUT;

CREATE TABLE IF NOT EXISTS twitter_stream_raw (
	row_id SERIAL PRIMARY KEY,
	tweet jsonb,
	tweet_id numeric GENERATED ALWAYS AS ((tweet ->> 'id_str')::numeric) STORED,
	tweet_timestamp timestamptz GENERATED ALWAYS AS (get_tweet_timestamp((tweet ->> 'created_at')::text)) STORED,
	tweet_dayofweek smallint GENERATED ALWAYS AS (get_tweet_dayofweek((tweet ->> 'created_at')::text)) STORED,
	tweet_day smallint GENERATED ALWAYS AS (get_tweet_day((tweet ->> 'created_at')::text)) STORED,
	tweet_month smallint GENERATED ALWAYS AS (get_tweet_month((tweet ->> 'created_at')::text)) STORED,
	tweet_year smallint GENERATED ALWAYS AS (get_tweet_year((tweet ->> 'created_at')::text)) STORED,
	tweet_hour smallint GENERATED ALWAYS AS (get_tweet_hour((tweet ->> 'created_at')::text)) STORED,
	tweet_minute smallint GENERATED ALWAYS AS (get_tweet_minute((tweet ->> 'created_at')::text)) STORED,
	tweet_second smallint GENERATED ALWAYS AS (get_tweet_second((tweet ->> 'created_at')::text)) STORED,
	is_tweet boolean GENERATED ALWAYS AS ((CASE WHEN (tweet ->> 'id_str')::text is NOT NULL THEN true ELSE false END)::boolean) STORED,
	is_retweet boolean GENERATED ALWAYS AS ((CASE WHEN (tweet ->> 'retweeted_status')::text is NOT NULL THEN true ELSE false END)::boolean) STORED,
	has_coordinates boolean GENERATED ALWAYS AS ((CASE WHEN (tweet -> 'coordinates' ->> 'coordinates')::text is NOT NULL THEN true ELSE false END)::boolean) STORED,
	has_place boolean GENERATED ALWAYS AS ((CASE WHEN (tweet ->> 'place')::text is NOT NULL THEN true ELSE false END)::boolean) STORED,
	tweet_text text GENERATED ALWAYS AS (CASE WHEN tweet -> 'extended_tweet' ->> 'full_text' IS NOT NULL THEN
		(tweet -> 'extended_tweet' ->> 'full_text')::text
	 ELSE
		(tweet ->> 'text')::text
	 END
	) STORED,
	tweet_text_tsvector tsvector GENERATED ALWAYS AS (CASE WHEN tweet -> 'extended_tweet' ->> 'full_text' IS NOT NULL THEN
		get_tweet_tsvector((tweet -> 'extended_tweet' ->> 'full_text')::text)
	 ELSE
		get_tweet_tsvector((tweet ->> 'text')::text)
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
	user_id numeric GENERATED ALWAYS AS ((tweet -> 'user' ->> 'id_str')::numeric) STORED,
	user_create_timestamp timestamptz GENERATED ALWAYS AS (get_tweet_timestamp((tweet -> 'user' ->> 'created_at')::text)) STORED,
	user_is_verified boolean GENERATED ALWAYS AS ((tweet -> 'user' ->> 'verified')::boolean) STORED,
	user_has_place boolean GENERATED ALWAYS AS ((CASE WHEN tweet -> 'user' ->> 'location' is NOT NULL THEN true ELSE false END)::boolean) STORED,
	user_favourites integer GENERATED ALWAYS AS ((tweet -> 'user' ->> 'favourites_count')::integer) STORED,
	user_followers integer GENERATED ALWAYS AS ((tweet -> 'user' ->> 'followers_count')::integer) STORED,
	user_friends integer GENERATED ALWAYS AS ((tweet -> 'user' ->> 'friends_count')::integer) STORED,
	user_tweets integer GENERATED ALWAYS AS ((tweet -> 'user' ->> 'statuses_count')::integer) STORED,
	user_place text GENERATED ALWAYS AS ((tweet -> 'user' ->> 'location')::text) STORED,
	retweet_id numeric GENERATED ALWAYS AS ((tweet -> 'retweeted_status' ->> 'id_str')::numeric) STORED,
	retweet_user_id numeric GENERATED ALWAYS AS ((tweet -> 'retweeted_status' -> 'user' ->> 'id_str')::numeric) STORED
);

CREATE INDEX IF NOT EXISTS tweet_id_index ON twitter_stream_raw (tweet_id);
CREATE INDEX IF NOT EXISTS tweet_timestamp_index ON twitter_stream_raw (tweet_timestamp);
CREATE INDEX IF NOT EXISTS tweet_dayofweek_index ON twitter_stream_raw (tweet_dayofweek);
CREATE INDEX IF NOT EXISTS tweet_language_index ON twitter_stream_raw (tweet_language);
CREATE INDEX IF NOT EXISTS tweet_country_code_index ON twitter_stream_raw (tweet_country_code);
CREATE INDEX IF NOT EXISTS tweets_favourites_index ON twitter_stream_raw (tweet_favourites);
CREATE INDEX IF NOT EXISTS tweet_retweets_index ON twitter_stream_raw (tweet_retweets);
CREATE INDEX IF NOT EXISTS tweet_text_tsvector_index ON twitter_stream_raw USING GIN(tweet_text_tsvector);
CREATE INDEX IF NOT EXISTS tweet_place_type_index ON twitter_stream_raw(tweet_place_type);
CREATE INDEX IF NOT EXISTS tweet_has_coordinates_index ON twitter_stream_raw (has_coordinates) WHERE has_coordinates;
CREATE INDEX IF NOT EXISTS tweet_is_tweet_index ON twitter_stream_raw (is_tweet) WHERE is_tweet;
CREATE INDEX IF NOT EXISTS tweet_is_retweet_index ON twitter_stream_raw (is_retweet) WHERE is_retweet;
CREATE INDEX IF NOT EXISTS tweet_has_place_index ON twitter_stream_raw (has_place) WHERE has_place;
CREATE INDEX IF NOT EXISTS tweet_geometry_index ON twitter_stream_raw USING GIST(tweet_geometry);
CREATE INDEX IF NOT EXISTS tweet_place_geometry_index ON twitter_stream_raw USING GIST(tweet_place_geometry);

CREATE INDEX IF NOT EXISTS user_id_index ON twitter_stream_raw (user_id);
CREATE INDEX IF NOT EXISTS user_is_verified_index ON twitter_stream_raw (user_is_verified) WHERE user_is_verified;
CREATE INDEX IF NOT EXISTS user_create_timestamp ON twitter_stream_raw (user_create_timestamp);
CREATE INDEX IF NOT EXISTS user_has_place_index ON twitter_stream_raw (user_has_place) WHERE user_has_place;
CREATE INDEX IF NOT EXISTS user_friends_index ON twitter_stream_raw (user_friends);
CREATE INDEX IF NOT EXISTS user_followers_index ON twitter_stream_raw (user_followers);
CREATE INDEX IF NOT EXISTS user_tweets_index ON twitter_stream_raw (user_tweets);

CREATE TABLE IF NOT EXISTS twitter_stream_raw_misc
(CHECK (NOT is_tweet))
INHERITS (twitter_stream_raw);

CREATE OR REPLACE FUNCTION partition_twitter_stream_raw()
RETURNS TRIGGER AS $$
DECLARE
	partition_date TEXT;
	partition_name TEXT;
	day_start TEXT;
	day_end TEXT;
BEGIN
	partition_date := to_char((NEW.tweet ->> 'created_at')::timestamptz,'YYYY_MM_DD');
 	partition_name := 'twitter_stream_raw_' || partition_date;
	day_start := to_char((NEW.tweet ->> 'created_at')::timestamptz,'YYYY-MM-DD');
	day_end := to_char((NEW.tweet ->> 'created_at')::timestamptz + interval '1 day', 'YYYY-MM-DD');
IF NOT EXISTS
	(SELECT 1
   	 FROM information_schema.tables 
   	 WHERE table_name = partition_name) AND (NEW.tweet ->> 'id_str') IS NOT NULL
THEN
	RAISE NOTICE 'A partition has been created %', partition_name;
	EXECUTE format(E'CREATE TABLE %I (CHECK ( date_trunc(\'day\', tweet_timestamp) >= ''%s'' AND date_trunc(\'day\', tweet_timestamp) < ''%s'')) INHERITS (twitter_stream_raw)', partition_name, day_start, day_end);
END IF;
IF (NEW.tweet ->> 'id_str') IS NOT NULL THEN
	EXECUTE format('INSERT INTO %I (tweet) VALUES($1)', partition_name) using NEW.tweet;
ELSE
	EXECUTE format('INSERT INTO twitter_stream_raw_misc (tweet) VALUES($1)', partition_name) using NEW.tweet;
END IF;
RETURN NULL;
END
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS insert_twitter_stream_raw on twitter_stream_raw;
CREATE TRIGGER insert_twitter_stream_raw
    BEFORE INSERT ON twitter_stream_raw
    FOR EACH ROW EXECUTE PROCEDURE partition_twitter_stream_raw();
	