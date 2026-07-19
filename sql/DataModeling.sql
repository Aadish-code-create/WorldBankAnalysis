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