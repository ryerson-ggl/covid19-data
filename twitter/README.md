# covid19-data

Shishuo Xu shishuo.xu@ryerson.ca, Richard Wen rrwen.dev@gmail.com

Twitter streaming and REST API data.

## Twitter Data Stream

The Twitter data stream will stream a set of COVID-19 related keywords into a PostgreSQL database table.

### 1. Setting up the Twitter Stream

To collect streaming data from Twitter, we need to install the following:

1. Install [Node.js](https://nodejs.org/en/)
2. Install the [PostgreSQL Database](https://www.postgresql.org/)
3. Install the required `node` packages with `npm`
4. Create PostgreSQL database called `covid19`
5. Create a table in the database called `twitter_stream`
6. Create a column in the `twitter_stream` table called `tweet` with type `jsonb`

```
npm install
```

**Note**: Ensure you are in the `covid19-data` folder 

### 2. Set Up the Environment File
  
After this, create a file called `.env` at the root of the `covid19-data` folder and fill in the following information:

```
TWITTER_CONSUMER_KEY=***
TWITTER_CONSUMER_SECRET=***
TWITTER_ACCESS_TOKEN_KEY=***
TWITTER_ACCESS_TOKEN_SECRET=***
PGHOST=localhost
PGUSER=postgres
PGPASSWORD=***
COMPUTER_NAME=REMOTE-COMPUTER-NAME
USE_EMAIL=true
EMAIL_FROM=test-email@email.com
EMAIL_TO=your-email@email.com
```

### 3. Create a Twitter Data Stream Service
  
Now, install a Windows service with `nssm` called `covid19_twitter_stream` with the interface:

```
bin\nssm install covid19_twitter_stream
```

In the `Application` tab, apply the following settings:

* Set the `Path` to your node installation
* Set the `Startup Directory` to the `covid19-data` folder
* Set the `Arguments` the `twitter/stream.js` file with forward slashes `/`

![Example of Application settings](img/nssm_application.PNG)

Next, set the following settings in the `Details` tab:

* Change `Display Name` to `covid19_twitter_stream`
* Change `Description` to be `Twitter stream data into PostgreSQL database for COVID-19 tweets`

![Example of Details settings](img/nssm_details.PNG)

For the `Log on` tab:

* Check `Allow service to interact with Desktop`

![Example of Details settings](img/nssm_logon.PNG)

In the `Exit actions` tab, under `Restart`:

* Choose `Restart application`
* Set the `Delay restart by` to `15000`

![Example of Details settings](img/nssm_exit.PNG)

Finally, in the `I/O` tab:

* Set `Output (stdout)` and `Output (stderr)` to `twitter/logs/stream.log`
* Also create the `twitter/logs` folder if it does not exist

![Example of Details settings](img/nssm_io.PNG)

All other settings are left on default.

### 4. Run the Twitter Data Stream Service

Run the `covid19_twitter_stream` service we installed from the previous step with:

```
bin\nssm start covid19_twitter_stream
```

Checking on the service:

```
bin\nssm status covid19_twitter_stream
```

If you need to stop this service:

```
bin\nssm stop covid19_twitter_stream
```

If you need to make changes to the service:

```
bin\nssm edit covid19_twitter_stream
```

A log is created at `twitter/logs/stream.log`.
