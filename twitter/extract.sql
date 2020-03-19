SELECT 
	tweet ->> 'id' as id,
	tweet ->> 'geo' as geo,
	tweet ->> 'text' as text
FROM twitter_stream
WHERE tweet ->> 'id' IS NOT NULL;