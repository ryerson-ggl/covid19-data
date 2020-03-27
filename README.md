# covid19-data

* :wrench: [Database Setup](SETUP.md)
* :computer: [Database Interface](https://geocolab.ryerson.ca/db/pgadmin4)

Shishuo Xu shishuo.xu@ryerson.ca, Richard Wen rrwen.dev@gmail.com

Collection of 2019 Corona Virus Disease (COVID-19) data from multiple sources.

## Quick Start

Datasets can be accessed via our lab's `covid19` database:

1. Get your `Database Connection Details` from Richard rrwen.dev@gmail.com (more details [here](SETUP.md#covid19-database))
2. Get your `Database Interface` account setup from Richard
3. Login to the `Database Interface` [here](https://geocolab.ryerson.ca/db/pgadmin4)
4. Connect to our database with the [Create Server Dialog](https://www.pgadmin.org/docs/pgadmin4/latest/server_dialog.html#server-dialog) and use the [Query Tool](https://www.pgadmin.org/docs/pgadmin4/latest/query_tool.html) (example [here](SETUP.md#database-interface))
5. Access the datasets given their `schema` and `table/view` name

**Note**: For some datasets, files may also be available via download links.

## Available Datasets

A variety of datasets collected and curated by our team are available for COVID-19 project.

### Twitter Data Stream

Real-time tweets streamed from March 4, 2020 using Shishuo's COVID-19 keywords.

* :page_facing_up: [Details](twitter/README.md#twitter-data-stream)
* :notebook_with_decorative_cover: [Dictionary](twitter/dictionaries/twitter_stream_raw_dictionary.csv)
* :key: Access
    * `Database`: covid19
    * `Schema`: public
    * `Table/View`: twitter_stream
* :email: Contact: Richard Wen rrwen.dev@gmail.com
