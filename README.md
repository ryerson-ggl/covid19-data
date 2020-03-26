# covid19-data

Shishuo Xu shishuo.xu@ryerson.ca, Richard Wen rrwen.dev@gmail.com

Collection of 2019 Corona Virus Disease (COVID-19) data from multiple sources.

## Data Access

Data can be accessed via our lab's `covid19` database given the connection information: 

* `Host`
* `Port`
* `Database`
* `User`
* `Password`

Get the database connection information [here](ACCESS.md#covid19-database).

## Available Datasets

### Twitter Data Stream

Real-time tweets streamed from March 4, 2020 using Shishuo's COVID-19 keywords.

* :page_facing_up: [Details](twitter/README.md#twitter-data-stream)
* :notebook_with_decorative_cover: [Dictionary](twitter/dictionaries/twitter_stream_raw_dictionary.csv)
* :key: Access
    * `Database`: covid19
    * `Schema`: public
    * `Table/View`: twitter_stream
* :email: Contact: Richard Wen rrwen.dev@gmail.com
