const twitter2pg = require('twitter2pg');

require('log-timestamp');
require('dotenv').config();

// *** MAIL SETUP ***

var use_email = Boolean(process.env.USE_EMAIL) || false;

// (mail_reference) Reference text to help identify errors
var reference = `<b>References</b><ul>
<li><a href="https://www.npmjs.com/package/nodemailer">nodemailer Node.js Package</a></li>
<li><a href="https://medium.com/@nickroach_50526/sending-emails-with-node-js-using-smtp-gmail-and-oauth2-316fe9c790a1">nodemailer with Gmail</a></li>
<li><a href="https://support.google.com/googleapi/answer/6158841?hl=en">Enable Gmail API</a></li>
<li><a href="https://www.npmjs.com/package/dotenv">dotenv Node.js Package</a></li>
<li><a href="https://github.com/rrwen/twitter2pg">twitter2pg Node.js Package</a></li>
<li><a href="https://developer.twitter.com/en/docs/tweets/filter-realtime/api-reference/post-statuses-filter">Twitter Stream API</a></li>
<li><a href="https://developer.twitter.com/en/docs/tweets/filter-realtime/guides/basic-stream-parameters">Twitter Stream API Params</a></li>
<li><a href="https://developer.twitter.com/en/docs/tweets/rules-and-filtering/overview/standard-operators">Twitter Stream API Operators</a></li>
<li><a href="https://developer.twitter.com/en/docs/tweets/filter-realtime/guides/streaming-message-types">Twitter Stream Message Types</a><li>
</ul>`;

// (mail_object) Create email object
const email = require('./gmail.js')({
	mail_subject: 'Data Stream',
	mail_subject_tag: '[GGL COVID-19 TWITTER]',
	mail_before_message: 'Details below...<br><br>',
	mail_after_message: '<br><br>' + reference
});

// *** CONNECTION SETUP ***

// (options) Initialize options object
var options = {
	twitter: {},
	pg: {}
};

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
options.twitter.params = {
	track: 'coronavirus,covid19,coronavirusoutbreak,2019ncov,ncov2019,#Coronavirus,#COVID19,#coronavirusoutbreak,#2019nCov,#nCov2019,socialdistancing,social distancing,#socialdistancing'
};

// (options_pg) PostgreSQL options
options.pg.table = 'twitter_stream';
options.pg.column = 'tweet';
options.pg.query = 'INSERT INTO $options.pg.table($options.pg.column) VALUES($1);';

// (info_msg) Create info message object and log info
console.log('Starting Twitter stream...');
var info = [
	['Log email from', process.env.GMAIL_USER],
	['Log email to', process.env.GMAIL_TO],
	['Twitter method', options.twitter.method],
	['Twitter path', options.twitter.path],
	['Twitter track', options.twitter.params.track],
	['Database host', process.env.PGHOST],
	['Datbaase port', options.pg.connection.port],
	['Database name', options.pg.connection.database],
	['Database table', options.pg.table],
	['Database column', options.pg.column]
];
info.forEach(msg => console.log(`${msg[0]}: ${msg[1]}`));

// (twitter2pg_stream_mail) Send mail that stream has started
var info_html = '<b>Twitter Stream Parameters</b><br><ul>' + info.map(msg => `<li><b>${msg[0]}</b>: ${msg[1]}</li>`).join('<br>') + '</ul>';
if (use_email) email.send(info_html, 'START');

/*
// (twitter2pg_stream) Stream tweets into PostgreSQL table
var stream = twitter2pg(options);
stream.on('data', function (data) {
	throw new Error('Testing Error');
	// console.log('Inserted tweet into database...');
});
stream.on('error', function (error) {
	console.error(error.message);
	send_email('Error', 'Details below...<br><br>' + + JSON.stringify(error, null));
}); 
*/