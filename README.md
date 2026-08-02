# IBM HR Employee Attrition Analysis
### End-to-End Data Analytics Project · MySQL · Power BI

![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)
![Status](https://img.shields.io/badge/Status-Complete-10B981)

---

## Project Overview

A comprehensive HR analytics project analyzing **1,470 IBM employees** to understand why people leave, who is most at risk, and what the business can do about it. The project covers the full analytics lifecycle — from raw data cleaning and SQL engineering to a 7-page interactive Power BI dashboard and executive business recommendations.

**Core business question:** *Why are employees leaving despite competitive benefits, and what structural factors drive attrition?*

**Key finding:** Attrition rate sits at **16.1%** — above the industry benchmark of 10–12% — driven by a concentrated set of fixable conditions, not a company-wide problem.

---

## Key Results

| Finding | Rate | Vs. Baseline |
|---|---|---|
| Company-wide attrition | 16.1% | Benchmark: 10–12% |
| OverTime workers attrition | 30.5% | 3× non-OT rate (10.4%) |
| Sales Representatives | 39.8% | Highest by role |
| No stock options | 24.4% | vs 9.4% with options |
| Entry-level employees (L1) | 26.3% | Highest by seniority |
| Median income gap | $2,002/month | Leavers vs Stayers |

---

## Repository Structure

```
ibm-hr-attrition-analysis/
│
├── data/
│   ├── Clean_raw_data.csv          # 1,470 employees · 32 columns · cleaned
│   └── engineered_features.csv     # 1,470 rows · 19 engineered columns
│
├── sql/
│   ├── 01_database_setup.sql       # Schema creation & data import workflow
│   ├── 02_engineered_features.sql  # Feature engineering (CREATE TABLE + VIEW)
│   └── 03_analysis_queries.sql     # 13 production analysis queries (Q1–Q13)
│
├── dashboard/
│   └── HR_Attrition_Dashboard.html # 7-page interactive HTML dashboard
│
├── docs/
│   └── data_dictionary.md          # All 51 columns documented
│
└── README.md
```

---

## Dataset

- **Source:** [IBM HR Analytics Employee Attrition & Performance](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)
- **Size:** 1,470 employees · 32 original features
- **Target variable:** `Attrition` (Yes / No) → `Attrition_Binary` (1 / 0)

### Data Quality Findings

| Issue | Count | Resolution |
|---|---|---|
| Missing values | 0 | Dataset is complete |
| Duplicate rows | 0 | All records unique |
| Zero-variance columns | 3 | Dropped (`EmployeeCount`, `Over18`, `StandardHours`) |
| Truncated performance scale | Ratings 1–2 absent | Flagged for HR review |
| Ambiguous field (`MonthlyRate`) | 1 | Excluded from analysis |

**Data quality score: 87/100**

---

## Feature Engineering (SQL + Python)

19 new columns created in `employee_features` table:

| Feature | Type | Logic |
|---|---|---|
| `Age_Group` | Categorical | 5 bands: 18-25 / 26-35 / 36-45 / 46-55 / 56+ |
| `Monthly_Income_Band` | Categorical | Low / Medium / High / Very High |
| `Tenure_Group` | Categorical | New Hire / Early / Established / Long / Veteran |
| `Career_Stage` | Categorical | Entry / Early / Mid / Senior / Executive |
| `Distance_Band` | Categorical | Very Close / Close / Moderate / Far |
| `Manager_Tenure_Group` | Categorical | New / Developing / Established / Long-Term |
| `Satisfaction_Index` | Float | Avg of 4 satisfaction dimensions (1–4 scale) |
| `Engagement_Score` | Float | Avg of JobInvolvement + SatisfactionIndex |
| `Salary_vs_Role_Avg` | Float | Monthly income ÷ role average (window function) |
| `High_Flight_Risk` | Binary | JobSat ≤ 2 AND EnvSat ≤ 2 AND OverTime = Yes |
| `Stagnation_Flag` | Binary | YearsSinceLastPromotion ≥ 5 AND JobLevel ≤ 2 |
| `Attrition_Binary` | Integer | Yes → 1, No → 0 |
| + 7 label columns | String | Human-readable Likert scale labels |

---

## SQL Analysis Queries (Q1–Q13)

All queries in `sql/03_analysis_queries.sql` join the raw table with engineered features on `Employee_ID`.

| Query | What It Answers |
|---|---|
| Q1 | Overall attrition summary — rate, avg income, avg tenure |
| Q2 | Attrition rate by department with avg income |
| Q3 | OverTime × Department attrition cross-tab |
| Q4 | Compensation vs attrition by job role |
| Q5 | Satisfaction deep dive — all 5 dimensions by attrition status |
| Q6 | High Flight Risk employee list (prioritized by satisfaction) |
| Q7 | Promotion stagnation impact on attrition |
| Q8 | Salary fairness — who earns below role average |
| Q9 | Income band segmentation with satisfaction index |
| Q10 | Training frequency vs engagement and attrition |
| Q11 | Tenure lifecycle attrition pattern |
| Q12 | Window function — salary rank within job role |
| Q13 | Composite risk score (CTE) — Critical / High / Medium / Low |

---

## Dashboard

A 7-page interactive HTML dashboard was built using real row-level data embedded in JavaScript with live dropdown filtering. All KPI cards, bar charts, donut charts, and the satisfaction radar update dynamically when filters are changed.

> **Note on tooling:** The interactive Power BI-style dashboard was created with the assistance of **Claude (Anthropic)** as an AI coding tool. All analysis logic, SQL queries, feature engineering decisions, and business interpretations are my own work. Claude was used to accelerate the HTML/CSS/JavaScript implementation of the visual layer — similar to how a developer might use GitHub Copilot for code generation.

**Pages:**
1. Executive Overview — company-wide KPIs, department attrition, OT impact
2. Workforce Demographics — age, gender, marital status, travel, education
3. Attrition Drivers — role rankings, tenure lifecycle, commute distance
4. Compensation & Career — income bands, stock options, promotion stagnation
5. Satisfaction Deep Dive — radar chart (stayers vs leavers), WLB, training
6. Attrition Risk Analysis — 2×2 risk matrix, 5-factor scoring model
7. Key Insights & Actions — consolidated findings + 3-horizon action plan

All charts use real computed data — no mock values.

---

## Business Insights

### Why people leave (even with benefits)

Money buys tolerance, not engagement. The data shows that when structural conditions — specifically overtime, career stagnation, and low satisfaction — are present, compensation becomes secondary. An employee working overtime, single, and dissatisfied has a **60.8% probability of leaving**. No salary level in this dataset reversed that fully.

### Top 5 Drivers

1. **OverTime** — 30.5% attrition vs 10.4% without (3× multiplier)
2. **Low base pay** — under $3K/month: 28.6% attrition vs 8.9% above $10K
3. **Role-level concentration** — Sales Reps (39.8%) and Lab Technicians (23.9%) drive disproportionate departures
4. **Zero stock options** — 24.4% attrition for employees with none vs 9.4% with any
5. **Career stagnation** — 127 employees flagged; attrition spikes at 7+ years without promotion

### 3-Horizon Action Plan

**Now (30 days):** Pull the 263 High Flight Risk employees and schedule stay interviews. Audit overtime in Sales and R&D. Freeze Sales Rep backfill hiring pending root-cause analysis.

**1–3 months:** Benchmark entry-level salaries against market. Expand stock options to Level 1–2 staff. Set monthly OT caps. Build visible career ladders for Sales Reps and Lab Technicians.

**6–12 months:** Structured 90-day onboarding with mentors for all Level 1 hires. Tie 20% of manager performance score to team retention. Mandate annual promotion review for employees stagnant 3+ years. Introduce hybrid/remote flexibility for far commuters.

**Estimated impact:** Reducing attrition from 16.1% to 9–11% saves approximately **$3.5M/year** in replacement costs.

---

## Tools & Stack

| Layer | Tool |
|---|---|
| Data cleaning & EDA | Python · pandas · NumPy |
| Database & queries | MySQL 8.0 · MySQL Workbench |
| Feature engineering | SQL (window functions, CASE, CTEs) + Python |
| Dashboard | HTML · CSS · JavaScript (custom · no framework) |
| Dashboard AI assist | Claude (Anthropic) — HTML/JS visual layer |
| Version control | Git · GitHub |

---

## How to Run

### MySQL Setup

```sql
-- 1. Create database and import data
SOURCE sql/01_database_setup.sql;

-- 2. Create engineered features table
SOURCE sql/02_engineered_features.sql;

-- 3. Run analysis queries
SOURCE sql/03_analysis_queries.sql;
```

Or import `data/Clean_raw_data.csv` using MySQL Workbench Table Data Import Wizard into a table named `ibm_hr_employee_attrition`, then run the SQL files in order.

### Dashboard

Open `dashboard/HR_Attrition_Dashboard.html` in any modern browser. No server required — all data is embedded. Use the dropdown filters in each page to slice the data live.

---

## Author

**Fady Ibrahim**
Data Analyst · Business Information Systems, Helwan University
Background in inventory & stock operations management

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin)](https://linkedin.com/in/fady-ibrahim-b343013b1)
[![GitHub](https://img.shields.io/badge/GitHub-Fadyibrahim--analyst-181717?logo=github)](https://github.com/Fadyibrahim-analyst)

---

*Dataset: IBM HR Analytics — publicly available on Kaggle. Used for portfolio and educational purposes.*
