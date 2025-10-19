from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

default_arguments = {
    "owner": "you",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="wallstreetbot",
    default_args=default_arguments,
    schedule_interval="0 9 * * *",
    start_date=datetime(2025, 10, 20),
    max_active_runs=1,
) as dag:

    update_local_git_repo = BashOperator(
        task_id="update_local_git_repo",
        bash_command=(
            # cd to the repo folder
            "cd /home/michielsmulders/git-projects/r-wallstreetbots && "
            # make sure the agent can SSH to github.com
            "(eval \"$(ssh-agent -s)\" && "
            "ssh-add /home/michielsmulders/.ssh/pi_github_key && "
            # pull the repo
            "git pull) "
            # append the logs if needed
            ">> /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/logs/update_local_git_repo.log 2>&1"
        ),
    )

    etl_listing_status = BashOperator(
        task_id="etl_listing_status",
        bash_command=(
            # activate the python venv
            "source /home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/activate && "
            # execute a python file
            "python3 /home/michielsmulders/git-projects/r-wallstreetbots/python/1_alphavantage-function-LISTING_STATUS.py "
            # append the logs if needed
            ">> /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/logs/etl_listing_status.log 2>&1"
        ),
    )

    dbt_companies = BashOperator(
        task_id="dbt_companies",
        bash_command=(
            # activate dbt venv
            "source /home/michielsmulders/git-projects/r-wallstreetbots/dbt-core-venv/bin/activate && "
            # cd to the project
            "cd /home/michielsmulders/git-projects/r-wallstreetbots/dbt/wallstreetbot_dbt && "
            # debug and build dim_companies
            "(dbt debug && dbt build --select dim_companies) "
            ">> /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/logs/dbt_companies.log 2>&1"
        ),
    )

    etl_time_series_daily = BashOperator(
        task_id="etl_time_series_daily",
        bash_command=(
            # activate the python venv
            "source /home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/activate && "
            # execute a python file
            "python3 /home/michielsmulders/git-projects/r-wallstreetbots/python/2_alphavantage-function-TIME_SERIES_DAILY.py "
            # append the logs if needed
            ">> /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/logs/etl_time_series_daily.log 2>&1"
        ),
    )

    etl_balance_sheet = BashOperator(
        task_id="etl_balance_sheet",
        bash_command=(
            # activate the python venv
            "source /home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/activate && "
            # execute a python file
            "python3 /home/michielsmulders/git-projects/r-wallstreetbots/python/3_alphavantage-function-BALANCE_SHEET.py "
            # append the logs if needed
            ">> /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/logs/etl_balance_sheet.log 2>&1"
        ),
    )

    dbt_silver_gold = BashOperator(
        task_id="dbt_silver_gold",
        bash_command=(
            # activate dbt venv
            "source /home/michielsmulders/git-projects/r-wallstreetbots/dbt-core-venv/bin/activate && "
            # cd to the project
            "cd /home/michielsmulders/git-projects/r-wallstreetbots/dbt/wallstreetbot_dbt && "
            # build silver/gold layer and generate docs
            "(dbt build --exclude dim_companies dbt_get_dates && dbt docs generate) "
            ">> /home/michielsmulders/git-projects/r-wallstreetbots/airflow-venv/logs/dbt_silver_gold.log 2>&1"
        ),
    )

    update_local_git_repo >> etl_listing_status >> dbt_companies >> etl_time_series_daily >> etl_balance_sheet >> dbt_silver_gold
