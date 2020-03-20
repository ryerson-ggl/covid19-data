# covid19-data

Richard Wen rrwen.dev@gmail.com, Shishuo Xu shishuo.xu@ryerson.ca, Wei Huang huangweibuct@gmail.com

Twitter streaming and REST API data collection for the COVID-19 project.

## Twitter Data Stream

The twitter data stream collects real-time tweets based on a set of keywords and stores them into a PostgreSQL database.

Currently, we are collecting tweets with the [Standard Twitter Filter API](https://developer.twitter.com/en/docs/tweets/filter-realtime/api-reference/post-statuses-filter) based on keywords provided by Shishuo:

* **Keywords**: coronavirus, covid19, coronavirusoutbreak, 2019ncov, ncov2019, #Coronavirus, #COVID19, #coronavirusoutbreak, #2019nCov, #nCov2019,socialdistancing, social distancing, #socialdistancing
* **Limitations**
    * 400 keywords
    * 5,000 userid
    * 25 location boxes
    * 1 filter rule on one allowed connection
    * Disconnection required to adjust rule

To run the data collection service, see [INSTALL.md](INSTALL.md).

### See Also

* [Stream Parameters](https://developer.twitter.com/en/docs/tweets/filter-realtime/guides/basic-stream-parameters): details on streaming parameters
* [Standard Keyword Operators](https://developer.twitter.com/en/docs/tweets/rules-and-filtering/overview/standard-operators): details on filter behaviour of keyword queries, useful for refining `track` parameter