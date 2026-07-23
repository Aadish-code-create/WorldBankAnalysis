-- Question 01
WITH life_expectancy_2018 AS (
    SELECT country_key, life_expectancy, year,
        ROW_NUMBER() OVER (PARTITION BY country_key ORDER BY year DESC) AS rn
    FROM fact_country_year WHERE year BETWEEN 2015 AND 2018 AND life_expectancy IS NOT NULL
),
analysis AS (
    SELECT dc.country_name, dc.region, dc.income_group, 
        gdp2000.gdp_per_capita AS gdp_pc_2000, 
        gdp2018.gdp_per_capita AS gdp_pc_2018,
        le2000.life_expectancy AS life_2000,
        le2018.life_expectancy AS life_latest,
        le2018.year AS life_latest_year

    FROM dim_country dc

    INNER JOIN fact_country_year gdp2000
        ON dc.country_key = gdp2000.country_key
       AND gdp2000.year = 2000
       AND gdp2000.gdp_per_capita IS NOT NULL

    INNER JOIN fact_country_year gdp2018
        ON dc.country_key = gdp2018.country_key
       AND gdp2018.year = 2018
       AND gdp2018.gdp_per_capita IS NOT NULL

    INNER JOIN fact_country_year le2000
        ON dc.country_key = le2000.country_key
       AND le2000.year = 2000
       AND le2000.life_expectancy IS NOT NULL

    INNER JOIN life_expectancy_2018 le2018
        ON dc.country_key = le2018.country_key
       AND le2018.rn = 1
)

SELECT

    country_name,
    region,
    income_group,

    ROUND(
        ((gdp_pc_2018 - gdp_pc_2000) /
        NULLIF(gdp_pc_2000,0)) * 100,
        2
    ) AS gdp_per_capita_growth_pct,

    ROUND(
        life_latest - life_2000,
        2
    ) AS life_expectancy_gain,

    life_latest_year

FROM analysis

ORDER BY
    gdp_per_capita_growth_pct DESC;
    
WITH analysis AS (
WITH life_expectancy_2018 AS (
    SELECT country_key, life_expectancy, year,
        ROW_NUMBER() OVER (PARTITION BY country_key ORDER BY year DESC) AS rn
    FROM fact_country_year WHERE year BETWEEN 2015 AND 2018 AND life_expectancy IS NOT NULL
),
analysis AS (
    SELECT dc.country_name, dc.region, dc.income_group, 
        gdp2000.gdp_per_capita AS gdp_pc_2000, 
        gdp2018.gdp_per_capita AS gdp_pc_2018,
        le2000.life_expectancy AS life_2000,
        le2018.life_expectancy AS life_latest,
        le2018.year AS life_latest_year

    FROM dim_country dc

    INNER JOIN fact_country_year gdp2000
        ON dc.country_key = gdp2000.country_key
       AND gdp2000.year = 2000
       AND gdp2000.gdp_per_capita IS NOT NULL

    INNER JOIN fact_country_year gdp2018
        ON dc.country_key = gdp2018.country_key
       AND gdp2018.year = 2018
       AND gdp2018.gdp_per_capita IS NOT NULL

    INNER JOIN fact_country_year le2000
        ON dc.country_key = le2000.country_key
       AND le2000.year = 2000
       AND le2000.life_expectancy IS NOT NULL

    INNER JOIN life_expectancy_2018 le2018
        ON dc.country_key = le2018.country_key
       AND le2018.rn = 1
)

SELECT

    country_name,
    region,
    income_group,

    ROUND(
        ((gdp_pc_2018 - gdp_pc_2000) /
        NULLIF(gdp_pc_2000,0)) * 100,
        2
    ) AS gdp_per_capita_growth_pct,

    ROUND(
        life_latest - life_2000,
        2
    ) AS life_expectancy_gain,

    life_latest_year

FROM analysis
)

SELECT
    COUNT(*) AS countries,
    ROUND(AVG(gdp_per_capita_growth_pct),2) AS avg_gdp_growth,
    ROUND(MIN(gdp_per_capita_growth_pct),2) AS min_gdp_growth,
    ROUND(MAX(gdp_per_capita_growth_pct),2) AS max_gdp_growth,

    ROUND(AVG(life_expectancy_gain),2) AS avg_life_gain,
    ROUND(MIN(life_expectancy_gain),2) AS min_life_gain,
    ROUND(MAX(life_expectancy_gain),2) AS max_life_gain
FROM analysis;

WITH analysis AS (

WITH life_expectancy_2018 AS (
    SELECT country_key, life_expectancy, year,
        ROW_NUMBER() OVER (PARTITION BY country_key ORDER BY year DESC) AS rn
    FROM fact_country_year WHERE year BETWEEN 2015 AND 2018 AND life_expectancy IS NOT NULL
),
analysis AS (
    SELECT dc.country_name, dc.region, dc.income_group, 
        gdp2000.gdp_per_capita AS gdp_pc_2000, 
        gdp2018.gdp_per_capita AS gdp_pc_2018,
        le2000.life_expectancy AS life_2000,
        le2018.life_expectancy AS life_latest,
        le2018.year AS life_latest_year

    FROM dim_country dc

    INNER JOIN fact_country_year gdp2000
        ON dc.country_key = gdp2000.country_key
       AND gdp2000.year = 2000
       AND gdp2000.gdp_per_capita IS NOT NULL

    INNER JOIN fact_country_year gdp2018
        ON dc.country_key = gdp2018.country_key
       AND gdp2018.year = 2018
       AND gdp2018.gdp_per_capita IS NOT NULL

    INNER JOIN fact_country_year le2000
        ON dc.country_key = le2000.country_key
       AND le2000.year = 2000
       AND le2000.life_expectancy IS NOT NULL

    INNER JOIN life_expectancy_2018 le2018
        ON dc.country_key = le2018.country_key
       AND le2018.rn = 1
)

SELECT

    country_name,
    region,
    income_group,

    ROUND(
        ((gdp_pc_2018 - gdp_pc_2000) /
        NULLIF(gdp_pc_2000,0)) * 100,
        2
    ) AS gdp_per_capita_growth_pct,

    ROUND(
        life_latest - life_2000,
        2
    ) AS life_expectancy_gain,

    life_latest_year

FROM analysis

)

SELECT
    country_name,
    gdp_per_capita_growth_pct,
    life_expectancy_gain
FROM analysis
ORDER BY gdp_per_capita_growth_pct DESC
LIMIT 10;

WITH analysis AS (

WITH life_expectancy_2018 AS (
    SELECT country_key, life_expectancy, year,
        ROW_NUMBER() OVER (PARTITION BY country_key ORDER BY year DESC) AS rn
    FROM fact_country_year WHERE year BETWEEN 2015 AND 2018 AND life_expectancy IS NOT NULL
),
analysis AS (
    SELECT dc.country_name, dc.region, dc.income_group, 
        gdp2000.gdp_per_capita AS gdp_pc_2000, 
        gdp2018.gdp_per_capita AS gdp_pc_2018,
        le2000.life_expectancy AS life_2000,
        le2018.life_expectancy AS life_latest,
        le2018.year AS life_latest_year

    FROM dim_country dc

    INNER JOIN fact_country_year gdp2000
        ON dc.country_key = gdp2000.country_key
       AND gdp2000.year = 2000
       AND gdp2000.gdp_per_capita IS NOT NULL

    INNER JOIN fact_country_year gdp2018
        ON dc.country_key = gdp2018.country_key
       AND gdp2018.year = 2018
       AND gdp2018.gdp_per_capita IS NOT NULL

    INNER JOIN fact_country_year le2000
        ON dc.country_key = le2000.country_key
       AND le2000.year = 2000
       AND le2000.life_expectancy IS NOT NULL

    INNER JOIN life_expectancy_2018 le2018
        ON dc.country_key = le2018.country_key
       AND le2018.rn = 1
)

SELECT

    country_name,
    region,
    income_group,

    ROUND(
        ((gdp_pc_2018 - gdp_pc_2000) /
        NULLIF(gdp_pc_2000,0)) * 100,
        2
    ) AS gdp_per_capita_growth_pct,

    ROUND(
        life_latest - life_2000,
        2
    ) AS life_expectancy_gain,

    life_latest_year

FROM analysis

)

SELECT
    country_name,
    gdp_per_capita_growth_pct,
    life_expectancy_gain
FROM analysis
ORDER BY gdp_per_capita_growth_pct ASC
LIMIT 10;

WITH analysis AS (

WITH life_expectancy_2018 AS (
    SELECT country_key, life_expectancy, year,
        ROW_NUMBER() OVER (PARTITION BY country_key ORDER BY year DESC) AS rn
    FROM fact_country_year WHERE year BETWEEN 2015 AND 2018 AND life_expectancy IS NOT NULL
),
analysis AS (
    SELECT dc.country_name, dc.region, dc.income_group, 
        gdp2000.gdp_per_capita AS gdp_pc_2000, 
        gdp2018.gdp_per_capita AS gdp_pc_2018,
        le2000.life_expectancy AS life_2000,
        le2018.life_expectancy AS life_latest,
        le2018.year AS life_latest_year

    FROM dim_country dc

    INNER JOIN fact_country_year gdp2000
        ON dc.country_key = gdp2000.country_key
       AND gdp2000.year = 2000
       AND gdp2000.gdp_per_capita IS NOT NULL

    INNER JOIN fact_country_year gdp2018
        ON dc.country_key = gdp2018.country_key
       AND gdp2018.year = 2018
       AND gdp2018.gdp_per_capita IS NOT NULL

    INNER JOIN fact_country_year le2000
        ON dc.country_key = le2000.country_key
       AND le2000.year = 2000
       AND le2000.life_expectancy IS NOT NULL

    INNER JOIN life_expectancy_2018 le2018
        ON dc.country_key = le2018.country_key
       AND le2018.rn = 1
)

SELECT

    country_name,
    region,
    income_group,

    ROUND(
        ((gdp_pc_2018 - gdp_pc_2000) /
        NULLIF(gdp_pc_2000,0)) * 100,
        2
    ) AS gdp_per_capita_growth_pct,

    ROUND(
        life_latest - life_2000,
        2
    ) AS life_expectancy_gain,

    life_latest_year

FROM analysis


)

SELECT
    income_group,
    COUNT(*) AS countries,
    ROUND(AVG(gdp_per_capita_growth_pct),2) AS avg_gdp_growth,
    ROUND(AVG(life_expectancy_gain),2) AS avg_life_gain
FROM analysis
GROUP BY income_group
ORDER BY avg_gdp_growth DESC;