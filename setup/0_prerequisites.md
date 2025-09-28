# Project Prerequisites
This document outlines the essential hardware and configuration requirements needed to start the Git project, focusing on a **Raspberry Pi 5** as the primary development environment accessed remotely.

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
### SSH access
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
### Repository
* a new repository was created manually from the Github web interface

## 4. Local File storage
* later in the proces we will be exporting data as CSV files, to be uploaded to an Amazon S3 bucket, and finally consumed for any BI or analysis application.

   >bash code for folder structure
   ```bash
   cd /home/michielsmulders
   mkdir data
   cd data
   mkdir csv_exports
   # final folder path /home/michielsmulders/data/csv_exports
   ```
## 5. Updated locale
* we want to avoid "locale" issues or warnings when installing PostgreSQL later on, therefore we configure it in advance

   >bash code locale config
   ```bash
   sudo nano /etc/default/locale
   # Make sure it contains:
   # LANG="en_GB.UTF-8"
   # LC_ALL="en_GB.UTF-8"
   sudo locale-gen en_GB.UTF-8
   sudo dpkg-reconfigure locales
   # Select en_GB.UTF-8 UTF-8 in the list (spacebar to select).
   source /etc/default/locale
   sudo reboot
   ```

## 6. Acces to Public Stock Market data
A free API key to the AlphaVantage database has been requested here:
https://www.alphavantage.co/support/#api-key

This free key is limited to 25 requests per day. The main drawback is that there is no bulk-fetching of data (of example all companies on the Nasdaq), but it has to be requested ticker per ticker.

It does however allow fetching historical timeseries data of that one ticker in one request.

We will basically be fetching 3 types of data
- a list of available ticker symbols (eg Apple Inc. = `AAPL`)
- for a selection of tickers we fetch generic company data
- for a selection of tickers we fetch historical eod stock performance

For each python script that needs the key, a `.env` file is stored in the same directory.

(Obviously all `.env` files will be included in `.gitignore`)

Documentation on how to use the API here:
https://www.alphavantage.co/documentation/

## 7. AWS account
