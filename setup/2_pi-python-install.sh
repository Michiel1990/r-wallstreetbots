# python usually comes pre-installed for Raspberri Pi OS
python3 --version

# as a best practice we'll create a python venv in our project folder for all pip installs (make sure to add /python-venv to .gitignore)
python3 -m venv /home/michielsmulders/git-projects/r-wallstreetbots/python-venv

# to initate the python shell in the venv
#/home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/python

# to check the packages installed in the venv (should be almost none)
#/home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/pip3 list

# activate the venv
source /home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/activate

# required packages and installations
    # for using dataframes, etc.
    /home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/pip3 install pandas
    # for connecting to APIs
    /home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/pip3 install requests
    # for connecting to a local postgreSQL database
    /home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/pip3 install psycopg2-binary
    # the airflow installation
    mkdir /home/michielsmulders/git-projects/r-wallstreetbots/python-venv/airflow



    --break-system-packages