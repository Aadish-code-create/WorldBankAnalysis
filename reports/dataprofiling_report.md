# **Data Profiling and Ingestion Report**

## **Executive Summary**
## Executive Summary
This report presents the initial profiling of three raw datasets used in the World Economic Indicators Analytics project.
The objective of this stage was to assess the quality, completeness, and structure of the data before performing any cleaning or transformation.
The profiling process included schema inspection, descriptive statistics, missing value assessment, duplicate detection, and integrity validation.
The findings indicate that all datasets were successfully ingested. While several indicator variables contain substantial missing values, identifier fields remain complete and no duplicate observations were detected. Overall, the datasets are suitable for the data cleaning stage.

## **Data Overview**
| Dataset         |   Rows | Columns | Format   |
| --------------- | -----: | ------: | -------- |
| World Bank      | 12,449 |      15 | Long     |
| HDI             |    206 |   1,008 | Wide     |
| Data Dictionary |     58 |       3 | Metadata |


## **Data Schema**
### **World Bank**
<class 'pandas.DataFrame'>
RangeIndex: 12449 entries, 0 to 12448
dtypes: float64(10), int64(1), str(4)
memory usage: 2.0 MB

         |Country Name|  Country Code	|  Region	          |  IncomeGroup       |
---------|-----------:|:---------------:|:-------------------:|--------------------|
count	 |  12449     |   12449	        |   12449	          |      12449         |
unique	 |   211      |    211	        |     7	              |        5           |
top	     | Afghanistan|	   AFG	        |Europe & Central Asia|	Upper middle income|
freq	 |   59	      |    59	     	|   3304              |      3127          |

World Bank has **15** variables, **4** categorical columns, **1** integer column and **10** numeric indicators.

### **HDI**
<class 'pandas.DataFrame'>
RangeIndex: 206 entries, 0 to 205
Columns: 1008 entries, iso3 to mf_2021
dtypes: float64(1004), str(4)
memory usage: 1.6 MB

     	| iso3        | country  	| hdicode   |	region  |
--------|------------:|:-----------:|:---------:|----------:|
count	|   206	      |    206	    |   191	    |    151    |
unique	|   206	      |    206	    |    4	    |     6     |
top		|   AFG       |	Afghanistan | Very High |	 SSA    |
freq	|    1	      |    1        |	 66	    |     46    |



### **Dictionary**
<class 'pandas.DataFrame'>
RangeIndex: 58 entries, 0 to 57
Data columns (total 3 columns):
 #   Column       Non-Null Count  Dtype
---  ------       --------------  -----
 0   Table        58 non-null     str  
 1   Field        58 non-null     str  
 2   Description  58 non-null     str  
dtypes: str(3)
memory usage: 5.3 KB

## **Missing Value Assessment**
### **World Bank**
	                                                          | Missing Values	|Missing % |
--------------------------------------------------------------|:---------------:|---------:|                            Individuals using the Internet (% of population)	          |           7385	|    59.32 |
Unemployment (% of total labor force) (modeled ILO estimate)  |	          7241	|    58.17 |
Electric power consumption (kWh per capita)	                  |           6601	|    53.02 |
GDP per capita (USD)	                                      |           2874	|    23.09 |
GDP (USD)	                                                  |           2871	|    23.06 |
Infant mortality rate (per 1,000 live births)	              |           2465	|    19.80 |
Life expectancy at birth (years)	                          |           1273	|    10.23 |
Death rate, crude (per 1,000 people)	                      |           1033	|    8.30  |
Birth rate, crude (per 1,000 people)	                      |           1009	|    8.11  |
Population density (people per sq. km of land area)	          |            604	|    4.85  |
IncomeGroup	                                                  |              0	|    0.00  |
Country Name	                                              |              0	|    0.00  |
Year	                                                      |              0	|    0.00  |
Country Code	                                              |              0	|    0.00  |
Region	                                                      |              0	|    0.00  |

Three variables contain more than **50%** missing values:
- **Internet Usage**
- **Electricity Consumption**
- **Unemployment**

**GDP** and **GDP per Capita** contain approximately **23%** missing values and therefore require careful treatment during Stage 2. All identifier variables contain complete information, making them reliable keys for downstream integration.

### **HDI**        
                   | Missing Values	|  Missing %  |
-------------------|:--------------:|------------:|           
gdi_1992	       |             87 |	42.23     |
hdi_f_1990	       |             87 |	42.23     |
hdi_f_1991	       |             87 |	42.23     |
hdi_f_1992	       |             87 |	42.23     |
hdi_m_1990	       |             87 |	42.23     |
hdi_m_1992	       |             87 |	42.23     |
gdi_1991	       |             87 |	42.23     |
gdi_1990	       |             87 |	42.23     |
hdi_m_1991	       |             87 |	42.23     |
hdi_f_1993	       |             86 |	41.75     |
gdi_1993	       |             86 |	41.75     |
hdi_m_1994	       |             86 |	41.75     |
hdi_f_1994	       |             86 |	41.75     |
hdi_m_1993	       |             86 |	41.75     |
gdi_1994	       |             86 |	41.75     |
loss_2010	       |             82 |	39.81     |
ihdi_2010	       |             82 |	39.81     |
coef_ineq_2010	   |             82 |	39.81     |
diff_hdi_phdi_1990 |	         81 |	39.32     |
phdi_1990	       |             81 |	39.32     |

Due to size constraints only top 20 columns with most missing values are considered. Amongst them these shows maximum missing values %:
- **gdi_1992**	       
- **hdi_f_1990**	      
- **hdi_f_1991**	      
- **hdi_f_1992**	     
- **hdi_m_1990**	       
- **hdi_m_1992**	       
- **gdi_1991**	       
- **gdi_1990**
- **hdi_m_1991**

## **Duplicate Analysis**
### **World Bank**
Unique Row Count:
Country Name = 211
Country Code = 211
Region = 7
Year = 59
Income Group = 5 

### **HDI**
Unique Row Count:
Country Name = 206
iso3 = 206
Region = 6

### **No duplicate observations were identified in any of the three datasets.**

## **Integrity Check**
minimum value in 'Year' = 1960 
maximum value in 'Year' = 2018
minimum value in GDP (USD) = 8824450.0
minimum value in Population density = 0.0986245
unique(country code) * unique(year) = Len(world bank) = 12449

The World Bank dataset contains **211** unique countries observed across **59 years**.
The product of **unique Country Codes** and **unique Years** equals the total number of observations (211 × 59 = 12,449), confirming that each Country-Year combination appears exactly once.

## **Conclusion**

The data ingestion and profiling stage was completed successfully for all three datasets.
The World Bank dataset exhibits a consistent Country-Year grain with no duplicate observations and complete identifier fields. Several economic and infrastructure indicators contain substantial missing values, which have been documented for treatment during the cleaning stage.
The HDI dataset is structurally different from the World Bank dataset, as it is stored in a wide format where yearly observations are represented as individual columns. This dataset will require reshaping before integration.
The data dictionary is complete and provides reliable metadata for interpreting variables.
Overall, the datasets are suitable for further preprocessing. The next stage of the project will focus on cleaning, standardization, and preparation for loading into PostgreSQL.