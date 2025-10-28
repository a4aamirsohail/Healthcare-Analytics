# Healthcare-Analytics

Healthcare Analytics Project Overview

Overview

This project provides a comprehensive demonstration of data analysis, cleaning, and business intelligence skills using SQL, Python (Jupyter), and Power BI. The core objective was to analyze operational, financial, and patient data for a healthcare provider to derive strategic, actionable recommendations for optimizing revenue, efficiency, and patient care delivery.

The process involved initial AI-assisted data assessment, extensive data standardization in SQL, detailed statistical analysis in Python, and the calculation of key performance indicators (KPIs) to drive strategic insights.

Project Structure

Early Preprocessing (AI/ChatGPT): Initial data quality assessment, identification of dirty values (e.g., inconsistent gender or condition names), and planning the cleaning strategy.

SQL Data Cleaning (Health Care.sql):

Standardization: Cleaned and standardized values for Gender, Medical_Condition, Insurance, and Hospital names to ensure data consistency.

Data Quality: Handled nulls and ensured proper casing across various fields.

Python Analysis & Feature Engineering (Health Care.ipynb / Health AI.pdf):

Exploratory Data Analysis (EDA): Initial loading, inspection, and cleaning using pandas.

Feature Engineering: Extracted temporal features like Admission_Month_Name from date fields for time-series analysis.

Statistical Analysis: Identified seasonal patterns in diagnoses (e.g., Dengue, Cataracts) and analyzed month-over-month trends for admissions and discharges.

Presentation & Visualization (Power BI / Health Care Final.pptx):

KPI Calculation: Used calculated measures (DAX) for Total Revenue, Total Patients, Avg LOS (Days), and Avg Billing Amount.

Strategic Insights: Visualized trends (e.g., Monthly Revenue) and deep-dive analysis (e.g., LOS by Condition, Gender Billing, Age Group Billing) in the Power BI dashboard.

SQL Code

--Standardize Gender values

UPDATE [dbo].[HealthCare]
SET Gender = CASE 
    WHEN UPPER(Gender) IN ('MALE', 'M') THEN 'Male'
    WHEN UPPER(Gender) IN ('FEMALE', 'F') THEN 'Female'
    WHEN UPPER(Gender) IN ('O', 'OTHER') THEN 'Other'
    ELSE Gender
END;

--Standardize Name capitalization
Update HealthCare
SET Name = UPPER(SUBSTRING(Name,1,1)) 
          + LOWER(SUBSTRING(Name,2,LEN(Name)-1));

--Standardize Medical Conditions

Update HealthCare
SET Medical_Condition = CASE 
    WHEN UPPER(Medical_Condition) LIKE '%DIABETES%' 
         OR UPPER(Medical_Condition) = 'SUGAR' THEN 'Diabetes Type 2'
    WHEN UPPER(Medical_Condition) = 'TYPHOID' THEN 'Typhoid'
    WHEN UPPER(Medical_Condition) = 'DENGUE' THEN 'Dengue'
    WHEN UPPER(Medical_Condition) = 'HYPERTENSION' THEN 'Hypertension'
    WHEN UPPER(Medical_Condition) = 'ASTHMA' THEN 'Asthma'
    WHEN UPPER(Medical_Condition) = 'ANEMIA' THEN 'Anemia'
    WHEN UPPER(Medical_Condition) = 'JAUNDICE' THEN 'Jaundice'
    WHEN UPPER(Medical_Condition) = 'CATARACTS' THEN 'Cataracts'
    WHEN UPPER(Medical_Condition) = 'ORGAN TRANSPLANT' THEN 'Organ Transplant'
    ELSE Medical_Condition
END;

--Standardize Insurance Provider

Update HealthCare
SET Insurance = CASE 
    WHEN UPPER(Insurance) = 'NIC' THEN 'NIC'
    WHEN UPPER(Insurance) = 'UIC' THEN 'UIC'
    WHEN UPPER(Insurance) = 'OIC' THEN 'OIC'
    WHEN UPPER(Insurance) = 'NIACL' THEN 'NIACL'
    WHEN UPPER(Insurance) = 'EHS' THEN 'ESIC'
    WHEN UPPER(Insurance) IN ('SELF-PAY', 'SELF PAY') THEN 'Cash'
    ELSE Insurance
END;

--Standardize Hospital Names

Update HealthCare
SET Hospital = CASE
    WHEN Hospital LIKE '%Apollo%Mumbai%' THEN 'Apollo Hospital Mumbai'
    WHEN Hospital LIKE '%Apollo%' AND Hospital NOT LIKE '%Mumbai%' THEN 'Apollo Hospital'
    WHEN Hospital LIKE '%AIIMS%' THEN 'AIIMS Delhi'
    WHEN Hospital LIKE '%Fortis%Bangalore%' THEN 'Fortis Healthcare Bangalore'
    WHEN Hospital LIKE '%Fortis%' AND Hospital NOT LIKE '%Bangalore%' THEN 'Fortis Healthcare'
    WHEN Hospital LIKE '%Manipal%' THEN 'Manipal Hospital Bangalore'
    WHEN Hospital LIKE '%Max Super%' THEN 'Max Super Speciality Delhi'
    WHEN Hospital LIKE '%Medanta%' THEN 'Medanta Gurugram'
    WHEN Hospital LIKE '%Narayana%' THEN 'Narayana Health Bangalore'
    WHEN Hospital LIKE '%KIMS%' THEN 'KIMS Hyderabad'
    WHEN Hospital LIKE '%Government%Chennai%' THEN 'Government Hospital Chennai'
    WHEN Hospital LIKE '%Government%Kolkata%' THEN 'Government Hospital Kolkata'
    WHEN Hospital LIKE '%Government%Pune%' THEN 'Government Hospital Pune'
    ELSE Hospital
END;

Python Code

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
df = pd.read_csv("C:/Users/HP/OneDrive/Desktop/Healthcare Project/Healthcare Messy.csv")
df.head()
df.info()
df.describe()

# Converting source columns 'DOA' and 'DOD' to datetime format
# and create alias columns 'Admission_Date' and 'Discharge_Date' for compatibility

df['DOA'] = pd.to_datetime(df['DOA'], format='%d-%m-%Y', errors='coerce')
df['DOD'] = pd.to_datetime(df['DOD'], format='%d-%m-%Y', errors='coerce')

# create the expected column names so downstream code that uses
# Admission_Date / Discharge_Date won't fail
df['Admission_Date'] = df['DOA']
df['Discharge_Date'] = df['DOD']
df['Length_of_Stay'] = (df['Discharge_Date'] - df['Admission_Date']).dt.days
df.head()
# Extract year and month from admission
df['Admission_Year'] = df['Admission_Date'].dt.year
df['Admission_Month'] = df['Admission_Date'].dt.month
df['Admission_Month_Name'] = df['Admission_Date'].dt.month_name()
df.head()
# Strip whitespace and standardize
df['Hospital'] = df['Hospital'].str.strip()

# Fix common variations
hospital_fixes = {
    'Govt. Hospital Chennai': 'Government Hospital Chennai',
    'Govt.  Chennai': 'Government Hospital Chennai',
    'Govt. Hospital Pune': 'Government Hospital Pune',
    'Govt.  Pune': 'Government Hospital Pune',
    'Govt.  Hospital  Pune': 'Government Hospital Pune',
    'Government  Kolkata': 'Government Hospital Kolkata',
    'Max  Super  Speciality  Delhi': 'Max Super Speciality Delhi',
    'Manipal  Bangalore': 'Manipal Hospital Bangalore',
    'Apollo  Mumbai': 'Apollo Hospital Mumbai',
    'Fortis': 'Fortis Healthcare',
    'Apollo': 'Apollo Hospital'
}

df['Hospital'] = df['Hospital'].replace(hospital_fixes)

print("✓ Hospital names standardized")
print(f"Unique hospitals: {df['Hospital'].nunique()}")
df.head()
df['Billing_Amount'] = df['Billing_Amount'].astype(str)
df['Billing_Amount'] = df['Billing_Amount'].str.replace('â‚¹', '', regex=False)  # Remove rupee symbol
df['Billing_Amount'] = df['Billing_Amount'].str.replace('₹', '', regex=False)  # Remove another rupee symbol
df['Billing_Amount'] = df['Billing_Amount'].str.replace(',', '', regex=False)   # Remove commas
df['Billing_Amount'] = df['Billing_Amount'].str.strip()

# Convert to numeric
df['Billing_Amount'] = pd.to_numeric(df['Billing_Amount'], errors='coerce')
df.head()
# Save to your Desktop folder
df.to_csv(r'C:\Users\HP\OneDrive\Desktop\Healthcare Project\healthcare_data_cleaned.csv', index=False)
print("✓ Cleaned data saved to Desktop/Healthcare Project folder")


Key Insights
Revenue Crisis & Admissions Dip: Total revenue peaked at ₹29.8M in October, but suffered a drastic 59% drop to ₹12.3M in November, mirroring a similar crash in patient admissions/discharges toward the year-end.

Seasonal Diagnosis: Dengue shows a clear seasonal peak in late summer/early fall, while Cataracts peak in the spring/early summer. Chronic conditions like Hypertension remain stable but still reflect the overall year-end drop.

Operational Bottlenecks: Conditions like Cancer, Sepsis, and Organ Transplant have extremely long Average Length of Stay (20+ days), highlighting a need for targeted discharge planning.

Cost Anomaly: Adult Stroke patients drive an exceptionally high average bill (₹1.09M)—three times higher than any other age group for that condition.

Gender Gap in Billing: Female patients account for significantly less total billing compared to male patients, suggesting an opportunity for improved outreach.

Actionable Recommendations
Address Revenue Crisis: Conduct an immediate, high-priority analysis to pinpoint the exact operational reasons for the severe admission and revenue decline in November/December.

Seasonal Resource Planning: Proactively allocate resources (staffing, supplies, and marketing) for Dengue (late summer/fall) and Cataracts (spring/early summer) to manage predictable patient surges efficiently.

Optimize High-LOS Conditions: Implement proactive discharge planning and process improvements for the 20+ day stay conditions (e.g., Cancer, Sepsis) to increase bed turnover.

Develop Revenue Packages: Create specialized, high-value packages for the Adult and Young Adult segments, which currently show lower billing amounts, to boost revenue diversification.

Review Stroke Protocols: Initiate a focused review of treatment protocols for Adult Stroke patients to identify and optimize cost inefficiencies while maintaining care quality, addressing the ₹1.09M cost anomaly.

Conclusion
This Healthcare Data Analysis project successfully completed the full data lifecycle, moving from raw data to strategic business action. Data quality was established through rigorous SQL standardization and Python feature engineering, following an initial AI-assisted data assessment. The application of analytics revealed a critical revenue crisis, new seasonal patient demands, and key operational inefficiencies. The resulting recommendations provide the organization with a structured roadmap to stabilize revenue, enhance operational effectiveness, and improve targeted patient care.