# covid19-data: Data Access

Richard Wen rrwen.dev@gmail.com, Shishuo Xu shishuo.xu@ryerson.ca, Wei Huang huangweibuct@gmail.com

Data access instructions for the COVID-19 project.

## COVID19 Database

We have a `covid19` [PostgreSQL](https://www.postgresql.org/) database on our server's that can be connected to remotely if you have the following connection information:

* **Host**: ip address of the database server
* **Port**: port of the database server
* **Database**: database name you are connecting to
* **User**: name of the user with access the database
* **Password**: password for the user

Most of our data will be updated and stored here for easy and secure access.  
  
:email: Contact Richard Wen rrwen.dev@gmail.com to get these details.

## pgAdmin4 PostgreSQL Interface

The easiest way to experiment with the COVID-19 data is to use the [Query Tool](https://www.pgadmin.org/docs/pgadmin4/latest/query_tool.html) from [pgAdmin4](https://www.pgadmin.org/).

![Example of pgAdmin4 Interface](img/pgadmin4_example.png)

We have a self-hosted [pgAdmin4](https://www.pgadmin.org/) GUI available at:  
  
:link: [geocolab.ryerson.ca/db/pgadmin4](https://geocolab.ryerson.ca/db/pgadmin4) 
  
:email: Contact Richard Wen rrwen.dev@gmail.com to setup your account for access

Once you have your email and password setup:

1. Create a connection using the [Server Dialog](https://www.pgadmin.org/docs/pgadmin4/latest/server_dialog.html)
2. View the data using the [various pgAdmin4 Tools](https://www.pgadmin.org/docs/pgadmin4/4.19/editgrid.html)
3. Run queries with the [Query Tool](https://www.pgadmin.org/docs/pgadmin4/latest/query_tool.html)
