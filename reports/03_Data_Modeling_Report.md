# Data Modeling Report

## Project
**World Economic Indicators Analytics**

---

# 1. Objective

The objective of this stage is to transform the cleaned staging tables into a dimensional data warehouse that supports efficient analytical querying, reporting, and visualization.

The dimensional model follows a **Star Schema** consisting of one dimension table and one fact table. This structure improves query performance, minimizes data redundancy, and provides a scalable foundation for business intelligence applications such as Power BI.

---

# 2. Source Tables

The dimensional model is built using the following staging tables created during Stage 3.

| Table | Description |
|--------|-------------|
| stg_world_bank | Cleaned World Bank economic indicators |
| stg_hdi | Cleaned Human Development Index indicators |

These staging tables preserve the cleaned source data before it is transformed into analytical warehouse tables.

---

# 3. Data Warehouse Architecture

```
                Raw CSV Files
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼
 stg_world_bank            stg_hdi
         │                       │
         └───────────┬───────────┘
                     │
                     ▼
               dim_country
                     │
                     ▼
          fact_country_year
```

---

# 4. Star Schema Design

The warehouse follows a Star Schema composed of:

## Dimension Table

- dim_country

## Fact Table

- fact_country_year

The dimension table stores descriptive information about countries, while the fact table stores yearly economic and human development indicators.

---

# 5. Fact Table Grain

The grain of the fact table is defined as:

> **One Country × One Year**

Each record represents the complete set of available economic and human development indicators for a specific country during a specific year.

Example:

| Country | Year |
|----------|------|
| India | 2015 |
| India | 2016 |
| Japan | 2015 |

This grain ensures that every record is uniquely identified by the combination of **Country** and **Year**.

---

# 6. Dimension Table Design

## dim_country

### Purpose

Stores descriptive information about each country.

### Primary Key

- country_key

### Attributes

| Column | Description |
|---------|-------------|
| country_key | Surrogate Primary Key |
| country_code | ISO-3 Country Code |
| country_name | Country Name |
| region | World Bank Region |
| income_group | World Bank Income Classification |

A surrogate key was introduced to simplify joins and improve warehouse performance.

---

# 7. Fact Table Design

## fact_country_year

### Purpose

Stores yearly economic and human development indicators for every country.

### Primary Key

- fact_key

### Foreign Key

- country_key → dim_country(country_key)

### World Bank Measures

- Birth Rate
- Death Rate
- GDP
- GDP per Capita
- Electric Power Consumption
- Internet Users
- Infant Mortality
- Life Expectancy
- Population Density
- Unemployment

### Human Development Measures

- HDI
- HDI Rank
- IHDI
- GII
- GII Rank
- Expected Years of Schooling
- Mean Years of Schooling
- Gross National Income per Capita
- Life Expectancy (HDI)

---

# 8. Relationships

The warehouse contains one relationship.

```
dim_country
------------
country_key (PK)

       │
       │ 1 : Many
       ▼

fact_country_year
-----------------
country_key (FK)
```

This relationship enforces referential integrity between the dimension and fact tables.

---

# 9. Data Loading Strategy

The fact table is populated by combining both staging tables.

Join Conditions

```
stg_world_bank.Country Code = dim_country.country_code

stg_world_bank.Country Code = stg_hdi.iso3

stg_world_bank.Year = stg_hdi.Year
```

An INNER JOIN is used to connect the World Bank data with the country dimension.

A LEFT JOIN is used for the HDI dataset because HDI records are available only from 1990 onwards, while the World Bank dataset begins in 1960.

---

# 10. Validation

The warehouse was validated after loading.

| Validation | Result |
|------------|--------|
| Total Countries | 211 |
| Total Fact Records | 12,449 |
| Year Range | 1960 – 2018 |
| Missing Foreign Keys | 0 |

The validation confirms that all warehouse records were successfully loaded while maintaining referential integrity.

---

# 11. Design Decisions

The following design decisions were adopted during warehouse development:

- Implemented a Star Schema for analytical workloads.
- Used a surrogate primary key (`country_key`) for efficient joins.
- Preserved cleaned source data in staging tables.
- Combined World Bank and HDI indicators into a single fact table because both datasets share the same business grain (Country × Year).
- Added foreign key constraints to maintain data integrity.
- Used DOUBLE data types for numerical indicators to preserve precision during analytical computations.

---

# 12. Outcome

The dimensional warehouse provides a clean and scalable analytical data model that supports SQL analytics, dashboard development, and business intelligence reporting.

The warehouse serves as the foundation for the next stage of the project, where business queries, analytical views, and Power BI dashboards will be developed.

---

# Stage Status

| Stage | Status |
|--------|--------|
| Data Profiling | ✅ Completed |
| Data Cleaning | ✅ Completed |
| SQL Data Loading | ✅ Completed |
| Data Modeling | ✅ Completed |