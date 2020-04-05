require('log-timestamp');
var myVar = setInterval(TweetsQuery, 1000000);
function TweetsQuery() {
var twitter2pg = require('twitter2pg');
require('dotenv').config();

// (options) Initialize options object
var options = {
	twitter: {},
	pg: {}
};

// *** CONNECTION SETUP ***

// (options_pg_connection) PostgreSQL connection details
options.pg.connection = {
	port: 5432,
	database: 'covid19'
};

// *** SEARCH TWEETS ***
// See: https://developer.twitter.com/en/docs/tweets/search/api-reference/get-search-tweets

// Worldwide - (options_twitter_rest) Search for keywords and hashtags in path 'GET search/tweets'
options.twitter.method = 'get'; // get, post, or stream
options.twitter.path = 'search/tweets'; // api path
options.twitter.params = {q: 'coronavirus,#Coronavirus,#COVID19,#coronavirusoutbreak,#2019nCov,#nCov2019','count': 100}; // query tweets

// Worldwide - (options_pg) PostgreSQL options
options.pg.table = 'twitter_stream_raw';
options.pg.column = 'tweet';
options.pg.query = 'INSERT INTO $options.pg.table($options.pg.column) SELECT * FROM json_array_elements($1);';

// // (options_pg_connection) PostgreSQL connection details
// options.pg.connection = {
// 	host: 'localhost',
// 	port: 5432,
// 	database: 'postgres',
// 	user: 'postgres',
// 	password: 'ggl@mon304'
// };
// Korea - (options_twitter_rest) Search for keywords and hashtags in path 'GET search/tweets'
// options.twitter.method = 'get'; // get, post, or stream
// options.twitter.path = 'search/tweets'; // api path
// options.twitter.params = {geocode:'35.87028,128.59111,22.5mi', 'count': 100}; // query tweets

// // Korea - (options_pg) PostgreSQL options
// options.pg.table = 'twitter_query_korea';
// options.pg.column = 'tweet';
// options.pg.query = 'INSERT INTO $options.pg.table($options.pg.column) SELECT * FROM json_array_elements($1);';

// (options_jsonata) Filter for statuses array using jsonata
options.jsonata = 'statuses';

// (twitter2pg_rest) Query tweets using REST API into PostgreSQL table
twitter2pg(options)
    .then(data => {
        console.log(data);
    }).catch(err => {
        console.error(err.message);
	});
}