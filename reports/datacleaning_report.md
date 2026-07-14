# World Economic Indicators Analysis

## Stage 2: Data Cleaning & Standardization Report

------------------------------------------------------------------------

# Executive Summary

This report documents the data cleaning and standardization performed on
the **World Bank** and **Human Development Index (HDI)** datasets for
the **World Economic Indicators Analysis** project.

The objective of this stage was to transform the raw datasets into a
clean, standardized, and **lossless** format suitable for SQL analysis
and visualization. Throughout this stage, no analytical variables were
removed to preserve the original information and maintain flexibility
for future analysis.

The cleaning process included:

-   Relationship assessment
-   Reshaping the HDI dataset (Wide → Long)
-   Splitting `Indicator_Year` into `Indicator` and `Year`
-   Pivoting the HDI dataset to a Country--Year analytical grain
-   Validation after every major transformation
-   Country identifier (ISO3) validation
-   Missing value assessment and strategy
-   Export of cleaned datasets

The result is two standardized datasets aligned to the same
**Country--Year** grain, making them ready for SQL-based analysis and
dashboard development.

------------------------------------------------------------------------

# Dataset Overview

  Dataset               Rows   Columns Structure
  ----------------- -------- --------- ---------------
  World Bank          12,449        15 Wide Format
  HDI                  6,240        42 Country--Year
  Data Dictionary         58         3 Metadata

------------------------------------------------------------------------

# Dataset Structure

## World Bank Dataset

-   **Rows:** 12,449
-   **Columns:** 15
-   **Analytical Grain:** Country--Year
-   **Data Types**
    -   String: 4
    -   Integer: 1
    -   Float: 10

------------------------------------------------------------------------

## HDI Dataset

-   **Rows:** 6,240
-   **Columns:** 42
-   **Analytical Grain:** Country--Year
-   **Data Types**
    -   String: 2
    -   Integer (Nullable): 1
    -   Float: 39

------------------------------------------------------------------------

# Transformations Performed

1.  Assessed the relationship and grain of both datasets.
2.  Converted the HDI dataset from **Wide** to **Long** format.
3.  Split the combined `Indicator_Year` column into separate `Indicator`
    and `Year` fields.
4.  Pivoted the HDI dataset back to a standardized **Country--Year**
    structure.
5.  Validated every major transformation by checking:
    -   Dataset shape
    -   Unique country identifiers
    -   Data grain
    -   Missing values
6.  Removed aggregate HDI records (e.g., World, South Asia, Very High
    Human Development) while preserving all country-level observations.
7.  Compared ISO3 country codes between datasets and documented dataset
    coverage differences.
8.  Defined a missing value strategy.
9.  Exported cleaned datasets for downstream analysis.

------------------------------------------------------------------------

# Missing Value Assessment

## World Bank Dataset

### Key Observations

-   Internet Usage, Electricity Consumption, and Unemployment contain
    more than **50%** missing values.
-   GDP and GDP per capita contain approximately **23%** missing values.
-   Identifier fields (**Country Name, Country Code, Region,
    IncomeGroup, Year**) contain **0%** missing values and are suitable
    for joining.

### Decision

No columns were removed or imputed during this stage. Missing values
will be handled according to the requirements of each analysis rather
than applying a global imputation strategy.

------------------------------------------------------------------------

## HDI Dataset

### Key Observations

-   The highest missingness occurs in derived ranking and inequality
    indicators.
-   Core analytical variables such as **HDI**, **Life Expectancy**,
    **Mean Years of Schooling**, **Expected Years of Schooling**, and
    **GNI per Capita** retain sufficient coverage for downstream
    analysis.

### Decision

No variables were removed based solely on missing values. All analytical
variables were retained to preserve the completeness of the master
dataset.

------------------------------------------------------------------------

# Validation Summary

The cleaned datasets were validated after each major transformation.

Validation checks included:

-   Dataset shape
-   Country--Year analytical grain
-   Unique ISO3 identifiers
-   Data types
-   Missing values
-   Country coverage

All validation checks passed successfully.

------------------------------------------------------------------------

# Final Output

The following cleaned datasets were generated:

``` text
data/
└── processed/
    ├── world_bank_clean.csv
    └── hdi_clean.csv
```

These datasets are ready for import into **MySQL Workbench** for SQL
analysis.

------------------------------------------------------------------------

# Conclusion

Stage 2 successfully transformed the raw datasets into standardized
analytical datasets while preserving all original information.

Key outcomes include:

-   Standardized both datasets to a common Country--Year analytical
    grain.
-   Removed aggregate HDI records while preserving country-level
    observations.
-   Validated ISO3 country identifiers before integration.
-   Documented a missing value strategy without unnecessary imputation.
-   Exported cleaned datasets for SQL analysis.

The project is now ready to proceed to **Stage 3: SQL Data Modeling and
Analysis using MySQL Workbench**.
