SELECT *
FROM Student

-- If you want to return only the first 3 rows in the result of the Query
-- You will use Top(3)
SELECT top(3) *
FROM Student

SELECT top(3) FirstName
FROM Student

-- It will return the first 3 in Alex --> Because --> Top execute on the result of 
-- the query not the query itself
SELECT top(3) *
FROM Student
WHERE Address = 'Alex'

SELECT top(3) Salary --> It will return the first 3 salary in the result
FROM Instructor      -- not the biggest three salary

-- If I want the biggest three salary
SELECT top(2) Salary
FROM Instructor
ORDER BY Salary DESC

-- Don't write it as follow --> top(2) DISTINCT
-- Write it as follow --> DISTINCT top(2)  
SELECT DISTINCT top(2) Salary
FROM Instructor
ORDER BY Salary DESC


SELECT top(4) with ties * --> ERROR --> To execute it, you should use ORDER BY
FROM Student

SELECT top(4) with ties * --> It will return the first 4 rows from the result
FROM Student
ORDER BY FirstName

SELECT top(5) with ties * --> It will return the first 5 rows from the result
FROM Student
ORDER BY FirstName

SELECT top(3) with ties * --> In normal we excpect that it will return only 3 rows
FROM Student              -- but it returns 4 rows because --> with ties --> retuns
ORDER BY FirstName        -- the rows that is similar to the last value

-- If the fifth row and the sexth row has the same value as the third row it will
-- return them in the result --> although you make top(3) but it will return 6 rows
-- It means that it returns the last repeated value (the tail)

SELECT NEWID() --> It will return a Global Universal ID (GUID)

-- IDENTITY() --> it will make a unique ID over all the table
-- NEWID() --> It will make a unique ID over all the server --> there isn't anything 
--             in the server that takes the same ID

-- NEWID() --> It will return a randomised and unique ID

SELECT *, NEWID() --> It will return the data of student and New id with each row of it
FROM Student

--> In each run of the query --> it will return new , unique and randomised IDs

-- It will order them by NEWID() --> But actually he doesn't repeate them
-- because it order them with randomised values
SELECT *
FROM Student
ORDER BY NEWID()

-- It will return 3 random students in each run of the query
--> It is a type of randomising the data
SELECT top(3) *
FROM Student
ORDER BY NEWID() --> create random IDs that doesn't have repeated
--> So that when I make ORDER BY with unordered values --> It means that I want 
-- it to random the table (make the table be unordered)


SELECT FirstName + ' ' + LastName AS fullname
FROM Student
ORDER BY fullname --> It will execute normally

SELECT FirstName + ' ' + LastName AS fullname
FROM Student
WHERE fullname = 'ahmed ali' --> ERROR --> Because the WHERE executed before the SELECT
--> SO that when it comes to WHERE he will raise ERROR --> Because he doesn't have 
-- anything called fullname

-- Execution Order
  -- FROM
  -- JOIN
  -- ON
  -- WHERE 
  -- GROUP BY
  -- HAVING [Aggregate Functions]
  -- SELECT [DISTINCT, + Aggregate Functions]
  -- ORDER BY
  -- TOP

-- First   --> I know the tables that I will work on them USING (FROM, JOIN, ON)
-- Second  --> I will filter the rows USING (WHERE)
-- Third   --> I will devide the rows into groups USING (GROUP BY)
-- Fourth  --> I will filter the groups USING (HAVING)
-- Fifth   --> I will know what I want to show USING (SELECT)
-- Sexth   --> I will ORDER the rows USING (ORDER BY)
-- Seventh --> I will Select subset of rows USING (TOP)


SELECT FirstName + ' ' + LastName AS fullname
FROM Student
WHERE fullname = 'ahmed ali'

-- To solve the ERROR of the previous Query

-- The first solution is using the main columns
SELECT FirstName + ' ' + LastName AS fullname
FROM Student
WHERE FirstName + ' ' + LastName = 'ahmed ali'

-- The second solution is using the subquery
SELECT *
FROM (SELECT FirstName + ' ' + LastName AS fullname
      FROM Student) AS Newtable --> The alias name is essential --> If you don't do it, the query will raise an ERROR
WHERE fullname = 'ahmed ali'

-- Any subquery that comes with FROM should have an Alias name
-- It is like creating a table in runtime

SELECT *
FROM (SELECT FirstName + ' ' + LastName AS fullname
      FROM Student) --> ERROR --> Because you didn't write an Alias Name to the subquery
WHERE fullname = 'ahmed ali'

-- To solve it, you should write an Alias Name to the subquery
SELECT *
FROM (SELECT FirstName + ' ' + LastName AS fullname
      FROM Student) AS Newtable 
WHERE fullname = 'ahmed ali'


-- DB Objects [table   view    function    stored procedure     rule]
-- To reach to any object in the database --> you should cross by the default pass 
-- of it (This default pass is called --> [ServerName].[DBName].[schemaName].[ObjectName])

SELECT *
FROM Student

SELECT *
FROM [AHMED-TAYEL83\SQLEXPRESS].ITI_SYSTEM.dbo.Student

SELECT *
FROM Project --> ERROR --> Because there isn't a table in ITI_SYSTEM databse called Project

-- To solve it --> I will use the database of it
SELECT *
FROM Company_SD.dbo.Project --> It will run normally although using ITI_SYSTEM
-- But you make a connection on Company_SD database

-- I can do JOIN or UNION between a data that exsists in a database and a data that
-- exsists in another database

SELECT DName
FROM Company_SD.dbo.Project
UNION ALL
SELECT Dep_Name
FROM Department

-- I can make JOIN on two servers in the same time and work on them but the two servers
-- must be a SQL Server

SELECT *
FROM Student

-- DDL Query
SELECT * INTO Table2 --> SELECT INTO --> create a new table and put the data FROM another
FROM Student         -- table in it


SELECT *
FROM Table2

-- You can't run the same query again
SELECT * INTO Table2 --> Because you create a table with the same name 
FROM Student         -- You should change the name of the table

-- You can't do this
SELECT * INTO Student
FROM Student --> Because there is a table in the database with the same name

-- But You can do this
SELECT * INTO COMPANY_SD.dbo.Student
FROM Student --> Because in this Query you create the table in another database

-- You can take a part of the table to create another table
SELECT St_ID, FirstName INTO tab3
FROM Student
WHERE Address = 'Alex'

-- It will create an empty table --> Because the condition won't be executed
-- In this case I take the structure without the data
SELECT * INTO tab4
FROM Student
WHERE 1=2

-- The script --> is the code without data such as the code that creat the table

-- How can I separate the data from the structure and transfer it to another table
-- Note that the another table is already created
-- To make it , I will use INSERT based on SELECT

INSERT INTO tab3
VALUES (66,'ali')

-- INSERT based on SELECT
INSERT INTO tab3 --> It won't run because the structure of the two tables must be the same
SELECT * FROM Student

-- To solve it -->
INSERT INTO tab3 
SELECT St_ID, FirstName FROM Student


-- You can do HAVING without GROUP BY --> If the SELECT has Aggregate only
SELECT SUM(Salary)
FROM Instructor
HAVING COUNT(Ins_ID) < 100

--> If the SELECT has Aggregate and column --> You must do GROUP BY with HAVING

SELECT SUM(Salary)
FROM Instructor
WHERE COUNT(Ins_ID) < 100 --> ERROR

SELECT FirstName
FROM Student
HAVING COUNT(Ins_ID) < 100 --> ERROR --> Because there is a column in the SELECT
-- So that you should use GROUP BY

-- Ranking Functions
  -- Row_Number()
  -- Dense_rank()
  -- NTiles(Group)
  -- Rank()

SELECT *, Row_Number() OVER(ORDER BY salary DESC) AS RN,
DENSE_RANK() OVER(ORDER BY Salary DESC) AS DR
FROM Employee --> It will order the table with Salary DESC
--> RN --> is a column that contains sequential numbers for the rows


-- The difference between Row_Number() AND DENSE_RANK()

-- In Row_Number() --> The rows that have the same value take difference rank 
-- Example --> If you have 2rows that have the same value(10000) --> The first row 
-- will take 1 (rank) and the second row will take 2 (rank)

-- In DENSE_RANK() --> The rows that have the same value take he same rank 
-- Example --> If you have 2rows that have the same value(10000) --> The first row 
-- will take 1 (rank) and the second row will take 1 (rank)


SELECT *, Row_Number() OVER(ORDER BY salary DESC) AS RN,
DENSE_RANK() OVER(ORDER BY Salary DESC) AS DR
FROM Employee
WHERE RN = 1 --> ERROR --> because the Alias Name in the SELECT --> we can't use it 
             -- in WHERE

-- To solve the problem of the previous query I will use the subquery
SELECT *
FROM (SELECT *, Row_Number() OVER(ORDER BY salary DESC) AS RN,
DENSE_RANK() OVER(ORDER BY Salary DESC) AS DR
FROM Employee) AS New_table
WHERE RN = 1 --> It is like TOP(1) --> But the TOP(1) is faster than it


-- If I want the three biggest salary
SELECT *
FROM (SELECT *, Row_Number() OVER(ORDER BY salary DESC) AS RN,
DENSE_RANK() OVER(ORDER BY Salary DESC) AS DR
FROM Employee) AS New_table
WHERE RN = 3


-- If I want the biggest salary with repetition
SELECT *
FROM (SELECT *, Row_Number() OVER(ORDER BY salary DESC) AS RN,
DENSE_RANK() OVER(ORDER BY Salary DESC) AS DR
FROM Employee) AS New_table
WHERE DR = 1 --> It is like TOP(1) But with repetition

-- If I want the biggest two salary with repetition
SELECT *
FROM (SELECT *, Row_Number() OVER(ORDER BY salary DESC) AS RN,
DENSE_RANK() OVER(ORDER BY Salary DESC) AS DR
FROM Employee) AS New_table
WHERE DR <= 2

-- You should put these Functions in the SELESCT --> You can't put them in WHERE

-- NTile() --> It helps you to devide the table into groups
-- You define the number of groups you want then the function will devide the table
-- into this number of groups

SELECT *
FROM (SELECT *, Row_Number() OVER(ORDER BY salary DESC) AS RN,
DENSE_RANK() OVER(ORDER BY Salary DESC) AS DR,
NTILE(3) OVER(ORDER BY Salary DESC) AS G
FROM Employee) AS New_table
WHERE G = 1
--> You can't use the three functions in the same Query

-- NTile() --> First, will order the rows with the salary After that it will devide 
-- the rows into 3 groups --> If there is a remain in the division --> the decreament
-- will be in the last group --> but also the decreament shouldn't exceed 1

-- If the number of rows = 14 and I want to devide them to 3 groups
--> the number of the first group will be 5, the second group will be 5, 
--  the third group will be 4

-- If the number of rows = 13 and I want to devide them to 3 groups
--> the number of the first group will be 5, the second group will be 4, 
--  the third group will be 4


-- The RANK() function is a window function that assigns a ranking value to
-- each row within a partition of a result set, giving identical ranks to tied
-- rows and skipping subsequent ranks to leave gaps in the numbering sequence.

-- RANK() OVER (
--    [PARTITION BY partition_expression, ... ]
--    ORDER BY sort_expression [ASC | DESC], ...
--)

-- PARTITION BY (Optional): Breaks the data into groups. 
-- The ranking resets to 1 at the beginning of each group.

-- ORDER BY (Required): Determines the criteria used to sort and 
-- evaluate the ranks (highest to lowest, or lowest to highest).

-- How Gaps Work in RANK() -->  When two or more rows tie for a position,
-- they receive the exact same rank. However, the function 
-- calculates the next rank by adding the number of tied rows to the tied rank.
-- This means the resulting integers will not always be consecutive.
-- For example, if two employees tie for Rank 1, the next employee 
-- down the list skips Rank 2 and is assigned Rank 3.
--> 1 2 2 2 5 6 7 7 7 10

-- Practical Examples

-- 1. Basic Global RankingThis query ranks employees globally across the organization
-- based on their salary, starting with the highest earner.

SELECT 
    Emp_ID, 
    Salary,
    RANK() OVER (ORDER BY Salary DESC) AS GlobalSalaryRank
FROM Employee;

-- 2. Grouped Ranking using PARTITION BYThis query groups employees 
-- by their respective departments first, and then ranks them by salary 
-- within each department boundaries.

SELECT 
    Dep_ID,
    Emp_ID, 
    Salary,
    RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS DeptSalaryRank
FROM Employee;


-- Partition by
SELECT *,ROW_NUMBER() OVER(PARTITION BY Dep_ID ORDER BY Salary DESC) AS RN,
DENSE_RANK() OVER(PARTITION BY Dep_ID ORDER BY Salary DESC) AS DR
FROM Employee

-- PARTITION BY --> IS LIKE GROUPING 
-- The rows disappeared in GROUPING
-- The rows didn't disappear in PARTITION BY --> it will divide the table into groups only

-- PARTITION BY --> In first --> It will divide the table into groups 
                -- After that --> It will ORDER each group by the column that exsits in ORDER BY
                -- After that --> It will write the number to each partition alone
                -- The function will be executed on each partition alone (As he doesn't see the other partitions)

-- If I want the data of the biggest Salary in each Department
SELECT *
FROM(SELECT *,ROW_NUMBER() OVER(PARTITION BY Dep_ID ORDER BY Salary DESC) AS RN,
DENSE_RANK() OVER(PARTITION BY Dep_ID ORDER BY Salary DESC) AS DR
FROM Employee) AS NewTable
WHERE RN=1
--> This will show the full row
-- It is like using MAX() + GROUP BY --> but MAX() + GROUP BY disappear the row
-- but the Partition doesn't disappear the row and show the full data of it


-- If I want the data of the third biggest Salary in each Department
SELECT *
FROM(SELECT *,ROW_NUMBER() OVER(PARTITION BY Dep_ID ORDER BY Salary DESC) AS RN,
DENSE_RANK() OVER(PARTITION BY Dep_ID ORDER BY Salary DESC) AS DR
FROM Employee) AS NewTable
WHERE RN=3 -->



-- If I want the data of the biggest Salary in each Department with repetition
SELECT *
FROM(SELECT *,ROW_NUMBER() OVER(PARTITION BY Dep_ID ORDER BY Salary DESC) AS RN,
DENSE_RANK() OVER(PARTITION BY Dep_ID ORDER BY Salary DESC) AS DR
FROM Employee) AS NewTable
WHERE DR=1 -->


-- If I want the data of the biggest two Salary in each Department with repetition
SELECT *
FROM(SELECT *,ROW_NUMBER() OVER(PARTITION BY Dep_ID ORDER BY Salary DESC) AS RN,
DENSE_RANK() OVER(PARTITION BY Dep_ID ORDER BY Salary DESC) AS DR
FROM Employee) AS NewTable
WHERE DR<=2 -->


SELECT *, ROW_NUMBER() OVER(ORDER BY Address DESC) AS RN
FROM Student

SELECT *, DENSE_RANK() OVER(ORDER BY Address DESC) AS DR
FROM Student


SELECT *, ROW_NUMBER() OVER(ORDER BY Address DESC) AS RN
FROM Student
WHERE RN = 1 --> ERROR --> Because the order of execution

-- To solve the error I will use the subquery
SELECT *
FROM (SELECT *, ROW_NUMBER() OVER(ORDER BY Address DESC) AS RN
FROM Student) AS NewTable
WHERE RN = 1

SELECT *, DENSE_RANK() OVER(ORDER BY Address DESC) AS DR
FROM Student
WHERE DR = 1 --> ERROR --> Because the order of execution

-- To solve the error I will use the subquery
SELECT *
FROM(
SELECT *, DENSE_RANK() OVER(ORDER BY Address DESC) AS DR
FROM Student) AS NewTable1
WHERE DR = 1


SELECT *
FROM(
SELECT *, DENSE_RANK() OVER(ORDER BY Address DESC) AS DR
FROM Student) AS NewTable1
WHERE DR = 2


-- I will use the PARTITION BY
SELECT *
FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY Gender ORDER BY Address DESC) AS RN
FROM Student) AS NewTable
WHERE RN = 1


SELECT *
FROM(
SELECT *, DENSE_RANK() OVER(PARTITION BY Gender ORDER BY Address DESC) AS DR
FROM Student) AS NewTable1
WHERE DR = 1


-- If I want the data of employees of each Department without repetition
SELECT *
FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY Dep_ID ORDER BY Age DESC) AS RN
FROM Employee) AS NewTable
WHERE RN = 1


-- If I want the data of employees of each Department with repetition
SELECT *
FROM (SELECT *, DENSE_RANK() OVER(PARTITION BY Dep_ID ORDER BY Age DESC) AS DR
FROM Employee) AS NewTable
WHERE DR = 1


SELECT *, NTILE(4) OVER(ORDER BY Age DESC) AS G
FROM Employee

SELECT *
FROM(
SELECT *, NTILE(4) OVER(ORDER BY Age DESC) AS G
FROM Employee) AS NewTable
WHERE G = 1

-------------------------------Data types

-----------------Numeric Data type

-- bit      --> bool     0:1     true:false
-- tinyint  --> 1 Byte --> allow values from -128:+127    unsigned --> allow values from 0:255
-- smallint --> 2 Byte --> allow values from -32,768:+32,767  unsigned --> allow values from 0:65,535
-- int      --> 4 Byte
-- bigint   --> 8 Byte

-----------------Decimal Data type

-- smallmoney --> 4 Byte --> allow 4 decimal values  .0000
-- money      --> 8 Byte --> allow 4 decimal values  .0000
-- real       -->        --> allow 7 decimal values  .0000000
-- float      -->        --> allow .000000000000000000000000000000
-- dec        --> decimal--> is a data type and a validation on the data type
              --> dec(5,2) is a number contains 3 digit and 2 decimal values --> xxx.xx --> 132.87

-----------------Char Data type

-- char() --> [fixed length character] --> char(10) --> although you write ahmed he will allocate 10 byte --> ahmed 10 , ali 10
-- varchar() --> [variable length character] --> ahmed 5(will allocate 5 byte), ali 3(will allocate 3 byte)
-- nchar()   --> unicode --> If you will use another language
-- nvarchar() --> unicode --> If you will use another language
-- nvarchar(max) --> If I don't know the maximum of words that I will write --> It arrives up to 2GB
-- The number in () is the maximum

-----------------DateTime

-- Date --> MM/DD/yyyy
-- Time --> hh:mm:ss --> ss can be divided by 1000 to be nanosecond --> I can write 12.765 --> This is the default --> time(3)
-- time(7) --> hh:mm:ss --> ss can be divided by 10000000 to be nanosecond --> I can write 12.7659876
-- smalldatetime --> If I want date + time together --> MM/DD/yyyy hh:mm:00 --> seconds here is zeros --> but the range of the year is small --> it accept +30 year and - 30 year but doesn't accept for example +200 year (2200) and -200 year (1826)
-- datetime --> MM/DD/yyyy hh:mm:ss.987 --> If you want more range for year and seconds --> In this case you will divide the seconds on 1000
-- datetime2(7) --> MM/DD/yyyy hh:mm:ss.9879876 --> If you want more range for year and seconds --> In this case you will divide the seconds on 10000000
-- datetimeoffset --> (data + time + time zone) --> 11/24/2020 10:30  +2:00 --> time zone of cairo

-----------------Binary Data type

-- binary   0111100    11111100
-- image (you can save the images as binaries into the database)

-----------------Others

-- XML
-- unique_identifier
-- sql_variant
--------------------------------------------------------------------
-- DB Engine
-- types of instances         types of authentications
-- TOP                SELECT INTO
-- Ranking
-- Data types

--------------------------------------------------------------------
SELECT *
FROM Instructor

SELECT  FirstName,
        CASE 
        WHEN Salary >= 3000 THEN 'High sal'
        WHEN Salary < 3000 THEN 'Low sal'
        ELSE 'No value'
        END AS Newsal
FROM Instructor


SELECT  FirstName, Salary,
        CASE 
        WHEN Salary >= 3000 THEN 'High sal'
        WHEN Salary < 3000 THEN 'Low sal'
        ELSE 'No value'
        END AS Newsal
FROM Instructor


-- You can use the CASE WHEN in the SELECT and in the UPDATE
UPDATE Instructor --> this query will increase the salary of all instructors with 20%
SET Salary = Salary*1.20

UPDATE Instructor 
SET Salary =
CASE 
WHEN Salary >= 3000 THEN Salary*1.10
ELSE Salary*1.20
END


SELECT  FirstName, Salary,
        CASE 
        WHEN Salary >= 3000 THEN 'High sal'
        WHEN Salary < 3000 THEN 'Low sal'
        ELSE 'No value'
        END AS Newsal
FROM Instructor

-- You can use IIF() instead of CASE WHEN
SELECT FirstName, IIF(Salary >= 3000, 'High sal', 'Low sal')
FROM Instructor --> We use it, if the problem is considered as IF, ELSE only
--> It means that you haven't multipule conditions

-- IIF(condition, true, false)

----------------------------------------
SELECT CONVERT(VARCHAR(20), GETDATE())
--> They will return the same result --> The difference between them is the syntax
SELECT CAST(GETDATE() AS VARCHAR(20))

--> The clear difference between them is the dealing with the date
-- When you convert the date to string -->In this case --> COVERT() is better than CAST()
-- Because the CONVERT() take third parameter (number) that express the format of the date

SELECT CONVERT(VARCHAR(20), GETDATE(), 102)
SELECT CONVERT(VARCHAR(20), GETDATE(), 103)
SELECT CONVERT(VARCHAR(20), GETDATE(), 104)
SELECT CONVERT(VARCHAR(20), GETDATE(), 105)

-- Because it is difficult for us to memorize the format of each number --> 
-- he invent the format function --> You can give it the format of date as string

SELECT FORMAT(GETDATE(), 'dd-MM-yyyy')
SELECT FORMAT(GETDATE(), 'dddd MMMM yyyy')
SELECT FORMAT(GETDATE(), 'ddd MMM yy')
SELECT FORMAT(GETDATE(), 'dddd')
SELECT FORMAT(GETDATE(), 'MMMM')
SELECT FORMAT(GETDATE(), 'hh:mm:ss')
SELECT FORMAT(GETDATE(), 'HH')
SELECT FORMAT(GETDATE(), 'hh tt')
SELECT FORMAT(GETDATE(), 'dd-MM-yyyy hh:mm:ss tt')

SELECT FORMAT(GETDATE(), 'dd') --> raturn a string
SELECT DAY(GETDATE()) --> return an integer

SELECT EOMONTH(GETDATE()) --> It takes a date and returns a date
--> It returns the last day in the month that I give it

-- If I want to know the last day in the month is a weekend or not --> I will use FORMAT()\
SELECT FORMAT(EOMONTH(GETDATE()), 'dddd')

-- -- If I want to know the last day in the month is 30 or 31
SELECT FORMAT(EOMONTH(GETDATE()), 'dd')

SELECT EOMONTH('1/1/2000')

