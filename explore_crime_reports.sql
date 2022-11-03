/*
   CITY OF AUSTIN: CRIME REPORTS
    
    - Skills used: CTE's, Window Functions, Aggregate Functions, Creating Views
    
    - Number of records: 672,579
    
    Questions:
    - What types of offenses happen the most?
    - What categories of crimes happen the most?
    - What time of day do most crimes happen?
    - Is there seasonality?
    - Are any types of crime on the rise?
    - What are the top 10 offenses per year?

*/


/* 
What type of offenses happen the most?
- Look at each year
*/

SELECT 
    YEAR(occurred_date),
    highest_offense_description,
    COUNT(highest_offense_description) AS num_of_offenses
FROM
    crime_reports
GROUP BY 1 , 2
ORDER BY 1 , 3 DESC;

-- Create a view for later use

CREATE VIEW yearly_offesne_counts AS
SELECT 
	YEAR(occurred_date) as yr,
    highest_offense_description,
    COUNT(highest_offense_description) AS num_of_offenses
FROM
    crime_reports
GROUP BY 1, 2
ORDER BY 1, 3 DESC
;

/* 
Categorize the offenses and determin what categories are most common and if there are any changes year to year
- Categories:
    - Crimes Against A Person: Crimes against a person are those that result in physical or mental harm to another person.
    - Crimes Against Property: Crimes against property typically involve interference with the property of another party. Burglary, larceny, robbery ...etc
    - Statutory Crimes: Three significant types of statutory crimes are alcohol related crimes, drug crimes, traffic offenses
    - Financial Crimes:  Financial crimes often involve deception or fraud for financial gain.
    - Inchoate Crime: Inchoate crimes refer to those crimes that were initiated but not completed, and acts that assist in the commission of another crime. 
    - Other
*/

-- STEP 1 Create a table that labels all the crimes with their respective categories.
-- Use REGEXP with Word list to group offenses into their caregories.  
-- STEP 2 Use table as CTE to count the categories by year.

WITH category_table AS
(SELECT 
	incident_number,
    highest_offense_description,
    occurred_date,
    CASE
		WHEN highest_offense_description REGEXP 'CRED CARD|GAMBLING|FORGERY|FRAUD|TAX|EMBEZZLEMENT|FRAUD|BRIBERY|DEBIT CARD|IDENTITY' THEN 'Financial'
        WHEN highest_offense_description REGEXP 'ABUSE|ASLT|ASSAULT|SODOMY|KIDNAPPING|SEXUAL|MURDER|HOMICIDE|SEX|FAMILY|HARASSMENT|INDECENCY|INCEST|INJURY|EXPLOITATION|FAMILY|RAPE|CHILD' THEN 'Crimes Against a Person'
        WHEN highest_offense_description REGEXP 'THEFT|BURGLARY|ARSON|BURG|TRESPASS|MISCHIEF|ROBBERY|GRAFFITI' THEN 'Crimes Against Property'
        WHEN highest_offense_description REGEXP 'NTOXICATED|INTOX|INTOXICATION|DRUG|CONTROLLED SUB|ALCOHOL|MARIJUANA|DWI|TOBACCO|POSS|POSS OF' THEN 'Statutory Crimes'
        WHEN highest_offense_description REGEXP 'CONSPIRACY|AIDING|ABETTING|ATTEMPT|SOLICITATION' THEN 'Inchoate Crimes'
	ELSE 'Other'
    END AS offense_category
FROM crime_reports)
SELECT 
	YEAR(occurred_date) AS yr,
    offense_category, 
    COUNT(offense_category) AS num_reports
FROM category_table
GROUP BY 1, 2
ORDER BY 1, 3 DESC
;


/*
What time of day do most reported crimes happen?
*/

SELECT 
    HOUR(occurred_date_time) AS hr,
    COUNT(*) AS total_reports,
    COUNT(*) / (SELECT 
            COUNT(*)
        FROM
            crime_reports) * 100 AS frequency_pct
FROM
    crime_reports
GROUP BY 1
ORDER BY 3 DESC;


/*
What day of the week do most reported crimes happen?
*/

SELECT 
    DAYOFWEEK(occurred_date_time) AS dow,
    COUNT(*) AS total_reports,
    COUNT(*) / (SELECT 
            COUNT(*)
        FROM
            crime_reports) * 100 AS frequency_pct
FROM
    crime_reports
GROUP BY 1
ORDER BY 3 DESC;


/*
What months do most reported crimes happen?
*/

SELECT 
    MONTH(occurred_date_time) AS mon,
    COUNT(*) AS total_reports,
    COUNT(*) / (SELECT 
            COUNT(*)
        FROM
            crime_reports) * 100 AS frequency_pct
FROM
    crime_reports
GROUP BY 1
ORDER BY 3 DESC;

/*
Are any offenses on the rise?
- Look at the percentage change in number of each offense from year to year
- YoY Change = Current Number - Previous Number / Previous Number
- Use window functions to get previous year values
*/

SELECT
	subq.yr,
    subq.highest_offense_description,
    subq.num_of_offenses,
    LAG(subq.num_of_offenses) OVER (PARTITION BY subq.highest_offense_description ORDER BY subq.yr) AS previous_yr_count,
    ((subq.num_of_offenses - LAG(subq.num_of_offenses) OVER (PARTITION BY subq.highest_offense_description ORDER BY subq.yr))/ LAG(subq.num_of_offenses) OVER (PARTITION BY subq.highest_offense_description ORDER BY subq.yr))*100 AS yoy_change_pct
FROM 
	(SELECT * FROM yearly_offesne_counts ORDER BY 2, 1) AS subq 
;

/*
What are the top 10 reported offenses for each year?
- Use RANK() function to rank each offense by year.
- Use as CTE then limit to a rank <= 10
*/
WITH offense_rank AS
(SELECT 
	yr,
    RANK() OVER (PARTITION BY yr ORDER BY num_of_offenses DESC ) AS offense_rank,
    highest_offense_description,
    num_of_offenses
FROM yearly_offesne_counts)
SELECT * 
FROM offense_rank
WHERE offense_rank <= 10
;
