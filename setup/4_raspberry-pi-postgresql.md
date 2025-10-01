# PostgreSQL
The basic installation can be done in the Terminal, no dedicated virtual environment is required.

### Updated locale
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

### Main installation
>Run the following commands in a Bash Shell:
```bash
# install PostgreSQL
sudo apt install postgresql postgresql-contrib

# start and enable the service
sudo systemctl start postgresql
sudo systemctl enable postgresql
#sudo systemctl status postgresql
#sudo systemctl restart postgresql

# access postgres shell with postgresql role (authenticated through the system user)
sudo -i -u postgres
psql
```

### database configuration
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

# Switch to the loader role and create schema in raw
SET ROLE loader;
\c raw
CREATE SCHEMA alphavatage;

# Switch to the dbt_dev role and create schemas in dev
SET ROLE dbt_dev;
\c dev
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

# Switch to the dbt_prd role and create schemas in prd
SET ROLE dbt_prd;
\c prd
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

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
# make sure the IP end with eg /32!

# enable the PostgreSQL db to listen to incoming LAN connections
sudo nano /etc/postgresql/15/main/postgresql.conf
# --> change the line to "listen_addresses = '*'"
```

### PS1
Here some screenshots to show how you would connect to the database using Dbeaver (with JDBC driver installed), as well as the SSH keys defined earlier.

<img width="803" height="507" alt="Screenshot 2025-09-28 at 11 11 49" src="https://github.com/user-attachments/assets/510282f8-db30-4504-876b-a8bc9af5ba16" />

<img width="1045" height="699" alt="Screenshot 2025-09-28 at 11 09 11" src="https://github.com/user-attachments/assets/5a246cae-f1ea-42d5-b1e6-3a7341fb3e42" />

<img width="1042" height="702" alt="Screenshot 2025-09-28 at 11 04 52" src="https://github.com/user-attachments/assets/6d2420cd-cb85-4d42-93b1-5ad2dd2cc88c" />

<img width="357" height="187" alt="image" src="https://github.com/user-attachments/assets/bd336bc3-fbb2-418a-b7ee-b68eaddb6ef6" />

### PS2
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