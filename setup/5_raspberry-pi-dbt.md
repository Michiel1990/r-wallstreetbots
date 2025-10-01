# dbt core
## Installation
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

## Initiation

### activate the dedicated dbt-core venv
>Run the following commands in a Bash Shell:
```bash
source /home/michielsmulders/git-projects/r-wallstreetbots/dbt-core-venv/bin/activate
cd /home/michielsmulders/git-projects/r-wallstreetbots/dbt
dbt init
```

#### follow prompts
- project name ("wallstreetbot_dbt")
- postgresql connection
- localhost
- port 5432
- credentials (postgreSQL "dev_dbt" user)

#### test
cd wallstreetbot_dbt

dbt debug

<img width="1202" height="675" alt="Screenshot 2025-09-28 at 11 53 12" src="https://github.com/user-attachments/assets/a3610278-9294-4670-ae9c-30c4eec61ca1" />

deactivate

#### remote VS code access
https://code.visualstudio.com/docs/remote/ssh
https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh

 --> used an older unencrypted ssh key pair as VS did not seem to promt me for the encryption...
<img width="736" height="364" alt="image" src="https://github.com/user-attachments/assets/3b85298d-f540-4751-a62b-4e7a13a5591d" />

<img width="1306" height="590" alt="image" src="https://github.com/user-attachments/assets/9855dc07-03b1-4872-9324-c715c8167b8c" />

<img width="1256" height="250" alt="image" src="https://github.com/user-attachments/assets/60e8460d-197f-4d6a-becf-4c0b052b23b3" />

<img width="2558" height="1446" alt="image" src="https://github.com/user-attachments/assets/2a12a7eb-459a-43df-ae4c-2f408979c0f1" />






