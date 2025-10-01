# Project Definition
### Goal
The **goal** of this repository is to showcase several Data Engineering / ETL / Analytics skillsets by documenting as detailed a codebase as possible.
### Scope
In order to have a real-world/fun project the idea emerged for starting a first draft of a "millenial investment bot" that can help people of my generation secure financial independence in their retirement (who knows when *that* is going to happen for a 35 year old...).

Therefore the **scope** is an attempt to acquire 25 years of historical data, on which we can apply Data Science and see if we can come up with BUY recommendations with a longterm vision (no get-rich-quick shenanigans).
>`r-wallstreetbots` is a wink to the Reddit sub `r/wallstreetbets` which is filled with idiots who think they're the next Warren Buffet... so an appropiate repo name?
### Problem
The **problem** I was faced with was the free API key offered by AlphaVantage, which only allows 25 API calls per day. And there is no "bulk" endpoint available so each API call can only fetch data from one company. The main advantage is the absence of a time-limit, so one call for one ticker fetches all available historical data.
>note that this is not a "real" problem as anyone who really needs the data can just buy a 50$/month license that allows 75 API calls *per minute*
### Solution
The **solution** will be a daily (Air)flow that uses these 25 API calls per day to fetch small bits of data at a time. The available data would thereby grow over time, and the Data Science running on it should therefore also get noticaebly better over time.

# Project High Level Overview
The project will be a flow (orchestrated with **Airflow**) that will run daily the following steps:
1. **ETL-flow** using `python`
	1. API request to AlphaVantage
	2. fetch a list of all known publicly traded companies in the US (and their unique "tickers", e.g. Apple Inc. = `AAPL`)
	3. Export the data locally (`.csv`)
	4. Load the (same) data into a PostgreSQL database (hosted on the same local server; "the database" henceforth)
2. **data cleanup** using `dbt`
	1. Merge the list of tickers into the existing one
	2. Prepare a model with the 12 next best candidates for acquiring data (eg based on oldest IPO for most data)
3. **ETL-flow** using `python`
	1. Connect to the database, fetch the 12 candidates and store in a list
	2. Loop over the list to make API requests to AlphaVantage
	3. For each ticker fetch historical data on balance sheet as well as stock performance
	4. Store the data locally (`.csv`)
	5. Load the data into the database
4. Long term data **storage** using `AWSCLI` (*still to be developed*)
	- Upload all CSV files (ex steps 1.3 and 3.4) to an Amazon S3 Bucket, which will server as our **Bronze** layer or "data lake"
	>the local UNIX server is relatively small (64GB) and we wouldn't want to lose data should it fail
 	>we will be using the Medallion architecture for our DWH
5. **data cleanup** using `dbt`
	1. Clean and model the data into the **Silver** layer incrementally
		- Facts:
			- stock prices
		- Dims:
			- companies
			- balance sheets
			- generic date framework
	2. Calculate metrics and outputs in the **Gold** layer
		- the balance sheets will be used to calculate the evolution of "company health" over time
		- the stock prices will be used to track the evolution of "company value" over time
6. **Data Science** using `R` *(template ready to be applied)*
	1. use the k-means clustering algorithm to create "groups" of similar companies based on their "health" (balance sheet)
	2. track the progress across a time dimension:
		>which companies have improved/deteriorated the most?
7. **Visualisation** using `Power BI` (*still to be developed*)
	- bring everything together to hopefully show a couple of clear cases of companies who
		- have made the most progress improving their health over time
		- but where the stock price has performed the worst over time
	>This last visualisation step will by definition not be visible in the repo

# Project Architecture & Prerequisites
The following outlines the essential hardware and configuration requirements needed to start the Git project, focusing on a **Raspberry Pi 5** as the primary development environment accessed remotely.

## 1. Hardware
* **Raspberry Pi 5:** The core computing device for the project. It will be the server that runs our "bot".
* Henceforth always aliased as "**pi**" in filenames, code, etc.

## 2. Operating System & Access
* **OS:** **Raspberry Pi OS Lite (64-bit)**
    * This is a **Debian/UNIX-based** operating system.
    * **No Desktop GUI** is provided; it's a command-line-only environment.
* **Access:** **"Headless" Access via SSH**
    * Remote shell access is configured exclusively through the **SSH protocol**.
    * Authentication uses **SSH Key-Pairs** for enhanced security.
    * This allows me to steer the pi from my Macbook (M1 Air)

## 3. GitHub
#### Repository
* the repository (you're reading now) was created manually from the Github web interface.
#### SSH access
* **Macbook M1 Air:** An **encrypted SSH Key** is set up for local development and management. This allows me to use visual GUI tools when needed
* **Raspberry Pi 5:** A dedicated **SSH Key** is configured for operations directly from the device.

   >bash code for generating and using the SSH key pair:
   ```bash
   #generate keypair locally
   ssh-keygen -t ed25519 -C "my_email@icloud.com" -f ~/.ssh/my_key_name
       # --> public key manually uploaded to https://github.com/settings/keys
   
   #test key
   ssh -i ~/.ssh/my_key_name -T git@github.com
   
   #add key to agent
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/my_key_name
   ```

## 4. Acces to Public Stock Market data
A free API key to the AlphaVantage database has been requested here:
https://www.alphavantage.co/support/#api-key

This free key is limited to 25 requests per day. The main drawback is that there is no bulk-fetching of data (of example all companies on the Nasdaq), but it has to be requested ticker per ticker.

It does however allow fetching historical timeseries data of that one ticker in one request.

We will basically be fetching 3 types of data
- a list of available ticker symbols (eg Apple Inc. = `AAPL`)
- for a selection of tickers we fetch historical balance sheet states
- for a selection of tickers we fetch historical end-of-day stock performance

For each python script that needs the API key, a `.env` file is stored in the same directory.

(Obviously all `.env` files will be included in `.gitignore`)

Documentation on how to use the API here:
https://www.alphavantage.co/documentation/

## 5. AWS account
Obviously an AWS account need to be available with the proper billing enabled. For now we will only be using the S3 bucket storage.
> The 5GB free tier will be more than enough for now

# Project Future
It's highly in doubt the Project in it's current definition will result in actual meaningfull investment gains (maybe at some point I can add simulated Buys/Sells to dry-run how the portfolio would run).

To have truly valuable investment insights it would need the following upgrades:
- (much) more **data** for training and/or mining. So preferably start looking at Options trading (puts/calls) which is datasets orders of magnitude bigger than classic Stock trading (buys/sells)
- (much) more intelligent **Data Science**, involving true Machine Learning or LLM models
- out of the previous would follow the need for (much) better **infrastructure**:
	- Host Airflow in the Cloud (e.g. AWS)
	- Run all python/R code as cloud functions (e.g. Lambda)
	- Use blob storage as a true Data Lake (e.g. S3 Buckets)
	- dbt Cloud i/o Core (preferably Teams or Enterprise license)
	- Cloud based Database and CPU for OLAP (e.g. Snowflake)
	- Cloud based ML/AI capabilities (e.g. also Snowflake)
	- ...

May the Fork be with us!
