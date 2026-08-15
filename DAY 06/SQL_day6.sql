-- SchemaName.ObjectName

SELECT *
FROM dbo.Student

-- SCHEMA --> Is a group of objects
CREATE SCHEMA HR

CREATE SCHEMA Sales

ALTER SCHEMA HR TRANSFER Student --> Now insteade of dbo.Student --> become HR.Student

ALTER SCHEMA HR TRANSFER Instructor --> Now insteade of dbo.Instructor --> become HR.Instructor

ALTER SCHEMA Sales TRANSFER Department --> Now insteade of dbo.Department --> become Sales.Department

CREATE TABLE Student --> It will run normally --> Because there isn't a table called 
(                    -- Student in this Schema --> the default schema (dbo)
 ID INT,
 NAME VARCHAR(20)
)


CREATE TABLE Sales.Student --> It will run normally --> Because there isn't a table called 
(                          -- Student in this Schema --> Sales schema     
 ID INT,
 NAME VARCHAR(20)
)


SELECT * FROM Instructor --> It won't run because the default schema is dbo
-- and this table exsists in the HR schema not the dbo schema

-- To solve it you will use the HR Schema
SELECT * FROM HR.Instructor

-- From the above --> we know that we can create 2 columns with the same name in the 
-- database but in different schema

SELECT * FROM Student

SELECT * FROM HR.Student

SELECT * FROM HumanResources.EmployeeDepartmentHistory

-- To avoid writing this long name --> I will use shortcut --> through using synonym

CREATE synonym HE
FOR HumanResources.EmployeeDepartmentHistory

SELECT * FROM HumanResources.EmployeeDepartmentHistory --> Instead of this query
--> I will write the following Query

SELECT * FROM HE
----------------------------

DROP TABLE Course --> data & Metadata(Structure)

DELETE FROM Course --> data
--> I will use DELETE If I want to delete a part of rows --> Because WHERE comes with DELETE
--> DELETE is slower than TRUNCATE But it doesn't mean that we will use TRUNCATE 
--> The reason of slow of DELETE is --> that DELETE always have been written 
--> in LOG File but TRUNCATE sometimes have been written in LOG File
--> Because the writing of DELETE in LOG FILE --> I can rollback and return the data, 
--> But I can't do that in TRUNCATE
--> DELETE doesn't make reset to the IDENTITY --> Example: If you have IDENTITY column
--> and you wrote IDs from 1 to 1000 then you DELETE all of them --> When you insert
--> it will put ID(10001) but In TRUNCATE it will reset the IDENTITY it will put ID(1)
--> If I have Parent table(PK) and Child table(FK) --> I should use DELETE with the 
--> parent and I can't use TRUNCATE with it
--> Any Parent Table --> I should use DELETE with him NOT TRUNCATE

CREATE TABLE test1
(
 ID INT IDENTITY,
 NAME VARCHAR(20)
)

INSERT INTO test1 VALUES('ali'),('ali'),('ali'),('ali'),('ali'),('ali')

SELECT * FROM test1

DELETE FROM test1

INSERT INTO test1 VALUES('omar') --> He will take ID 7 (DELETE doesn't reset the IDENTITY)

SELECT * FROM test1

TRUNCATE TABLE test1

INSERT INTO test1 VALUES('Hassan') --> He will take ID 1 (TRUNCATE reset the IDENTITY)

SELECT * FROM test1

TRUNCATE TABLE Course --> data
-- WHERE doesn't come with TRUNCATE
---------------------------------------

CREATE TABLE Dept
(
 Dep_id INT PRIMARY KEY,
 Dname VARCHAR(20)
)

CREATE TABLE emp
(
 eid INT IDENTITY(1,1),
 ename VARCHAR(20),
 eadd VARCHAR(20) DEFAULT 'Alex',
 hiredate DATE DEFAULT GETDATE(),
 sal INT,
 overtime INT,
 netsal AS(ISNULL(sal,0)+ISNULL(overtime,0)) PERSISTED, --> becomes not derived because of PERSISTED
 BD DATE,
 age AS(YEAR(GETDATE())-YEAR(BD)), --> You can't do it a PERSISTED column --> because the GETDATE() Function changes always automatocally --> because the column contains a non deterministic function --> (function related with the date)
 gender VARCHAR(1),
 hour_rate INT NOT NULL,
 did INT,
 CONSTRAINT C1 PRIMARY KEY(eid,ename), --> composite PK
 CONSTRAINT C2 UNIQUE(sal), --> accept only 1 NULL value
 CONSTRAINT C3 UNIQUE(overtime),
 CONSTRAINT C4 CHECK(sal>1000),
 CONSTRAINT C5 CHECK(eadd IN ('Cairo', 'Mansoura', 'Alex')), --> If the column that you make CONSTRAINT on it has Default value it should exsist in the CHECK CONSTRAINT
 CONSTRAINT C6 CHECK(gender = 'F' OR gender = 'M'),
 CONSTRAINT C7 CHECK(overtime BETWEEN 100 AND 500),
 CONSTRAINT C8 FOREIGN KEY(did) REFERENCES Dept(Dept_id)
 ON DELETE SET NULL ON UPDATE CASCADE
)

-- I can create these CONSTRAINES After the creation of the table
ALTER TABLE emp ADD CONSTRAINT C100 CHECK(hour_rate > 100)
--> In this case (ADD of CONSTRAINT After the Creation of the table) --> You may face 
-- a problem --> The table may have data that doesn't acheive the CONSTRAINT
--> So that the CONSTRAINT won't be created

--> IF I want to delete any CONSTRAINT
ALTER TABLE emp DROP CONSTRAINT C3

-- I want to create the following -->
-- CONSTRAINT --> Applied on the New Data
-- CONSTRAINT --> Shared between more than one table
-- Data type  --> That has a condition (CONSTRAINT) and Default value

--> To create all of above I will create a Rule
-- Rule --> It is like a CONSTRAINT but it has been created on the level of the 
-- database (schema)

ALTER TABLE Instructor ADD CONSTRAINT C200 CHECK(Salary > 1000) --> It won't run 
--> Because there are Salaries that less than 1000

CREATE RULE r1 AS @x>1000 --> Anything that contains (@) --> It means it is a variable

SP_BINDRULE r1, 'Instructor.Salary' --> Anything that begins with SP_ --> It means 
--> Built_In Stored Procedure
--> After run the query --> It will put the column (Instructor.Salary) instead of @x

--> The Rule will execute on the new data and on the old data that you update it

-- I can use the same Rule at many tables 
SP_BINDRULE r1, 'emp.overtime'

-- To delete the rule --> I should first unbined it from the table , then drop it
SP_UNBINDRULE r1, 'Instructor.Salary'

SP_UNBINDRULE r1, 'emp.overtime'

DROP RULE r1

-- The one column has only one Rule

-- We can Create default
CREATE DEFAULT def1 AS 5000

SP_BINDEFAULT def1, 'Instructor.Salary'

SP_UNBINDEFAULT def1, 'Instructor.Salary'

DROP DEFAULT def1

-- CREATE New Data type 

-- I want to create a New Data type --> his name is ComplexDT (int   >1000   default  5000)
--> To do that yhr first thing --> you should create RULE then create Default value
--> don't connect them with anything now

SP_ADDTYPE ComplexDT, 'INT' --> Copy of the Data type

SP_BINDRULE r1, ComplexDT

SP_BINDEFAULT def1, ComplexDT

CREATE TABLE test3
(
 ID INT,
 Name VARCHAR(20),
 Salary ComplexDT
)

--> You can make A CONSTRAINT and A RULE On the same column but they shouldn't be conflicted
--> The constrain will execute first then the rule will execute secondly

