-- When we send the query to the engine --> It arrive accross definite cycle
-- Query --> Parsing (syntax) --> Optimize (Metadata) --> Query Tree --> Execution Plan

-- A stored procedure in SQL Server is a precompiled collection of Transact-SQL (T-SQL) 
-- statements saved as a reusable object on the database server. Instead of writing and
-- sending complex queries repeatedly over the network, you can bundle them into a single
-- procedure and trigger them with a quick command.

--- Core Benefits

-- Faster Performance: SQL Server compiles the procedure once and caches its execution plan.
-- Subsequent runs reuse this plan to process data extremely fast.

-- Reduced Network Traffic: A client application only needs to transmit the execution name 
-- and parameters (e.g., EXEC GetUser 5), rather than long paragraphs of raw SQL text.

-- Stronger Security: You can block users from seeing or modifying raw tables directly, 
-- while still granting them permission to execute a specific procedure that handles data
-- safely. This also inherently isolates data against SQL injection attacks.

-- Code Reusability: Centralizes your business rules. If logic changes, you only update the
-- code inside the procedure, without rewriting the client application.

-- Basic Syntax

-- The syntax structure requires a creation definition block, parameter initializations 
-- (if any), an AS marker, and a bounded BEGIN...END block containing your actual query 
-- code.

CREATE PROCEDURE schema_name.procedure_name
    @parameter1 data_type,
    @parameter2 data_type = default_value -- Optional default
AS
BEGIN
    SET NOCOUNT ON; -- Prevents extra "rows affected" messages from clogging network traffic
    
    -- Your T-SQL query code goes here
    SELECT * FROM YourTable WHERE Column1 = @parameter1;
END;
GO

--- Practical Code Examples

-- 1. Simple Procedure (No Parameters)

-- Best used for retrieving static reports or routine logs.

CREATE PROCEDURE dbo.GetAllActiveProducts
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ProductID, ProductName, UnitPrice 
    FROM dbo.Products 
    WHERE IsActive = 1;
END;
GO

-- To Execute:

EXEC dbo.GetAllActiveProducts;

-- 2. Input Parameter Procedure

-- Allows you to pass variables to filter or dynamically process datasets.

CREATE PROCEDURE dbo.GetCustomersByRegion
    @RegionName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CustomerID, CompanyName, ContactName 
    FROM dbo.Customers 
    WHERE Region = @RegionName;
END;
GO

-- To Execute:

EXEC dbo.GetCustomersByRegion @RegionName = 'North America';

-- 3. Procedure with Output Parameters

-- Used to return single scalar values (like counts, generated IDs, or calculation totals)
-- back to the caller.

CREATE PROCEDURE dbo.GetProductCountBySupplier
    @SupplierID INT,
    @ProductCount INT OUTPUT -- Marked explicitly to pass values back out
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @ProductCount = COUNT(*) 
    FROM dbo.Products 
    WHERE SupplierID = @SupplierID;
END;
GO

-- To Execute:

-- Declare a local variable to hold the output value
DECLARE @TotalCount INT;

EXEC dbo.GetProductCountBySupplier 
    @SupplierID = 2, 
    @ProductCount = @TotalCount OUTPUT; -- Must include 'OUTPUT' keyword here too

-- View the returned value
SELECT @TotalCount AS TotalSupplierProducts;


--- How to Modify or Delete a Procedure

-- Modifying an existing procedure: Always use ALTER or CREATE OR ALTER so you do not lose
-- the object's existing security permissions.

ALTER PROCEDURE dbo.GetAllActiveProducts
AS 
BEGIN
    -- New updated code here
END;

-- Deleting a procedure: Use the DROP statement.

DROP PROCEDURE dbo.GetAllActiveProducts;
--------------------------------------------------

CREATE PROCEDURE GetSt @id INT  --> @id --> is a parameter
AS 
    SELECT *
    FROM Student
    WHERE St_ID = @id 

-- When you call the stored procedure --> you write the name of it only and the parameter
-- If It takes a parameter

GetSt 4

-- You can write all kinds of queries in the Stored Procedure 

-- At the first call of the stored procedure --> It put the value of the parameter and begin
--> Query --> Parsing (syntax) --> Optimize (Metadata) --> Query Tree --> Execution Plan
--> When the stored procedure arrives to the phase of (Query Tree) he start saving the 
-- Query Tree in the server then Execute the query 

-- Query --> Parsing (syntax) --> Optimize (Metadata) --> Query Tree --> Execution Plan

-- If I call the same stored procedure again --> It won't begin from the first --> It will
-- start from the phase of the Execution plan 

-- Stored Procedure --> is an object that exists in the database 

-- You can write INSERT Statement in the Stored Procedure
CREATE PROCEDURE InstSt @id INT, @name VARCHAR(20)
AS
   INSERT INTO Student(St_ID, FirstName)
   VALUES(@id, @name)


InstSt 7, 'ali'

-- If the id exists in the table it will raise an ERROR --> So that you should make any 
-- condition before the runing of the DML 

CREATE PROCEDURE InstSt @id INT, @name VARCHAR(20)
AS
  IF NOT EXISTS(SELECT St_ID FROM Student WHERE St_ID = @id)
    INSERT INTO Student(St_ID, FirstName)
    VALUES(@id, @name)
  ELSE
    SELECT 'Duplicate ID'


InstSt 7, 'ali'

-- The benefits of stored procedure in sql server

-- Stored procedures in SQL Server offer significant advantages by improving database 
-- performance, enhancing security, and simplifying code maintenance. By grouping 
-- Transact-SQL (T-SQL) statements into a single, executable database object, they bridge
-- the gap between application logic and raw data efficiency.

--- 🚀 Improved Performance

-- Execution Plan Caching: SQL Server compiles the procedure upon its first execution 
-- and saves the optimal execution plan. Subsequent calls reuse this cached plan, 
-- eliminating the overhead of parsing and optimizing the query every time.

-- Reduced Memory Overhead: The executable code is shared among multiple users, lowering
-- server memory requirements.

--- 🛡️ Enhanced Security

-- Access Control: You can grant users permission to run a stored procedure without giving
-- them direct access to the underlying tables.

-- SQL Injection Prevention: Stored procedures inherently treat input parameters as literal
-- values rather than executable code, which blocks malicious query injections.

-- Obfuscation: You can encrypt the procedure definition to hide sensitive business logic
-- from unauthorized users.

--- 📉 Reduced Network Traffic

-- Single-Call Execution: Instead of sending hundreds of lines of ad-hoc SQL text over 
-- the network, the client application only transmits the procedure name and its arguments.
-- This minimizes data transmission and network congestion.

--- 🛠️ Centralized Maintenance & Reusability

-- Modular Logic: Business rules are written once and stored in the data tier. Multiple
-- client applications can call the exact same script, preventing code duplication.

-- Seamless Updates: When database structures change, you only need to update the stored 
-- procedure. The front-end application code remains completely untouched.

--- 🔄 Summary Comparison

-- Feature        | Stored Procedures                 | Ad-hoc Queries
-------------------------------------------------------------------------------------------
-- Execution Plan | Pre-compiled and reused           | Compiled on every execution
-------------------------------------------------------------------------------------------
-- Network Cost   | Extremely low (name + params only)| High (full query text transmitted)
-------------------------------------------------------------------------------------------
-- Security Layer | Restricts direct table access     | Requires direct table permissions
-------------------------------------------------------------------------------------------
-- Maintenance    | Centralized in the database       | Scattered across application code
-------------------------------------------------------------------------------------------


-- There are 3types of Stored Procedure 

-- 1. Built in Stored Procedure SP --> Any thing that begins with (SP_)
SP_BINDRULE
SP_UNBINDRULE
SP_BINDEFAULT
SP_UNBINDEFAULT
SP_HELP
SP_HELPCONSTRAINT
SP_RENAME
SP_ADDTYPE

-- 2. User defined Stored Procedure

SELECT *
FROM Student

CREATE PROC GetSt --> CREATE PROCEDURE GetSt
AS
   SELECT *
   FROM Student

-- To call the Stored Procedure (SP) --> I will write the name of it OR I will EXECUTE 
-- before the name of the SP

GetSt

EXECUTE GetSt

-- I can send parameters to the SP
CREATE PROC GetStbyAddress @add VARCHAR(20)
AS  
   SELECT St_ID, FirstName, Address
   FROM Student
   WHERE Address = @add
   

GetStbyAddress 'alex' --> It considered as a dynamic view

EXECUTE GetStbyAddress 'alex'

DELETE FROM Student WHERE St_ID = 1

INSERT INTO Student(St_ID, FirstName)
VALUES (663, 'ali')

CREATE PROC InstSt @id INT, @name VARCHAR(20)
AS
   INSERT INTO Student(St_ID, FirstName)
   VALUES (@id, @name)


InstSt 44, 'ali'

-- To prevent the ERROR --> You will use BEGIN TRY AND END TRY , BEGIN CATCH AND END CATCH

ALTER PROC InstSt @id INT, @name VARCHAR(20)
AS
   BEGIN TRY 
       INSERT INTO Student(St_ID, FirstName)
       VALUES (@id, @name)
   END TRY
   BEGIN CATCH
       SELECT 'ERROR'
   END CATCH


InstSt 44, 'ali'


CREATE PROC Sumdata @x INT, @y INT
AS
   SELECT @x+@y


Sumdata 3,9 --> calling parameter by position  --> In this care the order does matter
--> 3 in the first position so that it will be send to @x , 9 in the second position 
--so that it will be send to @y

-- Another way to call the Stored Procedure 
Sumdata @y=9, @x=4 --> calling parameter by name --> In this case there order doesn't matter

-- The Stored Procedure can take a default value 

ALTER PROC Sumdata @x INT, @y INT = 100
AS
   SELECT @x+@y


Sumdata 3 --> It will run because @y has a default value and the result will be 103

ALTER PROC Sumdata @x INT = 100, @y INT = 100
AS
   SELECT @x+@y


Sumdata --> It will run because @y and @x have a default value and the result will be 200

-- If I want to take the result of SP and use it

CREATE PROC GetStbyAge @age1 INT, @age2 INT
AS
   SELECT St_ID, FirstName 
   FROM Student 
   WHERE Age BETWEEN @age1 AND @age2


GetStbyAge 23,28 --> If I want to take the result and use it --> I used to use INSERT Based
-- on SELECT --> but the SELECT Statement exists in the SP --> So that we will use -->
-- INSERT Based On EXECUTE 

INSERT INTO tab4(St_ID, FirstName)
EXECUTE GetStbyAge 23,28 --> It is one of the cases that I should write EXECUTE before 
-- the SP 

DECLARE @t table(x INT, y VARCHAR(20))
INSERT INTO @t
EXECUTE GetStbyAge 23,28 
SELECT COUNT(*) FROM @t --> We will run the 4lines in the same batch
-- We use this case if the return value from the SP is a table

-- If the return value from the SP is one value --> In this case you will write it like 
-- the way of writing the scalar function 

CREATE PROC Getdata @id INT
AS
   DECLARE @age INT --> we write it to make the SP as the scalar function
      SELECT @age = Age --> we take the result of the SP and put it in the variable 
      FROM Student
      WHERE St_ID = @id
   RETURN @age --> return the value --> Note that this return --> returns an integer only and returns only a one value

DECLARE @x INT --> We do this to store the result of the SP at a variable and return it 
SET @x = EXECUTE Getdata 3
SELECT @x

-- The return of the SP differs from the return of the function 

-- The return of the SP has been implemented to return a number that reflects the behaviour
-- of the SP not to return a value

-- The return that exists in the function return a value that returns from the function

-- If I want to return a number from the SP I won't write it as the previous query 
-- The SP has two kinds of parameters --> Input parameter , Output parameter 

CREATE PROC Getdata @id INT, @age INT OUTPUT --> It means that I will send a variable for you
AS -- If the variable has been changed in the SP --> You will feel with this change
   SELECT @age = Age
   FROM Student
   WHERE St_ID = @id

DECLARE @x INT
EXECUTE Getdata 3, @x OUTPUT --> You should write (OUTPUT) here --> If you don't write it
SELECT @x                    -- the @x value will still be NULL

-- IF I want to return two things --> I will make another variable 
-- The SP --> In this case take 3 parameters --> (1 input and 2 outputs)
CREATE PROC Getdata @id INT, @age INT OUTPUT, @name VARCHAR(20) OUTPUT 
AS
   SELECT @age = Age, @name = FirstName
   FROM Student
   WHERE St_ID = @id

DECLARE @x INT, @y VARCHAR(20)
EXECUTE Getdata 6, @x OUTPUT, @y OUTPUT 
SELECT @x, @y

------------------------------------------------------------------------
CREATE PROC Getmydata @age INT OUTPUT, @name VARCHAR(20) OUTPUT 
AS
   SELECT @age = Age, @name = FirstName
   FROM Student
   WHERE St_ID = @age

DECLARE @x INT = 6, @y VARCHAR(20) --> Here @x is an INPUT AND OUTPUT parameter in the 
EXECUTE Getmydata @x OUTPUT, @y OUTPUT -- same time
SELECT @x, @y

-- We have 4 kinds of parameters in the SP --> INPUT parameter, OUTPUT parameter,
-- INPUT OUTPUT parameter , return value / return parameter

CREATE PROC Getalldata @col VARCHAR(20), @tab VARCHAR(20)
AS
   SELECT @col FROM @tab --> ERROR

-- To solve it --> I will use EXECUTE and the concatination
CREATE PROC Getalldata @col VARCHAR(20), @tab VARCHAR(20)
AS
   EXECUTE('SELECT ' + @col + ' FROM ' + @tab)


Getalldata '*', 'Student'

Getalldata '*', 'Instructor'

-- To secure the SP , you should write (WITH ENCRYPTION) in the creation of it
ALTER PROC Getalldata @col VARCHAR(20), @tab VARCHAR(20)
WITH ENCRYPTION
AS
   EXECUTE('SELECT ' + @col + ' FROM ' + @tab)

SP_HELPTEXT 'Getalldata'

-- I can use the function as a part of a query in SELECT/ INSERT/ UPDATE but I can't d that
-- in the SP
--------------------------------------------------------------------------
-- 3. Trigger (Special type of Stored Procedure)

-- I can't call it 
-- I can't send parameters to it
-- We have Triggers on the server , Triggers on the database and Triggers on the table

-- Triggers on the table is considered as an implicit code in the server that you can't call
-- it --> It will show for the client --> It listen on the actions that occur on the table
--> (INSERT, UPDATE, DELETE)

INSERT INTO Student(St_ID, FirstName)
VALUES(777, 'ali') --> After execute it, we will see only a message that belongs to SQL 
-- If I want a thing be shown for the client  --> I will create a TRIGGER

CREATE TRIGGER t1
ON Student 

-- There are two kinds of Triggers that exist on the table --> 1. After, 2. Instead of
-- After --> is a code that runs after the query 
-- Instead of --> is a code that runs instead of the query 

CREATE TRIGGER t1
ON Student 
AFTER INSERT  --> AFTER = FOR --> Sometimes we write AFTER , Sometimes we write FOR
AS
   SELECT 'Welcome to ITI'

INSERT INTO Student(St_ID, FirstName)
VALUES(777, 'ali') --> When I run the INSERT Statement --> The (Welcome to ITI) Statement 
-- will appear 

CREATE TRIGGER t2
ON Student
AFTER UPDATE -->
AS
   SELECT GETDATE()

CREATE TRIGGER t2
ON Student
FOR UPDATE  -->
AS
   SELECT GETDATE()

UPDATE Student
SET Age += 1 --> When I run this Query --> It will show the date that I update the table on it

CREATE TRIGGER t3
ON Student 
INSTEAD OF DELETE --> Here I use the TRIGGER insteade of the permission --> I want to prevent
AS                -- the delete on all people 
   SELECT 'Not allowed for user = '+ SUSER_SNAME()


DELETE FROM Student WHERE St_ID = 779

-- If you want to make a table to be a read only table
CREATE TRIGGER t4
ON Department
INSTEAD OF INSERT, UPDATE, DELETE
AS
   SELECT 'Not allowed'


UPDATE Department
SET Dep_Name = 'Cloud'
WHERE Dep_ID = 40

-- IF I want to return the INSERT, UPDATE, DELETE on the table --> I will drop the TRIGGER

DROP TRIGGER t4

-- There are another way instead of DROP the trigger --> The trigger is considered as an
-- object on the table --> I can make enable and disable for it

ALTER TABLE Department DISABLE TRIGGER t4

-- If I want to return the trigger to work --> I will use ENABLE

ALTER TABLE Department ENABLE TRIGGER t4

-- Note that --> All TRIGGERS will be called if the query affected on rows or don't affect
-- Note that --> The TRIGGER takes the name of the schema automatically 

CREATE TRIGGER t7
ON Sales.Student
AFTER UPDATE
AS
   SELECT 'Hi'


UPDATE Sales.Student
SET id = 4
WHERE id = 7

ALTER TRIGGER t7 --> It will show an ERROR --> Because The TRIGGER takes the name of 
ON Sales.Student -- the schema automatically 
AFTER UPDATE
AS
   SELECT 'Hi'

-- To solve the ERROR --> you should write the name of the schema before the Trigger_name
ALTER TRIGGER sales.t7
ON Sales.Student
AFTER UPDATE
AS
   SELECT 'Hi'

-- UPDATE is the only keyword in SQL that their color is red
-- We know that any thing that their color is red --> means it is a function
-- Note that --> You can use UPDATE as a function in the TRIGGER

ALTER TRIGGER sales.t7
ON Sales.Student--> In the first it showed (Hi) if the query update (affect on rows) 
AFTER UPDATE    -- or doesn't update (doesn't affect on rows)
AS
  IF UPDATE(name) --> Here --> It will show Hi only if the query affect on rows
     SELECT 'Hi' --> Here --> The UPDATE is a thing that returns TRUE or FALSE
     -- The UPDATE() Function takes the column and tell you if the column is a part of 
     -- your update statement or not

-- If I delete the part of IF UPDATE(name) --> It means that the Hi will appear after any
-- update on any column

-- When I put the part of IF UPDATE(name) --> It means that the Hi will appear only after 
-- updating the column name 

UPDATE Sales.Student
SET Name = 'ahmed'
WHERE id = 7

-- The most important information about TRIGGER is using it for audoting

-- Any datadase has two tables --> inserted , deleted
-- but If I make a SELECT Statement from them --> they will raise an ERROR
SELECT * FROM INSERTED

SELECT * FROM DELETED

CREATE TRIGGER t5
ON Course
AFTER UPDATE
AS
   SELECT * FROM inserted
   SELECT * FROM deleted

-- With each fire for the TRIGGER it will create a table that its name is inserted and a 
-- table that its name is deleted --> with the same structure if the table that the TRIGGER
-- has been created on it

-- It will run normally --> Because the inserted table and the deleted table have meaning
-- only in the TRIGGER but they have no meaning out of the TRIGGER

UPDATE Course
SET Crs_name = 'Cloud', Crs_duration = 45
WHERE Crs_id = 100
--> When you run this Query --> The Statement of SELECT * FROM inserted will have been executed
-- and the Statement of SELECT * FROM deleted will have been executed

-- The data that exists in the deleted and inserted table depends on the Query 
--> If you make INSERT --> Then the inserted table will have the rows that I try to insert 
-- them and the deleted table will be empty
--> If you make DELETE --> Then the deleted table will have the rows that I try to delete 
-- them and the inserted table will be empty
--> If you make UPDATE --> It means there is old and new data --> Then the deleted table
-- will have the old data (the rows that I want to delete them) and the inserted table
-- will have the new data (the rows that I want to insert them)


CREATE TRIGGER t5 -->Here I create a TRIGGER on the student table that prevents the delete
ON Student        -- and show the name that I tried to delete it
INSTEAD OF DELETE
AS
   SELECT FirstName FROM deleted


DELETE FROM Student
WHERE St_ID = 779


-- If I want to know the old course_name before the UPDATE
CREATE TRIGGER t8
ON Course
AFTER UPDATE
AS
   SELECT Crs_Name FROM deleted --> because the old names will be existed in deleted table


UPDATE Course
SET Crs_name = 'Cloud', Crs_duration = 45
WHERE Crs_id = 100


UPDATE Course
SET Crs_name = 'Cloud', Crs_duration = 45
WHERE Crs_id = 300


CREATE TRIGGER t8
ON Course
AFTER UPDATE
AS
   SELECT * FROM inserted
   SELECT * FROM deleted 


UPDATE Course
SET Crs_name = 'Cloud', Crs_duration = 45, top_id = 5
WHERE Crs_id = 700

-- The result will be changed for each fire
UPDATE Course
SET Crs_name = 'Cloud', Crs_duration = 45, top_id = 5
WHERE Crs_id = 800

UPDATE Course
SET Crs_name = 'html5', Crs_duration = 45, top_id = 5
WHERE Crs_id = 900

-- I can know the data before updating through using variable with update
UPDATE Course
SET Crs_Name = 'oop', @x = Crs_Name
WHERE Crs_ID = 100

-- I want to make a TRIGGER that prevents people from making deletion from table course in
-- Friday

-- The first way using AFTER
CREATE TRIGGER t9
ON Course
AFTER DELETE
AS
   IF FORMAT(GETDATE(), 'dddd') = 'friday'
      BEGIN
         SELECT 'Not delete'
         -- ROLLBACK --> It is a solution
         INSERT INTO Course --> I take the row that I delete it and insert it again in the
         SELECT * FROM deleted -- course table
      END

-- The second way using INSTEAD OF
CREATE TRIGGER t9
ON Course
INSTEAD OF DELETE
AS
   IF FORMAT(GETDATE(), 'dddd') != 'friday'
      BEGIN
         DELETE FROM Course WHERE Crs_ID = (SELECT Crs_ID FROM deleted) --> The data will be send to deleted and inserted in case of (INSTEAD OF / AFTER)
      END 

-- The deleted and inserted are volatile 

-- I want to make a thing that like deleted and inserted but it saves the information to use
-- it when I need (nonvolatile)
CREATE TABLE history
(
 _User VARCHAR(20),
 _date DATE,
 _oldid INT,
 _Newid INT
) --> I create this table to prevent the update on topic and stores information about it 
-- in the same time 

CREATE TRIGGER t10
ON topic
INSTEAD OF UPDATE
AS
   IF UPDATE(top_id)
      BEGIN
        DECLARE @new INT, @old INT
        SELECT @old = top_id FROM deleted
        SELECT @new = top_id FROM inserted
        INSERT INTO history
        VALUES(SUSER_NAME(), GETDATE(), @old, @new)
      END

--> Here I prevent the UPDATE at all but I store a row in history if this UPDATE was on 
-- top_id ELSE I don't store any values in history table

--------------------------------------------------------------
-- OUTPUT --> It makes a time trigger --> It means that It makes a trigger but in the runtime
-- through the time of running the query only

DELETE FROM Student
WHERE St_ID = 44 --> It will delete this row because I didn't make a TRIGGER
-- If I want to know the name of the user that want to delete a row ,I make a TRIGGER to
-- know that

-- There are another way --> Instead of TRIGGER we can use OUTPUT
DELETE FROM Student
OUTPUT GETDATE(), deleted.FirstName
WHERE St_ID = 44 --> It is like that you make a TRIGGER that show the date and the name that
-- you deleted it --> Note that this OUTPUT (TRIGGER) is on this QUERY only --> If you run
-- another query it doesn't return the date and the name of the persone that you deleted it
-- because actually there isn't a TRIGGER

-- I can do the OUTPUT also with the UPDATE and the INSERT 
UPDATE Student
SET FirstName = 'ali'
OUTPUT SUSER_NAME(), deleted.Age
WHERE St_ID = 1

-- I can take the data that exists in the OUTPUT and put it in the history table
UPDATE Student
SET FirstName = 'ali'
OUTPUT SUSER_NAME(), deleted.Age INTO history
WHERE St_ID = 1

INSERT INTO Student(St_ID, FirstName)
OUTPUT 'welcome to ITI'
VALUES(444,'ali')

-- OUTPUT --> It means that you make a runtime TRIGGER --> It means a TRIGGER on the query 
-- that you run it only

-- It means that the inserted table and deleted table always exist --> If you make TRIGGER
-- OR don't make --> They are used in the TRIGGER and with the OUTPUT

-----------------------------------------------------------------------------------
-- XML 
--> I use it to transfere data from database to another database such as transfering data
-- FROM oracle database to SQL Server database

-- If I want to make a join statement on data that exists in SQL Server and on data that 
-- exists in Oracle --> In this case I want a way to convert the Oracle to SQL OR to 
-- convert the SQL to Oracle --> The solution is using XML because it is an independent
-- language from the platform and the tool

-- There are two ways --> 
--1. I will convert the XML to a table through the keyword (OPEN XML)

--2. I will convert the table to XML through the keyword (FOR XML)
     -- FOR XML raw
     -- FOR XML auto
     -- FOR XML Explicit
     -- FOR XML Path

SELECT * --> The return value is a result set --> a thing in the shape of a table
FROM Student 

-- To make the return value returns in the shape of XML --> I will use (FOR XML) with one 
-- of the 4 keywords
SELECT *
FROM Student
FOR XML RAW --> I convert the table to XML --> some of tages

-- The result tage in XML doesn't have a name --> their name is row --> I want their name
-- to be student
SELECT *
FROM Student
FOR XML RAW('student')

-- All columns returned as attributes for the tage --> I want to make them as elements
--> I will use ELEMENTS
SELECT *
FROM Student
FOR XML RAW('student'),ELEMENTS

-- I want to make a root for the XML --> I will use ROOT()
SELECT *
FROM Student
FOR XML RAW('student'),ELEMENTS,ROOT('ITI_Studs')

-- The FOR XML has four modes to control XML Formate:
-- 1) RAW --> Transforms each row in the result set into an XML element

-- In the default --> the null value doesn't been shown in XML
-- If I want to show null values in XML --> I will use xsinil
SELECT *
FROM Student
FOR XML RAW('student'),ELEMENTS XSINIL,ROOT('ITI_Studs')

-- RAW mode queries can include aggregated columns and GROUP BY clauses.
SELECT * FROM Student
ORDER BY Address
FOR XML RAW('Student'), ELEMENTS, ROOT('STUDENTS')

SELECT Address, COUNT(St_ID) FROM Student
GROUP BY Address
FOR XML RAW('Student'), ELEMENTS, ROOT('STUDENTS')

-- You can only present data as elements or attributes
-- using FOR XML Path is the solution for representing mixed "elements and attributes"
-- for each seperate raw

-- JOIN problem
SELECT t.Top_id, Top_Name, Crs_Id, Crs_Name
FROM Topic t, Course c
WHERE t.Top_Id = c.Top_Id
FOR XML RAW ('topic'), ELEMENTS

-- should be nested topic includes cources
-- using FOR XML Auto is the solution for this problem

-- 2)Auto
-- Returns query results in a simple, nested XML tree. Each table in the FROM clause
-- for which at least one column is listed in the SELECT clause is represented as an XML
-- element. The columns listed in the SELECT clause are mapped to the appropriate element

SELECT t.Top_id, Top_Name, Crs_Id, Crs_Name
FROM Topic t, Course c
WHERE t.Top_Id = c.Top_Id
FOR XML AUTO, ELEMENTS

-- There is a problem in (FOR XML RAW) and (FOR XML AUTO) --> the all columns shown as 
-- attributes or as elements --> I can't make a mix of them 

-- To make this mix --> You will use (FOR XML Explicit) OR (FOR XML Path)


-- 3)Explicit
-- FOR XML EXPLICIT is a mode in SQL Server used to convert a query result set into a 
-- heavily customized, hierarchical XML document. It gives you absolute, granular control
-- over the generated XML structure. However, it requires a rigid, complex query design 
-- featuring a "Universal Table" structure constructed via UNION ALL statements.

--- The Universal Table Format

-- To use EXPLICIT mode, your query's result set must begin with two specific metadata 
-- columns, followed by the data columns using a structured naming convention:
   -- 1. Tag: An integer column representing the current element's nesting level.
   -- 2. Parent: An integer column representing the Tag number of its parent element 
   -- (set to NULL for top-level root elements).
   -- 3. Data Columns: Named using a specific four-part format argument: 
   -- ElementName!TagNumber!AttributeName!Directive.

--- Understanding Column Naming Syntax

-- Data column aliases must follow this exact format to direct SQL Server's layout engine:

[ElementName!TagNumber!AttributeName!Directive]

-- ElementName: The name of the resulting XML tag (e.g., Customer).

-- TagNumber: The structural tag level integer this column maps to.

-- AttributeName (Optional): The name of the attribute inside the element. If left blank,
-- it outputs as a child element instead of an attribute if a directive is given.

-- Directive (Optional): Modifies how data behaves (e.g., element to force a child tag, 
-- xml for unescaped content, or cdata to wrap in a CDATA section).

--- Step-by-Step Practical Example

-- Suppose you want to create a nested hierarchy of Customers and their Orders.

-- 1. The SQL Query

-- UNION ALL to pull data for both layers, then sort them via an ORDER BY statement so 
-- child rows immediately follow their parent rows.

SELECT 
    1 AS [Tag],
    NULL AS [Parent],
    CustomerID AS [Customer!1!ID],
    CustomerName AS [Customer!1!Name],
    NULL AS [Order!2!ID],
    NULL AS [Order!2!Date]
FROM Customers

UNION ALL

SELECT 
    2 AS [Tag],
    1 AS [Parent],
    CustomerID, -- Maps back to Parent to ensure accurate ORDER BY grouping
    NULL,
    OrderID,
    OrderDate
FROM Orders

ORDER BY [Customer!1!ID], [Tag]
FOR XML EXPLICIT;

-- 2. The Resulting XML Output

-- The query constructs a cleanly nested XML tree output like this:

<Customer ID="1" Name="Alice">
  <Order ID="101" Date="2026-08-12" />
  <Order ID="102" Date="2026-08-13" />
</Customer>
<Customer ID="2" Name="Bob">
  <Order ID="103" Date="2026-08-13" />
</Customer>

--- Modern Alternative: Why You Should Avoid It

-- While highly effective, FOR XML EXPLICIT is notoriously verbose, tedious to write,
-- and hard to maintain.

-- Microsoft introduced FOR XML PATH to solve this issue. PATH mode combined with nested 
-- FOR XML queries gives you the same absolute flexibility but with cleaner, much simpler
-- standard subqueries:

-- Modern, simpler equivalent using PATH
SELECT 
    CustomerID AS [@ID],
    CustomerName AS [@Name],
    (SELECT OrderID AS [@ID], OrderDate AS [@Date]
     FROM Orders o 
     WHERE o.CustomerID = c.CustomerID
     FOR XML PATH('Order'), TYPE)
FROM Customers c
FOR XML PATH('Customer');



-- 4)Path
-- Provides a simpler way to mix elements and attributes, and to 
-- introduce additional nesting for representing complex properities.
-- Easier than Explicit mode

--> These are an xbath expression --> that express the shape of the tage that will return
-- not an alias name
SELECT St_ID "@StudentID" --> @ --> means an attribute
       FirstName "StudentName/FirstName", --> name/name --> means nested tage
       LastName "StudentName/LastName", 
       Address "Address" --> name only --> means a tage
FROM Student
FOR XML Path('student')


SELECT St_ID "@StudentID" 
       FirstName "StudentName/@FirstName", --> means that the StudentName is a tage that 
       LastName "StudentName/LastName", -- have a tage (LastName) and an attribute (FirstName)
       Address "Address" 
FROM Student
FOR XML Path('student')


-- If I want to make a normal query or a query that has a GROUP BY in it --> I will use 
-- (FOR XML RAW)

-- If I want to make a query that has a JOIN in it --> I will use (FOR XML AUTO)

-- If I want to make a mix of an attribute and a tage and control the shape of the XML
-- I will use (FOR XML Path) OR (FOR XML Explicit)

------------------------------------------------------
-- We want to do the vise versa --> We have an XML and we want to convert it to a table
-- Or we want to make a join between an XML and a table , or create a table , or put the 
-- data that comes from XML in a table 

-- There are 5 steps that you should do them to convert the XML to a table

  -- 1. put the XML in a variable that its type is an XML
  DECLARE @docs XML = 
  
  -- 2. Declare an integer variable --> Declare document handle
  DECLARE @hdocs INT

  -- 3. I will call a built in stored called sp_xml_preparedocument then give it the integer
  -- as an OUTPUT and the XML --> create memory tree
  --> If the XML will formated --> I can draw it as a tree in the memory
  -- sp_xml_preparedocument --> try to draw the XML as a tree through that we will know
  -- if the XML will formated or has a problem
  EXEC SP_XML_PREPAREDOCUMENT @hdocs OUTPUT, @docs --> hdocs is like a pointer that I can 
  -- draw and read the tree from it

  -- 4.process document 'read tree from memory'
  -- OPENXML Creates Result set from XML Document

  SELECT * --> Here, I will write SELECT FROM the xml not from the table because the data 
  FROM -- exsits in an XML not in a table
  OPENXML (@hdocs, '//Student') --levels XPATH Code --> I want to reach each tage that called that called Student to read their data --> I have an XPATH expression '//Student' --> It means take all tages that their name is Student
  WITH (StudentID INT '@StudentID', --> In this step --> It is like creating a table
        Address VARCHAR(10) 'Address', --> the word that after the data type is the XPATH that it will use it to read
        StudentFirst VARCHAR(10) 'StudentName/First',
        StudentSECOND VARCHAR(10) 'StudentName/Second'
        )

  -- OPENXML (handler (the pointer that I can read the data with it), XPATH expression)

  -- 5.remove memory tree
  EXEC SP_XML_REMOVEDOCUMENT @hdocs

-- Note that you should the 5 steps in the same batch (in the same time)

-- I can create a new table with the XML 
DECLARE @docs XML =

DECLARE @hdocs INT

EXEC SP_XML_PREPAREDOCUMENT @hdocs OUTPUT, @docs 

SELECT * INTO ITIStuds --> SELECT INTO
  FROM 
  OPENXML (@hdocs, '//Student') 
  WITH (StudentID INT '@StudentID', 
        Address VARCHAR(10) 'Address',
        StudentFirst VARCHAR(10) 'StudentName/First',
        StudentSECOND VARCHAR(10) 'StudentName/Second'
        )

EXEC SP_XML_REMOVEDOCUMENT @hdocs
--> I will run the 5 steps in the same time

SELECT * FROM ITIStuds
-- I can make join between the data that exists in the XML and a data that exists in anither table
