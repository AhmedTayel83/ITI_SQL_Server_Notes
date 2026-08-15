SELECT Salary
FROM Instructor

SELECT SUM(Salary)
FROM Instructor

SELECT MIN(Salary) AS Min_Value, MAX(Salary) AS Max_Value
FROM Instructor

SELECT COUNT(*), COUNT(St_ID), COUNT(LastName)
FROM Student

SELECT *
FROM Student


SELECT AVG(Age) --> In this query he sum and devided on the number of people that have age only
FROM Student

--> They are the same query but they don't return the same value

SELECT SUM(Age)/COUNT(*) --> In this query he sum and devided on the number of all rows
FROM Student --> (People that have an age and people that have NULL value in the field of the Age)


-- To make them return the same value we will use the ISNULL() Function in the first query
SELECT AVG(ISNULL(Age, 0)) 
FROM Student

SELECT SUM(Age)/COUNT(*)
FROM Student

--> IN This Case The Two queries will return the same value 

SELECT SUM(Salary), Dep_Id
FROM Instructor --> ERROR --> Because you must do GROUP BY To The column that 
-- doesn't exsit in the Aggregate Function

-- TO solve the error we will do that
SELECT SUM(Salary), Dep_Id
FROM Instructor
GROUP BY Dep_Id

-- Use must but the columns that doesn't exsit in the Aggregate Functions in the GROUP BY

SELECT SUM(Salary), Dep_Id, FirstName
FROM Instructor --> ERROR --> Because The FirstName Column doesn't exsit in the
GROUP BY Dep_Id -- GROUP BY 

--> TO SOLVE IT , YOU MUST PUT THE FirstName ALSO IN THE GROUP BY
SELECT SUM(Salary), Dep_Id, FirstName
FROM Instructor
GROUP BY Dep_Id, FirstName


SELECT SUM(Salary), Dep_ID, Dep_Name
FROM Instructor I
INNER JOIN Department D
ON I.Dep_ID = D.Dep_ID
GROUP BY D.Dep_ID, Dep_Name

SELECT AVG(st_age), Address, Dep_ID
FROM Student
GROUP BY Address, Dep_ID

-- When I make GROUPING With * --> It means that I make grouping with PK
--> It means that the GROUPING has no meaning --> Because in this case you
-- make each row --> considered as a group 

SELECT AVG(st_age), *
FROM Student
GROUP BY *

SELECT AVG(st_age), St_ID
FROM Student
GROUP BY St_ID

--> The tow query are the same and they return the same result

-- I don't make GROUP BY with PK OR with *
-- I make GROUP BY with any repeated column

SELECT SUM(Salary), Dep_ID --> It will return the all groups
FROM Instructor
GROUP BY Dep_ID

SELECT SUM(Salary), Dep_ID --> It will return also the all groups
FROM Instructor --> Because the WHERE doesn't effect the groups itself
WHERE Salary > 1000 --> but it effects on the values that return with each group
GROUP BY Dep_ID


SELECT SUM(Salary), Dep_ID --> It will return the all groups (3 rows in this case)
FROM Instructor
GROUP BY Dep_ID

SELECT SUM(Salary), Dep_ID --> It will not return the all groups (1 row in this case)
FROM Instructor --> Because HAVING effect on the groups itself
GROUP BY Dep_ID
HAVING SUM(Salary) > 100000


-- The Aggregate Functions that Exsits in the Select Statement don't have to be 
-- the Aggregate Functions that Exsits in the HAVING Statement

SELECT SUM(Salary), Dep_ID
FROM Instructor
GROUP BY Dep_ID
HAVING COUNT(Ins_ID) < 5

---------------------------------------

-- Subqueries
--> I will take the output of the query as an input to another query
--> You can use the subqueries with SELECT, UPDATE, DELETE, INSERT

SELECT *
FROM Student
WHERE Age < AVG(Age)--> ERROR --> Because the Aggregate Functions don't come with the where statement

-- To solve it , I must use HAVING --> When I use HAVING, I must use GROUP BY
-- When I use GROUP BY, I shouldn't use (*) --> because it doesn't have meaning in 
-- the GROUP BY

-- But I want to use the Aggregate Function in the WHERE statement SO that I Will
-- use it in a subquery

SELECT *
FROM Student
WHERE Age < (SELECT AVG(Age) FROM Student) --> This query devided in two parts 
-- (Outer Query) AND (Inner Query)
-- The Inner Query will execute before the Outer Query

-- In the previous query --> The average of the age equal to 23
-- So that the previous query equal to this query
SELECT *
FROM Student
WHERE Age < 23 --> 23 = (SELECT AVG(Age) FROM Student)


SELECT *, COUNT(St_ID) --> ERROR --> Because we should do GROUP BY(*) --> But it doesn't
FROM Student -- have meaning --> So that we will use the subquery

SELECT *, (SELECT COUNT(St_ID) FROM Student)
FROM Student

-- In the previous query --> COUNT(St_ID) = 14
-- So that it equal to this query

SELECT *, 14 --> 14 = (SELECT COUNT(St_ID) FROM Student)
FROM Student

-- You can write the subquery at any position In(SELECT, FROM, WHERE, HAVING ....)
-- But it doesn't mean that the outer query and the inner query should be on the same table
-- and doesn't mean that the subqueries used to solve the Aggregate Functions Only


-- You can write a subquery that return a value from two defferent tables And without
-- using Aggregate Functions

SELECT Dep_Name --> In this query he want names of departments that have students
FROM Department
WHERE Dep_ID IN (SELECT DISTINCT(Dep_ID) 
                 FROM Student
                 WHERE Dep_ID IS NOT NULL)

-- In the subquery that return more than one value we use (IN, NOT IN) , we don't use (=)
-- In the subquery that return only one value we use (=)

SELECT Dep_Name --> In this query he want names of departments that don't have students
FROM Department
WHERE Dep_ID IN (SELECT DISTINCT(Dep_ID) 
                 FROM Student
                 WHERE Dep_ID IS NOT NULL)


SELECT Dep_Name 
FROM Department
WHERE Dep_ID IN (SELECT DISTINCT(Dep_ID) 
                 FROM Student
                 WHERE Dep_ID IS NOT NULL)

-- We can write the above query using join (Join is faster than the subquery)
SELECT DISTINCT Dep_Name
FROM Student S 
INNER JOIN Department D
ON D.Dep_ID = S.Dep_ID

-- In the performance --> Join is better than Subquery
-- There are defferent princibles that may change it like the number of Joins
-- If I have 5 Joins ON 5 Tables and One subquery --> In this case the subquery is
-- better than 5 Joins
-- You must check the number of Joins 

-- If I have a subquery and I have two tables that have a relationship between them
-- the engine will convert the subquery to Join


-- We can use the subqueries with DML Queries
-- Subqueries + DML

DELETE FROM Student_Course
WHERE St_ID = 1

DELETE FROM Student_Course
WHERE St_ID IN (SELECT St_ID FROM Student
               WHERE Address = 'cairo')

-- We can use Join and Subqueries with DML
-------------------------------------------

-- UNION FAMILY
-- UNION ALL     -- UNION       -- INTERSECT      -- EXCEPT

SELECT FirstName
FROM Student

SELECT FirstName
FROM Instructor


SELECT FirstName
FROM Student
UNION ALL   --> It will put the result from two queries above each other
SELECT FirstName --> The number of rows = The number of student_rows + The number of instructor_rows
FROM Instructor --> In the output he will put the name of the first column as the name of the new column


SELECT FirstName, St_ID
FROM Student
UNION ALL
SELECT FirstName
FROM Instructor --> ERROR --> Because the number of columns in the first SELECT
                -- should be equal to the number of columns in the second SELECT

SELECT St_ID
FROM Student
UNION ALL
SELECT FirstName
FROM Instructor --> ERROR --> Because the Domain (Data type) in the first SELECT (Column)
                -- should be the same as the coulmn of the second SELECT

-- UNION ALL --> allow the repeated values  --> It keeps the suplicates --> Faster
-- UNION --> take the distinct and unique values --> It drop the duplicates --> Slower

SELECT St_ID
FROM Student
UNION  --> It will show the unique names of students and instructors
SELECT FirstName
FROM Instructor

-- UNOIN --> Has the same conditions as UNION ALL --> 
--   1       The number of columns in the first SELECT Statement should be equal to 
--           the Number of columns in the second SELECT Statement
--   2       The Domain (Data type) in the First SELECT Statement should be the same
--           as the Second SELECT Statement 


-- Intersect --> return the common values that exsit in the tow SELECT Statement
-- Intersect --> It returns the Distinct and Unique values between the two SELECT Statements

-- UNION , INTERSECT, EXCEPT --> they make DISTINCT --> It means that they order the 
--                               values and drop the duplicate (repeated) values

SELECT St_ID
FROM Student
INTERSECT  --> It will show the unique common names of students and instructors
SELECT FirstName
FROM Instructor

-- INTERSECT --> Has the same conditions as UNION ALL and UNION --> 
--   1       The number of columns in the first SELECT Statement should be equal to 
--           the Number of columns in the second SELECT Statement
--   2       The Domain (Data type) in the First SELECT Statement should be the same
--           as the Second SELECT Statement 


-- EXCEPT --> It returns the UNIQUE RESULT SET That Exsits in The First SELECT Statement
--            and doesn't exsit in the Second SELECT Statement

SELECT St_ID
FROM Student
EXCEPT  --> It will show the unique names of students that aren't similar to instructors_name
SELECT FirstName
FROM Instructor

--> IN the UNION FAMILY (UNION ALL, UNION, INTERSECT, EXCEPT) --> We can work on them
-- without a relationship between the columns

-------------------------------------------

-- You can make ORDER BY with column that doesn't exsit in the SELECT Statement

SELECT FirstName, Age, Dep_ID
FROM Student
ORDER BY Address --> This Query will run normally


SELECT FirstName, Age, Dep_ID
FROM Student
ORDER BY 1 --> This means ORDER BY (The first column in the SELECT ) FirstName

SELECT FirstName, Age, Dep_ID
FROM Student
ORDER BY 2 --> This means ORDER BY (The second column in the SELECT ) Age

SELECT FirstName, Age, Dep_ID
FROM Student
ORDER BY 4 --> ERROR --> Because this means order by the fourth table in the SELECT
--                       and you have only three columns in the SELECT


--You can do ORDER BY with two columns

SELECT FirstName, Age, Dep_ID
FROM Student
ORDER BY Dep_ID, Age --> He will order by Dep_ID in the first After that the recorders
                     -- that have the same Dep_ID he will order them with Age
                     -- It is like sub orders (Order in another Order


SELECT FirstName, Age, Dep_ID
FROM Student
ORDER BY Dep_ID ASC, Age DESC


-- If the first column doesn't repeat , the ORDER BY has no meaning
SELECT FirstName, Age, Dep_ID
FROM Student
ORDER BY St_ID, Age

-- When I make ORDER BY with two columns --> The first column must be repeated

-- We can't do (UPDATE OR DELETE) Parent that has a child
DELETE FROM Department
WHERE Dep_ID = 20 --> ERROR --> Because there is a relationship between Department and Student

UPDATE Department SET Dep_ID = 4000 
WHERE Dep_ID = 20 --> ERROR --> Because there is a relationship between Department and Student

-- The solution of the previous problem (UPDATE , DELETE) -->
-- You should fix the tables that have a relationship with this table before anything

DELETE FROM Department
WHERE Dep_ID = 20 
--> In the previous Query You should delete the Dep_ID From Student Table And Instructor Table
-- You do that manualy with Queries
-- After that you can do the deletion and the UPDATE without any ERROR

UPDATE Department SET Dep_ID = 4000 
WHERE Dep_ID = 20


-- BuiltIn Functions
-- Aggregate Functions
-- getdate()    ISNULL() 
-- coalesce()   YEAR()      CONCAT()     CONVERT()

SELECT YEAR(GETDATE())

SELECT MONTH(GETDATE())

-- If I want a part of a word, I will use SUBSTRING()

SELECT SUBSTRING(FirstName, 1, 3) --> It will return the first 3 characters from the FirstName
FROM Student --> 1 (The start index), 3 (The length)

SELECT SUBSTRING(FirstName, 3, 3) --> It will return the third , fourth and fifth character
FROM Student --> It will return the characters that it is in index(3,4,5)

-- I want to know the name of the Database that I work on it
-- I will use db_name()

SELECT db_name()

-- I want to know the name of the user that login on the database (server) and run it
-- I will use suser_name()

SELECT suser_name() --> Usually it will be the name of the user of the windows

