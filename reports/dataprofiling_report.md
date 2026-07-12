# World Economic Indicators Analysis
## Stage 1: Data Ingestion & Profiling Report

---

# Executive Summary

This report presents the initial profiling of three raw datasets used in the **World Economic Indicators Analysis** project.

The objective of this stage was to assess the quality, completeness, and structure of the data before performing any cleaning or transformation.

The profiling process included:

- Data ingestion
- Schema inspection
- Descriptive statistics
- Missing value assessment
- Duplicate detection
- Data integrity validation

The findings indicate that all datasets were successfully ingested. While several indicator variables contain substantial missing values, identifier fields remain complete and no duplicate observations were detected. Overall, the datasets are suitable for the data cleaning stage.

---

# Dataset Overview

| Dataset | Rows | Columns | Structure |
|---------|-----:|--------:|-----------|
| World Bank | 12,449 | 15 | Long |
| HDI | 206 | 1,008 | Wide |
| Data Dictionary | 58 | 3 | Metadata |

---

# Dataset Structure

## World Bank Dataset

| Attribute | Value |
|-----------|------|
| Rows | 12,449 |
| Columns | 15 |
| Numeric Variables | 10 |
| Integer Variables | 1 |
| Categorical Variables | 4 |
| Memory Usage | 2.0 MB |

### Categorical Variables

| Column | Unique Values | Most Frequent |
|---------|--------------:|---------------|
| Country Name | 211 | Afghanistan |
| Country Code | 211 | AFG |
| Region | 7 | Europe & Central Asia |
| Income Group | 5 | Upper Middle Income |

---

## HDI Dataset

| Attribute | Value |
|-----------|------|
| Rows | 206 |
| Columns | 1,008 |
| Numeric Variables | 1,004 |
| Categorical Variables | 4 |
| Memory Usage | 1.6 MB |

### Categorical Variables

| Column | Unique Values | Most Frequent |
|---------|--------------:|---------------|
| ISO3 | 206 | AFG |
| Country | 206 | Afghanistan |
| HDI Code | 4 | Very High |
| Region | 6 | SSA |

---

## Data Dictionary

| Attribute | Value |
|-----------|------|
| Rows | 58 |
| Columns | 3 |
| Missing Values | 0 |
| Purpose | Metadata describing dataset variables |

---

# Missing Value Assessment

## World Bank Dataset

| Variable | Missing Values | Missing % |
|----------|---------------:|----------:|
| Individuals using the Internet (% of population) | 7,385 | 59.32% |
| Unemployment (% of total labor force) (modeled ILO estimate) | 7,241 | 58.17% |
| Electric power consumption (kWh per capita) | 6,601 | 53.02% |
| GDP per capita (USD) | 2,874 | 23.09% |
| GDP (USD) | 2,871 | 23.06% |
| Infant mortality rate (per 1,000 live births) | 2,465 | 19.80% |
| Life expectancy at birth (years) | 1,273 | 10.23% |
| Death rate, crude (per 1,000 people) | 1,033 | 8.30% |
| Birth rate, crude (per 1,000 people) | 1,009 | 8.11% |
| Population density (people per sq. km of land area) | 604 | 4.85% |

### Observations

- Three variables contain more than **50%** missing values:
  - Internet Usage
  - Electricity Consumption
  - Unemployment

- GDP and GDP per Capita contain approximately **23%** missing values and therefore require careful treatment during Stage 2.

- Identifier variables (**Country Name, Country Code, Region, Income Group, and Year**) contain **no missing values**, making them reliable keys for downstream integration.

---

## HDI Dataset

Only the top 20 variables with the highest missing values are reported.

| Variable | Missing % |
|----------|----------:|
| gdi_1992 | 42.23% |
| hdi_f_1990 | 42.23% |
| hdi_f_1991 | 42.23% |
| hdi_f_1992 | 42.23% |
| hdi_m_1990 | 42.23% |
| hdi_m_1992 | 42.23% |
| gdi_1991 | 42.23% |
| gdi_1990 | 42.23% |
| hdi_m_1991 | 42.23% |
| hdi_f_1993 | 41.75% |
| gdi_1993 | 41.75% |
| hdi_m_1994 | 41.75% |
| hdi_f_1994 | 41.75% |
| hdi_m_1993 | 41.75% |
| gdi_1994 | 41.75% |
| loss_2010 | 39.81% |
| ihdi_2010 | 39.81% |
| coef_ineq_2010 | 39.81% |
| diff_hdi_phdi_1990 | 39.32% |
| phdi_1990 | 39.32% |

### Observations

The highest missing values are concentrated primarily within historical HDI and Gender Development Index indicators. Due to the large number of variables, only the twenty variables with the greatest percentage of missing values are presented.

---

# Duplicate Analysis

## World Bank

| Attribute | Unique Values |
|-----------|--------------:|
| Country Name | 211 |
| Country Code | 211 |
| Region | 7 |
| Year | 59 |
| Income Group | 5 |

---

## HDI

| Attribute | Unique Values |
|-----------|--------------:|
| Country | 206 |
| ISO3 | 206 |
| Region | 6 |

### Observation

No duplicate observations were identified in any of the three datasets.

---

# Data Integrity Assessment

## World Bank Validation

| Validation | Result |
|------------|--------|
| Minimum Year | 1960 |
| Maximum Year | 2018 |
| Minimum GDP | 8,824,450 |
| Minimum Population Density | 0.0986245 |

### Candidate Key Validation

- Unique Countries = **211**
- Unique Years = **59**
- 211 × 59 = **12,449**

This exactly matches the total number of observations, confirming that each **Country–Year** combination appears exactly once within the dataset.

---

# Conclusion

The data ingestion and profiling stage was completed successfully for all three datasets.

The World Bank dataset exhibits a consistent **Country–Year** grain with no duplicate observations and complete identifier fields. Several economic and infrastructure indicators contain substantial missing values, which have been documented for treatment during the cleaning stage.

The HDI dataset is structurally different from the World Bank dataset, as it is stored in a wide format where yearly observations are represented as individual columns. This dataset will require reshaping before integration.

The Data Dictionary contains complete metadata and provides reliable descriptions for all variables.

Overall, the datasets are suitable for further preprocessing. The next stage of the project will focus on cleaning, standardization, reshaping the HDI dataset, and preparing both datasets for loading into PostgreSQL.