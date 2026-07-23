-- ==========================================================
-- Business Query 03
-- Query 1: Build Analysis Dataset (Latest Available Year: 2018)
-- ==========================================================

WITH analysis AS (
    SELECT
        dc.country_name,
        dc.region,
        dc.income_group,
        f.life_expectancy_hdi,
        f.gdp_per_capita,
        f.electric_power_consumption,
        f.internet_users,
        f.infant_mortality,
        f.unemployment,
        f.mean_years_schooling,
        f.expected_years_schooling,
        f.gross_national_income_per_capita

    FROM dim_country dc
    INNER JOIN fact_country_year f ON dc.country_key = f.country_key
    WHERE f.year = 2018

      AND f.life_expectancy_hdi IS NOT NULL
      AND f.gdp_per_capita IS NOT NULL
      AND f.mean_years_schooling IS NOT NULL
      AND f.expected_years_schooling IS NOT NULL
      AND f.gross_national_income_per_capita IS NOT NULL
)

SELECT * FROM analysis;

-- ==========================================================
-- Business Query 03
-- Query 2: Correlation Between Life Expectancy and Key Indicators
-- ==========================================================

WITH analysis AS (
    SELECT
        f.life_expectancy_hdi,
        f.gdp_per_capita,
        f.electric_power_consumption,
        f.internet_users,
        f.infant_mortality,
        f.unemployment,
        f.mean_years_schooling,
        f.expected_years_schooling,
        f.gross_national_income_per_capita

    FROM fact_country_year f

    WHERE f.year = 2018
      AND f.life_expectancy_hdi IS NOT NULL
)

-- GDP per Capita
SELECT
    'GDP per Capita' AS indicator,

    ROUND((COUNT(*) * SUM(life_expectancy_hdi * gdp_per_capita) - SUM(life_expectancy_hdi) * SUM(gdp_per_capita)) /
    SQRT((COUNT(*) * SUM(POW(life_expectancy_hdi,2)) - POW(SUM(life_expectancy_hdi),2)) *
        (COUNT(*) * SUM(POW(gdp_per_capita,2)) - POW(SUM(gdp_per_capita),2))),3) AS correlation

FROM analysis WHERE gdp_per_capita IS NOT NULL UNION ALL

-- Electricity Consumption
SELECT
    'Electric Power Consumption',

    ROUND((COUNT(*) * SUM(life_expectancy_hdi * electric_power_consumption) - SUM(life_expectancy_hdi) * SUM(electric_power_consumption)) /
    SQRT((COUNT(*) * SUM(POW(life_expectancy_hdi,2))- POW(SUM(life_expectancy_hdi),2)) *
        (COUNT(*) * SUM(POW(electric_power_consumption,2)) - POW(SUM(electric_power_consumption),2))),3)

FROM analysis WHERE electric_power_consumption IS NOT NULL UNION ALL

-- Internet Users
SELECT
    'Internet Users',

    ROUND((COUNT(*) * SUM(life_expectancy_hdi * internet_users) - SUM(life_expectancy_hdi) * SUM(internet_users)) /
    SQRT((COUNT(*) * SUM(POW(life_expectancy_hdi,2)) - POW(SUM(life_expectancy_hdi),2)) *
        (COUNT(*) * SUM(POW(internet_users,2)) - POW(SUM(internet_users),2))),3)

FROM analysis WHERE internet_users IS NOT NULL UNION ALL

-- Infant Mortality
SELECT
    'Infant Mortality',

    ROUND((COUNT(*) * SUM(life_expectancy_hdi * infant_mortality) - SUM(life_expectancy_hdi) * SUM(infant_mortality)) /
    SQRT((COUNT(*) * SUM(POW(life_expectancy_hdi,2)) - POW(SUM(life_expectancy_hdi),2)) *
        (COUNT(*) * SUM(POW(infant_mortality,2)) - POW(SUM(infant_mortality),2))),3)

FROM analysis WHERE infant_mortality IS NOT NULL UNION ALL

-- Mean Years of Schooling
SELECT
    'Mean Years Schooling',

    ROUND((COUNT(*) * SUM(life_expectancy_hdi * mean_years_schooling) - SUM(life_expectancy_hdi) * SUM(mean_years_schooling)) /
    SQRT((COUNT(*) * SUM(POW(life_expectancy_hdi,2)) - POW(SUM(life_expectancy_hdi),2)) *
        (COUNT(*) * SUM(POW(mean_years_schooling,2)) - POW(SUM(mean_years_schooling),2))),3)

FROM analysis WHERE mean_years_schooling IS NOT NULL UNION ALL

-- Expected Years of Schooling
SELECT
    'Expected Years Schooling',

    ROUND((COUNT(*) * SUM(life_expectancy_hdi * expected_years_schooling) 
    - SUM(life_expectancy_hdi) * SUM(expected_years_schooling)) /
    SQRT((COUNT(*) * SUM(POW(life_expectancy_hdi,2)) - POW(SUM(life_expectancy_hdi),2)) *
        (COUNT(*) * SUM(POW(expected_years_schooling,2)) - POW(SUM(expected_years_schooling),2))),3)

FROM analysis WHERE expected_years_schooling IS NOT NULL UNION ALL

-- Gross National Income
SELECT 'Gross National Income per Capita',
    ROUND((COUNT(*) * SUM(life_expectancy_hdi * gross_national_income_per_capita)
        - SUM(life_expectancy_hdi) * SUM(gross_national_income_per_capita)) /
    SQRT((COUNT(*) * SUM(POW(life_expectancy_hdi,2)) - POW(SUM(life_expectancy_hdi),2)) *
		(COUNT(*) * SUM(POW(gross_national_income_per_capita,2)) 
        - POW(SUM(gross_national_income_per_capita),2))),3)

FROM analysis WHERE gross_national_income_per_capita IS NOT NULL
ORDER BY correlation DESC;

-- ==========================================================
-- Business Query 03
-- Query 3: GDP per Capita vs Life Expectancy
-- Correlation by Income Group
-- ==========================================================

WITH analysis AS (

    SELECT dc.income_group, f.life_expectancy_hdi, f.gdp_per_capita

    FROM dim_country dc
    INNER JOIN fact_country_year f ON dc.country_key = f.country_key
    WHERE f.year = 2018 AND f.life_expectancy_hdi IS NOT NULL AND f.gdp_per_capita IS NOT NULL
)

SELECT income_group,
    ROUND(
        (COUNT(*) * SUM(life_expectancy_hdi * gdp_per_capita) - SUM(life_expectancy_hdi) * SUM(gdp_per_capita)) /
        SQRT((COUNT(*) * SUM(POW(life_expectancy_hdi,2)) - POW(SUM(life_expectancy_hdi),2)) *
            (COUNT(*) * SUM(POW(gdp_per_capita,2)) - POW(SUM(gdp_per_capita),2))) ,3) AS correlation
FROM analysis
GROUP BY income_group
ORDER BY income_group;
