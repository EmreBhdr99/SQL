--Data Definition Language (DDL)
--Perform basic data management chores (add, delete and modify)

--SHOW DATABASES
SELECT name FROM sys.databases

SELECT name FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');

EXEC sp_databases


--CREATE DATABASE
--The major SQL DDL statements are. CREATE DATABASE
CREATE DATABASE new_db;

USE new_db;

EXECUTE sp_helpindex departments;

--RENAME COLUMN
EXEC sp_rename 'Tmp_Names', 'Names'
--rename new column to old column name
EXEC sp_rename 'table1.col1', 'oldcol1', 'column'


--CREATE TABLE
--Table name is the name of the database table such as departments. Each field in the CREATE TABLE has three parts: ColumnName, Data type, Optional Column Constraint, Table Constraint
CREATE TABLE departments(
	id BIGINT NOT NULL,
	name VARCHAR(20) NULL,
	dept_name VARCHAR(20) NULL,
	seniority VARCHAR(20) NULL,
	graduation VARCHAR(20) NULL,
	salary BIGINT NULL,
	hire_date DATE NULL,
    
	CONSTRAINT pk_1 
	PRIMARY KEY (id)
);

--ALTER TABLE
--ALTER TABLE allows columns to be removed.
--You can use ALTER TABLE statements to add and drop constraints.

--ALTER TABLE tablo_adi
--{ADD{COLUMN alan alan_tipi [(boyut)][NOT NULL][CONSTRAINT indeks]
--CONSTRAINT coklu_indeks}
--DROP{COLUMN alan | CONSTRAINT constraint_adi}
--}

--ALTER ADD CONSTRAINT
ALTER TABLE departments
ADD 
CONSTRAINT unique_id_constraint 
UNIQUE (id);

--ALTER DROP CONSTRAINT
ALTER TABLE departments
DROP CONSTRAINT unique_id_constraint;

--ALTER COLUMN CHANGE DATA STRUCTURE
ALTER TABLE departments
ALTER COLUMN dept_name VARCHAR(50) NOT NULL;

--ALTER DROP COLUMN
ALTER TABLE departments
DROP COLUMN seniority;

--ALTER ADD COLUMN
ALTER TABLE departments
ADD seniority VARCHAR(20) NULL;

--DROP TABLE
--The DROP TABLE will remove a table from the database. Make sure you have the correct database selected.
DROP TABLE departments;

DROP TABLE IF EXISTS departments;

--DROP DATABASE
--The DROP DATABASE command is used to delete an existing SQL database.
DROP DATABASE new_db;

--Key Terms
--DDL: abbreviation for data definition language
--DML: abbreviation for data manipulation language
--SEQUEL: acronym for Structured English Query Language; designed to manipulate and retrieve data stored in IBM’s quasi-relational database management system, System R
--Structured Query Language(SQL): a database language designed for managing data held in a relational database management system

--Data Manipulation Language (DML)
--SELECT – to query data in the database
--INSERT – to insert data into a table
--UPDATE – to update data in a table
--DELETE – to delete data from a table

SELECT * 
FROM departments;

--INSERT
--INSERT [INTO] Table_name | view name [column_list]
--DEFAULT VALUES | values_list | select statement
INSERT departments (id, name, dept_name, seniority, graduation, salary, hire_date)
VALUES
(10238,	'Eric'	   ,'Economics'	       ,'Experienced'	,'MSc' ,72000	,'2019-12-01'),
(13378,	'Karl'	   ,'Music'	       ,'Candidate'	,'BSc' ,42000	,'2022-01-01'),
(23493,	'Jason'	   ,'Philosophy'       ,'Candidate'	,'MSc' ,45000	,'2022-01-01'),
(30766,	'Jack'     ,'Economics'	       ,'Experienced'	,'BSc' ,68000	,'2020-06-04'),
(36299,	'Jane'	   ,'Computer Science' ,'Senior'	,'PhD' ,91000	,'2018-05-15'),
(40284,	'Mary'	   ,'Psychology'       ,'Experienced'	,'MSc' ,78000	,'2019-10-22'),
(43087,	'Brian'	   ,'Physics'	       ,'Senior'	,'PhD' ,93000	,'2017-08-18'),
(53695,	'Richard'  ,'Philosophy'       ,'Candidate'	,'PhD' ,54000	,'2021-12-17'),
(58248,	'Joseph'   ,'Political Science','Experienced'	,'BSc' ,58000	,'2021-09-25'),
(63172,	'David'	   ,'Art History'      ,'Experienced'	,'BSc' ,65000	,'2021-03-11'),
(64378,	'Elvis'	   ,'Physics'	       ,'Senior'	,'MSc' ,87000	,'2018-11-23'),
(96945,	'John'	   ,'Computer Science' ,'Experienced'	,'MSc' ,80000	,'2019-04-20'),
(99231,	'Santosh'  ,'Computer Science' ,'Experienced'	,'BSc' ,74000	,'2020-05-07');

--SELECT DISTINCT item(s)
--FROM table(s)
--WHERE predicate
--GROUP BY field(s)
--ORDER BY fields;

SELECT TOP 2 id, name, dept_name
FROM departments
ORDER BY id;

--To allow an insert with a specific identity value, the IDENTITY_INSERT option should be used.
--You can't alter the existing columns for identity.
--You have 2 options,
--Create a new table with identity & drop the existing table
--Create a new column with identity & drop the existing column
SET IDENTITY_INSERT departments ON;

INSERT departments (id, name, dept_name, seniority, graduation, salary, hire_date)
VALUES (44552,	'Edmond' ,'Economics'	,'Candidate','BSc' ,60000	,'2021-12-04')

SET IDENTITY_INSERT departments OFF;

--Insert with SELECT
--You should use # for creating a temporary table.
CREATE TABLE #salary (
id BIGINT NOT NULL,
name VARCHAR (40) NULL,
salary BIGINT NULL
);

SELECT * 
FROM #salary;

--ADDING SAMPLE QUERY VALUES
INSERT #salary
SELECT id, name, salary 
FROM departments;

--Or you can use the SELECT ... INTO ... FROM statement as follow:
--CREATE TABLE AND ADDING
SELECT id, name, salary 
INTO #salary
FROM departments;

--CREATE COPY TABLE
SELECT *
INTO departments_copy
FROM departments;

SELECT * 
FROM departments_copy;

--UPDATE
UPDATE departments
SET name = 'Edward'
WHERE id = 10238;

SELECT * 
FROM departments
WHERE id = 10238;

--DELETE
--DELETE [FROM] {table_name | view_name }
--[WHERE clause];

--Deleting all rows from a table (Not recommended):
DELETE FROM departments;

--Deleting selected rows:
DELETE FROM departments WHERE id = 10238;