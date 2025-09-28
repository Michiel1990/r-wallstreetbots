### activate the dedicated dbt-core venv
source /home/michielsmulders/git-projects/r-wallstreetbots/dbt-core-venv/bin/activate
cd /home/michielsmulders/git-projects/r-wallstreetbots/dbt
dbt init

### follow prompts
- project name ("wallstreetbot_dbt")
- postgresql connection
- localhost
- port 5432
- credentials (postgreSQL "dev_dbt" user)

### test
cd wallstreetbot_dbt

dbt debug

<img width="1202" height="675" alt="Screenshot 2025-09-28 at 11 53 12" src="https://github.com/user-attachments/assets/a3610278-9294-4670-ae9c-30c4eec61ca1" />

deactivate


