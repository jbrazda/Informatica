# Install Mys sql server

First, install the MySQL server and client packages:

```shell
sudo apt-get install mysql-server mysql-client
```

Installer will ask you for root password
You need to set a root password, for starters. MySQL has it’s own user accounts, which are not related to the user accounts on your Linux machine.
By default, the root account of the MySQL Server is empty. You need to set it. Please replace ‘mypassword’ with your actual password and myhostname with your actual hostname.

This can be also done with a following commands

```shell
sudo mysqladmin -u root -h localhost password 'mypassword'
sudo mysqladmin -u root -h myhostname password 'mypassword'
```

## Install My SQL Workbench

Follow download instructions at [APT download](https://dev.mysql.com/downloads/repo/apt/)
First, install the MySQL APT repository as described in the MySQL APT Repository documentation. For example:

```shell
sudo dpkg -i mysql-apt-config_{version}.deb
sudo apt-get update
```

Next, install MySQL Workbench. You might have multiple Workbench packages available, so choose the "mysql-workbench-community" version. For example:

```shell
sudo apt-get install mysql-workbench-community
```

### Install MySQL JDBC drivers

```shell
sudo apt-get install mysql-connector-java
cp /usr/share/java/mysql-connector-java-8.0.11.jar agent_home_path/apps/process-engine/ext
```

## Create Database for ActiveVOS server

```shell
mysqladmin -u root -p create avosdb
```

### Connect with root

mysql -u root -p
password: 'secret_password'

### Create User

```sql
--GRANT usage ON *.* TO avosdba@localhost identified by 'password'
GRANT usage ON *.* TO avosdba@'%' identified by 'bpeladmin';
GRANT usage ON *.* TO bpeluser@'%' identified by 'bpel';
```

### Grant Permissions

```sql
GRANT ALL PRIVILEGES ON avosdb.* TO 'avosdba'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON avosdb.* TO 'bpeluser'@'%';
```

### Login as avosdba

```sql
use avosdb
run avos ddl scripts
mysql> \. /home/infabpm/ActiveVOS/Server/server-enterprise/jboss_config/ddls/ActiveBPEL_Enterprise-MySQL.sql
mysql> \. /home/infabpm/ActiveVOS/Server/server-enterprise/jboss_config/ddls/create_repository_MySQL.ddl
```

passwords:
System users
iclab...........: iclab

mysql
root............: sqlAdmin
avosdba.........: bpeladmin
bpeluser........: bpel

### JDBC Settings Demo DB

|            Parameter            |             Value             |
|---------------------------------|-------------------------------|
| Datasource Name                 | DS1                           |
| JNDI Path                       | jdbc/DS1                      |
| Driver Class                    | com.mysql.jdbc.Driver         |
| URL                             | jdbc:mysql://localhost/demodb |
| Username                        | demodb                        |
| Password                        | demodb                        |
| Initial Size                    | 1                             |
| Max Active                      | 100                           |
| Max Wait (ms)                   | -                             |
| Min Idle                        | 1                             |
| Default Transaction Isolation   | (default)                     |
| Pooling Statements              | yes                           |
| Min Evictable Idle Time (ms)    | -                             |
| Number Tests per Eviction Run   | -                             |
| Time Between Eviction Runs (ms) | -                             |
| Test on Borrow                  | yes                           |
| Test on Return                  | no                            |
| Test while Idle                 | no                            |
| Validation Query                | SELECT 1                      |
|                                 |                               |