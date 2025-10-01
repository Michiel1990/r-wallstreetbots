# R
The basic installation can be done in the Terminal, no dedicated virtual environment is required.
>Run the following commands in a Bash Shell:
```bash
# installation
sudo apt install r-base

# open R shell as root user
sudo R
```
An additional PostgreSQL connection package is needed
>Run the following in the opened R shell
```R
# install RPostgres
install.packages("RPostgres")
```
Eventually the PostgreSQL db would be accessed as follows:
```R
library(DBI)
con <- dbConnect(RPostgres::Postgres(), dbname="raw", host="localhost", port=5432, user="loader", password="***")
df <- dbGetQuery(con, "SELECT * FROM public.access_test_dummy;")
```
<img width="1552" height="262" alt="image" src="https://github.com/user-attachments/assets/aabb51fc-670c-4131-9e2c-4f3917a2dfa8" />


All the main functions should be installed now:
- `read.csv()`
- `write.csv()`
- `data.frame()`
- `kmeans()`
- `dbConnect()`
- `dbGetQuery()`
- `...`