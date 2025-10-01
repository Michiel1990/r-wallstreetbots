# AWS CLI
The basic installation can be done in the Terminal, no dedicated virtual environment is required.
>Run the following commands in a Bash Shell:
```bash
# Install AWS CLI v2 (Latest Version)
sudo apt install unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# check the installation
/usr/local/bin/aws --version
```