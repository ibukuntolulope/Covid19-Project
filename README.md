# Covid19-Project

This project is a collection of SQL queries and data analysis related to COVID-19 data. It aims to analyze COVID-19 statistics, including deaths, cases, vaccinations, and population data, and derive insights from the data. It performs various calculations and creates views to facilitate further analysis. The project includes the following major sections:

Filtering and Sorting Data: The project starts by selecting specific columns from a table named "coviddeaths" where the "continent" column is not null and orders the results based on certain columns.

Analyzing COVID-19 Cases and Deaths in States: It focuses on COVID-19 cases and deaths in locations containing the word "states" in their name, calculating death percentages and population percentages affected.

Analyzing Countries with High Infection Rates: It identifies countries with the highest infection rates compared to their populations.

Analyzing Countries with the Highest Death Counts: It identifies countries with the highest death counts per population.

Breakdown by Continent: It breaks down COVID-19 data by continent, including the continent with the highest death count per population.

Global COVID-19 Numbers: It presents global COVID-19 statistics, including total cases, total deaths, and death percentages.

Calculations without Date: Similar to the global numbers but without considering specific dates.

Using Common Table Expressions (CTE): The project demonstrates the use of CTEs to simplify complex queries and calculations.

Creating and Populating Temporary Tables: Temporary tables are created to store intermediate results, and data is inserted into these tables. The code also calculates the percentage of the population vaccinated.

Further Analysis: This section includes additional calculations and creates a view to store data for later visualizations.

Creating a View: A view named "PercentPopulationVaccinated" is created to store processed data for visualization purposes.

Selecting Data from View: The project concludes by selecting data from the created view.

This project serves as a comprehensive analysis of COVID-19 data using SQL queries and provides a structured workflow for analyzing and visualizing pandemic-related statistics.
