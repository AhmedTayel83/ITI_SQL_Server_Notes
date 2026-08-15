USE ITI_System

-- Types of joins

  -- Cross join 
     -- Cartesian Product

  -- Inner join
     -- Equi join

  -- Outer join
     -- Left Outer join
     -- Right Outer join
     -- Full Outer join

  -- Self join (Unary / Self relationship)


-- Cartesian Product

SELECT FirstName, Dep_Name
FROM Student, Department --> It will do a Cartesian Product
--> number of rows of TABLE Student X number of rows of TABLE Department

SELECT FirstName, Dep_Name
FROM Student CROSS JOIN Department --> It will do a Cartesian Product
--> number of rows of TABLE Student X number of rows of TABLE Department

-- Cartesian Product --> We do it with using --> CROSS JOIN or COMMA (,)

-- To correct the result we will write WHERE CONDITION --> it corresponds to Equi join
-- Equi join --> We use the equal operator (=) in it
SELECT FirstName, Dep_Name
FROM Student , Department
WHERE Dep_ID = St_ID

-- If I have two columns with the same name we use this format when we select 
-- from two tables --> TableName.ColumnName1 , TableName.ColumnName2
-- Example -->
SELECT FirstName, Dep_Name
FROM Student , Department --> (,) IN THIS EXAMPLE THE COMMA IS EQUAL TO INNER JOIN
WHERE Department.Dep_ID = Student.St_ID

-- In this example It is not nessecary to use the TableName.
-- because the two tables hasn't the same name
-- we can write it like this --> WHERE Dep_ID = St_ID

-- We can use the Alias name to refer to the tables
-- Example -->

-- Without Aliasing
SELECT FirstName, Dep_Name
FROM Student , Department
WHERE Department.Dep_ID = Student.St_ID

-- With Aliasing
SELECT FirstName, Dep_Name
FROM Student S, Department D 
WHERE D.Dep_ID = S.St_ID

-- In the last example we can remove the comma and put (INNER JOIN) instead of it
-- and we can remove the WHERE and put (ON) instead of it

-- The example will be
SELECT FirstName, Dep_Name
FROM Student S INNER JOIN Department D 
ON D.Dep_ID = S.St_ID

-- Equi join and Inner join show the same result
-- Equi join and Inner join produce the same output


-- Outer join
-- The table that is after the (FROM) is the left table 
-- The table that is far from the (FROM) is the right table


-- LEFT OUTER JOIN

-- Example Of LEFT OUTER JOIN
SELECT FirstName, Dep_Name
FROM Student S LEFT OUTER JOIN Department D 
ON D.Dep_ID = S.St_ID

-- In this example it will show all the data in the Student table 
-- whether it has a Department or not

-- LEFT OUTER JOIN --> Will show the data in the left table with the shared data 
-- between the left table and the right table , if there isn't data in the 
-- right table that match the data in the left table it will put NULL VALUE
-- in the position of the right table


-- RIGHT OUTER JOIN

-- Example Of RIGHT OUTER JOIN
SELECT FirstName, Dep_Name
FROM Student S RIGHT OUTER JOIN Department D 
ON D.Dep_ID = S.St_ID


-- FULL OUTER JOIN

-- FULL OUTER JOIN = RIGHT OUTER JOIN + LEFT OUTER JOIN
-- NUMBER OF COLUMNS IN FULL OUTER JOIN = NUMBER OF COLUMNS IN RIGHT OUTER JOIN + NUMBER OF COLUMNS IN LEFT OUTER JOIN


-- SELF JOIN
--> It comes from self relationship

-- SELECT X.EName AS EmpName, Y.EName AS SuperName
-- FROM Employee X, Employee Y
-- WHERE Y.Emp_ID = X.Emp_ID  --> X (Child) --> Employee, Y (Parent) --> Supervisor 

-- SELECT X.Ename, Y.*
-- FROM Employee X, Employee Y
-- WHERE Y.eid = X.superid

------------------------------------
SELECT FirstName, D.*
FROM Student S, Department D
WHERE D.Dep_ID = S.St_ID --> The same output

SELECT FirstName, D.* --> The same output
FROM Student S INNER JOIN Department D
ON D.Dep_ID = S.St_ID


SELECT FirstName, Dep_Name
FROM Student S INNER JOIN Department D
ON D.Dep_ID = S.St_ID
WHERE Address = 'Alex' --> The same output

SELECT FirstName, Dep_Name --> The same output
FROM Student S INNER JOIN Department D
ON D.Dep_ID = S.St_ID AND Address = 'Alex'


SELECT FirstName, Dep_Name
FROM Student S, Department D
WHERE D.Dep_ID = S.St_ID
ORDER BY Dep_Name

SELECT FirstName, Dep_Name
FROM Student S, Department D
WHERE D.Dep_ID = S.St_ID AND Address = 'Alex'
ORDER BY Dep_Name


SELECT FirstName, Dep_Name
FROM Student S LEFT OUTER JOIN Department D
ON D.Dep_ID = S.St_ID

SELECT FirstName, Dep_Name
FROM Student S RIGHT OUTER JOIN Department D
ON D.Dep_ID = S.St_ID

SELECT FirstName, Dep_Name
FROM Student S FULL OUTER JOIN Department D
ON D.Dep_ID = S.St_ID


-- SELF JOIN

SELECT X.FirstName AS Sname, Y.*
FROM Student X, Student Y  --> X (Child) Student (THE TABLE THAT IT IS WITH ME IN THE DATABASE), Y (Parent) Supervisor (THE NEW TABLE)
WHERE Y.St_ID = X.Supervisor_ID --> THE TABLE WITH THE PK IS THE PARENT, THE TABLE WITH THE FK IS THE CHILD

SELECT X.FirstName AS Sname, Y.*
FROM Student X INNER JOIN Student Y  --> X (Child) Student , Y (Parent) Supervisor
ON Y.St_ID = X.Supervisor_ID
-- SELF JOIN --> DOESN'T HAVE ONE WAY IN WRITING IT --> WE HAVE TOW COPIES FROM THE SAME TABLE IN THE QUERY
-- WHEN I RUN THE QUERY IT MAKE A COPY FROM THE TABLE IN THE MEMORY NOT IN THE DATABASE

-- Jion Multi Tables
SELECT FirstName, Crs_Name, Grade --> Since you have 3 columns you will write 2 conditions for join
FROM Student S, Student_Course SC, Course C
WHERE S.St_ID = SC.St_ID AND C.Crs_ID = SC.Crs_ID

-- The same example using INNER JOIN
SELECT FirstName, Crs_Name, Grade --> Since you have 3 columns you will write 2 conditions for join
FROM Student S INNER JOIN Student_Course SC 
ON S.St_ID = SC.St_ID 
INNER JOIN Course C
ON C.Crs_ID = SC.Crs_ID


SELECT FirstName, Crs_Name, Grade, Dep_Name
FROM Student S INNER JOIN Student_Course SC 
ON S.St_ID = SC.St_ID 
INNER JOIN Course C
ON C.Crs_ID = SC.Crs_ID
INNER JOIN Department D
ON D.Dep_ID = S.St_ID-

-- Join DML

  -- join update

UPDATE Student_Course
SET Grade += 10

SELECT Grade --> The grade of the students that live in Cairo
FROM Student S, Student_Course SC
WHERE S.St_ID = SC.St_ID AND Address = 'Cairo'

UPDATE Student_Course --> Update the rows that return from join
SET Grade += 10
FROM Student S, Student_Course SC
WHERE S.St_ID = SC.St_ID AND Address = 'Cairo'

  
  -- join delete --> search for it

  -- The SQL DELETE JOIN statement allows you to delete rows from one table 
  -- based on matching conditions in another related table. 
  -- It is useful for managing linked data across multiple tables 
  -- while ensuring database consistency.

  -- Deletes rows from only one table even when multiple tables are joined.

  -- Uses joins to apply conditions based on related table data.

  -- Supports INNER JOIN, LEFT JOIN, and USING to match rows.

  -- Allows precise deletion using the WHERE clause.

  DELETE Student
  FROM Student
  INNER JOIN Department
  ON Student.St_ID = Department.Dep_ID
  WHERE Department.Dep_Name = 'HR'

-- Syntax:
   -- DELETE table1 
   -- FROM table1 
   -- JOIN table2 
   -- ON table1.attribute_name = table2.attribute_name
   -- WHERE condition;

   -- DELETE table1 
   -- FROM table1 
   -- JOIN table2 
   -- ON table1.attribute_name = table2.attribute_name AND  condition;

-- table1: The primary table from which rows will be deleted
-- table2: The table used for comparison or condition.
-- ON: Specifies the condition for the JOIN.
-- WHERE: Optional; filters which rows to delete. --> WE CAN PUT (AND) INSTEAD OF IT


  -- join insert --> search for it

  -- To insert data into a table using a JOIN, 
  -- you use the INSERT INTO ... SELECT statement combined with a JOIN clause.
  -- This allows you to combine data from multiple source tables 
  -- and insert the results directly into a destination table in a single query.

  -- Syntax Example
  -- Here is the standard way to write an INSERT statement with a JOIN:

  -- INSERT INTO destination_table (dest_column1, destcolumn2)
  -- SELECT source_table1.columnA, source_table2.columnB
  -- FROM source_table1
  -- JOIN source_table2 
  --   ON source_table1.matching_id = source_table2.matching_id;

  -- Practical Scenario: Order Summary Table

  -- Imagine you have an orders table and a customers table, 
  -- and you want to populate a new order_summaries table with
  -- the customer's name and their order ID.

  -- INSERT INTO order_summaries (order_id, customer_name)
  -- SELECT o.id, c.name
  -- FROM orders o
  -- JOIN customers c 
  -- ON o.customer_id = c.id;

  -- Important Things to Remember

  -- Match Column Counts: The number of columns in the INSERT clause 
  -- must perfectly match the number of columns returned by the SELECT query.

  -- Data Types: The data types of the selected columns 
  -- must be compatible with the destination columns.

  -- Duplicate Prevention: Using a JOIN might create multiple rows 
  -- for a single destination row. You may need to use GROUP BY or DISTINCT
  -- in your SELECT statement to avoid inserting duplicate records.



SELECT FirstName
FROM Student

SELECT FirstName
FROM Student
WHERE FirstName IS NOT NULL

-- We use The ISNULL Function to replace the Null with a specific value
-- ISNULL --> TAKE THE COLUMN --> IF THIS COLUMN HAS A VALUE IT WILL SHOW IT
-- IF THIS COLUMN HAS NULL --> IT WILL PUT THE REPLACEMENT IN IT

SELECT ISNULL(FirstName,'') --> Will replace the Null with empty string ''
FROM Student

SELECT ISNULL(FirstName,'Has No Name') --> Will replace the Null with (Has No Name)
FROM Student

SELECT ISNULL(FirstName,LastName) --> Will replace the Null with the LastName
FROM Student --> IF THR FirstName = NULL AND THE LastName = NULL --> THE RESULT WILL BE NULL

SELECT ISNULL(FirstName,LastName) AS NewName --> The Name of the column
FROM Student

-- Use use the ISNULL Function when you want to do one replacement

-- When we want to do multipule replacement you will use Coalesce() Function
-- THE Coalesce() Function TAKES AN ARRAY BUT FINALLY THE RESULT WILL BE ONE COLUMN
SELECT Coalesce(FirstName, LastName, Address, 'No Data')
FROM Student --> If the FirstName exist show it if it doesn't exist show the LastName
-- If the LastName doesn't exist show the Address
-- If the Address doesn't exist show the string 'No Data'

SELECT FirstName, Supervisor_ID
FROM Student

SELECT FirstName + ' '+ Supervisor_ID
FROM Student --> error because the 2 columns not in the same data type
--> To solve the error --> I need to convert the data type of one of them to the data type of the other

SELECT FirstName + ' '+ CONVERT(VARCHAR(2),Supervisor_ID)
FROM Student --> Will execute normally

SELECT 'StudentName = '+FirstName + ' &SupervisorID = '+ CONVERT(VARCHAR(2),Supervisor_ID)
FROM Student 


-- While doing the concatenation if one of the value of the two columns is NULL
-- AND if the null enter in any operation the result will be NULL
-- To solve this proplem I will use the ISNULL Function 

SELECT ISNULL(FirstName, '')+ ' '+ CONVERT(VARCHAR(2),ISNULL(Supervisor_ID, 0))
FROM Student
--> but this way is very complicated and it will affect on the performance
--> so that we will use the CONCAT Function

SELECT FirstName, '', Supervisor_ID
FROM Student

SELECT CONCAT(FirstName, '', Supervisor_ID)
FROM Student

--> CONCAT() --> Do two things --> The first thing --> It converts the data type of the columns to string
--> The second thing --> It removes the NULL and put empty string '' instead of it

SELECT *
FROM Student
WHERE FirstName = 'Ahmed'

--> We can put (like) instead of (=)

SELECT *
FROM Student
WHERE FirstName LIKE 'Ahmed'

-- We use (LIKE) if we know only a part of the word
--> _ (underscore) --> one char (This is the meaning of it)
--> % (percentage) --> zero or more char (This is the meaning of it)


-- If we want it show all names that start with a we use the %
SELECT *
FROM Student
WHERE FirstName LIKE 'a%' --> a + any count of characters


-- If we want it show all names that end with a we use the %
SELECT *
FROM Student
WHERE FirstName LIKE '%a' --> any count of characters + a


-- If we want it show all names that contains the character (a) at any position 
SELECT *
FROM Student
WHERE FirstName LIKE '%a%' --> any count of characters + a + any count of characters


-- If we want to show all names that contains the character (a) at the second position
SELECT *
FROM Student
WHERE FirstName LIKE '_a%'

-- 'a%h' --> string that starts with (a) and ends with (h)
-- '%a_' --> string that contains (a) at the before last position
-- 'ahm%' --> string that starts with (ahm)
-- '[ahm]%' --> string that starts with (a) or (h) or (m) --> [] --> means OR
-- '[^ahm]%' --> string that doesn't start with (a) or (h) or (m)
-- '[a-h]%' --> string that starts with character in the range from (a) to (h) --> [char1-char2] --> means range of characters that starts with char1 and ends with char2
-- '[^a-h]%' --> string that doesn't start with character in the range from (a) to (h)
-- '[346]%' --> string that starts with 3 or 4 or 6
-- '%[%]' --> string that ends with the percentage operator (%) --> the (%) that out of [] is a normal (%) but the (%) that is in the [] refers to the percentage char itself (%)
-- '%[_]%' --> string that contains the underscore char itself (_) in the center of it --> example --> ahmed_ali
-- '[_]%[_]' --> string that strats and ends with the underscore char itself (_) --> example --> _ahmed_


SELECT FirstName, Supervisor_ID
FROM Student
ORDER BY Address --> It will execute normally because you deal with the main Table
-- THE COLUMN THAT I MAKE ORDER BY WITH IT SHOULDN'T BE EXCIST IN THE SELECT STATEMENT

SELECT FirstName, Supervisor_ID
FROM Student
ORDER BY 1 --> It means ORDER BY the first column in the select --> ORDER BY FirstName column 


SELECT FirstName, Supervisor_ID
FROM Student
ORDER BY 2 --> It means ORDER BY the second column in the select --> ORDER BY Supervisor_ID column 


SELECT FirstName, Supervisor_ID
FROM Student
ORDER BY 3 --> Error --> out of range --> because you have only 2 columns in the select statement


SELECT FirstName, Supervisor_ID
FROM Student
ORDER BY FirstName, Supervisor_ID --> it will order mainly with the first column (Firstname)
--> If the first column has been repeated --> it will order the repeated values with 
--> the second column (Supervisor_ID) 

-- ASC --> ascending --> from the smallest to the largest
-- DESC --> descending --> from the largest to the smallest

SELECT FirstName, Supervisor_ID
FROM Student
ORDER BY FirstName ASC, Supervisor_ID DESC


SELECT FirstName, Supervisor_ID
FROM Student
ORDER BY St_ID, Supervisor_ID --> In this case the ORDER BY Supervisor_ID has no meaning
--> because the St_ID is not repeated so that he will never repeat with Supervisor_ID

-- I can ORDER BY multipule columns if the first column is repeated and the second 
-- column until before the last column.....
 
