# Applications required on the Raspberry Pi
## Main Python installation
Python usually comes pre-installed for Raspberry Pi OS Lite (64 bit), which is something we can double-check
>Run the following commands in a Bash Shell:
```bash
python3 --version
```
As a best practice we'll create virtual environments in our project folder for all further (python) installs

**!! make sure each is added to .gitignore !!**

## ETL/API installations
>Run the following commands in a Bash Shell:
```bash
# create the dedicated general python virtual environment ("venv")
python3 -m venv /home/michielsmulders/git-projects/r-wallstreetbots/python-venv

# activate the venv
source /home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/activate

#for using dataframes, etc.
pip3 install pandas

#for connecting to APIs
pip3 install requests

#for connecting to a local postgreSQL database
pip3 install psycopg2-binary

# deactivate the python venv
deactivate
```
## Airflow installation
>Run the following commands in a Bash Shell:
```bash
# create the dedicated Airflow virtual environment ("venv")
python3 -m venv /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv

# activate the venv
source /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/bin/activate

# prerequisite packages
sudo apt update
sudo apt install gcc python3-dev libffi-dev libpq-dev build-essential

# config where to store airflow config and metadata
mkdir /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/airflow_home
export AIRFLOW_HOME=/home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/airflow_home
echo 'export AIRFLOW_HOME=/home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/airflow_home' >> /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/bin/activate

# Install Airflow using constraints
AIRFLOW_VERSION=2.8.1
PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1,2)"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# initialize
airflow db init

# create admin user for the web UI
airflow users create \
--username admin \
--firstname Michiel \
--lastname Smulders \
--role Admin \
--email smulders.michiel@icloud.com \
--password ***

# deactivate the airflow venv
deactivate
```
>Afterwards you can start the webserver and/or scheduler in a Bash Shell:
```bash
# always activate airflow-venv first
source /home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/activate
airflow webserver --port 8080
airflow scheduler
```

## dbt core installation
>Run the following commands in a Bash Shell:
```bash
# create the dedicated dbt core virtual environment ("venv")
python3 -m venv /home/michielsmulders/git-projects/r-wallstreetbots/dbt-core-venv

# activate the venv
source /home/michielsmulders/git-projects/r-wallstreetbots/dbt-core-venv/bin/activate

# install both dbt-core and the PostgreSQL adapter
python -m pip install dbt-core dbt-postgres

# deactivate the dbt venv
deactivate
```

## PostgreSQL installation
The basic installation can be done in the Terminal, no dedicated virtual environment is required.

#### Updated locale
For some reason we get "locale" issues or warnings when installing PostgreSQL later on, therefore we configure it in advance
>Run the following commands in a Bash Shell:
```bash
sudo nano /etc/default/locale
# Make sure it contains:
# LANG="en_GB.UTF-8"
# LC_ALL="en_GB.UTF-8"
sudo locale-gen en_GB.UTF-8
sudo dpkg-reconfigure locales
# Select en_GB.UTF-8 UTF-8 in the list (spacebar to select).
source /etc/default/locale
sudo reboot
```

#### Main installation
>Run the following commands in a Bash Shell:
```bash
# install PostgreSQL
sudo apt install postgresql postgresql-contrib

# start and enable the service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# access postgres shell with postgresql role (authenticated through the system user)
sudo -i -u postgres
psql
```

#### PostgreSQL database configuration
>Run the following commands in the psql Shell:
```sql
# create the raw database and loading user (for storing raw stock market data)
CREATE DATABASE raw;
CREATE USER loader WITH ENCRYPTED PASSWORD '***';
GRANT ALL PRIVILEGES ON DATABASE raw TO LOADER;
ALTER DATABASE raw OWNER TO loader;

# create the DEV database and dbt development user
CREATE DATABASE dev;
CREATE USER dbt_dev WITH ENCRYPTED PASSWORD '***';
GRANT ALL PRIVILEGES ON DATABASE DEV TO dbt_dev;
ALTER DATABASE dev OWNER TO dbt_dev;

# create the PRD database and dbt production user
CREATE DATABASE prd;
CREATE USER dbt_prd WITH ENCRYPTED PASSWORD '***';
GRANT ALL PRIVILEGES ON DATABASE prd TO dbt_prd;
ALTER DATABASE prd OWNER TO dbt_prd;

# check the port (to be used later for remote access)
show PORT;

# switch back to Bash Shell
exit
```
Finally we want to enable remote access for other devices within the same LAN. As the Raspberry Pi itself does not have a desktop environment, being able to connect to the database through for example Dbeaver would speed up the execution and development of SQL code.
>Run the following commands in a Bash Shell:
```bash
# make sure another device can access the database over LAN
sudo nano /etc/postgresql/15/main/pg_hba.conf
# --> add the following line under IPv4 and save the file
# host    all             all             <you_subnet_IP>            md5

# enable the PostgreSQL db to listen to incoming LAN connections
sudo nano /etc/postgresql/15/main/postgresql.conf
# --> change the line to "listen_addresses = '*'"
```

#### PS1
Here some screenshots to show how you would connect to the database using Dbeaver (with JDBC driver installed), as well as the SSH keys defined earlier.

<img width="803" height="507" alt="Screenshot 2025-09-28 at 11 11 49" src="https://github.com/user-attachments/assets/510282f8-db30-4504-876b-a8bc9af5ba16" />

<img width="1045" height="699" alt="Screenshot 2025-09-28 at 11 09 11" src="https://github.com/user-attachments/assets/5a246cae-f1ea-42d5-b1e6-3a7341fb3e42" />

<img width="1042" height="702" alt="Screenshot 2025-09-28 at 11 04 52" src="https://github.com/user-attachments/assets/6d2420cd-cb85-4d42-93b1-5ad2dd2cc88c" />

<img width="357" height="187" alt="image" src="https://github.com/user-attachments/assets/bd336bc3-fbb2-418a-b7ee-b68eaddb6ef6" />

#### PS2
Included here are some usefull commands to be executed within a psql shell:
```sql
# check current user
SELECT current_user;

# check session user
SELECT session_user;

# list users and roles
\du

# list all databases
\l

# list all roles
SELECT * FROM pg_roles;

# reset passwords
ALTER USER postgres WITH PASSWORD 'your_new_password';

# exit pgsql shell
\q
```
## R installation
The basic installation can be done in the Terminal, no dedicated virtual environment is required.
>Run the following commands in a Bash Shell:
```bash
# installation
sudo apt install r-base

# open R shell as root user
sudo R
```
An additional PostgreSQL connection package is needed
>Run the following in the opened R shell
```R
# install RPostgres
install.packages("RPostgres")
```
Eventually the PostgreSQL db would be accessed as follows:
```R
library(DBI)
con <- dbConnect(RPostgres::Postgres(), dbname="raw", host="localhost", port=5432, user="loader", password="***")
df <- dbGetQuery(con, "SELECT * FROM public.access_test_dummy;")
```
<img width="1552" height="262" alt="image" src="https://github.com/user-attachments/assets/aabb51fc-670c-4131-9e2c-4f3917a2dfa8" />


All the main functions should be installed now:
- `read.csv()`
- `write.csv()`
- `data.frame()`
- `kmeans()`
- `dbConnect()`
- `dbGetQuery()`
- `...`

## AWSCLI installation
The basic installation can be done in the Terminal, no dedicated virtual environment is required.
>Run the following commands in a Bash Shell:
```bash
# Install AWS CLI v2 (Latest Version)
sudo apt install unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# check the installation
/usr/local/bin/aws --version
```
