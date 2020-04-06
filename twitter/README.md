# covid19-data: Twitter Data

Twitter streaming and REST API data collection for the COVID-19 project.

## Twitter Data Stream

* :notebook_with_decorative_cover: [Dictionary](dictionaries/twitter_stream_raw_dictionary.csv)
* :hammer_and_wrench: [Setup](SETUP.md#twitter-data-stream-service)

The twitter data stream collects real-time tweets based on a set of keywords and stores them into a PostgreSQL database.

We are collecting tweets with the [Standard Twitter Filter API](https://developer.twitter.com/en/docs/tweets/filter-realtime/api-reference/post-statuses-filter) based on keywords provided by Shishuo and Wei:

* **Start Date**: March 4, 2020
* **End Date**: Ongoing
* **Keywords**: 
    * **March 4, 2020 to March 29, 2020 (Shishuo)**: coronavirus, covid19, coronavirusoutbreak, 2019ncov, ncov2019, #Coronavirus, #COVID19, #coronavirusoutbreak, #2019nCov, #nCov2019, socialdistancing, social distancing, #socialdistancing
    * **March 29, 2020 to Current (Shishuo/Wei)**: coronavirus, covid19, coronavirusoutbreak, 2019ncov, ncov2019, #Coronavirus, #COVID19, #coronavirusoutbreak, #2019nCov, #nCov2019, socialdistancing, social distancing, #socialdistancing, #physicaldistancing, physical distancing, #stayinsideyourbubble, #stayhomesaveslives, #stayhomesavelives
* **Limitations**
    * 400 keywords
    * 5,000 userid
    * 25 location boxes
    * 1 filter rule on one allowed connection
    * Disconnection required to adjust rule

### Twitter Data Stream References

* [API Stream Parameters](https://developer.twitter.com/en/docs/tweets/filter-realtime/guides/basic-stream-parameters): details on streaming parameters
* [API Keyword Operators](https://developer.twitter.com/en/docs/tweets/rules-and-filtering/overview/standard-operators): details on filter behaviour of standard keyword queries, useful for refining `track` parameter
* [Tweet Data Dictionary](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/tweet-object): descriptions of returned tweet object fields
* [User Data Dictionary](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/user-object): descriptions of returned user object fields
* [Geo Data Dictionary](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/geo-objects): descriptions of returned geo object fields
* [Connection Rules](https://developer.twitter.com/en/docs/tweets/filter-realtime/guides/connecting): details on rate limits and connection behaviour/rules
* [Message Types](https://developer.twitter.com/en/docs/tweets/filter-realtime/overview/statuses-filter): details on message types returned during events such as rate limits, errors, or disconnections
