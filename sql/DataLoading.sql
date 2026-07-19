/*==============================================================
  Stage 3 : Staging Layer
  Project : World Economic Indicators
  Database: world_economic_indicators
==============================================================*/

USE world_economic_indicators;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS stg_world_bank;
DROP TABLE IF EXISTS stg_hdi;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- Create World Bank Staging Table
-- ============================================================

CREATE TABLE stg_world_bank
(
    `Country Name` VARCHAR(150),
    `Country Code` CHAR(3),
    `Region` VARCHAR(100),
    `IncomeGroup` VARCHAR(50),
    `Year` SMALLINT,

    `Birth rate, crude (per 1,000 people)` DOUBLE,
    `Death rate, crude (per 1,000 people)` DOUBLE,
    `Electric power consumption (kWh per capita)` DOUBLE,
    `GDP (USD)` DOUBLE,
    `GDP per capita (USD)` DOUBLE,
    `Individuals using the Internet (% of population)` DOUBLE,
    `Infant mortality rate (per 1,000 live births)` DOUBLE,
    `Life expectancy at birth (years)` DOUBLE,
    `Population density (people per sq. km of land area)` DOUBLE,
    `Unemployment (% of total labor force) (modeled ILO estimate)` DOUBLE
);

-- ============================================================
-- Create HDI Staging Table
-- ============================================================

CREATE TABLE stg_hdi
(
    iso3 CHAR(3),
    country VARCHAR(150),
    Year SMALLINT,

    abr DOUBLE,
    co2_prod DOUBLE,
    coef_ineq DOUBLE,
    diff_hdi_phdi DOUBLE,
    eys DOUBLE,
    eys_f DOUBLE,
    eys_m DOUBLE,
    gdi DOUBLE,
    gdi_group DOUBLE,
    gii DOUBLE,
    gii_rank DOUBLE,
    gni_pc_f DOUBLE,
    gni_pc_m DOUBLE,
    gnipc DOUBLE,
    hdi DOUBLE,
    hdi_f DOUBLE,
    hdi_m DOUBLE,
    hdi_rank DOUBLE,
    ihdi DOUBLE,
    ineq_edu DOUBLE,
    ineq_inc DOUBLE,
    ineq_le DOUBLE,
    le DOUBLE,
    le_f DOUBLE,
    le_m DOUBLE,
    lfpr_f DOUBLE,
    lfpr_m DOUBLE,
    loss DOUBLE,
    mf DOUBLE,
    mmr DOUBLE,
    mys DOUBLE,
    mys_f DOUBLE,
    mys_m DOUBLE,
    phdi DOUBLE,
    pr_f DOUBLE,
    pr_m DOUBLE,
    rankdiff_hdi_phdi DOUBLE,
    se_f DOUBLE,
    se_m DOUBLE
);

-- ============================================================
-- Load World Bank CSV
-- ============================================================

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/world_bank_clean.csv'
INTO TABLE stg_world_bank
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
`Country Name`,
`Country Code`,
`Region`,
`IncomeGroup`,
`Year`,
@BirthRate,
@DeathRate,
@ElectricPower,
@GDP,
@GDPPerCapita,
@InternetUsers,
@InfantMortality,
@LifeExpectancy,
@PopulationDensity,
@Unemployment
)
SET
`Birth rate, crude (per 1,000 people)` = NULLIF(@BirthRate,''),
`Death rate, crude (per 1,000 people)` = NULLIF(@DeathRate,''),
`Electric power consumption (kWh per capita)` = NULLIF(@ElectricPower,''),
`GDP (USD)` = NULLIF(@GDP,''),
`GDP per capita (USD)` = NULLIF(@GDPPerCapita,''),
`Individuals using the Internet (% of population)` = NULLIF(@InternetUsers,''),
`Infant mortality rate (per 1,000 live births)` = NULLIF(@InfantMortality,''),
`Life expectancy at birth (years)` = NULLIF(@LifeExpectancy,''),
`Population density (people per sq. km of land area)` = NULLIF(@PopulationDensity,''),
`Unemployment (% of total labor force) (modeled ILO estimate)` = NULLIF(@Unemployment,'');

-- ============================================================
-- Load HDI CSV
-- ============================================================

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hdi_clean.csv'
INTO TABLE stg_hdi
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
iso3,
country,
Year,
@abr,
@co2_prod,
@coef_ineq,
@diff_hdi_phdi,
@eys,
@eys_f,
@eys_m,
@gdi,
@gdi_group,
@gii,
@gii_rank,
@gni_pc_f,
@gni_pc_m,
@gnipc,
@hdi,
@hdi_f,
@hdi_m,
@hdi_rank,
@ihdi,
@ineq_edu,
@ineq_inc,
@ineq_le,
@le,
@le_f,
@le_m,
@lfpr_f,
@lfpr_m,
@loss,
@mf,
@mmr,
@mys,
@mys_f,
@mys_m,
@phdi,
@pr_f,
@pr_m,
@rankdiff_hdi_phdi,
@se_f,
@se_m
)
SET
abr = NULLIF(@abr,''),
co2_prod = NULLIF(@co2_prod,''),
coef_ineq = NULLIF(@coef_ineq,''),
diff_hdi_phdi = NULLIF(@diff_hdi_phdi,''),
eys = NULLIF(@eys,''),
eys_f = NULLIF(@eys_f,''),
eys_m = NULLIF(@eys_m,''),
gdi = NULLIF(@gdi,''),
gdi_group = NULLIF(@gdi_group,''),
gii = NULLIF(@gii,''),
gii_rank = NULLIF(@gii_rank,''),
gni_pc_f = NULLIF(@gni_pc_f,''),
gni_pc_m = NULLIF(@gni_pc_m,''),
gnipc = NULLIF(@gnipc,''),
hdi = NULLIF(@hdi,''),
hdi_f = NULLIF(@hdi_f,''),
hdi_m = NULLIF(@hdi_m,''),
hdi_rank = NULLIF(@hdi_rank,''),
ihdi = NULLIF(@ihdi,''),
ineq_edu = NULLIF(@ineq_edu,''),
ineq_inc = NULLIF(@ineq_inc,''),
ineq_le = NULLIF(@ineq_le,''),
le = NULLIF(@le,''),
le_f = NULLIF(@le_f,''),
le_m = NULLIF(@le_m,''),
lfpr_f = NULLIF(@lfpr_f,''),
lfpr_m = NULLIF(@lfpr_m,''),
loss = NULLIF(@loss,''),
mf = NULLIF(@mf,''),
mmr = NULLIF(@mmr,''),
mys = NULLIF(@mys,''),
mys_f = NULLIF(@mys_f,''),
mys_m = NULLIF(@mys_m,''),
phdi = NULLIF(@phdi,''),
pr_f = NULLIF(@pr_f,''),
pr_m = NULLIF(@pr_m,''),
rankdiff_hdi_phdi = NULLIF(@rankdiff_hdi_phdi,''),
se_f = NULLIF(@se_f,''),
se_m = NULLIF(@se_m,'');

-- ============================================================
-- Validation
-- ============================================================

SELECT COUNT(*) AS world_bank_rows
FROM stg_world_bank;

SELECT COUNT(*) AS hdi_rows
FROM stg_hdi;

SELECT
    MIN(Year) AS min_year,
    MAX(Year) AS max_year
FROM stg_world_bank;

SELECT
    MIN(Year) AS min_year,
    MAX(Year) AS max_year
FROM stg_hdi;

SELECT COUNT(*) AS world_bank_rows FROM stg_world_bank;
SELECT COUNT(*) AS hdi_rows FROM stg_hdi;
SELECT COUNT(DISTINCT `Country Code`) FROM stg_world_bank;
SELECT MIN(Year), MAX(Year), COUNT(DISTINCT iso3) FROM stg_hdi;