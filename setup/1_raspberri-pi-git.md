# Raspberri Pi 5 git installation
The following shows how to install, setup and configure git on the Raspberri Pi. Note we have already created an empty repository as well as enabled SSH access for the Pi in `0_prerequisites.md`.
>Run the following commands in a Bash Shell:
```bash
# install and verify git
sudo apt update
sudo apt upgrade
sudo apt install git
git --version

# create a folder for git repositories/projects
cd /home/michielsmulders
sudo mkdir git-projects
cd /home/michielsmulders/git-projects

# Clone the root git project 
git clone git@github.com:Michiel1990/r-wallstreetbots.git
cd /home/michielsmulders/git-projects/r-wallstreetbots

# Create setup folder and its contents
touch readme.md
touch .gitignore
mkdir setup
touch setup/1_raspberri-pi-git.md # PS the file eventually containing this code :-)

# Create dags folder and empty DAG file
mkdir dags
touch dags/wallstreetbot.py

# Create python folder and empty ETL script
mkdir python
touch python/ETL_stock_market_data.py

# Create r folder and empty kmeans clustering script
mkdir r
touch r/kmeans_clustering.r

# Create dbt folder and empty config file
mkdir -p dbt
touch dbt/dbt_project.yml

# Create bi folder and empty file
mkdir bi
touch bi/dashboard_notes.md

# Create docs folder and empty documentation files
mkdir docs
touch docs/architecture_diagram.png
touch docs/ERD.dbml

# Stage and commit everything
git add .
git commit -m "Initial project structure for r/wallstreetbots project"
git push
```

Depending on where/which folder you are cloning the repository to, you might need root user privileges to execute most git commands. You can fix this by preceding every git command with `sudo -E `
- `sudo` executes as root user
- `-E` preserves the venv which holds the SSH agent (the root user is not using the SSH keys)

>Additionally the following was executed in a Bash Shell:
```bash
git config --global --add safe.directory /home/michielsmulders/git-projects/r-wallstreetbots
```
