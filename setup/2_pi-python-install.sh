# python usually comes pre-installed for Raspberri Pi OS
python3 --version

# as a best practice we'll create virtual environments in our project folder for all further (python) installs 
# !! make sure each is added to .gitignore !!

# ETL/API
python3 -m venv /home/michielsmulders/git-projects/r-wallstreetbots/python-venv
source /home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/activate
    # for using dataframes, etc.
    pip3 install pandas
    # for connecting to APIs
    pip3 install requests
    # for connecting to a local postgreSQL database
    pip3 install psycopg2-binary
    # deactivate the python venv
    deactivate

# AIRFLOW
python3 -m venv /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv
source /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/bin/activate
    # where to store airflow config and metadata
    export AIRFLOW_HOME=~/airflow
    # Install Airflow using constraints
    AIRFLOW_VERSION=2.8.1
    PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1,2)"
    CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
    pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"
    # init
    airflow db init
    # create admin user for the web UI
    airflow users create \
    --username admin \
    --firstname Michiel \
    --lastname Smulders \
    --role Admin \
    --email smulders.michiel@icloud.com \
    --password airflow-web-UI
    # to start the webserver and scheduler
    airflow webserver --port 8080
    airflow scheduler
    # deactivate the airflow venv
    deactivate

# dbt core
python3 -m venv /home/michielsmulders/git-projects/r-wallstreetbots/dbt-core-venv
source /home/michielsmulders/git-projects/r-wallstreetbots/dbt-core-venv/bin/activate
    # install both dbt-core and the PostgreSQL adapter
    python -m pip install dbt-core dbt-postgres
    # move to the required dbt folder (where we will store all models) and init
    cd /home/michielsmulders/git-projects/r-wallstreetbots/dbt
    dbt init
    # deactivate the dbt venv
    deactivate