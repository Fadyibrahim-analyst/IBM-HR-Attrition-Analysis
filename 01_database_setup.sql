
/*
===============================================================================
Project : IBM HR Employee Attrition Analysis
Database: MySQL 8.0
Dataset : IBM HR Employee Attrition
Author  : Fady Ibrahim
===============================================================================
*/

/*=========================
	Database Creation
  ========================= */
  
   drop database if exists ibm_hr_employee_attrition;
   create database ibm_hr_employee_attrition;
	use ibm_hr_employee_attrition;
    
    /*=========================
	TABLE Creation
  ========================= */
  
/*
Data Import

The dataset was imported into MySQL using the MySQL Workbench
Table Data Import Wizard by creating a new table from the CSV file.

Validation queries:
*/

SELECT COUNT(*) AS total_records
FROM ibm_hr_employee_attrition;

DESCRIBE ibm_hr_employee_attrition;

SELECT *
FROM ibm_hr_employee_attrition
LIMIT 10;
	
/*
DATA IMPORT PROCESS

1. Created a new schema named 'ibm_hr_employee_attrition'.
2. Used MySQL Workbench Table Data Import Wizard.
3. Selected the dataset file: ibm_hr_employee_attrition.csv.
4. Chose "Create New Table".
5. Imported the CSV into table `ibm_hr_employee_attrition`.
6. Verified the imported data.

Note:
The import was performed using the MySQL Workbench GUI rather than
the LOAD DATA INFILE command.
*/

		