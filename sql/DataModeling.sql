/*==============================================================
  File      : DataModel.sql
  Project   : World Economic Indicators Analytics
  Purpose   : Build dimensional model
  Author    : Aadish Kumar
==============================================================*/

USE world_economic_indicators;

/*==============================================================
    DROP EXISTING WAREHOUSE TABLES
==============================================================*/

DROP TABLE IF EXISTS fact_country_year;
DROP TABLE IF EXISTS dim_country;

/*==============================================================
    CREATE DIMENSION TABLE : dim_country
==============================================================*/

CREATE TABLE dim_country
( country_key INT AUTO_INCREMENT PRIMARY KEY, country_code CHAR(3) NOT NULL, 
  country_name VARCHAR(150) NOT NULL, region VARCHAR(100),
  income_group VARCHAR(50), CONSTRAINT uq_dim_country_code UNIQUE (country_code) );

/*==============================================================
    POPULATE DIMENSION TABLE
==============================================================*/

INSERT INTO dim_country( country_code, country_name, region, income_group )
SELECT DISTINCT `Country Code`, `Country Name`, Region, IncomeGroup FROM stg_world_bank
WHERE `Country Code` IS NOT NULL ORDER BY `Country Name`;

/*==============================================================
    VALIDATION
==============================================================*/

-- Total countries
SELECT COUNT(*) AS total_countries
FROM dim_country;

-- Duplicate country codes
SELECT country_code, COUNT(*) AS duplicate_count
FROM dim_country GROUP BY country_code HAVING COUNT(*) > 1;

-- Preview
SELECT * FROM dim_country ORDER BY country_name LIMIT 10;
SELECT COUNT(*) FROM dim_country;

/*==============================================================
    CREATE FACT TABLE : fact_country_year
==============================================================*/

CREATE TABLE fact_country_year
(
    fact_key INT AUTO_INCREMENT PRIMARY KEY,

    country_key INT NOT NULL,
    year INT NOT NULL,

    -- World Bank Indicators
    birth_rate DOUBLE,
    death_rate DOUBLE,
    electric_power_consumption DOUBLE,
    gdp DOUBLE,
    gdp_per_capita DOUBLE,
    internet_users DOUBLE,
    infant_mortality DOUBLE,
    life_expectancy DOUBLE,
    population_density DOUBLE,
    unemployment DOUBLE,

    -- HDI Indicators
    hdi DOUBLE,
    hdi_rank DOUBLE,
    gii DOUBLE,
    gii_rank DOUBLE,
    ihdi DOUBLE,
    life_expectancy_hdi DOUBLE,
    expected_years_schooling DOUBLE,
    mean_years_schooling DOUBLE,
    gross_national_income_per_capita DOUBLE,

    CONSTRAINT fk_fact_country
        FOREIGN KEY (country_key)
        REFERENCES dim_country(country_key),

    CONSTRAINT uq_country_year
        UNIQUE(country_key, year)
);

DESCRIBE stg_world_bank;
DESCRIBE stg_hdi;

/*==============================================================
    POPULATE FACT TABLE
==============================================================*/

INSERT INTO fact_country_year
(
    country_key,
    year,

    birth_rate,
    death_rate,
    electric_power_consumption,
    gdp,
    gdp_per_capita,
    internet_users,
    infant_mortality,
    life_expectancy,
    population_density,
    unemployment,

    hdi,
    hdi_rank,
    gii,
    gii_rank,
    ihdi,
    life_expectancy_hdi,
    expected_years_schooling,
    mean_years_schooling,
    gross_national_income_per_capita
)
SELECT
    dc.country_key,
    wb.Year,
    wb.`Birth rate, crude (per 1,000 people)`,
    wb.`Death rate, crude (per 1,000 people)`,
    wb.`Electric power consumption (kWh per capita)`,
    wb.`GDP (USD)`,
    wb.`GDP per capita (USD)`,
    wb.`Individuals using the Internet (% of population)`,
    wb.`Infant mortality rate (per 1,000 live births)`,
    wb.`Life expectancy at birth (years)`,
    wb.`Population density (people per sq. km of land area)`,
    wb.`Unemployment (% of total labor force) (modeled ILO estimate)`,
    h.hdi,
    h.hdi_rank,
    h.gii,
    h.gii_rank,
    h.ihdi,
    h.le,
    h.eys,
    h.mys,
    h.gnipc
FROM stg_world_bank wb

INNER JOIN dim_country dc ON wb.`Country Code` = dc.country_code
LEFT JOIN stg_hdi h ON wb.`Country Code` = h.iso3 AND wb.Year = h.Year;

/*==============================================================
    VALIDATION : fact_country_year
==============================================================*/
-- Total rows
SELECT COUNT(*) AS total_rows FROM fact_country_year;
-- Year range
SELECT MIN(year) AS first_year, MAX(year) AS last_year FROM fact_country_year;
-- Distinct countries
SELECT COUNT(DISTINCT country_key) AS countries FROM fact_country_year;
-- Preview
SELECT * FROM fact_country_year LIMIT 10;

SELECT COUNT(*) AS total_rows FROM fact_country_year;
SELECT COUNT(DISTINCT country_key) AS total_countries FROM fact_country_year;
SELECT MIN(year) AS first_year, MAX(year) AS last_year FROM fact_country_year;
SELECT COUNT(*) AS missing_country_key FROM fact_country_year WHERE country_key IS NULL;