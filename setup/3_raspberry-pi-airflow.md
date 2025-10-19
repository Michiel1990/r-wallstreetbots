# Aitrflow
## Installation
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
source /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/bin/activate
airflow webserver --port 8080
airflow scheduler
```
