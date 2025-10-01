# Python
Python usually comes pre-installed for Raspberry Pi OS Lite (64 bit), which is something we can double-check
>Run the following commands in a Bash Shell:
```bash
python3 --version
```
As a best practice we'll create virtual environments in our project folder for all further (python) installs

**!! make sure each is added to .gitignore !!**

### ETL/API installations
Packages needed that are not standard python Library:
- for fetching environment variables (such as api keys) from a .env file:
  - `dotenv`/`load_dotenv`
- for making the API requests:
  - `requests`
- for storing tabular/CSV data in dataframes
  - `pandas`
- for outputting dataframes as csv in a folder location of choice:
  - `pathlib`/`Path`
  - `datetime`/`date`
- for connection engines to PostgreSQL
  - `psycopg2-binary`
  - `sqlalchemy`/`create_engine`
 
FYI we'll also be using standard python library such as `os`, `io` and `csv`.

>Run the following commands in a Bash Shell:
```bash
# create the dedicated general python virtual environment ("venv")
python3 -m venv /home/michielsmulders/git-projects/r-wallstreetbots/python-venv

# activate the venv
source /home/michielsmulders/git-projects/r-wallstreetbots/python-venv/bin/activate

# installe listed packages
pip3 install dotenv
pip3 install requests
pip3 install pandas
pip3 install pathlib
pip3 install datetime
pip3 install psycopg2-binary
pip3 install sqlalchemy

# deactivate the python venv
deactivate
```