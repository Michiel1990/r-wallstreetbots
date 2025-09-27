#generate keypair locally
ssh-keygen -t ed25519 -C "my_email@icloud.com" -f ~/.ssh/macbook_github_key

#public key manually uploaded to https://github.com/settings/keys

#test key
ssh -i ~/.ssh/macbook_github_key -T git@github.com

#add key to agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/macbook_github_key

# new repo created on Github.com webinterface
# Clone the root project folder
cd /Users/akagi/Library/GitHub
git clone git@github.com:Michiel1990/r-wallstreetbots.git

# Create setup folder and its contents
touch readme.md
touch .gitignore
cd /Users/akagi/Library/GitHub/r-wallstreetbots
mkdir setup
touch setup/1_git-ssh-folder-setup.sh
touch setup/2_pi-setup.md
touch setup/3_pi-apt-packages.sh

# Create dags folder and DAG file
mkdir dags
touch dags/wallstreetbot.py

# Create python folder and scripts
mkdir python
touch python/ETL_stock_market_data.py

# Create r folder and scripts
mkdir r
touch r/kmeans_clustering.r

# Create dbt folder (later to be filled with dbt init command)
mkdir -p dbt
touch dbt/dbt_project.yml

# Create bi folder and dashboard files
mkdir bi
touch bi/dashboard_notes.md

# Create docs folder and documentation files
mkdir docs
touch docs/architecture_diagram.png
touch docs/ERD.dbml

# Stage and commit everything
git add .
git commit -m "Initial project structure for r/wallstreetbots project"
git push
