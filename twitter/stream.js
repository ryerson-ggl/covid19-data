var twitter2pg = require('twitter2pg');

// (options) Initialize options object
var options = {
	twitter: {},
	pg: {}
};

// *** CONNECTION SETUP ***

// (options_pg_connection) PostgreSQL connection details
options.pg.connection = {
	port: 5432,
	database: 'covid19',
	user: 'postgres'
};

// *** STREAM TWEETS ***
// See: https://developer.twitter.com/en/docs/tweets/filter-realtime/api-reference/post-statuses-filter

// (options_twitter_connection) Track keyword 'twitter' in path 'POST statuses/filter'
options.twitter.method = 'stream'; // get, post, or stream
options.twitter.path = 'statuses/filter'; // api path
options.twitter.params = {track: 'coronavirus,covid19,coronavirusoutbreak,2019ncov,ncov2019, #Coronavirus,#COVID19,#coronavirusoutbreak,#2019nCov,#nCov2019, socialdistancing, social distancing, #socialdistancing'}; // query tweets

// (options_pg) PostgreSQL options
options.pg.table = 'twitter_stream';
options.pg.column = 'tweet';
options.pg.query = 'INSERT INTO $options.pg.table($options.pg.column) VALUES($1);';

// (twitter2pg_stream) Stream tweets into PostgreSQL table
var stream = twitter2pg(options);
stream.on('data', function(data){
	console.log('Inserted tweet into database...');
});
stream.on('error', function(error) {
	console.error(error.message);
});