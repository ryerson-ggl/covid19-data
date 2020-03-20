const sendmail = require('sendmail')();
const twitter2pg = require('twitter2pg');

require('log-timestamp');
require('dotenv').config();

// Set the following in .env
/*
TWITTER_CONSUMER_KEY=
TWITTER_CONSUMER_SECRET=
TWITTER_ACCESS_TOKEN_KEY=
TWITTER_ACCESS_TOKEN_SECRET=
PGHOST=
PGPASSWORD=
COMPUTER_NAME=
USE_EMAIL=
EMAIL_FROM=
EMAIL_TO=
*/

// *** MAIL SETUP ***

var use_email = (process.env.USE_EMAIL.toLowerCase().trim() == 'true') || false;

// (mail_reference) Reference text to help identify errors
var reference = `
<b>Package References</b>
<ul>
<li><a href="https://www.npmjs.com/package/sendmail">sendmail Node.js Package</a></li>
<li><a href="https://www.npmjs.com/package/dotenv">dotenv Node.js Package</a></li>
<li><a href="https://github.com/rrwen/twitter2pg">twitter2pg Node.js Package</a></li>
</ul><br>
<b>Twitter API References</b><br>
<ul>
<li><a href="https://developer.twitter.com/en/docs/tweets/filter-realtime/api-reference/post-statuses-filter">Stream API</a></li>
<li><a href="https://developer.twitter.com/en/docs/tweets/filter-realtime/guides/basic-stream-parameters">Stream Paramaters</a></li>
<li><a href="https://developer.twitter.com/en/docs/tweets/rules-and-filtering/overview/standard-operators">Track Operators</a></li>
<li><a href="https://developer.twitter.com/en/docs/tweets/filter-realtime/guides/streaming-message-types">Message Types</a></li>
</ul>`;

// (mail_object) Create email object
const email = require('./email.js')({
	mail_subject: 'Data Stream',
	mail_subject_tag: '[GGL COVID-19 TWITTER]',
	mail_before_message: 'Details below...<br><br>',
	mail_after_message: '<br>' + reference
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
	database: 'covid19'
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
	['Running on', process.env.COMPUTER_NAME],
	['Log email from', process.env.EMAIL_FROM],
	['Log email to', process.env.EMAIL_TO],
	['Twitter method', options.twitter.method],
	['Twitter path', options.twitter.path],
	['Twitter track', options.twitter.params.track],
	['Database host', process.env.PGHOST],
	['Database port', options.pg.connection.port],
	['Database name', options.pg.connection.database],
	['Database table', options.pg.table],
	['Database column', options.pg.column]
];
info.forEach(msg => console.log(`${msg[0]}: ${msg[1]}`));

// (twitter2pg_stream_mail) Send mail that stream has started
var info_html = '<b>Twitter Stream Parameters</b><br><ul>' + info.map(msg => `<li><b>${msg[0]}</b>: ${msg[1]}</li>`).join('<br>') + '</ul>';
if (use_email) {
	email.send(info_html, 'START');
}

// (twitter2pg_stream) Stream tweets into PostgreSQL table
var stream = twitter2pg(options);
stream.on('error', function (err) {
	console.error(err.message);
	var details = `${err.message}<br><br>${err.stack}`;
	if (use_email) {
		email.send(info_html + '<br><b>Error</b><br><br>' + details + '<br><br>', 'ERROR');
	}
	stream.destroy(() => {
		process.exit(1);
	});
});

// (twitter2pg_stream_exit) Exit function
function on_exit(code) {
	var details = `Twitter stream was stopped with exit code ${code}!`;
	console.log(details);
	if (use_email) {
		email.send(info_html + '<br><b>Exit</b><br><br>' + details + '<br><br>', 'STOP');
	}
	stream.destroy(() => {
		process.exit(code);
	});
}

// (twitter2pg_stream_exit_process) Apply exit function to different conditions
process.on('exit', on_exit);
process.on('SIGINT', on_exit);
process.on('SIGUSR1', on_exit);
process.on('SIGUSR2', on_exit);
process.on('uncaughtException', on_exit);
