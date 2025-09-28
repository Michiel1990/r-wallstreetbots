# Raspberry Pi 5 git installation
The following shows how to install, setup and configure git on the Raspberry Pi. Note we have already created an empty repository as well as enabled SSH access for the Pi in `0_prerequisites.md`.
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
# sudo executes as root user
# -E preserves the venv which holds the SSH agent (the root user is not using the SSH keys)
sudo -E git clone git@github.com:Michiel1990/r-wallstreetbots.git

# avoid dubious ownership issues between root and user
git config --global --add safe.directory /home/michielsmulders/git-projects/r-wallstreetbots

# navigate to the new repo
cd /home/michielsmulders/git-projects/r-wallstreetbots

# Create setup folder and its contents
touch readme.md
touch .gitignore
mkdir setup
touch setup/1_raspberry-pi-git.md # PS the file eventually containing this code :-)

# Create dags folder and empty DAG file
mkdir dags
touch dags/wallstreetbot.py

# Create python folder and empty ETL script
mkdir python
touch python/ETL_stock_market_data.py

# Create r folder and empty kmeans clustering script
mkdir r
touch r/kmeans_clustering.r

# Create dbt folder and empty file
mkdir -p dbt
touch dbt/readme.md

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
