	1. Execute Python file a. 
		a. Connect to public stock market data API
		b. Load into Dataframe
		c. Write the data to the local database (of choice)
	2. Airflow SQL Sensor?
	3. Trigger dbt core build job to clean/stg
		a. clean up the raw stock market data on the local database (of choice) 
		b. Include EPS?
	4. Execute R file
		a. Fetch data from the local database (of choice)
		b. Perfom kmeans clustering
		c. Write the results to the local database (of choice)
	5. Trigger dbt core build job for silver layer
		a. that simulates the "purchase" and "sales" of "stocks", based on the output of the R kmeans clustering, and stores them in a table called "portfolio"
			i. Best "buy" would be
				1) Bad performance in last X days 
				2) Same cluster as Good performing 
				3) Low EPS
			ii. Sell would be
				1) Return reached
				2) EPS high
		b. Update the value of already exisiting "purchase" in the "portfolio" based on the available stock market data update
	6. Airflow PostgreSQL bash job for Postgress to export Silver layer (recent date) as CSV
	7. Airflow File Sensor operator to look for CSV
	8. Airflow AWSCLI bash command to upload to blob storage
	9. Trigger the BI tool to refresh the "portfolio" data to offer several insights into how it is going
