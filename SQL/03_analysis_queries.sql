/* ===========================
	Analysis Queries
============================== */

-- Q1: Overall Attrition Summary

select  
count(*) as total_employees ,
sum(Attrition_Binary)  as total_attrition,
round(avg(Attrition_Binary)*100,1) as attrition_rate_pct ,
round(avg(Monthly_Income),0) as avg_monthly_income ,
round(avg(Years_At_Company),1) as avg_tenure_years 
from ibm_hr_employee_attrition ibm
join employee_features ef
on ibm.Employee_ID = ef.Employee_ID
;

-- Q2 Attrition Rate by Department

select 
Department,
count(*) as  head_count ,
sum(Attrition_Binary) as attrition_count ,
round(avg(Attrition_Binary)*100,1) as attrition_rate_pct ,
round(avg(Monthly_Income),0) as avg_monthly_income 
from ibm_hr_employee_attrition ibm
join employee_features ef
on ibm.Employee_ID = ef.Employee_ID
group by Department 
order by attrition_rate_pct ;

-- Q3 OverTime x Attrition (Critical Driver)

select 
Over_Time ,
Department,
count(*) as head_count ,
sum(Attrition_Binary) as left_count ,
round(avg(Attrition_Binary)*100,1) as attrition_rate_pct 
from ibm_hr_employee_attrition ibm
join employee_features ef
on ibm.Employee_ID = ef.Employee_ID
group by Over_Time , Department 
order by Over_Time , attrition_rate_pct ;

-- Q4 Compensation vs Attrition By Role

select 
Job_Role ,
count(*) as  head_count ,
round(avg(case when Attrition = 'Yes' then Monthly_Income End) , 0) as avg_income_left ,
round(avg(case when Attrition = 'No' then Monthly_Income End) , 0) as avg_income_stayed ,
round(avg(Attrition_Binary)*100,1) as attrition_rate_pct 
from ibm_hr_employee_attrition ibm
join employee_features ef
on ibm.Employee_ID = ef.Employee_ID
group by Job_Role 
order by attrition_rate_pct ;

-- Q5 Satisfaction Deep Dive

select 
attrition ,
round(avg(Environment_Satisfaction) , 2) as avg_env_sat ,
round(avg(Job_Satisfaction) , 2) as avg_job_sat ,
round(avg(Relationship_Satisfaction) , 2) as avg_rel_sat ,
round(avg(Work_Life_Balance) , 2) as avg_wlf ,
round(avg(Satisfaction_Index) , 2) as avg_sat_index ,
round(avg(Engagement_Score) , 2) as avg_eng_score 
from ibm_hr_employee_attrition ibm
join employee_features ef
on ibm.Employee_ID = ef.Employee_ID
group by Attrition ;

-- Q6 High Flight Risk Employees

select 
ibm.Employee_ID ,
Department , Job_Role ,
Monthly_Income , Over_Time ,
Years_Since_Last_Promotion , Age_Group ,
Satisfaction_Index , Engagement_Score
from ibm_hr_employee_attrition ibm
join employee_features ef
on ibm.Employee_ID = ef.Employee_ID
where High_Flight_Risk = 1 
order by Satisfaction_Index asc , Engagement_Score asc ;

-- Q7 Promotion Stagnation Impact

select 
Stagnation_Flag ,
count(*)  as head_count ,
sum(Attrition_Binary) as leaving_flag ,
round(avg(Attrition_Binary)*100,1) as attrition_rate_pct ,
round(avg(MOnthly_Income) , 0) as avg_income ,
round(avg(Job_Satisfaction) , 2) as avg_job_sat 
from ibm_hr_employee_attrition ibm
join employee_features ef
on ibm.Employee_ID = ef.Employee_ID
group by Stagnation_Flag ;

-- Q8 Salary vs Role Average Fairness

select 
Job_Role ,
round(avg(Salary_vs_Role_Avg) , 2) as avg_salary_ratio , 
sum(case when Salary_vs_Role_Avg < 0.9 then 1 else 0 end) as underpaid_employees ,
round(avg(case when Salary_vs_Role_Avg <0.9 then Attrition_Binary end ) *100 , 1) as underpaid_attrition_rate 
from ibm_hr_employee_attrition ibm
join employee_features ef
on ibm.Employee_ID = ef.Employee_ID
group by Job_Role 
order by avg_salary_ratio asc ;

-- Q9 Income Band Segmentation

select 
Monthly_Income_Band ,
count(*) as head_count ,
sum(Attrition_Binary) as attrition_count ,
round(avg(Attrition_Binary)*100 , 1) as attrition_rate_pct ,
round(avg(Satisfaction_Index) , 2) as avg_sat
from employee_features 
group by Monthly_Income_Band 
order by field(Monthly_Income_Band , 'Low' , 'Medium' , 'High' , 'Very High') ;

-- Q10 Training & Engagement 

select 
Training_Times_Last_Year ,
count(*) as head_count, 
round(avg(Attrition_Binary)*100 , 1) as attrition_rate_pct ,
round(avg(Engagement_Score) , 2) as avg_engagement ,
round(avg(Job_Satisfaction) , 2 ) as avg_job_sat
from ibm_hr_employee_attrition ibm
join employee_features ef
on ibm.Employee_ID = ef.Employee_ID
group by Training_Times_Last_Year
order by Training_Times_Last_Year;

-- Q11 Tenure Attrition Lifecycle 

select 
Tenure_Group ,
count(*) as head_count ,
round(avg(Attrition_Binary)*100 , 1) as attrition_rate_pct ,
round(avg(Monthly_Income) , 0) as avg_income ,
round(avg(Years_Since_Last_Promotion) , 1 ) as avg_yrs_since_promo
from ibm_hr_employee_attrition ibm
join employee_features ef
on ibm.Employee_ID = ef.Employee_ID
group by Tenure_Group 
order by field(Tenure_Group , 'New Hire' , 'Early Tenure' , 'Established' , 'Long Tenure' , 'Veteran') ;

-- Q12 Salary Rank Within Role 

select ibm.Employee_ID , Job_Role , Monthly_Income ,
rank () over (partition by Job_Role order by Monthly_Income desc ) as Salary_Rank ,
round(Monthly_Income / avg(Monthly_Income) over (partition by Job_Role) , 2) as income_vs_role_avg , 
Attrition 
from ibm_hr_employee_attrition ibm
join employee_features ef
on ibm.Employee_ID = ef.Employee_ID
order by Job_Role , Salary_Rank ;

-- Q13 Attrition Risk Score

with Risk_Scores as (
select 
ibm.Employee_ID , Department , Job_Role , Monthly_Income , Attrition ,
(case when Over_Time = 'Yes' then 2 else 0 end
+ case when High_Flight_Risk = 1 then 3 else 0 end 
+ case when Stagnation_Flag = 1 then 2 else 0 end 
+ case when Satisfaction_Index < 2 then 2 else 0 end 
+ case when Monthly_Income_Band = 'Low' then 1 else 0 end )
as risk_score
from ibm_hr_employee_attrition ibm
join employee_features ef
on ibm.Employee_ID = ef.Employee_ID 
)
select * , 
case when risk_score >= 7 then 'Critical'
	when risk_score >= 4 then 'High'
    when risk_score >= 2 then 'Medium'
    else 'Low' end as Risk_Category
    from Risk_Scores
    order by risk_score desc ;