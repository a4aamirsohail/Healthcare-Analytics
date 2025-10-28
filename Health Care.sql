
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

