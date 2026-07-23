-- Question 01
WITH life_expectancy_2018 AS (
    SELECT
        country_key,
        life_expectancy,
        year,
        ROW_NUMBER() OVER (
            PARTITION BY country_key
            ORDER BY year DESC
        ) AS rn
    FROM fact_country_year
    WHERE year BETWEEN 2015 AND 2018
      AND life_expectancy IS NOT NULL
),

analysis AS (
    SELECT
        dc.country_name,
        dc.region,
        dc.income_group,

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

FROM analysis ORDER BY gdp_per_capita_growth_pct DESC;

-- ==========================================================
-- Business Query 02
-- Query 2: Top 10 Countries with the Largest HDI Gains (2000–2021)
-- ==========================================================

WITH analysis AS (
    SELECT
        dc.country_name,
        dc.region,
        dc.income_group,

        hdi2000.hdi AS hdi_2000,
        hdi2018.hdi AS hdi_2018

    FROM dim_country dc

    INNER JOIN fact_country_year hdi2000
        ON dc.country_key = hdi2000.country_key
       AND hdi2000.year = 2000
       AND hdi2000.hdi IS NOT NULL

    INNER JOIN fact_country_year hdi2018
        ON dc.country_key = hdi2018.country_key
       AND hdi2018.year = 2018
       AND hdi2018.hdi IS NOT NULL
)

SELECT

    country_name,
    region,
    income_group,

    ROUND(hdi_2000,3) AS hdi_2000,
    ROUND(hdi_2018,3) AS hdi_2018,

    ROUND(hdi_2018 - hdi_2000,3) AS hdi_gain

FROM analysis

ORDER BY hdi_gain DESC

LIMIT 10;

-- ==========================================================
-- Business Query 02
-- Query 3: Bottom 10 Countries with the Smallest HDI Gains (2000–2021)
-- ==========================================================

WITH analysis AS (
    SELECT
        dc.country_name,
        dc.region,
        dc.income_group,

        hdi2000.hdi AS hdi_2000,
        hdi2018.hdi AS hdi_2018

    FROM dim_country dc

    INNER JOIN fact_country_year hdi2000
        ON dc.country_key = hdi2000.country_key
       AND hdi2000.year = 2000
       AND hdi2000.hdi IS NOT NULL

    INNER JOIN fact_country_year hdi2018
        ON dc.country_key = hdi2018.country_key
       AND hdi2018.year = 2018
       AND hdi2018.hdi IS NOT NULL
)

SELECT

    country_name,
    region,
    income_group,

    ROUND(hdi_2000, 3) AS hdi_2000,
    ROUND(hdi_2018, 3) AS hdi_2018,

    ROUND(hdi_2018 - hdi_2000, 3) AS hdi_gain

FROM analysis

ORDER BY hdi_gain ASC

LIMIT 10;

-- ==========================================================
-- Business Query 02
-- Query 4: Average HDI Gain by Region (2000–2018)
-- ==========================================================

WITH analysis AS (
    SELECT
        dc.region,

        hdi2000.hdi AS hdi_2000,
        hdi2018.hdi AS hdi_2018

    FROM dim_country dc

    INNER JOIN fact_country_year hdi2000
        ON dc.country_key = hdi2000.country_key
       AND hdi2000.year = 2000
       AND hdi2000.hdi IS NOT NULL

    INNER JOIN fact_country_year hdi2018
        ON dc.country_key = hdi2018.country_key
       AND hdi2018.year = 2018
       AND hdi2018.hdi IS NOT NULL
)
SELECT region,
    COUNT(*) AS countries,
    ROUND(AVG(hdi_2000), 3) AS avg_hdi_2000,
    ROUND(AVG(hdi_2018), 3) AS avg_hdi_2018,
    ROUND(AVG(hdi_2018 - hdi_2000), 3) AS avg_hdi_gain

FROM analysis GROUP BY region ORDER BY avg_hdi_gain DESC;

-- ==========================================================
-- Business Query 02
-- Query 5: Average HDI Gain by Income Group (2000–2018)
-- ==========================================================

WITH analysis AS (
    SELECT
        dc.income_group,

        hdi2000.hdi AS hdi_2000,
        hdi2018.hdi AS hdi_2018

    FROM dim_country dc

    INNER JOIN fact_country_year hdi2000
        ON dc.country_key = hdi2000.country_key
       AND hdi2000.year = 2000
       AND hdi2000.hdi IS NOT NULL

    INNER JOIN fact_country_year hdi2018
        ON dc.country_key = hdi2018.country_key
       AND hdi2018.year = 2018
       AND hdi2018.hdi IS NOT NULL
)

SELECT

    income_group,

    COUNT(*) AS countries,

    ROUND(AVG(hdi_2000), 3) AS avg_hdi_2000,

    ROUND(AVG(hdi_2018), 3) AS avg_hdi_2018,

    ROUND(AVG(hdi_2018 - hdi_2000), 3) AS avg_hdi_gain

FROM analysis

GROUP BY income_group

ORDER BY avg_hdi_gain DESC;