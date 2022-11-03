# City of Austin, TX Crime Reports 2016 - 2022
## Using data from the City of Austin, TX, to explore and discover trends in reported crimes.

[Download Data](https://data.austintexas.gov/Public-Safety/Crime-Reports/fdj4-gpfu)

[View Tableau Dashboard](https://bit.ly/3DCHXJ9)

### Process:
1. Original download contained over 22 Million records. For this exploration, I decided to use only the last seven years. 
2. Prepared/Cleaned the data to make it ready to load into MYSQL Database.
    - Formatted date and datetime fields to work with MYSQL
    - Removed fields not needed for exploration.
3. Used a variety of queries and commands to explore the data further and find insights. [View MYSQL Queries](https://github.com/Scombes/Austin_crime_reports/blob/main/explore_crime_reports.sql)
4. Used query results to help create visuals in Tableau.

### Takeaways:
- Reported crimes are on a downward trend. In 2016 there were 107,054 reported crimes, while in 2021, that number dropped to 91,483.
- The most common reported offense is "Family Disturbance." Since 2016 there have been 69,469 reports. The next most reported crime is "Burglary of Vehicle," with 60,899 reports.
- Crimes Against Property is the most common type of offense.  It makes up 43.14% of all reported crimes.
- "Theft Catalytic Converter" has been a growing crime since 2021.  
- Most reported crimes happen around 12 AM and 12 PM. With the fewest at 5 AM in the morning.  

### Recommendations:
- Ensure that officers are adequately trained to handle "Family Disturbance" offenses. The City of Austin could look into using social workers in these instances.  
- To help combat burglaries of vehicles:
  - Increase surveillance in high-risk areas.
  - Educate citizens on how to prevent this crime. 
  - Warn citizens if they are in an area prone to this crime.
- Make sure that there are adequate police officers available during peak report times, 12 AM and 12 PM. The best time to schedule a shift change is at 5 AM. This is when the least amount of reports come in. 
- There needs to be increased police presence in the Downtown and the North Lamar Rundberg Neighborhoods. These two neighborhoods make up 11% of all reported crimes.

[View Tableau Dashboard](https://bit.ly/3DCHXJ9)
