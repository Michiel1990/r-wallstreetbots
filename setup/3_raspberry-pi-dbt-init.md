### activate the dedicated dbt-core venv
source /home/michielsmulders/git-projects/r-wallstreetbots/dbt-core-venv/bin/activate

dbt init

### follow prompts
- postgresql connection
localhost
port 5432
credentials

### test
cd wallstreetbot_dbt
dbt debug