# covid19-data: Data Access

Richard Wen rrwen.dev@gmail.com, Shishuo Xu shishuo.xu@ryerson.ca, Wei Huang huangweibuct@gmail.com

Data access instructions for the COVID-19 project.

## COVID19 Database

We have a `covid19` [PostgreSQL](https://www.postgresql.org/) database on our server that can be connected to remotely if you have the following connection details:

* **Host**: ip address of the database server
* **Port**: port of the database server
* **Database**: database name you are connecting to
* **User**: name of the user with access the database
* **Password**: password for the user

:email: Please contact Richard Wen rrwen.dev@gmail.com for connection details.

## pgAdmin4

* :computer: [geocolab.ryerson.ca/db/pgadmin4](https://geocolab.ryerson.ca/db/pgadmin4)

The easiest way to experiment with the data is to use the [Query Tool](https://www.pgadmin.org/docs/pgadmin4/latest/query_tool.html) from [pgAdmin4](https://www.pgadmin.org/) on our self-hosted GUI [here](https://geocolab.ryerson.ca/db/pgadmin4).

![Example of pgAdmin4 Interface](img/pgadmin4_example.png)

Please contact Richard Wen rrwen.dev@gmail.com to setup your account for access.

Using an email and password setup, you can experiment with the [Available data](../README.md#available-data):

1. Create a connection using the [Server Dialog](https://www.pgadmin.org/docs/pgadmin4/latest/server_dialog.html)
2. View the data using the [various pgAdmin4 Tools](https://www.pgadmin.org/docs/pgadmin4/4.19/editgrid.html)
3. Run queries with the [Query Tool](https://www.pgadmin.org/docs/pgadmin4/latest/query_tool.html)

* :email: Please contact Richard Wen rrwen.dev@gmail.com for account setup.

## Programming Languages

Programming languages have their own interface that allow you to connect to a [PostgreSQL](https://www.postgresql.org/) database using either a package or a library:

* **Python**: [pandas Library](https://pandas.pydata.org/docs/) using [read_sql](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_sql.html?highlight=read#pandas.read_sql)
* **R**: [RPostgres Package](https://rpostgres.r-dbi.org/) using [dbConnect](https://rpostgres.r-dbi.org/reference/dbconnect-pqdriver-method) and [dbSendQuery](https://rpostgres.r-dbi.org/reference/postgres-query.html)

To use programming language libraries or packages, you will need the [COVID19 Database Connection Details](#covid19-database).
