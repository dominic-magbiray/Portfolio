/*
We started by joining the columns to see every essential data for cleaning, transformation, exploration, and analysis.
The code below also is used to clean and transform the data within 2 decimal places.
We also used aggregate functions to show the data of every column properly.
To check all the states and join it with other needed columns for Data Exploration and Analysis using the column "state_usa"
as their point of connection.
Then we can just replace the "order by" function to check the highest and lowest of each and every data needed.
This code can also answer all the business questions because we can now compare every state and their given data.
*/

SELECT health_spending.state_usa,

	ROUND(SUM(research_development_spent),2) AS Research_Dev,
	ROUND (SUM(profit),2) 			AS profit,
	ROUND(SUM(marketing_spent),2)		AS marketing_spent,
	ROUND(SUM(population.estimate),2)	AS population, 
	ROUND(AVG(convictions_per_capita),2)	AS conviction_rate,
	ROUND(AVG(avg_spending),2)		AS health_spending,
	ROUND(AVG(avg_price) ,2)		AS avg_property_price,
	ROUND(AVG(average_income) ,2)		AS avg_state_income

FROM health_spending

	FULL JOIN population ON population.state_usa = health_spending.state_usa
	FULL JOIN corruption_convictions_per_capita ON corruption_convictions_per_capita.state_usa = health_spending.state_usa
	FULL JOIN competitors ON health_spending.state_usa = competitors.state_usa
	FULL JOIN property_prices ON health_spending.state_usa = property_prices.state_usa
	FULL JOIN state_income ON health_spending.state_usa = state_income.state_usa
	
GROUP BY health_spending.state_usa
ORDER BY avg_state_income DESC

/*Upon checking the states, we saw that there is a state that only have one value in it 
and it is the "District of Columbia" so we concluded that this is an outlier and does not
have an impact with our analysis so we deleted this state together with its data.
*/

DELETE FROM population
	WHERE state_usa = 'District of Columbia'


--DATA CLEANING, CHECKING FOR DUPLICATES, SPELLING CHECKS, AND CHECKING OF NULL VALUES

SELECT DISTINCT state_usa,
		estimate 
FROM population;

SELECT MAX(average_income) FROM state_income;
SELECT MIN(average_income) FROM state_income;

SELECT MAX(convictions_per_capita) FROM corruption_convictions_per_capita;
SELECT MIN(convictions_per_capita) FROM corruption_convictions_per_capita;

SELECT MAX(convictions_per_capita) FROM corruption_convictions_per_capita;
SELECT MIN(convictions_per_capita) FROM corruption_convictions_per_capita;

SELECT MAX(convictions_per_capita) FROM corruption_convictions_per_capita;
SELECT MIN(convictions_per_capita) FROM corruption_convictions_per_capita;



/*This code below transforms the income and corruption convictions per capita to a minimum 
of 2 decimal places and added a "%" sign for better readability. 
This code also answers the first business question for data analysis.
Using this code we can interchange the order by function to compare the columns.
*/

SELECT state_income.state_usa,

	CONCAT(ROUND(((average_income/(SELECT SUM(average_income) FROM state_income))*100),2),'%')as income_percentage,
	CONCAT(ROUND((convictions_per_capita/ (SELECT SUM(convictions_per_capita) FROM corruption_convictions_per_capita))*100,2),'%')as corruption_percentage

FROM state_income

	JOIN corruption_convictions_per_capita ON corruption_convictions_per_capita.state_usa = state_income.state_usa

ORDER BY income_percentage ASC