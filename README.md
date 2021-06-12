# Elastic Stack (ELK) and MySQL on Docker

[![Elastic Stack version](https://img.shields.io/badge/Elastic%20Stack-7.13.0-00bfb3?style=flat&logo=elastic-stack)](https://www.elastic.co/blog/category/releases)
[![MySQL version](https://img.shields.io/badge/MySQL-8.0-f29111?style=flat&logo=MySQL&logoColor=white)](https://dev.mysql.com/doc/relnotes/mysql/8.0/en/)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Frayjasson98%2Fdocker-mysql-elk&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)

Learn how to synchronize data from MySQL to Elasticsearch using Logstash and JDBC.

## Run Services

Docker Compose is used to run Elastic Stack (ELK) and MySQL as multi-container Docker applications.

- To start the services, run
  - `$ docker-compose up`, or
  - `$ docker-compose up -d [service1, service2, ...]`
- To stop the services _(without deleting states)_, run
  - `$ docker-compose stop`, or
  - `$ docker-compose stop [service1, service2, ...]`
- To remove containers together with saved states, run
  - `$ docker-compose down -v`

After everything is up,

- Open http://localhost:5601/app/dev_tools#/console.
- Log in with `username: elastic` and `password: changeme`.
- Type `GET /temp_index/_search` to query the `temp_index` on Elasticsearch.

## Things to Note

- **Access Services on Localhost**
  - You can access ELK services by their ports.
  - MySQL can be accessed using MySQL Workbench with a new connection. _You might need to stop MySQL services on your host machine to prevent port conflicts._
- **Save Changes**
  - Data of Elasticsearch and MySQL will be persisted on the host machine using volumes (managed by Docker).
  - In other words, all states will be saved and you can continue where you left off on next restart.
  - Kibana's dashboards will be saved in Elasticsearch.
  - Logstash only uses config files and does not have any states.
- **Just In Case**
  - If something goes wrong, you might need to bring down the services, rebuild the images and restart the containers. Just run
    ```console
    $ docker-compose down -v
    $ docker-compose build --no-cache
    $ docker-compose up
    ```

## Basic Configurations

- Specify versions of Elastic Stack (ELK) and MySQL in [`.env`][env]
- MySQL:
  - [`mysql/config/mysql.cnf`][config-mysql]
  - Save the config file as _read-only_ or else configurations will fail.
- Elasticsearch: [`elasticsearch/config/elasticsearch.yml`][config-es]
- Logstash: [`logstash/config/logstash.yml`][config-logstash]
- Kibana: [`kibana/config/kibana.yml`][config-kibana]
- Refer to [`docker-compose.yml`][docker-compose] for configurations like username, password, ports, etc.

## MySQL

- **Database Credentials**
  - Username: _system_
  - Password: _admin123_
- By default, `temp_db` and `temp_table`, which is populated with some dummy data, have been created.
- Write SQL scripts and store in [`mysql/sql`][mysql-sql] to initialize database with new tables and populate data into the tables.
- Initialization of MySQL only takes place during the fresh installation. If you want to change the default database or modify existing SQL scripts, you must remove the saved states and rebuild the MySQL image. To achieve this, run
  ```console
  $ docker volume rm docker-mysql-elk_mysql
  $ docker-compose build --no-cache mysql
  ```

## Elasticsearch

- **Login Credentials**
  - Username: _elastic_
  - Password: _changeme_
- `xpack.license.self_generated.type: basic` (in [`elasticsearch/config/elasticsearch.yml`][config-es])
  - By default, only basic X-Pack features are enabled.
  - Switch to `xpack.license.self_generated.type: trial` for paid features with a 30-day free trial.

## Logstash

- **Pipeline**
  - [`init_temp_table.conf`][logstash-init] is used to load existing data from MySQL to Elasticsearch. It is only run _once_.
  - [`sync_temp_table.conf`][logstash-sync] is used to sync newly inserted/updated data between MySQL and Elasticsearch. It is configured to run every 5 seconds. The sync frequency can be configured using cron syntax. See `schedule` settings in [`sync_temp_table.conf`][logstash-sync].
- When adding a new pipeline:
  - Write new config file and store it in [`logstash/pipeline/conf`][logstash-conf].
  - Write new SQL statement and store it in [`logstash/pipeline/sql`][logstash-sql]. Link the `.sql` file path to `statement_filepath` in your config file. See [`sync_temp_table.conf`][logstash-sync] for reference.
  - Remember to specify `pipeline.id` and `path.config` in [`logstash/pipeline/pipelines.yml`][logstash-pipelines].

## References

- [GitHub: Elastic stack (ELK) on Docker](https://github.com/deviantony/docker-elk)
- [Elastic: How to keep Elasticsearch synchronized with a relational database using Logstash and JDBC](https://www.elastic.co/blog/how-to-keep-elasticsearch-synchronized-with-a-relational-database-using-logstash)
- [Towards Data Science: How to synchronize Elasticsearch with MySQL](https://towardsdatascience.com/how-to-synchronize-elasticsearch-with-mysql-ed32fc57b339)
- [Docker Hub: MySQL configurations](https://hub.docker.com/_/mysql)
- [Elastic Docs: Install Elasticsearch with Docker](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
- [Elastic Docs: Configuring Logstash for Docker](https://www.elastic.co/guide/en/logstash/current/docker-config.html)
- [Elastic Docs: Install Kibana with Docker](https://www.elastic.co/guide/en/kibana/current/docker.html)

[docker-compose]: ./docker-compose.yml
[env]: ./.env
[config-es]: ./elasticsearch/config/elasticsearch.yml
[config-logstash]: ./logstash/config/logstash.yml
[config-kibana]: ./kibana/config/kibana.yml
[config-mysql]: ./mysql/config/mysql.cnf
[mysql-sql]: ./mysql/sql
[logstash-init]: ./logstash/pipeline/conf/init_temp_table.conf
[logstash-sync]: ./logstash/pipeline/conf/sync_temp_table.conf
[logstash-conf]: ./logstash/pipeline/conf
[logstash-sql]: ./logstash/pipeline/sql
[logstash-pipelines]: ./logstash/pipeline/pipelines.yml
