-- Query 01: Validate total employee records
-- Purpose: Confirm that all employee records were imported successfully
-- Expected result: 1470 records

SELECT
    COUNT(*) AS TotalEmployees
FROM hr_employee_attrition;

-- Query 02: Validate total column count
-- Purpose: Confirm that all analytical variables were imported
-- Expected result: 36 columns

SELECT
    COUNT(*) AS TotalColumns
FROM pragma_table_info('hr_employee_attrition');

-- Query 03: Validate unique employee IDs
-- Purpose: Confirm that each employee has a unique identifier
-- Expected result: 1470 unique employee IDs

SELECT
    COUNT(DISTINCT EmployeeNumber) AS UniqueEmployeeIDs
FROM hr_employee_attrition;

-- Query 04: Check for duplicate employee IDs
-- Purpose: Identify employee identifiers appearing more than once
-- Expected result: 0 duplicate employee IDs

SELECT
    COUNT(*) AS DuplicateEmployeeIDs
FROM (
    SELECT EmployeeNumber
    FROM hr_employee_attrition
    GROUP BY EmployeeNumber
    HAVING COUNT(*) > 1
) AS DuplicateRecords;

-- Query 05: Check for missing values
-- Purpose: Identify missing values across all 36 analytical variables
-- Expected result: 0 missing values

SELECT
    SUM(
        (Age IS NULL OR TRIM(Age) = '') +
        (Attrition IS NULL OR TRIM(Attrition) = '') +
        (BusinessTravel IS NULL OR TRIM(BusinessTravel) = '') +
        (DailyRate IS NULL OR TRIM(DailyRate) = '') +
        (Department IS NULL OR TRIM(Department) = '') +
        (DistanceFromHome IS NULL OR TRIM(DistanceFromHome) = '') +
        (Education IS NULL OR TRIM(Education) = '') +
        (EducationField IS NULL OR TRIM(EducationField) = '') +
        (EmployeeNumber IS NULL OR TRIM(EmployeeNumber) = '') +
        (EnvironmentSatisfaction IS NULL OR TRIM(EnvironmentSatisfaction) = '') +
        (Gender IS NULL OR TRIM(Gender) = '') +
        (HourlyRate IS NULL OR TRIM(HourlyRate) = '') +
        (JobInvolvement IS NULL OR TRIM(JobInvolvement) = '') +
        (JobLevel IS NULL OR TRIM(JobLevel) = '') +
        (JobRole IS NULL OR TRIM(JobRole) = '') +
        (JobSatisfaction IS NULL OR TRIM(JobSatisfaction) = '') +
        (MaritalStatus IS NULL OR TRIM(MaritalStatus) = '') +
        (MonthlyIncome IS NULL OR TRIM(MonthlyIncome) = '') +
        (MonthlyRate IS NULL OR TRIM(MonthlyRate) = '') +
        (NumCompaniesWorked IS NULL OR TRIM(NumCompaniesWorked) = '') +
        (OverTime IS NULL OR TRIM(OverTime) = '') +
        (PercentSalaryHike IS NULL OR TRIM(PercentSalaryHike) = '') +
        (PerformanceRating IS NULL OR TRIM(PerformanceRating) = '') +
        (RelationshipSatisfaction IS NULL OR TRIM(RelationshipSatisfaction) = '') +
        (StockOptionLevel IS NULL OR TRIM(StockOptionLevel) = '') +
        (TotalWorkingYears IS NULL OR TRIM(TotalWorkingYears) = '') +
        (TrainingTimesLastYear IS NULL OR TRIM(TrainingTimesLastYear) = '') +
        (WorkLifeBalance IS NULL OR TRIM(WorkLifeBalance) = '') +
        (YearsAtCompany IS NULL OR TRIM(YearsAtCompany) = '') +
        (YearsInCurrentRole IS NULL OR TRIM(YearsInCurrentRole) = '') +
        (YearsSinceLastPromotion IS NULL OR TRIM(YearsSinceLastPromotion) = '') +
        (YearsWithCurrManager IS NULL OR TRIM(YearsWithCurrManager) = '') +
        (AgeGroup IS NULL OR TRIM(AgeGroup) = '') +
        (IncomeBand IS NULL OR TRIM(IncomeBand) = '') +
        (TenureGroup IS NULL OR TRIM(TenureGroup) = '') +
        (AttritionFlag IS NULL OR TRIM(AttritionFlag) = '')
    ) AS TotalMissingValues
FROM hr_employee_attrition;

-- Query 06: Validate numerical data types
-- Purpose: Identify incorrectly stored numerical values
-- Expected result: 0 invalid numerical values

SELECT
    SUM(
        (TYPEOF(Age) <> 'integer') +
        (TYPEOF(DailyRate) <> 'integer') +
        (TYPEOF(DistanceFromHome) <> 'integer') +
        (TYPEOF(Education) <> 'integer') +
        (TYPEOF(EmployeeNumber) <> 'integer') +
        (TYPEOF(EnvironmentSatisfaction) <> 'integer') +
        (TYPEOF(HourlyRate) <> 'integer') +
        (TYPEOF(JobInvolvement) <> 'integer') +
        (TYPEOF(JobLevel) <> 'integer') +
        (TYPEOF(JobSatisfaction) <> 'integer') +
        (TYPEOF(MonthlyIncome) <> 'integer') +
        (TYPEOF(MonthlyRate) <> 'integer') +
        (TYPEOF(NumCompaniesWorked) <> 'integer') +
        (TYPEOF(PercentSalaryHike) <> 'integer') +
        (TYPEOF(PerformanceRating) <> 'integer') +
        (TYPEOF(RelationshipSatisfaction) <> 'integer') +
        (TYPEOF(StockOptionLevel) <> 'integer') +
        (TYPEOF(TotalWorkingYears) <> 'integer') +
        (TYPEOF(TrainingTimesLastYear) <> 'integer') +
        (TYPEOF(WorkLifeBalance) <> 'integer') +
        (TYPEOF(YearsAtCompany) <> 'integer') +
        (TYPEOF(YearsInCurrentRole) <> 'integer') +
        (TYPEOF(YearsSinceLastPromotion) <> 'integer') +
        (TYPEOF(YearsWithCurrManager) <> 'integer') +
        (TYPEOF(AttritionFlag) <> 'integer')
    ) AS InvalidNumericalValues
FROM hr_employee_attrition;

-- Query 07: Validate attrition flag consistency
-- Purpose: Confirm that AttritionFlag matches the original Attrition status
-- Expected result: 0 inconsistent records

SELECT
    COUNT(*) AS InconsistentAttritionFlags
FROM hr_employee_attrition
WHERE
    CASE
        WHEN Attrition = 'Yes' AND AttritionFlag = 1 THEN 0
        WHEN Attrition = 'No' AND AttritionFlag = 0 THEN 0
        ELSE 1
    END = 1;
	
-- Query 08: Validate attrition and non-attrition counts
-- Purpose: Reconcile employee attrition counts with Excel
-- Expected result: 237 attrition and 1233 non-attrition records

SELECT
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN AttritionFlag = 1 THEN 1 ELSE 0 END) AS AttritionCount,
    SUM(CASE WHEN AttritionFlag = 0 THEN 1 ELSE 0 END) AS NonAttritionCount
FROM hr_employee_attrition;

-- Query 09: Validate overall attrition rate
-- Purpose: Reconcile the overall attrition rate with Excel
-- Expected result: 16.12%

SELECT
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    ROUND(
        SUM(AttritionFlag) * 100.0 / COUNT(*), 2
    ) AS AttritionRate,
    ROUND(
        (COUNT(*) - SUM(AttritionFlag)) * 100.0 / COUNT(*), 2
    ) AS RetentionRate
FROM hr_employee_attrition;

-- =====================================================
-- SECTION 2: WORKFORCE KPI ANALYSIS
-- =====================================================

-- Query 10: Overall workforce KPI summary
-- Business Question: What are the key characteristics
-- of the organization's workforce?

SELECT
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100, 2) AS AttritionRate,
    ROUND(AVG(Age), 2) AS AverageAge,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(TotalWorkingYears), 2) AS AverageWorkExperience,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance
FROM hr_employee_attrition;

-- =====================================================
-- SECTION 3: EXPLORATORY DATA ANALYSIS
-- =====================================================

-- Query 11: Departmental attrition analysis
-- Business Question: Which departments experience
-- the highest employee attrition rates?

SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction
FROM hr_employee_attrition
GROUP BY Department
ORDER BY AttritionRate DESC;

-- Query 12: Job role attrition analysis
-- Business Question: Which job roles experience
-- the highest employee attrition rates?

SELECT
    JobRole,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure
FROM hr_employee_attrition
GROUP BY JobRole
ORDER BY AttritionRate DESC;

-- Query 13: Attrition by age group
-- Business Question: Which employee age groups
-- experience the highest attrition rates?

SELECT
    AgeGroup,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction
FROM hr_employee_attrition
GROUP BY AgeGroup
ORDER BY AttritionRate DESC;

-- Query 14: Attrition by gender
-- Business Question: How does employee attrition
-- differ across recorded gender categories?

SELECT
    Gender,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance
FROM hr_employee_attrition
GROUP BY Gender
ORDER BY AttritionRate DESC;

-- Query 15: Attrition by marital status
-- Business Question: How does employee attrition
-- vary across marital status categories?

SELECT
    MaritalStatus,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(Age), 2) AS AverageAge,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance
FROM hr_employee_attrition
GROUP BY MaritalStatus
ORDER BY AttritionRate DESC;

-- Query 16: Attrition by education level
-- Business Question: How does employee attrition
-- vary across educational attainment levels?

SELECT
    Education AS EducationLevel,
    CASE Education
        WHEN 1 THEN 'Below College'
        WHEN 2 THEN 'College'
        WHEN 3 THEN 'Bachelor'
        WHEN 4 THEN 'Master'
        WHEN 5 THEN 'Doctor'
        ELSE 'Unknown'
    END AS EducationCategory,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction
FROM hr_employee_attrition
GROUP BY Education
ORDER BY AttritionRate DESC;

-- Query 17: Attrition by income band
-- Business Question: How does employee attrition
-- vary across monthly income categories?

SELECT
    IncomeBand,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(Age), 2) AS AverageAge,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction
FROM hr_employee_attrition
GROUP BY IncomeBand
ORDER BY AttritionRate DESC;

-- Query 18: Attrition by employee tenure
-- Business Question: At which stage of employee
-- tenure is attrition most prevalent?

SELECT
    TenureGroup,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(Age), 2) AS AverageAge,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance
FROM hr_employee_attrition
GROUP BY TenureGroup
ORDER BY AttritionRate DESC;

-- Query 19: Attrition by overtime status
-- Business Question: Do employees who work overtime
-- experience higher employee attrition rates?

SELECT
    OverTime,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance,
    ROUND(AVG(EnvironmentSatisfaction), 2) AS AverageEnvironmentSatisfaction
FROM hr_employee_attrition
GROUP BY OverTime
ORDER BY AttritionRate DESC;

-- Query 20: Attrition by business travel frequency
-- Business Question: How does employee attrition
-- vary across business travel categories?

SELECT
    BusinessTravel,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance,
    ROUND(AVG(DistanceFromHome), 2) AS AverageDistanceFromHome
FROM hr_employee_attrition
GROUP BY BusinessTravel
ORDER BY AttritionRate DESC;

-- Query 21: Attrition by job satisfaction
-- Business Question: How does employee attrition
-- vary across job satisfaction levels?

SELECT
    JobSatisfaction AS SatisfactionLevel,
    CASE JobSatisfaction
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High'
        WHEN 4 THEN 'Very High'
        ELSE 'Unknown'
    END AS SatisfactionCategory,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance,
    ROUND(AVG(EnvironmentSatisfaction), 2) AS AverageEnvironmentSatisfaction
FROM hr_employee_attrition
GROUP BY JobSatisfaction
ORDER BY AttritionRate DESC;

-- Query 22: Attrition by environment satisfaction
-- Business Question: How does employee attrition
-- vary across workplace environment satisfaction levels?

SELECT
    EnvironmentSatisfaction AS SatisfactionLevel,
    CASE EnvironmentSatisfaction
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High'
        WHEN 4 THEN 'Very High'
        ELSE 'Unknown'
    END AS SatisfactionCategory,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance
FROM hr_employee_attrition
GROUP BY EnvironmentSatisfaction
ORDER BY AttritionRate DESC;

-- Query 23: Attrition by work-life balance
-- Business Question: How does employee attrition
-- vary across work-life balance levels?

SELECT
    WorkLifeBalance AS BalanceLevel,
    CASE WorkLifeBalance
        WHEN 1 THEN 'Bad'
        WHEN 2 THEN 'Good'
        WHEN 3 THEN 'Better'
        WHEN 4 THEN 'Best'
        ELSE 'Unknown'
    END AS BalanceCategory,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(EnvironmentSatisfaction), 2) AS AverageEnvironmentSatisfaction
FROM hr_employee_attrition
GROUP BY WorkLifeBalance
ORDER BY AttritionRate DESC;

-- Query 24: Attrition by job involvement
-- Business Question: How does employee attrition
-- vary across job involvement levels?

SELECT
    JobInvolvement AS InvolvementLevel,
    CASE JobInvolvement
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High'
        WHEN 4 THEN 'Very High'
        ELSE 'Unknown'
    END AS InvolvementCategory,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance
FROM hr_employee_attrition
GROUP BY JobInvolvement
ORDER BY AttritionRate DESC;

-- Query 25: Attrition by training frequency
-- Business Question: How does employee attrition
-- vary across employee training frequency levels?

SELECT
    TrainingTimesLastYear AS TrainingFrequency,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(JobInvolvement), 2) AS AverageJobInvolvement,
    ROUND(AVG(PerformanceRating), 2) AS AveragePerformanceRating
FROM hr_employee_attrition
GROUP BY TrainingTimesLastYear
ORDER BY AttritionRate DESC;

-- Query 26: Attrition by years since last promotion
-- Business Question: How does employee attrition
-- vary according to time since last promotion?

SELECT
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN '0 years'
        WHEN YearsSinceLastPromotion BETWEEN 1 AND 2 THEN '1-2 years'
        WHEN YearsSinceLastPromotion BETWEEN 3 AND 5 THEN '3-5 years'
        WHEN YearsSinceLastPromotion BETWEEN 6 AND 10 THEN '6-10 years'
        ELSE '11+ years'
    END AS PromotionGroup,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(JobInvolvement), 2) AS AverageJobInvolvement
FROM hr_employee_attrition
GROUP BY PromotionGroup
ORDER BY AttritionRate DESC;

-- Query 27: Attrition by distance from home
-- Business Question: How does employee attrition
-- vary across commuting distance categories?

SELECT
    CASE
        WHEN DistanceFromHome BETWEEN 1 AND 5 THEN '1-5'
        WHEN DistanceFromHome BETWEEN 6 AND 10 THEN '6-10'
        WHEN DistanceFromHome BETWEEN 11 AND 20 THEN '11-20'
        ELSE '21+'
    END AS DistanceGroup,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(DistanceFromHome), 2) AS AverageDistance,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance
FROM hr_employee_attrition
GROUP BY DistanceGroup
ORDER BY AttritionRate DESC;

-- Query 28: Attrition by job level
-- Business Question: How does employee attrition
-- vary across organizational job levels?

SELECT
    JobLevel,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(Age), 2) AS AverageAge,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(TotalWorkingYears), 2) AS AverageWorkExperience,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(YearsSinceLastPromotion), 2) AS AverageYearsSincePromotion
FROM hr_employee_attrition
GROUP BY JobLevel
ORDER BY AttritionRate DESC;

-- Query 29: Attrition by stock option level
-- Business Question: How does employee attrition
-- vary across employee stock option levels?

SELECT
    StockOptionLevel,
    COUNT(*) AS TotalEmployees,
    SUM(AttritionFlag) AS AttritionCount,
    COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
    ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
    ROUND(AVG(Age), 2) AS AverageAge,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(JobLevel), 2) AS AverageJobLevel
FROM hr_employee_attrition
GROUP BY StockOptionLevel
ORDER BY AttritionRate DESC;

-- ==================================================
-- SECTION 4: ADVANCED COMPARATIVE ANALYSIS
-- ==================================================

-- Query 30: Combined overtime and job level analysis
-- Business Question: Which combinations of overtime
-- status and job level experience the highest attrition?

WITH OvertimeJobLevel AS (
    SELECT
        JobLevel,
        OverTime,
        COUNT(*) AS TotalEmployees,
        SUM(AttritionFlag) AS AttritionCount,
        COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
        ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
        ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
        ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
        ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
        ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance
    FROM hr_employee_attrition
    GROUP BY JobLevel, OverTime
)

SELECT
    *,
    ROUND(
        AttritionRate - (
            SELECT AVG(AttritionFlag) * 100.0
            FROM hr_employee_attrition
        ), 2
    ) AS DifferenceFromOverallRate,
    DENSE_RANK() OVER (
        ORDER BY AttritionRate DESC
    ) AS AttritionRank
FROM OvertimeJobLevel
ORDER BY AttritionRank;

-- Query 31: Combined income and tenure analysis
-- Business Question: Which combinations of income
-- band and employee tenure experience the highest attrition?

WITH IncomeTenureAnalysis AS (
    SELECT
        IncomeBand,
        TenureGroup,
        COUNT(*) AS TotalEmployees,
        SUM(AttritionFlag) AS AttritionCount,
        COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
        ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
        ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
        ROUND(AVG(Age), 2) AS AverageAge,
        ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction
    FROM hr_employee_attrition
    GROUP BY IncomeBand, TenureGroup
    HAVING COUNT(*) >= 20
)

SELECT
    *,
    ROUND(
        AttritionRate - (
            SELECT AVG(AttritionFlag) * 100.0
            FROM hr_employee_attrition
        ), 2
    ) AS DifferenceFromOverallRate,
    DENSE_RANK() OVER (
        ORDER BY AttritionRate DESC
    ) AS AttritionRank
FROM IncomeTenureAnalysis
ORDER BY AttritionRank;

-- Query 32: Combined job satisfaction and work-life balance analysis
-- Business Question: Which combinations of job satisfaction
-- and work-life balance experience the highest attrition rates?

WITH SatisfactionBalanceAnalysis AS (
    SELECT
        JobSatisfaction AS SatisfactionLevel,
        CASE JobSatisfaction
            WHEN 1 THEN 'Low'
            WHEN 2 THEN 'Medium'
            WHEN 3 THEN 'High'
            WHEN 4 THEN 'Very High'
        END AS SatisfactionCategory,
        WorkLifeBalance AS BalanceLevel,
        CASE WorkLifeBalance
            WHEN 1 THEN 'Bad'
            WHEN 2 THEN 'Good'
            WHEN 3 THEN 'Better'
            WHEN 4 THEN 'Best'
        END AS BalanceCategory,
        COUNT(*) AS TotalEmployees,
        SUM(AttritionFlag) AS AttritionCount,
        COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
        ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
        ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
        ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
        ROUND(AVG(JobInvolvement), 2) AS AverageJobInvolvement,
        ROUND(AVG(EnvironmentSatisfaction), 2)
            AS AverageEnvironmentSatisfaction
    FROM hr_employee_attrition
    GROUP BY JobSatisfaction, WorkLifeBalance
    HAVING COUNT(*) >= 20
)

SELECT
    *,
    ROUND(
        AttritionRate - (
            SELECT AVG(AttritionFlag) * 100.0
            FROM hr_employee_attrition
        ), 2
    ) AS DifferenceFromOverallRate,
    DENSE_RANK() OVER (
        ORDER BY AttritionRate DESC
    ) AS AttritionRank
FROM SatisfactionBalanceAnalysis
ORDER BY AttritionRank;

-- Query 33: Combined department and overtime analysis
-- Business Question: Which departments experience the
-- highest attrition rates when overtime is considered?

WITH DepartmentOvertimeAnalysis AS (
    SELECT
        Department,
        OverTime,
        COUNT(*) AS TotalEmployees,
        SUM(AttritionFlag) AS AttritionCount,
        COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
        ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
        ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
        ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
        ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
        ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance
    FROM hr_employee_attrition
    GROUP BY Department, OverTime
    HAVING COUNT(*) >= 20
)

SELECT
    *,
    ROUND(
        AttritionRate - (
            SELECT AVG(AttritionFlag) * 100.0
            FROM hr_employee_attrition
        ), 2
    ) AS DifferenceFromOverallRate,
    DENSE_RANK() OVER (
        ORDER BY AttritionRate DESC
    ) AS AttritionRank
FROM DepartmentOvertimeAnalysis
ORDER BY AttritionRank;

-- Query 34: Comparative profile of retained and departed employees
-- Business Question: How do employee characteristics differ
-- between employees who left and employees who remained?

SELECT
    CASE AttritionFlag
        WHEN 1 THEN 'Departed Employees'
        WHEN 0 THEN 'Retained Employees'
    END AS EmployeeStatus,
    COUNT(*) AS TotalEmployees,
    ROUND(AVG(Age), 2) AS AverageAge,
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure,
    ROUND(AVG(TotalWorkingYears), 2) AS AverageWorkExperience,
    ROUND(AVG(JobSatisfaction), 2) AS AverageJobSatisfaction,
    ROUND(AVG(EnvironmentSatisfaction), 2)
        AS AverageEnvironmentSatisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS AverageWorkLifeBalance,
    ROUND(AVG(JobInvolvement), 2) AS AverageJobInvolvement,
    ROUND(AVG(DistanceFromHome), 2) AS AverageDistanceFromHome,
    ROUND(AVG(TrainingTimesLastYear), 2)
        AS AverageTrainingFrequency,
    ROUND(AVG(YearsSinceLastPromotion), 2)
        AS AverageYearsSincePromotion,
    ROUND(AVG(JobLevel), 2) AS AverageJobLevel,
    ROUND(AVG(StockOptionLevel), 2) AS AverageStockOptionLevel,
    ROUND(
        AVG(CASE WHEN OverTime = 'Yes' THEN 1.0 ELSE 0 END)
        * 100.0, 2
    ) AS OvertimePercentage
FROM hr_employee_attrition
GROUP BY AttritionFlag
ORDER BY AttritionFlag DESC;

-- ==========================================================
-- SECTION 5: FINAL SQL VALIDATION AND RECONCILIATION
-- ==========================================================

-- Query 35: Final dataset validation and reconciliation
-- Purpose: Confirm that the analytical dataset remains
-- consistent with the original validated Excel dataset.

WITH FinalValidation AS (
    SELECT
        COUNT(*) AS TotalEmployees,
        COUNT(DISTINCT EmployeeNumber) AS UniqueEmployeeIDs,
        SUM(AttritionFlag) AS AttritionCount,
        COUNT(*) - SUM(AttritionFlag) AS RetainedEmployees,
        ROUND(AVG(AttritionFlag) * 100.0, 2) AS AttritionRate,
        ROUND((1 - AVG(AttritionFlag)) * 100.0, 2)
            AS RetentionRate,
        SUM(CASE
            WHEN AttritionFlag NOT IN (0, 1)
                OR AttritionFlag IS NULL
            THEN 1 ELSE 0
        END) AS InvalidAttritionFlags,
        SUM(CASE
            WHEN Attrition = 'Yes' AND AttritionFlag = 1 THEN 0
            WHEN Attrition = 'No' AND AttritionFlag = 0 THEN 0
            ELSE 1
        END) AS InconsistentAttritionFlags
    FROM hr_employee_attrition
)

SELECT
    *,
    TotalEmployees - UniqueEmployeeIDs
        AS EmployeeIDDiscrepancy,
    CASE
        WHEN TotalEmployees = 1470
            AND UniqueEmployeeIDs = 1470
            AND AttritionCount = 237
            AND RetainedEmployees = 1233
            AND AttritionRate = 16.12
            AND RetentionRate = 83.88
            AND InvalidAttritionFlags = 0
            AND InconsistentAttritionFlags = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END AS FinalValidationStatus
FROM FinalValidation;