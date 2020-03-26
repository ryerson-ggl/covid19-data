# covid19-data

Shishuo Xu shishuo.xu@ryerson.ca, Richard Wen rrwen.dev@gmail.com

Collection of 2019 Corona Virus Disease (COVID-19) data from multiple sources.

## Data Access

Our data is stored on our `covid19` database remotely in our lab's server.

To gain access, please contact Richard Wen rrwen.dev@gmail.com for connection details:

* `Host`
* `Port`
* `Database`
* `User`
* `Password`

More details [here](ACCESS.md#covid19-database).

## Available Datasets

### Twitter Data Stream

Real-time tweets beginning on March 4, 2020 using COVID-19 keywords from Shishuo:

* :notebook_with_decorative_cover: [Dictionary](twitter/dictionaries/twitter_stream_raw_dictionary.csv)
* :page_facing_up: [Details](twitter/README.md#twitter-data-stream)
* :key: Access
    * `Database`: covid19
    * `Schema`: public
    * `Table/View`: twitter_stream
