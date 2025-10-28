# Zomato Data Analysis

## Overview

This project demonstrates my SQL, Python, Excel, Power BI, and AI problem-solving skills through the analysis of data for Zomato, a popular food delivery company in India. The project involves preprocessing data using ChatGPT and Excel, importing data, handling null values, and solving a variety of business problems using complex SQL queries, generating insights and actionable recommendations.

## Project Structure

- Early Preprocessing (ChatGPT): Data quality assessment
- Excel Preprocessing: Duplicate removal & cleaning
- SQL Data Cleaning: Null handling & standardization
- Power BI Visualization & DAX Measures: Avg Order Value, Avg Rating, Avg Sale, Last Order Date, Total Orders, Total Sales
- Business Problem-Solving (SQL): Addressed key business queries

## SQL Code

-- Standardize Date Format (DD-MM-YYYY HH:MM)
UPDATE Zomato
SET order_datetime = TRY_CONVERT(DATETIME, order_datetime, 105);

-- Recalculate missing total_amount
UPDATE Zomato
SET total_amount = (quantity * item_price) - discount_amount
WHERE total_amount IS NULL;

-- Standardize city names (trim + proper case)
UPDATE Zomato
SET city = LTRIM(RTRIM(LOWER(city)));

-- Clean phone numbers (remove spaces, symbols)
UPDATE Zomato
SET customer_phone = REPLACE(REPLACE(REPLACE(customer_phone, ' ', ''), '-', ''), '(+91)', '91');

-- Handle missing payment_method
UPDATE Zomato
SET payment_method = 'Unknown'
WHERE payment_method IS NULL;

-- Update all customer_name names in a table
UPDATE Zomato
SET customer_name = UPPER(LEFT(customer_name, 1)) + LOWER(SUBSTRING(customer_name, 2, LEN(customer_name)));

-- Update all area names in a table
UPDATE Zomato
SET area = UPPER(LEFT(area, 1)) + LOWER(SUBSTRING(area, 2, LEN(area)));

-- Update all restaurant names in a table
UPDATE Zomato
SET restaurant_name = UPPER(LEFT(restaurant_name, 1)) + LOWER(SUBSTRING(restaurant_name, 2, LEN(restaurant_name)));

-- KPI Queries

-- Total Revenue
SELECT SUM(total_amount) AS Total_Revenue FROM Zomato;

-- Top 5 Restaurants by Revenue
SELECT TOP 5 restaurant_name, SUM(total_amount) AS Revenue
FROM Zomato
GROUP BY restaurant_name
ORDER BY Revenue DESC;

-- Average Customer Rating
SELECT AVG(rating) AS Avg_Rating FROM Zomato WHERE rating IS NOT NULL;

-- Customer Segmentation by Total Amount
SELECT
    total_amount,
    CASE
        WHEN total_amount > 1200 THEN 'Gold'
        WHEN total_amount > 600 AND total_amount <= 1200 THEN 'Silver'
        WHEN total_amount > 0 AND total_amount <= 600 THEN 'Bronze'
        ELSE 'UNKNOWN'
    END AS Customer_Segment
FROM Zomato;

## Python Code

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load the dataset
df = pd.read_csv(r"C:\Users\HP\OneDrive\Desktop\Zomato.csv")
df.head()

# Check for missing values
df.isnull().sum()
df.info()

# Convert 'order_datetime' to datetime format
df['order_datetime'] = pd.to_datetime(df['order_datetime'], format='mixed', dayfirst=True)

# Extract month, year, and day from 'order_datetime'
df['Order_Month'] = df['order_datetime'].dt.month
df['Order_Year'] = df['order_datetime'].dt.year
df['Order_Day'] = df['order_datetime'].dt.day

# Handle missing values
df = df.dropna(subset=['customer_email', 'customer_phone'])
df['payment_method'].fillna('Unknown', inplace=True)

# Check for duplicates
df.duplicated().sum()
df[df.duplicated(keep=False)].sort_values(by=['order_id'])

# Plot the number of orders per month
sns.lineplot(x='Order_Month', y='total_amount', data=df)
plt.title('Order Amount by Month')
plt.show()

sns.countplot(x='Order_Month', data=df)
plt.title('Number of Orders per Month')
plt.show()
```

## Key Insights

- Customer Segments: Bronze customers dominate with ₹286.7K, while Gold contributes only ₹6.9K, showing weak premium adoption.
- Monthly Sales Trend: Sales are strong in April–August (₹74K–80K) but dip sharply in Oct (₹0.32K) and Nov (₹4.19K) before a slight recovery in December.
- Category Performance: Main Course leads massively (₹372.8K), while snacks (₹26.4K) and salads (₹29.4K) trail behind.
- Order Status: 38% of orders are cancelled or returned, highlighting operational and satisfaction issues.
- City-Wise Revenue: Bengaluru tops (₹8K), while Jaipur lags far behind (₹1.5K), showing big regional differences.

## Actionable Recommendations

1. Upgrade Customers: Encourage Silver users to move to Gold with loyalty rewards and premium benefits.
2. Address Seasonal Dip: Launch festival/winter promotions in Oct–Nov to prevent sharp sales declines.
3. Promote Underperforming Items: Offer combos and discounts on snacks & salads to boost diversity in orders.
4. Fix Order Failures: Reduce 38% cancellations/returns by improving restaurant and delivery reliability.
5. Geographic Expansion: Run city-specific offers in Jaipur & Ahmedabad to increase market penetration.

## Conclusion

This Zomato Data Analysis project demonstrated the complete journey from raw data to actionable insights.
Data was preprocessed using ChatGPT prompts and Excel, ensuring quality and consistency.
SQL was applied for data cleaning, standardization, and KPI generation.
Python supported exploratory analysis and trend visualization.
Power BI with DAX measures enabled dynamic dashboards and business intelligence.
The approach taken here demonstrates a structured problem-solving methodology, data manipulation skills, and the ability to derive actionable insights from data.


