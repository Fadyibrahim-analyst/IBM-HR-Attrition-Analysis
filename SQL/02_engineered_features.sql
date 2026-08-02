/*====================
Engineered Features
===================== */

create table employee_features as

select Employee_ID ,

CASE
    WHEN ï»¿Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN ï»¿Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN ï»¿Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN ï»¿Age BETWEEN 46 AND 55 THEN '46-55'
    ELSE '56+'
END AS Age_Group,

CASE
    WHEN Monthly_Income < 3000 THEN 'Low'
    WHEN Monthly_Income BETWEEN 3000 AND 6999 THEN 'Medium'
    WHEN Monthly_Income BETWEEN 7000 AND 14999 THEN 'High'
    ELSE 'Very High'
END AS Monthly_Income_Band,

CASE
    WHEN Years_At_Company <= 2 THEN 'New Hire'
    WHEN Years_At_Company BETWEEN 3 AND 5 THEN 'Early Tenure'
    WHEN Years_At_Company BETWEEN 6 AND 10 THEN 'Established'
    WHEN Years_At_Company BETWEEN 11 AND 20 THEN 'Long Tenure'
    ELSE 'Veteran'
END AS Tenure_Group,

CASE
    WHEN Total_Working_Years <= 2 THEN 'Entry Level'
    WHEN Total_Working_Years BETWEEN 3 AND 7 THEN 'Early Career'
    WHEN Total_Working_Years BETWEEN 8 AND 15 THEN 'Mid Career'
    WHEN Total_Working_Years BETWEEN 16 AND 25 THEN 'Senior'
    ELSE 'Executive'
END AS Career_Stage,

CASE
    WHEN Distance_From_Home <= 5 THEN 'Very Close'
    WHEN Distance_From_Home <= 10 THEN 'Close'
    WHEN Distance_From_Home <= 20 THEN 'Moderate'
    ELSE 'Far'
END AS Distance_Band,

CASE
    WHEN Years_With_Curr_Manager <= 2 THEN 'New'
    WHEN Years_With_Curr_Manager BETWEEN 3 AND 5 THEN 'Developing'
    WHEN Years_With_Curr_Manager BETWEEN 6 AND 10 THEN 'Established'
    ELSE 'Long-Term'
END AS Manager_Tenure_Group,

ROUND(
(
Environment_Satisfaction +
Job_Satisfaction +
Relationship_Satisfaction +
Work_Life_Balance
)/4.0,2) AS Satisfaction_Index,

ROUND(
(
Job_Involvement +
Environment_Satisfaction +
Job_Satisfaction +
Relationship_Satisfaction +
Work_Life_Balance
)/4.0,2) AS Engagement_Score,

ROUND(
Monthly_Income /
AVG(Monthly_Income) OVER(PARTITION BY Job_Role),
2
) AS Salary_vs_Role_Avg,

CASE
    WHEN Attrition='Yes'
        OR (
            Job_Satisfaction<=2
            AND Environment_Satisfaction<=2
            AND Over_Time='Yes'
        )
    THEN '1'

    ELSE '0'
END AS High_Flight_Risk,

CASE
    WHEN Years_Since_Last_Promotion>=5
        AND Job_Level<=2
    THEN '1'

    ELSE '0'
END AS Stagnation_Flag,

CASE
    WHEN Attrition='Yes' THEN 1
    ELSE 0
END AS Attrition_Binary,

CASE Education
WHEN 1 THEN 'Below College'
WHEN 2 THEN 'College'
WHEN 3 THEN 'Bachelor'
WHEN 4 THEN 'Master'
WHEN 5 THEN 'Doctor'
END AS Education_Label,

CASE Environment_Satisfaction
WHEN 1 THEN 'Low'
WHEN 2 THEN 'Medium'
WHEN 3 THEN 'High'
WHEN 4 THEN 'Very High'
END AS Environment_Satisfaction_Label,

CASE Job_Satisfaction
WHEN 1 THEN 'Low'
WHEN 2 THEN 'Medium'
WHEN 3 THEN 'High'
WHEN 4 THEN 'Very High'
END AS Job_Satisfaction_Label,

CASE Relationship_Satisfaction
WHEN 1 THEN 'Low'
WHEN 2 THEN 'Medium'
WHEN 3 THEN 'High'
WHEN 4 THEN 'Very High'
END AS Relationship_Satisfaction_Label,

CASE Work_Life_Balance
WHEN 1 THEN 'Bad'
WHEN 2 THEN 'Good'
WHEN 3 THEN 'Better'
WHEN 4 THEN 'Best'
END AS Work_Life_Balance_Label,

CASE Performance_Rating
WHEN 3 THEN 'Meets Expectations'
WHEN 4 THEN 'Excellent'
END AS Performance_Rating_Label,

CASE Stock_Option_Level
WHEN 0 THEN 'None'
WHEN 1 THEN 'Low'
WHEN 2 THEN 'Medium'
WHEN 3 THEN 'High'
END AS Stock_Option_Label
from ibm_hr_employee_attrition;

CREATE VIEW vw_employee_features AS
SELECT
    *
FROM employee_features;

select * from employee_features;
