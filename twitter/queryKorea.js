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

// *** SEARCH TWEETS ***
// See: https://developer.twitter.com/en/docs/tweets/search/api-reference/get-search-tweets

// Worldwide - (options_twitter_rest) Search for keywords and hashtags in path 'GET search/tweets'
options.twitter.method = 'get'; // get, post, or stream
options.twitter.path = 'search/tweets'; // api path
options.twitter.params = {q: 'coronavirus,#Coronavirus,#COVID19,#coronavirusoutbreak,#2019nCov,#nCov2019', 'count': 100}; // query tweets

// Worldwide - (options_pg) PostgreSQL options
options.pg.table = 'twitter_query';
options.pg.column = 'tweet';
options.pg.query = 'INSERT INTO $options.pg.table($options.pg.column) SELECT * FROM json_array_elements($1);';

// Korea - (options_twitter_rest) Search for keywords and hashtags in path 'GET search/tweets'
options.twitter.method = 'get'; // get, post, or stream
options.twitter.path = 'search/tweets'; // api path
options.twitter.params = {q: 'coronavirus,#Coronavirus,#COVID19,#coronavirusoutbreak,#2019nCov,#nCov2019', geocode:'35.87028,128.59111,22.5mi', 'count': 100}; // query tweets

// Korea - (options_pg) PostgreSQL options
options.pg.table = 'twitter_query_Korea';
options.pg.column = 'tweet';
options.pg.query = 'INSERT INTO $options.pg.table($options.pg.column) SELECT * FROM json_array_elements($1);';

// Italy - (options_twitter_rest) Search for keywords and hashtags in path 'GET search/tweets'
options.twitter.method = 'get'; // get, post, or stream
options.twitter.path = 'search/tweets'; // api path
options.twitter.params = {q: 'coronavirus,#Coronavirus,#COVID19,#coronavirusoutbreak,#2019nCov,#nCov2019', geocode:'42.713050,12.541911,340.80mi', 'count': 100}; // query tweets

// Italy - (options_pg) PostgreSQL options
options.pg.table = 'twitter_query_Italy';
options.pg.column = 'tweet';
options.pg.query = 'INSERT INTO $options.pg.table($options.pg.column) SELECT * FROM json_array_elements($1);';

// Japan - (options_twitter_rest) Search for keywords and hashtags in path 'GET search/tweets'
options.twitter.method = 'get'; // get, post, or stream
options.twitter.path = 'search/tweets'; // api path
options.twitter.params = {q: 'coronavirus,#Coronavirus,#COVID19,#coronavirusoutbreak,#2019nCov,#nCov2019', geocode:'36.191005,138.785531,594.17mi','count': 100}; // query tweets

// Japan - (options_pg) PostgreSQL options
options.pg.table = 'twitter_query_Japan';
options.pg.column = 'tweet';
options.pg.query = 'INSERT INTO $options.pg.table($options.pg.column) SELECT * FROM json_array_elements($1);';

// Iran - (options_twitter_rest) Search for keywords and hashtags in path 'GET search/tweets'
options.twitter.method = 'get'; // get, post, or stream
options.twitter.path = 'search/tweets'; // api path
options.twitter.params = {q: 'coronavirus,#Coronavirus,#COVID19,#coronavirusoutbreak,#2019nCov,#nCov2019', geocode:'31.656278,54.268005,744.27mi','count': 100}; // query tweets

// Iran - (options_pg) PostgreSQL options
options.pg.table = 'twitter_query_Iran';
options.pg.column = 'tweet';
options.pg.query = 'INSERT INTO $options.pg.table($options.pg.column) SELECT * FROM json_array_elements($1);';


// (options_jsonata) Filter for statuses array using jsonata
options.jsonata = 'statuses';

// (twitter2pg_rest) Query tweets using REST API into PostgreSQL table
twitter2pg(options)
    .then(data => {
        console.log(data);
    }).catch(err => {
        console.error(err.message);
    });
