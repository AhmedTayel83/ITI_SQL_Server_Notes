-- VARIABLES

-- Local Variable             -- Global Variable

-- Local Variable

-- To Declare a variable --> Declare @VariableName DataType
--> The initial value of the variable is the NULL value

DECLARE @x INT

--> To assign a value to the variable , there are 4 wayes
-- Don't forgit the (@) with the variable --> because it is a part of the variable

-- 1 --> Set @VariableName = Value
Set @x = 10

-- 2 --> Select @VariableName = Value
SELECT @x = 100

-- 3 --> You can write the normal Query of SELECT and take the result to assign it at a variable
SELECT Age FROM Student WHERE St_ID = 1 --> The normal Query 
SELECT @x = Age FROM Student WHERE St_ID = 1 --> The assign Query

-- 4 --> You can write the normal Query of UPDATE and take the result to assign it at a variable
UPDATE Student Set FirstName = 'Omar', Age = 20 WHERE ID = 9 --> The normal Query
UPDATE Student Set FirstName = 'Omar', @x = Age WHERE ID = 9 --> I will take the value
-- of the age in the variable --> This Query is like a UPDATE and SELECT Statement in
-- the same time 
--> In the previous Query I tell him to update the variable with the value that returns
-- from Age

--> To show the result of The variable --> SELECT @VariableName
SELECT @x

-- I must highlight the 3 phases in the same batch to show the Result of the variable
-- Declare @x
-- Assign the value to @x --> Select @x = 10
-- Show the value of x --> Select @x

-- If I want to Declare and initialise the variable in the same Query 
--> I will use this --> Declare @VariableName DataType = Value
DECLARE @x INT = 100


-- Global Variable

-- I can't Declare a Global Variable
-- I can't assign a value to a Global Variable
--> It is like variables that exsists in the server that affected with the events 
-- that occur in the server --> So that I can only show the values that exsist in it

-- All Global Variables start with @@

SELECT @@SERVERNAME --> It returns the name of the server that you work on it --> It is
-- usually the name of your device

SELECT @@ROWCOUNT --> If I want to know the number of rows that affected scince the 
-- last Query that I run it

-- All of Global Variables affected with the last Query (Statement) you run it

SELECT @@VERSION --> It ruturns the version Of SQL Server that you work on it --> It is
-- very useful because there are some of queries that work on spicific version

SELECT @@ERROR --> If I run a Query and this Query doesn't return an ERROR , it will
-- return 0 --> This means that the last Query that I run it didn't return an error
-- If I run a Query and it ruturns an ERROR --> Usually these ERROR has shown as a
-- message bellow and there is a number for each ERROR --> So that If I run a Query
-- that has an ERROR --> The number of ERROR message will be shown in the @@ERROR
-- If you want to run a Query and you want to know if this query return or doesn't 
-- return an ERROR and you want to know the kind of the ERROR --> You will use -->
-- SELECT @@ERROR --> If it returns 0 --> It means the Query doesn't have an ERROR
-- But if it returns a number --> It means this is the number of the ERROR message that
-- exsists in the SQL Server

SELECT @@IDENTITY --> It will retun the last IDENTITY that enter the table from the 
-- last Insert --> When you run an Insert on a table that has an IDENTITY and you 
-- want to know the number of the value of the IDENTITY that entered --> you will write
-- SELECT @@IDENTITY --> If you run an INSERT statement on a table that doesn't have an
-- IDENTITY --> When you write --> SELECT @@IDENTITY --> It will have a NULL Value

-- I can assign the value of the Global variable into a Local Variable 
-- but not viseversa(the opposite) --> It means that -->
-- I can't assign the value of the Local Variable into a Global variable
SELECT @x = @@ROWCOUNT

SELECT @@ROWCOUNT = @x --> ERROR 

-- The First thing before Declaring and Using variables you should use the Database 
-- that you will work on it
USE ITI_System

DECLARE @x INT --> you should highlight the 3 lines and run them together to show the result
Set @x = 10   -- they should be in the same batch
SELECT @x

DECLARE @x INT
SELECT @x = 10
SELECT @x

DECLARE @x INT = 10
SELECT @x

DECLARE @x INT = (SELECT AVG(Age) FROM Student)
SELECT @x

DECLARE @y INT
SELECT @y = Age FROM Student WHERE St_ID = 6
SELECT @y

-- This Query doesn't return a value So that the variable will save the last value that
-- exsists in it and doesn't put a NULL Value in it
-- The Query doesn't return a value --> because I don't have an ID 990 
DECLARE @y INT
SELECT @y = Age FROM Student WHERE St_ID = 990
SELECT @y

-- I have a lot of rows that have the same Address (Alex) So that the Select will return
-- an array of values --> The variable will take the last value in the array
DECLARE @y INT
SELECT @y = Age FROM Student WHERE Address = 'Alex'
SELECT @y

-- If you use the variable with the SELECT statement that doesn't return a result 
--> The variable will save the value that exsists in it without any update

-- If you use the variable with the SELECT Statement that returns a one value 
--> The variable will take this value as a new value for it

-- If you use the variable with the SELECT Statement that returns an array of values
--> The variable will take the last value of the array as a new value for it

-- The initial value of the variable is the NULL value

-- This query won't run because in this case --> you use the SELECT to Show and Assign
-- a value
DECLARE @y INT
SELECT @y = Age,FirstName FROM Student WHERE St_ID = 4
SELECT @y

-- To solve it you should declare another variable
DECLARE @y INT, @name VARCHAR(20)
SELECT @y = Age,@name = FirstName FROM Student WHERE St_ID = 4
SELECT @y, @name


DECLARE @z INT
UPDATE Student Set FirstName = 'Ali', @z = Dep_ID
WHERE St_ID = 7
SELECT @z -- I will know the number of Department of Ali


-- If the Select Statement returns an Array and you want to save the all values in 
-- the array not only the last value --> I will Declare a variable that the kind of it
-- is a table --> and I will convert it to Select Statement based on SELECT
-- this table is a table that exsists in the memory and doesn't exsist physically 
-- in the database --> this table will take the array of values that will return 
-- from the query

DECLARE @t table(x INT) --> @t (is the variable name), x (is the name of the column that exsists in the variable)
INSERT INTO @t --> It becomes an INSERT based on SELECT
SELECT St_Id FROM Student WHERE Address = 'Alex'
SELECT * FROM @t


-- I can use more than one column in the table
DECLARE @t table(x INT, y VARCHAR(20))
INSERT INTO @t
SELEcT St_Id, FirstName FROM Student WHERE Address = 'Alex'
SELECT * FROM @t

-- We know that the Top() takes static number 
SELECT TOP(2) *
FROM Student

-- We can make the TOP() works dynamically through using a variable in it
DECLARE @x INT = 4
SELECT TOP(@x) *
FROM Student


DECLARE @col VARCHAR(20) = '*', @tab VARCHAR(20) = 'student'
SELECT @col FROM @tab --> ERROR --> because the @tab is a string variable --> I should
-- use a variable that its kind is a table --> You should put a name of table with FROM

--> The previous Query is like the Following
SELECT '*' FROM 'student'

SELECT 'SELECT * FROM Student' --> It will show the statement 

-- To solve the problem --> I will use the execute() Function --> It takes a string
-- and convert this string to a query if it is possible and run it
EXECUTE('SELECT * FROM Student') 

-- So that I can use the EXECUTE() function with the variable

DECLARE @col VARCHAR(20) = '*', @tab VARCHAR(20) = 'student'
SELECT @col FROM @tab --> ERROR

-- To solve the ERROR I will use the EXECUTE() function and the concatenation
DECLARE @col VARCHAR(20) = '*', @tab VARCHAR(20) = 'student'
EXECUTE('SELECT' + @col + 'FROM' + @tab) --> It is like (SELECT * FROM Student)
--> This is a Dynamic Query

DECLARE @col VARCHAR(20) = '*', @tab VARCHAR(20) = 'Instructor' --> I changed the table
EXECUTE('SELECT' + @col + 'FROM' + @tab) --> For this reason , It is a dynamic query

---------------------------
-- Global Variables

SELECT @@SERVERNAME

SELECT @@VERSION

UPDATE Student
SET Age += 1

-- There is two things in the window that exsists below in the SQL Server --> 
-- (Message + Result)  --> The message hasn't been returned to the Application
--> The thing that has been returned to the Application is the Result

-- So that If I want to know the number of rows that have been affected with the Query
-- that I run it --> I will write --> SELECT @@ROWCOUNT

UPDATE Student
SET Age += 1
SELECT @@ROWCOUNT

UPDATE Student
SET Age += 1
SELECT @@ROWCOUNT
SELECT @@ROWCOUNT --> This Second @@ROWCOUNT will always return 1 --> Because it shows
-- the number of rows that have been affected with the last query that I run it 
-- and the last Query that I run it is SELECT @@ROWCOUNT that before the second
-- SELECT @@ROWCOUNT

SELECT @@ERROR --> Will return 0 --> because the last Query that I run it has no ERROR

-- If I write a query and this Query has an ERROR 
SELECT * FROM Stu
GO
SELECT @@ERROR --> This will return the number of ERROR message of the last Query
-- that you run it

-- If the Query has no ERROR --> It will return 0
SELECT * FROM Student
GO
SELECT @@ERROR

SELECT @@IDENTITY --> It will return NULL
--> Because we use it When I do an Insert Statement on a table that has an IDENTITY
-- and I want to know the number of the IDENTITY that has been entered in the table

-----------------------------

-- Control of Flow Statement

-- If 

DECLARE @x INT
UPDATE Student
Set Age += 1
SELECT @x = @@ROWCOUNT
IF @x > 0 --> AND / OR   
  SELECT 'Multi rows affected'
ELSE --> ELSE IF
  SELECT 'No Rows Affected'

--> IF I will use more than one query after IF / ELSE --> In programming we USE {} 
-- In SQL We use --> Begin    End 

DECLARE @x INT
UPDATE Student
Set Age += 1
SELECT @x = @@ROWCOUNT
IF @x > 0 
  BEGIN
  SELECT 'Multi rows affected'
  END
ELSE 
  BEGIN
  SELECT 'No Rows Affected'
  END

-- Begin
-- End

-- IF exists  IF Not Exists

--> There is a RULE --> When I write a keyword that contains two parts 
--> The first part is a schema name and the second part is an object name

SELECT * FROM sys.all_columns --> It will return all the name of columns that exists 
-- in the database

-- sys --> is a built in schema (system schema) --> It contains some tables and views
-- that contains our metadata of the database

SELECT * FROM sys.tables --> It will return all information of the tables that exists 
-- in the database

SELECT * FROM sys.all_views --> It will return all information of the views that exists
-- in the database

-- Note that you call the metadata

SELECT Name FROM sys.tables --> It will return a list of names of the columns that 
-- exists in the database

SELECT Name FROM sys.tables WHERE Name = 'Student' --> In this case the interest of you 
-- is that this query will return a result or not --> If it returns a result , it means
-- True , If it doesn't return a result it means False --> To do this you will use 
-- If exists --> It takes a query --> If the query returns a result , It means True
--> If the query doesn't return a result , It means False
 
CREATE TABLE Student --> IF the table exist it will return ERROR 
(
 ID INT,
 Name VARCHAR(20)
)

IF EXISTS(SELECT Name FROM sys.tables WHERE Name = 'Student')
  SELECT 'Table is existed'
ELSE
CREATE TABLE Student --> IF the table exist it will return --> Table is existed
(                    -- and doesn't raise an ERROR
 ID INT,             --> If the table doesn't exist , It will Create that table
 Name VARCHAR(20)
)

DELETE FROM Department WHERE Dep_ID = 20 --> It usually returns an ERROR because the
-- table usually has a relationship with another table

-- To solve the previous problem , I will use (IF NOT EXISTS) to check the Dep_ID in
-- the tables that it has a relationship with them

IF NOT EXISTS(SELECT Dep_ID FROM Student WHERE Dep_ID = 20)
   AND NOT EXISTS(SELECT Dep_ID FROM Instructor WHERE Dep_ID = 20)
   DELETE FROM Department WHERE Dep_ID = 20 
ELSE 
   SELECT 'Table has relationship'

-- I can use (TRY AND CATCH) To solve the same problem
-- I use it , If I don't know the source of the ERROR

BEGIN TRY
   DELETE FROM Department WHERE Dep_ID = 20
END TRY
BEGIN CATCH
   SELECT 'Table has relationship' --> ERROR
   SELECT ERROR_LINE(), ERROR_MESSAGE(), ERROR_NUMBER() --> If I want information about the ERROR
END CATCH


-- While

DECLARE @x INT = 10
WHILE @x < 20
BEGIN
  Set @x += 1
  IF @x = 14
     CONTINUE
  IF @x = 16
     BREAK
  SELECT @x
END --> It will return 11  12  13  15

-- Continue

-- In SQL Server, the CONTINUE statement immediately restarts a WHILE loop
-- from the beginning, skipping any remaining code inside the loop for that
-- specific iteration. It evaluates the loop's boolean condition 
-- again before proceeding.

WHILE condition
BEGIN
   -- Code executed every time
   IF skip_condition
      CONTINUE; -- Skips directly back to the top condition
   
   -- This code is skipped if skip_condition is true
END

-- Key Rules

-- Avoid Infinite Loops: You must increment or modify your loop counter before
-- calling CONTINUE. If you place the counter modification after CONTINUE, 
-- your counter will never change, trapping the script in an endless execution loop.

-- Pair with IF: It is almost always nested inside an IF statement to check 
-- for specific skip conditions.


-- Practical Example

-- This example prints numbers from 1 to 5 but skips the number 3:

DECLARE @Counter INT = 0;

WHILE @Counter < 5
BEGIN
    SET @Counter = @Counter + 1; -- Increment BEFORE the CONTINUE statement

    IF @Counter = 3
    BEGIN
        CONTINUE; -- Skips printing '3' and jumps back to the WHILE condition
    END

    PRINT 'Current Number: ' + CAST(@Counter AS VARCHAR(10));
END

-- Output:

--Current Number: 1
--Current Number: 2
--Current Number: 4
--Current Number: 5

-- Contrast: CONTINUE vs BREAK
-- CONTINUE: Skips the rest of the current iteration and restarts the loop.
-- BREAK: Exits the entire loop immediately, passing execution to the code
-- below the loop block.


-- Break

-- In SQL Server, the phrase "break" most commonly refers to either the BREAK 
-- control-of-flow statement used to exit a WHILE loop, or a text line break 
-- inside a string. Less frequently, it refers to stopping script execution.

-- Here is how to implement each scenario.

-- 1. The BREAK Loop Statement The BREAK keyword exits the innermost WHILE 
-- loop immediately. It is invalid outside of a loop and will throw a syntax error
-- if used on its own.

DECLARE @Counter INT = 1;

WHILE @Counter <= 10
BEGIN
    PRINT @Counter;
    
    -- Exit the loop early when counter reaches 3
    IF @Counter = 3
        BREAK; 
        
    SET @Counter = @Counter + 1;
END;

-- Control resumes here after BREAK
PRINT 'Loop exited.';

-- 2. Inserting a Line Break in a String To format text with a line break or new line,
-- use the CHAR() function with the ASCII values for Carriage 
-- Return (13) and Line Feed (10).Windows standard line break (CRLF): 
-- CHAR(13) + CHAR(10)Unix standard line break (LF): CHAR(10)

DECLARE @Message VARCHAR(200);

-- Combine strings using the ASCII characters
SET @Message = 'First Line' + CHAR(13) + CHAR(10) + 'Second Line';

PRINT @Message;

-- 3. Breaking / Stopping Script Execution If you need to instantly halt 
-- a full SQL script or query batch based on a condition, 
-- BREAK will not work. Instead, you must use RAISERROR or THROW to force a
-- fatal execution halt, or RETURN to exit a stored procedure.

-- Stop script and skip all subsequent code
IF (SELECT COUNT(*) FROM MyTable) = 0
BEGIN
    PRINT 'No records found. Aborting.';
    RETURN; 
END;

-- This code won't run if the RETURN above is triggered
SELECT * FROM MyTable;


-- Case

-- IIF

-- Waitfor

-- The WAITFOR statement in SQL Server pauses the execution of a batch, 
-- stored procedure, or transaction until a specified time interval passes 
-- or a specific time of day is reached. It is commonly used to build polling loops,
-- stagger resource-intensive queries, or simulate human-like application behavior.

-- Core Syntax and Keywords

-- You can implement WAITFOR primarily using two modifiers: DELAY and TIME.

-- 1. WAITFOR DELAY
-- Pauses execution for a relative duration of time (up to 24 hours).
-- The accepted string format is hh:mm:ss[.fff].

-- Pauses execution for exactly 5 seconds
WAITFOR DELAY '00:00:05';
SELECT '5 seconds have passed!' AS Status;

-- 2. WAITFOR TIME
-- Pauses execution until an absolute, specified time of day. 
-- It uses a 24-hour military clock format.

-- Pauses execution until 11:30 PM
WAITFOR TIME '23:30:00';
SELECT 'It is now 11:30 PM, starting job...' AS Status;

-- Passing Dynamic Variables
-- Instead of using hardcoded string literals, you can pass local variables 
-- to WAITFOR to handle dynamic delays.

DECLARE @DelayTime VARCHAR(8) = '00:00:10';
WAITFOR DELAY @DelayTime;

-- Advanced Usage: Service Broker

-- WAITFOR can also block a thread dynamically until a message arrives in 
-- a SQL Server Service Broker queue, using a RECEIVE statement. 
-- If no message arrives within the specified timeout, the statement breaks

WAITFOR (
    RECEIVE TOP(1) conversation_handle, message_body
    FROM TargetQueueInfo
), TIMEOUT 60000; -- Waits up to 60,000 milliseconds (1 minute)

-- Critical Performance Considerations

-- Active Thread Consumption: Each WAITFOR statement ties up an active
-- SQL Server execution thread while it waits

-- Thread Starvation Risk: If you fire off hundreds of concurrent WAITFOR delays 
-- simultaneously, you risk exhausting your server's available thread pool. 
-- If thread starvation occurs, SQL Server will randomly terminate some waiting
-- threads to protect itself.

-- Extended Lock Times: While WAITFOR does not generate database locks on its own,
-- placing it inside an open transaction (BEGIN TRAN) keeps existing locks open longer.
-- This can severely degrade system performance by blocking other user queries.


-- Choose

-- The CHOOSE function in SQL Server is a logical function that acts like an index into
-- an array, returning the item at a specific position from a list of values. 
-- It serves as a more concise, readable alternative to a complex CASE statement when
-- mapping consecutive integers to specific values.

-- 1. Basic Syntax

CHOOSE ( index, value_1, value_2, [ ...value_n ] )

-- index: An integer expression that specifies which item to return.
-- It uses 1-based indexing (the first value is 1, the second is 2, etc.).

-- value_1, value_2, ...: A comma-separated list of values of any data type.
-- You can pass up to 254 values.

-- 2. Practical Examples

-- Basic Static Lookup

-- If you pass the number 3, the function skips the first two entries and returns
-- the third item.

SELECT CHOOSE(3, 'Manager', 'Director', 'Developer', 'Tester') AS Result;
-- Returns: 'Developer'

-- Mapping Month Numbers to Names or Seasons

-- You can use CHOOSE alongside the MONTH() function to cleanly dynamically 
-- translate dates into fiscal periods or seasons.

SELECT 
    OrderDate,
    CHOOSE(MONTH(OrderDate), 'Winter', 'Winter', 'Spring', 'Spring', 'Spring', 'Summer', 'Summer', 'Summer', 'Autumn', 'Autumn', 'Autumn', 'Winter') AS Season
FROM Sales.SalesOrderHeader;

-- 3. Critical Rules & Edge Cases

-- Out-of-Bounds Indexing: If the index is 0, a negative number, or greater than 
-- the number of items provided, CHOOSE returns NULL.

-- Implicit Type Conversion: If the index expression results in a non-integer numeric
-- type (like a float or decimal), SQL Server automatically converts it to an integer.

-- Data Type Precedence: The returned value's data type is determined by 
-- SQL Server Data Type Precedence. If you mix INT and VARCHAR in your value list, 
-- SQL Server will try to convert the string to an integer, 
-- which may cause a runtime error.

-- Performance Note: Under the hood, SQL Server translates the CHOOSE function into 
-- an equivalent CASE WHEN structure in the execution plan. For vast quantities of 
-- static choices, a dedicated lookup table is generally better for performance 
-- and indexing.

-----------------------------------
-- The difference between --> Batch,  Transaction,  Script

-- Batch --> is a group of unrelated queries that don't have any affect on each other
-- ,but you can run it together

INSERT 
UPDATE 
DELETE --> I can run these 3 queries together

-- Script --> There is a group of some queries that can't run together in the same 
-- batch , specifically with the DML queries

CREATE TABLE
             --> You can't run the two query in the same time
DROP TABLE 

-- To solve the problem --> You should seperate them with GO
CREATE TABLE
GO
DROP TABLE

CREATE RULE
GO
SP_BINDRULE

CREATE TABLE
GO
DROP TABLE
GO
CREATE RULE
GO
SP_BINDRULE

-- I use (GO) to seperate some queries that can't run together in the same batch

-- Transaction --> Is some queries that should run together 
--> Set of queries that have been executed as single unit of work

-- There are an implicit transaction that exist in DELETE and INSERT

-- We will talk about the explicit transaction that we will write it manually

-- BEGIN Transaction
  -- INSERT
  -- UPDATE
  -- DELETE
-- COMMIT     -- Rollback


CREATE TABLE parent(pid INT PRIMARY KEY)

CREATE TABLE Child(cid INT FOREIGN KEY REFERENCES parent(pid))

INSERT INTO parent Values(1) --> (1 row(s) affected)
INSERT INTO parent Values(2) --> (1 row(s) affected)
INSERT INTO parent Values(3) --> (1 row(s) affected)
INSERT INTO parent Values(4) --> (1 row(s) affected)

INSERT INTO Child VALUES(1) --> (1 row(s) affected)
INSERT INTO Child VALUES(5) --> Error message
INSERT INTO Child VALUES(3) --> (1 row(s) affected)

SELECT * FROM Child --> You will see ID 1 and 3

TRUNCATE TABLE Child

BEGIN TRANSACTION
  INSERT INTO Child VALUES(1) --> (1 row(s) affected)
  INSERT INTO Child VALUES(2) --> (1 row(s) affected)
  INSERT INTO Child VALUES(3) --> (1 row(s) affected)
ROLLBACK --> It will delete the values that have been inserted

SELECT * FROM Child --> You will see that the table is empty

BEGIN TRANSACTION
  INSERT INTO Child VALUES(1) --> (1 row(s) affected)
  INSERT INTO Child VALUES(5) --> Error message
  INSERT INTO Child VALUES(3) --> (1 row(s) affected)
COMMIT --> This doesn't become a transacion, It becomes a batch

-- The normal --> If there is an ERROR It must show the word (ROLLBACK)
              --> If there isn't an ERROR It must show the word (COMMIT)

-- The best way to do that through using TRY and CATCH

BEGIN TRY
  BEGIN TRANSACTION
    INSERT INTO Child VALUES(1) --> (1 row(s) affected)
    INSERT INTO Child VALUES(5) --> Error message
    INSERT INTO Child VALUES(3) --> (1 row(s) affected)
  COMMIT --> If the 3 Queries are True --> You should do a COMMIT
END TRY
BEGIN CATCH
  ROLLBACK --> If there is an ERROR in any one of them --> You should do a ROLLBACK
END CATCH

--> If there isn't an ERROR --> COMMIT
--> If there is an ERROR --> ROLLBACK

----------------------------------------------
-- Functions 
  -- Built in Functions           -- User Defined Functions
   
-- Built in Functions (Scalar Functions) --> Functions that return one value

-- NULL(),   ISNULL(), Coalesce(),  NULLIF()
-- SYSTEM FUNCTIONS --> DB_NAME(), SUSER_NAME()
-- CONVERT FUNCTIONS --> CONVERT(), CAST(), FORMAT()
-- STRING FUNCTIONS --> SUBSTRING(), UPPER(), LOWER(), LEN()
-- DATE FUNCTIONS --> GETDATE(), YEAR(), MONTH(), DAY()
-- AGGREGATE FUNCTIONS --> COUNT(), MAX(), MIN(), AVG(), SUM()
-- MATH FUNCTIONS --> POWER(), LOG(), SIN(), COS(), TAN()
-- RANKING FUNCTIONS --> ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE()
-- LOGICAL FUNCTIONS --> IIF(), CHOOSE()
-- WENDOWING FUNCTIONS --> LEAD(), LAG(), FIRST_VALUE(), LAST_VALUE()

SELECT GETDATE()

SELECT ISNULL(FirstName, '') --> Takes one replacement
FROM Student

SELECT COALESCE(FirstName, LastName, '') --> Take more than one replacement
FROM Student

SELECT COALESCE(FirstName, LastName, Address, '') --> Take more than one replacement
FROM Student --> It will return the first non Null value

SELECT UPPER(FirstName), LOWER(LastName)
FROM Student

SELECT LEN(FirstName), FirstName
FROM Student

SELECT MAX(FirstName) --> Checks on the Character (ASCII CODE)
FROM Student

-- When I want to return the name that has the max number of characters -->
SELECT TOP(1) FirstName
FROM Student
ORDER BY LEN(FirstName) DESC

SELECT POWER(Salary, 2)
FROM Instructor

SELECT CONVERT(VARCHAR(20), GETDATE(), 101)

SELECT FORMAT(GETDATE(), 'dd-MM-yyyy')

SELECT DB_NAME()

SELECT SUSER_NAME()


-- User Defined Functions
  -- Scalar Function -- Inline Table Function -- Multi Statement Table Valued Function

-- The kind of Function dependes on the kind of return type
-- All Functions must return 
-- In All Functions we write only SELECT Statement

-- If the Function returns a one value --> I will write it with the syntax of the 
-- Scalar Function

-- If the Function returns a Table there are two choices -->
-- Inline Table Function        -- Multi Statement Table Valued Function

-- IF the body of the function --> SELECT Statement only without any If statement OR
-- any While loop OR any DECLARE for a variable OR any TRY AND CATCH --> In this case
-- It is like the view in the database So that It is actually (Inline Table Function)

-- If the body of the function --> SELECT Statement with any LOGIC like IF Statement 
-- OR DECLARE for a variable OR a While loop --> In this case It will be -->
-- Multi Statement Table Valued Function --> It is known as INSERT based on SELECT


-- Create My Own Functions

-- I want to create a Function that takes the ID of student and return the name of 
-- the student --> This is a scalar function 

-- string GETSNAME(int id)
CREATE FUNCTION GETSNAME(@id INT)
RETURNS VARCHAR(20)
   BEGIN
      DECLARE @name VARCHAR(20)
      SELECT @name = FirstName FROM Student WHERE St_ID = @id
      RETURN @name
   END

-- The part that exists before the BEGIN --> is the signature of the function -->
-- That contains the answer of the 3 Question --> What is the name of the Function ?
-- What does the function take ? , What does the function return ?

-- The part that exists between the BEGIN AND END --> is the body of the Function

-- The things that exist besides the return that exists in the body --> is the thing 
-- that will be returned (The return value)

-- The RETURNS that exists before the BEGIN --> It means the type of the return value

SELECT GETSNAME(1) --> ERROR --> Because he doesn't found it in the built in functions

-- To solve this problem --> You must use DBO schema to understand that this scalar 
-- function is a user defined function 

SELECT dbo.GETSNAME(1)

-- Any user defined function to call it --> you should use the name of the schema
-- before the name of it


-- To create the function in the schema of HR --> I will use HR before the name of the 
-- function in the creation of it

CREATE FUNCTION HR.GETSNAME(@id INT) --> I use the HR schema
RETURNS VARCHAR(20)
   BEGIN
      DECLARE @name VARCHAR(20)
      SELECT @name = FirstName FROM Student WHERE St_ID = @id
      RETURN @name
   END

-------------------------------------------
-- I need to create a function that takes the number of the department and return the
-- name of the Instructors that exists in the department with their yearly salary

CREATE FUNCTION Getist(@did INT)
RETURNS TABLE
AS
RETURN
(
  SELECT Ins_name, Salary * 12
  FROM Instructor
  WHERE Dep_ID = @did --> ERROR --> Because you should make an Alias name for Salary * 12
)

-- The solution of the problem
CREATE FUNCTION Getist(@did INT)
RETURNS TABLE
AS
RETURN
(
  SELECT Ins_name, Salary * 12 AS TotalSalary
  FROM Instructor
  WHERE Dep_ID = @did 
)

-- To call the function --> I will do the following
SELECT Getist(10) --> ERROR 

-- To solve the ERROR I will use the name of the schema before it --> We will do this
-- If It was a scalar function --> But we can't do that here because this function 
-- returns a table --> SO that we will use SELECT * FROM FunctionName 
SELECT * FROM Getist(10)

SELECT Ins_name FROM Getist(10)

SELECT SUM(TotalSalary) FROM Getist(10)

---------------------------------------
-- Multistatement

-- I want to create a Function that If I give it the FirstName , It should return a 
-- list of the FirstName of the Student and their IDs ,
-- If I give it the LastName , It should return a list of the LastName of the 
-- Student and their IDs , If I give it the FullName , It should return a 
-- list of the FullName of the Student and their IDs

-- You can't use the EXECUTE Function in the User Defined Function because these 
-- functions accept SELECT statements only

CREATE FUNCTION getstuds(@format VARCHAR(20))
RETURNS @t TABLE --> Here , We declare a variable that its kind of it is a table
       (
         id INT,
         ename VARCHAR(20)
       ) --> From the first line to here is the signature of the function
AS 
    BEGIN 
       IF @format = 'first'
          INSERT INTO @t
          SELECT St_ID, FirstName FROM Student
       ELSE IF @format = 'last'
          INSERT INTO @t
          SELECT St_ID, LastName FROM Student
       ELSE IF @format = 'full'
          INSERT INTO @t --> Some of People think that the two lines is a two Qyery but they are one Qury called ISERT based on SELECT So that we didn't use BEGIN, END
          SELECT St_ID, FirstName + ' ' + LastName FROM Student
       RETURN
    END

-- To call this Function -->
SELECT * FROM getstuds('first')

SELECT * FROM getstuds('last')

SELECT * FROM getstuds('full')

-- If I write another word --> The function will return an empty table
SELECT * FROM getstuds('ddddddd')

-------------------------------------------
-- There are some functions that we didn't talk about them --> 4 functions called 
-- Wendowing Functions (LEAD(), LAG(), FIRST_VALUE(), LAST_VALUE())

-- I will create a table that gives us information of students and their grade
SELECT S.St_ID AS SID, FirstName AS SName, Grade, Crs_Name AS CName INTO Grades --> I use the SELECT INTO to create a table
FROM Student S, Stud_Course SC, Course C
WHERE S.St_ID = SC.St_ID AND C.Crs_ID = SC.Crs_ID

SELECT * FROM Grades

SELECT SName, Grade,
    Prod_prev = LAG(Grade) OVER(ORDER BY Grade), --> will return the previous grade 
    Prod_Next = LEAD(Grade) OVER(ORDER BY Grade) --> will return the next grade 
FROM Grades

SELECT SName, Grade,
    Prod_prev = LAG(SName) OVER(ORDER BY Grade), --> will return the previous SName
    Prod_Next = LEAD(SName) OVER(ORDER BY Grade) --> will return the next SName
FROM Grades

-- LAG() --> return the value of the previous row based on the column that I make ORDER
-- BY with it

-- LEAD() --> return the value of the next row based on the column that I make ORDER
-- BY with it

SELECT SName, Grade,
    Prod_prev = LAG(SName) OVER(ORDER BY Grade), 
    Prod_Next = LEAD(SName) OVER(ORDER BY Grade) 
FROM Grades
WHERE SID = 4

SELECT SName, Grade,
    Prod_prev = LAG(SName) OVER(ORDER BY Grade), 
    Prod_Next = LEAD(SName) OVER(ORDER BY Grade) 
FROM Grades
WHERE SName = 'Eman' --> It will return NULL in the LAG() AND the LEAD() because it 
-- apply them on the result of the query --> so that we should use the subquery

SELECT *
FROM(
SELECT SName, Grade,
    Prod_prev = LAG(SName) OVER(ORDER BY Grade), 
    Prod_Next = LEAD(SName) OVER(ORDER BY Grade) 
FROM Grades) AS NewTable
WHERE SName = 'Eman'

-- This Query returned the grade of the previous value and the next value but not for
-- the same course
SELECT SName, Grade, CName
    Prod_prev = LAG(Grade) OVER(ORDER BY Grade), 
    Prod_Next = LEAD(Grade) OVER(ORDER BY Grade) 
FROM Grades

-- The normal that we want the previous grade and the next grade in the same course 
-- So that we will use PARTITION BY
SELECT SName, Grade, CName
    Prod_prev = LAG(Grade) OVER(PARTITION BY CName ORDER BY Grade), 
    Prod_Next = LEAD(Grade) OVER(PARTITION BY CName ORDER BY Grade) 
FROM Grades


SELECT SName, Grade, CName
    First = FIRST_VALUE(Grade) OVER(PARTITION BY CName ORDER BY Grade), --> It will return the first value in the result --> It is considered as Maximum value
    Last = LAST_VALUE(Grade) OVER(PARTITION BY CName ORDER BY Grade) --> It will return the last value in the result --> It is considered as Minimum value
FROM Grades

-- If I want to know the grade of me , the previous grade , the following grade, 
-- the maximum grade and the minimum grade
SELECT SName, Grade, CName
    Prod_prev = LAG(Grade) OVER(PARTITION BY CName ORDER BY Grade), 
    Prod_Next = LEAD(Grade) OVER(PARTITION BY CName ORDER BY Grade),
    First = FIRST_VALUE(Grade) OVER(PARTITION BY CName ORDER BY Grade), --> It will return the first value in the result --> It is considered as Maximum value
    Last = LAST_VALUE(Grade) OVER(PARTITION BY CName ORDER BY Grade) --> It will return the last value in the result --> It is considered as Minimum value
FROM Grades


-- If I want to know the grade of me , the previous grade , the following grade, 
-- the maximum grade and the minimum grade --> Here we make a comparison in the 
-- same partition of each course (USING PARTITION BY)
SELECT SName, Grade, CName
    Prod_prev = LAG(Grade) OVER(PARTITION BY CName ORDER BY Grade), 
    Prod_Next = LEAD(Grade) OVER(PARTITION BY CName ORDER BY Grade),
    First = FIRST_VALUE(Grade) OVER(PARTITION BY CName ORDER BY Grade), --> It will return the first value in the result --> It is considered as Maximum value
    Last = LAST_VALUE(Grade) OVER(PARTITION BY CName ORDER BY Grade) --> It will return the last value in the result --> It is considered as Minimum value
FROM Grades


-- If I want to know the Name of me , the previous Name , the following Name, 
-- the Name of the student that have the maximum grade and the Name of the student 
-- that have the minimum grade
SELECT SName, Grade, CName
    Prod_prev = LAG(SName) OVER(ORDER BY Grade), 
    Prod_Next = LEAD(SName) OVER(ORDER BY Grade),
    First = FIRST_VALUE(SName) OVER(ORDER BY Grade), --> It will return the first value (first row) in the result --> It is considered as Maximum value but Not exactly
    Last = LAST_VALUE(SName) OVER(ORDER BY Grade) --> It will return the last value (last row) in the result --> It is considered as Minimum value but Not exactly
FROM Grades


-- If I want to know the Name of me , the previous Name , the following Name, 
-- the Name of the student that have the maximum grade and the Name of the student 
-- that have the minimum grade --> Here we make a comparison in the same partition 
-- of each course (USING PARTITION BY)
SELECT SName, Grade, CName
    Prod_prev = LAG(SName) OVER(PARTITION BY CName ORDER BY Grade), 
    Prod_Next = LEAD(SName) OVER(PARTITION BY CName ORDER BY Grade),
    First = FIRST_VALUE(SName) OVER(PARTITION BY CName ORDER BY Grade), --> It will return the first value in the result --> It is considered as Maximum value
    Last = LAST_VALUE(SName) OVER(PARTITION BY CName ORDER BY Grade) --> It will return the last value in the result --> It is considered as Minimum value
FROM Grades

