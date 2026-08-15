-- When you make a table without a PK --> It means that the data is stored as a heap
--> It means that the data is not sorted on the hard disck --> So that the result is 
-- a Table Scan --> A table scan is a database operation where the system reads every
-- single row in a table sequentially from start to finish to check if the data
-- matches a query condition.

-- When I make a table without PK --> It means that the INSERT Statement is very 
-- simple and very fast --> Because When I make the INSERT Statement --> the new data
-- will always enter in the last because the data is not sorted

-- When you make a PK in your table --> There are 2 results --> 1- The data is sorted
-- -2 There is a Clustered Index that make the search is easy

-- When you search with non PK --> It will do a table scan --> To solve this problem 
-- You will create a NON Clustered Index

-- When you make a table with PK --> The Clustered Index will be created automatically
-- on the table (specifically on the PK)

-- So that I have only one Clustered Index in the table --> because I have only one PK
-- in the table


-- Clustered Index

-- A clustered index determines the physical, sorted order of data rows within a table.
-- Because physical data can only be stored in one sequence, a table can have only 
-- one clustered index. It acts like the table of contents of a book, storing 
-- the actual table records in its leaf nodes.

--- Key Characteristics

-- Physical Sorting: Unlike a regular index, the clustered index is the table.
-- When you create one, the database rearranges the physical rows on the disk 
-- to match the index order.

-- Single Instance: Because of physical storage constraints, you can only define 
-- exactly one clustered index per table.

-- Primary Key Default: In most relational database systems 
-- (like SQL Server or MySQL's InnoDB), the primary key automatically becomes
-- the clustered index unless you specify otherwise.

-- Leaf Node Contents: The lowest level (leaf nodes) of a clustered index tree
-- contains the actual data rows rather than pointers to them.

--- When to Use It

-- Clustered indexes are highly efficient but require careful planning:

-- Use for Range Queries: They are incredibly fast for returning a sequence of data
-- (e.g., all orders placed between Date A and Date B).

-- Use for Stable Data: The clustered column should ideally be static. 
-- If you update the value of a clustered column, the database must physically 
-- move the row on the disk, which can severely impact write performance.

-- Use for Unique or Sequential IDs: Keys that naturally increment 
-- (like an auto-incrementing integer or a sequential GUID) are ideal. This ensures 
-- new rows are appended to the end of the table rather than causing resource-heavy 
-- physical reordering in the middle of the disk.


--- Comparison with Nonclustered Indexes

-- Feature    |  Clustered Index              |   Nonclustered Index
---------------------------------------------------------------------------------------
-- Physical   |  Dictates the physical order  |   Does not alter physical order; exists
-- Ordering   |  of data on disk.             |   separately as a lookup structure.
---------------------------------------------------------------------------------------
-- Quantity   |  Only one per table.          |   Can have many per table.
-- allowed    |                               |
--------------------------------------------------------------------------------------- 
-- Leaf node  |  Contains the actual          |   Contains pointers to the 
-- data       |  data rows.                   |   physical rows.
---------------------------------------------------------------------------------------
-- Read/Write |  Very fast for reading;       |   Faster for inserts/updates than 
-- balance    |  slower for inserts/updates.  |   clustered, but reading all columns 
--            |                               |   may require an extra step.
---------------------------------------------------------------------------------------

-- Nonclustered Index

-- A non-clustered index is a separate database structure containing sorted index keys
-- and pointers that map back to the actual data rows. Unlike a clustered index, 
-- it does not change the physical order of data on the disk, allowing a table to 
-- have multiple non-clustered indexes.

--- How It Works

-- Separate Structure: Built as a B-tree outside the base table, like an index 
-- at the back of a book.

-- Leaf Nodes: Contain the indexed column values plus a row locator 
-- (either a Row ID pointer or a clustered index key).

-- Indirect Access: The database looks up the key in the index, finds the pointer, 
-- and then jumps to the data row.

--- Key Characteristics

-- Multiple Allowed: You can create many non-clustered indexes per table 
-- (up to 999 in SQL Server).

-- Storage Cost: They consume extra disk space because they duplicate column data
-- and store pointers.

-- Write Impact: Every insert, update, or delete on the table requires the database 
-- to update the separate index structure, which can slow down write performance.

-- Best Use: Ideal for speeding up selective WHERE, JOIN, or ORDER BY queries on
-- non-primary key columns.


CREATE CLUSTERED INDEX myindex
ON Student(FirstName) --> ERROR --> Because The student Table has a PK that has a
-- Clustered Index

-- I can't create more than clustered index on the same Table

-- To solve the previous problem , I will create a non clustered index
CREATE NONCLUSTERED INDEX myindex
ON Student(FirstName)

-- I can create more than one nonclustered index on the same table

CREATE NONCLUSTERED INDEX myindex2
ON Student(LastName)

-- The indexes will make the search more faster than the normal

SELECT *
FROM Student
WHERE St_ID = 100

-- PK     --> is a Constraint   --> Clustered Index
-- unique --> is a Constraint   --> Nonclustered Index

CREATE TABLE test2
(
 id INT PRIMARY KEY,
 name VARCHAR(20),
 age INT UNIQUE
) --> Once creating this table --> you will find that there are two indexes have been
-- created --> Clustered Index on the id column (PK) and NONClustered Index on the 
-- age column (UNIQUE)

-- Once creating a unique column --> You will find a NONClustered Index that have 
-- been created

-- Once creating a PK column --> You will find a Clustered Index that have 
-- been created

CREATE UNIQUE INDEX i4 --> UNIQUE Index --> It means a NONClustered Index
ON Student(Age) --> UNIQUE is a Constrain that has been applied on the old and 
-- new data --> So that If there is any row in the old data that doesn't match the
-- constraint , It won't be applied and will raise an ERROR

-- In the default --> IF there is a NONClustered Index and there isn't a Clustered 
-- Index --> The NONClustered Index will point to a pointer that point to the place 
-- of the data on the hard disck

-- If there is a Clustered Index and a NONClustered Index in the same table , the 
-- NONClustered Index will point to the Clustered Index

-- We create indexes on the columns that we will use it more in searching

-- There are two tools that will help you to know the columns that we use it more
-- in searching --> 1- SQL Server Profilier , 2- SQL Server Tuning Advisor

--------------------------------------------------
-- There are 4 databases that exist in the server by default --> 
-- (master, model, msdb, tempdb)

-- 1.master database --> contains all configurations (metadata) that exist in the server

-- The master database acts as the brain of a Microsoft SQL Server instance by 
-- recording all system-level configuration data, login accounts, and the 
-- physical file locations of all other user databases. Because it holds the
-- initialization blueprint for the entire instance, SQL Server cannot start 
-- if the master database is unavailable or corrupted.

--- Key Functions

-- Instance Configurations: Stores server-wide settings modified via sp_configure.

-- Security & Logins: Manages server login accounts, permissions, and linked 
-- server records.

-- Database Registry: Tracks the existence and physical .mdf and .ldf file paths of 
-- all other databases on the server.

--- Physical Properties

-- The master database consists of two default physical operating system files:
   -- Data File: master.mdf (Initial configuration grows by 10% automatically).
   -- Log File: mastlog.ldf (Initial configuration grows by 10% up to 2 terabytes).

--- Operational Rules & Restrictions

-- No User Objects: Do not create user tables, views, or stored procedures inside 
-- master.

-- Limited Modification: You cannot drop the database, change its default collation, 
-- or add extra filegroups.

-- Backup Limitations: It only supports full database backups; transaction log or
-- differential backups are not permitted.

--- Maintenance Best Practices

-- Backup Strategy: Back up master regularly, especially after running 
-- CREATE/ALTER/DROP DATABASE commands, changing server configurations, 
-- or modifying logins.

-- Disaster Recovery: If master is corrupted, you must start the SQL Server instance
-- in Single-User Mode (-m startup parameter) before you can run a RESTORE DATABASE
-- master command.


-- 2.model database --> It is considered as the template that exists on the server that 
-- if any data base created it will take an image from it

-- The model database in SQL Server is a built-in system database that serves as the 
-- template for every new database created on that SQL Server instance. When you run a
-- CREATE DATABASE statement, SQL Server copies the entire contents, configuration settings
-- , and structural options of the model database to form the foundation of your new 
-- database.

--- 🛠️ Key Roles of the model Database

-- Database Template: Any table, stored procedure, view, or user data type added to model
-- will automatically appear in every new database you create.

-- tempdb Lifecycle: Because the system tempdb database is completely recreated every time
-- SQL Server restarts, it relies on the model database configuration to rebuild its 
-- initial state.

-- Setting Defaults: It defines the starting parameters for downstream user databases.

--- 📋 Inherited Settings and Configurations

-- When a new database is generated, it clones several default physical and structural 
-- traits from model:

-- Inherited Property   |  Description
-------------------------------------------------------------------------------------------
-- Initial File Sizes   |  The default initial size of the .mdf (data) and .ldf (log) files.
-------------------------------------------------------------------------------------------
-- Autogrowth Rules     |  The specific MB or percentage increments the database uses 
--                         to expand when full.
-------------------------------------------------------------------------------------------
-- Recovery Model       |  Determines whether new databases default to Full, Simple, 
--                         or Bulk-Logged recovery.
-------------------------------------------------------------------------------------------
-- Database Options     |  State options like Collation settings, ANSI defaults, and 
--                         Compatibility Levels.
-------------------------------------------------------------------------------------------

--- ⚠️ Critical Best Practices

-- Do Not Add User Objects Lightly: Placing actual production tables or test objects 
-- directly into model can result in unwanted overhead, as those objects will accidentally
-- propagate across your entire server instance.

-- Intentional Modifications Only: Change settings in model only when setting 
-- instance-wide, corporate standards (e.g., standardizing a corporate default database
-- collation or establishing a default baseline for file growth).

-- Keep Regular Backups: If you customize the model database, ensure you capture it in
-- your System Database Backup Schedules. If model becomes corrupt or missing, SQL Server 
-- cannot rebuild tempdb and the entire server instance will fail to start.


-- 3. msdb database (Management Studio Database) --> The msdb database is a built-in 
-- system database in Microsoft SQL Server that serves as the central management hub 
-- for scheduling, automation, backup history, and background operations. It is primary 
-- known as the storage backbone for the SQL Server Agent service.

--- Core Responsibilities of msdb

-- SQL Server Agent: Stores all configuration and execution histories for jobs, steps,
-- schedules, alerts, operators, and proxies.

-- Backup & Restore History: Automatically logs the exact timestamp, media location, 
-- and type of every backup and restore operation performed on the server instance.

-- Database Mail: Retains configuration profiles, accounts, mail queues, and logging 
-- history for server-sent emails.

-- Integration Services (SSIS): Contains management tables for deploying, securing, 
-- and executing older SSIS or DTS packages.

-- High Availability Features: Tracks underlying operational metadata for features like 
-- log shipping and policy-based management.

--- Physical File Specifications

-- The database consists of two default physical files:
   -- Data File: MSDBData.mdf (Primary file group)
   -- Log File: MSDBLog.ldf (Transaction log)

--- Key Management Best Practices

-- Configure Maintenance Purges: The backup and job history tables will grow indefinitely
-- over time. Implement automated schedules using the Microsoft Learn Documentation on 
-- sp_delete_backuphistory and sp_purge_jobhistory to prevent disk space exhaustion.

-- Evaluate the Recovery Model: By default, msdb runs on the Simple recovery model. 
-- If you frequently alter jobs, packages, or require point-in-time recovery for audit
-- trails, consider switching it to the Full recovery model and establishing transaction 
-- log backups.

-- Perform Frequent Backups: Back up msdb as often as your production databases. If msdb
-- corrupts, SQL Server Management Studio (SSMS) loses the data required to build 
-- graphical database restoration trees.

-- : Treat msdb as a highly secure, sensitive environment. User accounts with excess
-- database permissions in msdb could potentially escalate privileges by writing 
-- malicious agent tasks.

--- Critical System Restrictions

-- To protect server stability, SQL Server blocks several operations on msdb:
   -- You cannot drop or rename the database.
   -- You cannot set the database to OFFLINE or change its primary collation.
   -- should not create custom user tables or objects inside it.


-- 4.tempdb --> The client (Devoloper) uses this database to create things in the runtime
-- and drop it in the runtime 

-- physical tabel
CREATE TABLE exam
(
  eid int,
  edate date,
  numofQ int,
) --> When I run this query and I use the ITI_SYSTEM --> The table will be created on 
-- the database of the ITI_SYSTEM

-- There is only one way to drop this column from the database --> using DROP 
DROP TABLE exam

-- There are another two types of tables rather than the physical table -->
   -- Local Table               -- Global Table

-- Local Tables (session based tables) --> To create these tables I will put (#) before 
--                                         the name of the column
CREATE TABLE #exam
(
  eid int,
  edate date,
  numofQ int,
) --> When I run this query and I use the ITI_SYSTEM --> Although that I won't find the 
-- table on the database of the ITI_SYSTEM --> I will find the table on the temp database
-- because of (#) that exists before the name of the table --> It means that you want to
-- create a session based table --> Every New Query that I create it , its name is a 
-- session --> but If I execute the query of the select statement from 
-- that table while using the ITI_SYSTEM --> It will be executed --> but there is a 
-- condition should be acheived , that you should run the query in the same session --> If 
-- you open a new session (New Query from above) and you try to execute the SELECT 
-- Statement --> The query won't run --> To solve this problem you will create the same 
-- table in the new session (New Query) and it will run 

-- You can create the same two tables with the same name in the same database in the same 
-- schema --> It is possible if they are temp tables --> he give each table an ID to know
-- the difference between them

-- You can DROP the tables with 2 ways -->
-- 1. You can use DROP TABLE TABLE_NAME
-- 2. When you close the session with saving it or without saving it --> Because they have
-- been created in the runtime and have been DROP in the runtime in the end of the session

-- ALL tables that begin with (#) --> will have been created in the temp database

SELECT * FROM #exam


-- Global Tables (shared tables)

CREATE TABLE ##exam
(
  eid int,
  edate date,
  numofQ int,
)--> When I run this query and I use the ITI_SYSTEM --> Although that I won't find the 
-- table on the database of the ITI_SYSTEM --> I will find the table on the temp database
-- because of (##) that exists before the name of the table --> It means that you want to
-- create a shared table --> It means that one person create it , then any one enter while
-- the person that create the table existed can work on this table 
--> It has a limit --> It will have been droped when all people that exists in the server
-- make disconnect

-- Those tables differ from the table variable
DECLARE @t TABLE (x INT) --> Local on the batch or on the function that he has been 
INSERT INTO @t VALUES(1) -- declared in it
SELECT * FROM @t

-- The tempdb database in SQL Server is a global, system-managed workspace shared by 
-- all users and databases connected to the SQL Server instance. It is explicitly designed
-- to handle transient data, meaning its contents are non-durable and do not persist across
-- database restarts.

--- Core Characteristics

-- Fresh Copy Every Restart: SQL Server drops and completely re-creates tempdb from
-- scratch every time the SQL Server service restarts.

-- No Backups or Restores: Because the data is fleeting, you cannot back up or restore 
-- the tempdb database.

-- Minimal Logging: Operations are minimally logged so that transactions can be rolled back
-- quickly, drastically improving throughput speed.

-- Simple Recovery Model: It is locked into the SIMPLE recovery model to ensure that 
-- log space is automatically reclaimed.

--- What Lives in TempDB?

-- The workload in tempdb is divided into three primary categories:

--                   ┌───────────────────────────────────┐
--                   │          tempdb Objects           │
--                   └─────────────────┬─────────────────┘
--                                     │
--       ┌─────────────────────────────┼─────────────────────────────┐
--       ▼                             ▼                             ▼
-- ┌─────────────────┐           ┌─────────────────┐           ┌─────────────────┐
-- │  User Objects   │           │Internal Objects │           │  Version Store  │
-- ├─────────────────┤           ├─────────────────┤           ├─────────────────┤
-- │• Local Temp     │           │• Spool work     │           │• Snapshot       │
-- │  Tables (#T)    │           │  tables         │           │  isolation      │
-- │• Global Temp    │           │• Hash join/     │           │• RCSI data      │
-- │  Tables (##T)   │           │  aggregate files│           │• Online index   │
-- │• Table variables│           │• Sort results   │           │  rebuilds       │
-- └─────────────────┘           └─────────────────┘           └─────────────────┘

-- 1. User Objects: Items explicitly created by users, such as local temporary tables 
-- (#table), global temporary tables (##table), table variables, temporary stored 
-- procedures, and cursors.

-- 2.Internal Objects: Transient work tables created automatically by the SQL Server 
-- Database Engine to process heavy query operations like sorting 
-- (for ORDER BY or GROUP BY), hash joins, and spooling.

-- 3.Version Store: A collection of data pages used to support features like snapshot 
-- isolation, Read Committed Snapshot Isolation (RCSI), and online index rebuilds.

--- Best Practices for Performance

-- Because tempdb is a heavily used, single global resource, it frequently becomes a
-- performance bottleneck if misconfigured. Follow these standard optimizations:

-- File Count Rule: Create one data file per logical CPU core up to a maximum of 8 data 
-- files. If contention continues beyond 8 files, add more in increments of 4.

-- Uniform Sizing: Configure all tempdb data files to have the exact same initial size 
-- and autogrowth settings. SQL Server uses a proportional-fill algorithm; unequal file 
-- sizes cause one file to absorb all the I/O pressure.

-- Fast Storage Isolation: Place tempdb data and log files on your fastest physical 
-- storage media, ideally dedicated NVMe or SSD drives, isolated entirely from your user
-- database files.

-- Avoid Manual Shrinking: Shrinking tempdb can severely fragment indexes and degrade 
-- performance. If it balloons unexpectedly due to a runaway query, it is best to simply
-- restart the SQL Server instance during a maintenance window to naturally reset its size.

------------------------------------------
-- Pivot and Group

USE test

CREATE TABLE Sales
(
  ProductID INT,
  SalesmanName VARCHAR(10),
  Quantity INT
)

TRUNCATE TABLE Sales 

INSERT INTO Sales
VALUES (1, 'ahmed', 10),
       (1, 'khalid', 20),
       (1, 'ali', 45),
       (2, 'ahmed', 15),
       (2, 'khalid', 30),
       (2, 'ahmed', 55),
       (2, 'khalid', 40),
       (2, 'ali', 70),
       (3, 'ahmed', 30),
       (4, 'ali', 90),
       (3, 'khalid', 30),
       (4, 'khalid', 90)

SELECT ProductID, SalesmanName, Quantity
FROM Sales

SELECT ISNULL(Name, 'my total'),qty
FROM(
   SELECT SalesmanName AS Name, SUM(quantity) AS Qty
   FROM Sales
   GROUP BY ROLLUP(SalesmanName)
   ) AS NewTa
   ble

SELECT ISNULL(x, 0), Quantities
FROM(
   SELECT ProductID AS X, SUM(quantity) AS "Quantities"
   FROM Sales
   GROUP BY ROLLUP(ProductID)
   ) AS newtable


SELECT ProductID AS X, SUM(quantity) AS "Quantities"
FROM Sales
GROUP BY ProductID --> It will return each productID with its sum of products

-- If I want a row in the result that contains the sum of all products
SELECT ProductID AS X, SUM(quantity) AS "Quantities"
FROM Sales
GROUP BY ProductID
UNION ALL
SELECT 0, SUM(quantity)
FROM Sales 

-- We can do the same thing using ROLLUP()

SELECT ProductID AS X, SUM(quantity) AS "Quantities"
FROM Sales
GROUP BY ROLLUP(ProductID)

-- ROLLUP() --> It takes the result of the query and executes on it the same function that
-- exists in the query

-- In the previous example --> It will execute the result of the sum on the same query

SELECT SalesmanName AS Name, SUM(quantity) AS Qty
FROM Sales 
GROUP BY ROLLUP(SalesmanName)


-- Order by ProductID, SalesmanName
SELECT SalesmanName, SUM(quantity) AS "Quantities"
FROM Sales 
GROUP BY ROLLUP(SalesmanName)


SELECT ProductID, SalesmanName, SUM(quantity) AS "Quantities"
FROM Sales 
GROUP BY ProductID, SalesmanName --> It will return the sum of quantities for each product
-- with each SalesmanName --> It is a compination between (ProductID, SalesmanName) --> 
-- it saw how many records that have (ProductID, SalesmanName) in the same time then sum 
-- the quantity of them
--> In this query it returns 10 rows


SELECT ProductID, SalesmanName, SUM(quantity) AS "Quantities"
FROM Sales 
GROUP BY ROLLUP(ProductID, SalesmanName) --> In this query it returns 15 rows --> It means 
-- there are 5 rows more than the rows in the previous query --> Because we use the ROLLUP()
-- in this query , there are 5 rows more than the previous query --> one of them is the sum 
-- of quentity because the ROLLUP() execute the same aggregate function on the result of the
-- query --> In this query --> ROLLUP() execute the same aggregate function with the first 
-- column only (ProductID) --> you will see that it returns the sum of ProductID1 and 
-- the sum of ProductID2, the sum of ProductID3, the sum of ProductID4 --> this means that
-- this is the result of 3queries --> The all total performance , the total performance for
-- each productID and the total performance for each ProductID with each SalesmanName with it


SELECT ProductID, SalesmanName, SUM(quantity) AS "Quantities"
FROM Sales 
GROUP BY ROLLUP(SalesmanName, ProductID) --> In this query it returns 14 rows --> Because I 
-- put the SalesmanName first then I put the ProductID --> the 10 rows is the main rows that
-- belong to the GROUP BY and the row that has the sum --> the remaining 4 rows contains the
-- sum for each SalesmanName alone --> Because the ROLLUP() works on the first column only
-- in the GROUP BY 
-- This query considered as the result of 3queries in the same time --> the performance of 
-- each product with each SalesmanName , the total performance for each SalesmanName and 
-- the all total performance 


-- We say that the ROLLUP() works on the first column only --> If I want it to work on the 
-- two columns , I will write CUBE() instead of ROLLUP()
SELECT ProductID, SalesmanName, SUM(quantity) AS "Quantities" 
FROM Sales 
GROUP BY CUBE(SalesmanName, ProductID) --> This query considered as the result of 4queries
-- together --> First, You make GROUP BY two columns --> It means the total performance for
-- each SalesmanName with each ProductID, You will see the total performance for each 
-- ProductID, You will see the total performance for each SalesmanName and the total
-- performance in general --> It means this is a UNION between 4Queries 


SELECT ProductID, SalesmanName, SUM(quantity) AS "Quantities" 
FROM Sales 
GROUP BY SalesmanName, ProductID --> The total quantity for each productID with each 
-- SelesmanName 


-- Grouping sets --> It ignores the GROUP BY --> It is the same that you didn't do a GROUP BY
SELECT ProductID, SalesmanName, SUM(quantity) AS "Quantities" 
FROM Sales 
GROUP BY GROUPING SETS(ProductID, SalesmanName) --> It will do ROLLUP() on the first column  
ORDER BY SalesmanName -- and on the second column and It won't do a GROUP BY 
-- In the GROUP BY --> you have to write the columns in it 
-- When you make GROUPING SETS --> you put the two columns because they exist in the SELECT
-- But actually --> you won't do a GROUP BY --> You will do ROLLUP() only on the two columns

-- Pivot and Unpivot OLAP
-- If you have the result of the previuos query
SELECT ProductID, SalesmanName, SUM(quantity) AS "Quantities"
FROM Sales
GROUP BY SalesmanName, ProductID

-- The pivot --> makes the rows as columns (GROUP BY and a rotation for the column)
-- To make a pivot , you want 3columns

SELECT *
FROM Sales --        FOR COLUMN_NAME  IN (the name of the rows that exist in it that I want to make them names of columns)
PIVOT (SUM(Quantity) FOR SalesmanName IN ([Ahmed],[Khalid], [Ali])) AS PVT 
--> In this Query , you take the rows of the SalesmanName and make it names of columns

-- This Query 
SELECT ProductID, SalesmanName, SUM(quantity) AS "Quantities"
FROM Sales
GROUP BY SalesmanName, ProductID
--> is the same meaning as the following Query if it can be executed
SELECT *
FROM Sales
PIVOT (SUM(Quantity)


-- UNPIVOT

-- The UNPIVOT operator in SQL Server rotates a table-valued expression by converting
-- columns into rows. It is the exact opposite of the PIVOT operator, restructuring wide
-- data formats into a tall, normalized structure.

SELECT <Non-pivoted columns>, <New Column Name for Labels>, <New Column Name for Values>
FROM <Source Table or Subquery>
UNPIVOT
(
    <New Column Name for Values> 
    FOR <New Column Name for Labels> IN (<Columns to turn into rows>)
) AS <Alias>;

-- Complete Code Example

-- Consider a MonthlySales table that tracks performance horizontally across columns:

-- 1. Setup Sample Data
CREATE TABLE MonthlySales (
    Year INT,
    January INT,
    February INT,
    March INT
);

INSERT INTO MonthlySales VALUES 
(2025, 200, 300, 250),
(2026, 400, 450, NULL);


-- 2. Apply UNPIVOT Querysql
SELECT Year, Month, Sales
FROM MonthlySales
UNPIVOT
(
    Sales FOR Month IN (January, February, March)
) AS UnpivotTable;

-- 3. Output Results

-- The dynamic column names shift under the Month column, and the metrics go under the 
-- Sales column:

-- Year              Month              Sales
-- 2025              January            200
-- 2025              February           300
-- 2025              March              250
-- 2026              January            400
-- 2026              February           450


--- Important Rules to Remember

-- NULLs are Dropped: By default, UNPIVOT automatically purges rows containing NULL values.
-- Notice how 2026 for March is missing completely from the output above.

-- Datatypes Must Match: All columns specified inside the IN (...) clause must share the
-- exact same data type and length. If they vary, you must convert them inside a subquery 
-- or Common Table Expression (CTE) first.


--- The Modern Alternative: CROSS APPLY

-- Many SQL developers prefer using CROSS APPLY with VALUES instead of the native UNPIVOT 
-- operator. It typically executes with better performance, handles multiple data types 
-- easier, and allows you to keep NULL records if desired.

SELECT m.Year, x.Month, x.Sales
FROM MonthlySales m
CROSS APPLY (
    VALUES 
    ('January', m.January),
    ('February', m.February),
    ('March', m.March)
) x(Month, Sales);
----------------------------------------------------
-- View
--> is a Select Statement
--> Specify user View of data 
--> hide DB Objects
--> Limit access of data 
--> Simplify Construction of complex queries
--> Has no parameter
--> Has no DML queries inside its body 
--> Standard view can be considered as Virtual table
--> Only index view can increase performance

-- Types of views:
   -- Standard View 
   -- Partotioned View
   -- Indexed View

-- Standard View (Virtual Table) --> The view that doesn't contain data
CREATE VIEW Vcairo
AS
   SELECT ID, Name, Address
   FROM Student
   WHERE Address = 'cairo'

SELECT * FROM Vcairo


CREATE VIEW Valex
AS
   SELECT ID, Name, Address
   FROM Student
   WHERE Address = 'alex'

SELECT * FROM Valex

-- I can do DML Queries but it will be applied on the basic table not on the view(the virtual table)


-- Partitioned View --> You create a view that takes data from different servers
CREATE VIEW VStuds
AS
   SELECT *
   FROM Mans_Server.ITI_SYSTEM.dbo.Students
   UNION ALL
   SELECT *
   FROM SohagServer.ITI2.HR.Studs

-- I can't do ORDER BY in the view and I can't do DDL Queries in the view 

-- SELECT Statements --> If they are on one server --> It will be a Standard View
                     --> If they are on more than one server --> It will be a Partitioned View


-- Indexed View --> It is considered as a view that has data in it --> It means that the 
-- performance will be better than the Standard View and the Partitioned View

-- An indexed view (also known as a materialized view) in SQL Server is a regular view 
-- that has been physically computed and stored on the disk.

-- Unlike a standard view—which is just a saved query that runs dynamically every time it
-- is called—an indexed view saves the actual data results to disk, drastically improving
-- query performance for complex joins and heavy aggregations.

--- How to Create an Indexed View

-- To materialize a view, you must follow a two-step process:

   -- 1.Create the view using the WITH SCHEMABINDING option and two-part table names 
   -- (e.g., dbo.TableName).

   -- 2.Create a Unique Clustered Index on the view.


-- Step 1: Create the view with schema binding
CREATE VIEW dbo.vw_SalesSummary
WITH SCHEMABINDING
AS
SELECT 
    ProductID,
    SUM(ISNULL(TotalAmount, 0)) AS TotalSales,
    COUNT_BIG(*) AS TotalTransactions -- Required if using GROUP BY
FROM dbo.SalesDetails
GROUP BY ProductID;
GO

-- Step 2: Materialize the view by creating a unique clustered index
CREATE UNIQUE CLUSTERED INDEX IX_vw_SalesSummary_ProductID
ON dbo.vw_SalesSummary (ProductID);
GO


--- When to Use vs. Avoid Indexed Views

-- Use Cases (Best Performance)      |     Avoid Cases (Performance Degradation)
-----------------------------------------------------------------------------------------
-- Read-heavy workloads and OLAP     |     Write-heavy tables (Frequent INSERT, UPDATE,
-- databases.                        |     DELETE).
-----------------------------------------------------------------------------------------
-- Queries with complex aggregates   |     Tables receiving more than 1,000 
-- on millions of rows.              |     modifications per minute.
-----------------------------------------------------------------------------------------
-- Joining large tables with static  |     When disk storage space is heavily restricted.
-- data.                             |
-----------------------------------------------------------------------------------------

-- Note: Whenever data changes in the underlying base tables, SQL Server automatically 
-- updates the data inside the indexed view. This adds processing overhead to every write
-- operation.

--- Strict Rules and Limitations

-- Because SQL Server needs to guarantee the physical data perfectly mirrors the base 
-- tables, indexed views carry extensive restrictions:

   -- Deterministic Data Only: You cannot use non-deterministic functions like GETDATE() 
   -- or NEWID().

   -- Syntax Restrictions: Standard T-SQL features like OUTER JOIN (LEFT/RIGHT), EXISTS,
   -- NOT EXISTS, SUBQUERIES, TOP, UNION, and DISTINCT are strictly forbidden.

   -- Aggregation Limits: If you use aggregates, you can use SUM and COUNT_BIG(*), but 
   -- you cannot use COUNT, MIN, or MAX.

   -- Schema Binding: You cannot alter or drop the underlying tables without dropping 
   -- the indexed view first.

   -- Single Database: The view cannot reference tables or views from other databases.

--- ⚠️ The "Enterprise" vs. "Standard" Edition Trap

-- SQL Server Enterprise Edition: The query optimizer will automatically look at your
-- queries, detect if an indexed view matches, and use it—even if you don't explicitly
-- reference the view in your FROM clause.

-- SQL Server Standard Edition: The query optimizer will ignore the index by default, 
-- treating it like a normal view. To force SQL Server Standard to use the physical index
-- on disk, you must explicitly query the view and add the WITH (NOEXPAND) table hint.

-- Required in SQL Server Standard Edition to gain performance benefits
SELECT ProductID, TotalSales 
FROM dbo.vw_SalesSummary WITH (NOEXPAND)
WHERE ProductID = 101;



--views
CREATE VIEW Vstuds
AS
   SELECT *
   FROM Students --> It means you disappear the metadata --> The user that will work on the 
   -- view won't know that there is a table called Students

SELECT * FROM Vstuds

-- You can take a part of the data not all the data
CREATE VIEW Vcairo
AS
   SELECT St_ID, FirstName, Address
   FROM Students
   WHERE Address = 'cairo'

SELECT * FROM Vcairo

SELECT FirstName FROM Vcairo

-- I can disappear the name of the columns through making alias names for each column while
-- creating the view

ALTER VIEW Vcairo(Sid, Sname, Saddress)
AS
   SELECT St_ID, FirstName, Address
   FROM Students
   WHERE Address = 'cairo'

SELECT * FROM Vcairo

SELECT FirstName FROM Vcairo --> ERROR --> Because there isn't FirstName column in the view

SELECT Sname FROM Vcairo


CREATE VIEW Valex(Sid, Sname, Saddress)
AS
   SELECT St_ID, FirstName, Address
   FROM Students
   WHERE Address = 'alex'

SELECT * FROM Valex

-- If there is a user that work on Vcairo and Valex in the same time --> 
SELECT * FROM Vcairo
UNION ALL
SELECT * FROM Valex

-- I can put the previous query in a new view
CREATE VIEW Vall
AS
   SELECT * FROM Vcairo
   UNION ALL
   SELECT * FROM Valex


ALTER SCHEMA HR TRANSFER Vall

CREATE VIEW Vjoin
AS
SELECT St_ID, FirstName, Dep_ID, Dep_Name
FROM Sudents S INNER JOIN Department D
ON D.Dep_ID = S.Dep_ID

SELECT * FROM Vjoin

-- If I want to change the name of the columns
ALTER VIEW Vjoin(Sid, Sname, Did, Dname)
AS
SELECT St_ID, FirstName, Dep_ID, Dep_Name
FROM Sudents S INNER JOIN Department D
ON D.Dep_ID = S.Dep_ID

SELECT * FROM Vjoin

SELECT Sname, Dname FROM Vjoin

SELECT Sname, Dname, Grade
FROM Vjoin --> ERROR --> Grade exists in the Student_Course Table

-- I can make join between view and table 

-- To solve the previous ERROR --> I will do a join between the view (Vjoin) and the Table
-- (Student_Course)

CREATE VIEW Vgrades
AS
SELECT Sname, Dname, Grade
FROM Vjoin V INNER JOIN Stud_Course SC
ON V.Sid = SC.St_ID

SELECT * FROM Vgrades


-- If I want the code that the view was written with it , I will use SP_HELPTEXT

SP_HELPTEXT 'Vjoin'
--> To prevent this --> You should use (WITH ENCRYPTION) while creating the view
CREATE VIEW Vjoin
WITH ENCRYPTION --> this is an encryption for the view not for the data 
AS
SELECT St_ID, FirstName, Dep_ID, Dep_Name
FROM Sudents S INNER JOIN Department D
ON D.Dep_ID = S.Dep_ID

-- When you run this query --> SP_HELPTEXT 'Vjoin' --> It won't show the code of the view
SP_HELPTEXT 'Vjoin' --> The result --> The text for object 'Vjoin' is encrypted


-- DML

--> I can't write DML Queries at the body of the view
-- I can do DML Queries on the view as a table , but with some conditions --> there are 2ways 
   -- 1.The view that take data from one table
   -- 2.The view that take data from multi tables


-- 1.The view that take data from one table --> you can make DML Queries on it but with 
-- some conditions --> The columns that doesn't exist in the view should allow 4things to
-- make the DML works --> (IDENTITY, ALLOW NULL, DEFAULT VALUE, DERIVED)
-- Here I can Do (INSERT, UPDATE, DELETE)

INSERT INTO Vcairo
VALUES (321,'ali','cairo')

SELECT * FROM Vcairo

-- 2.The view that take data from multi tables --> You can't use the DELETE operation here
-- You can do INSERT and UPDATE but there is a condition --> It should affect one table only

INSERT INTO Vjoin
VALUES(21, 'nada', 700, 'Cloud') --> It won't run because it insert two rows at different
-- tables 

-- To solve the problem --> you should insert in one table only
INSERT INTO Vjoin(Sid, Sname)
VALUES(21, 'nada') --> It will run because I INSERT values in columns that exist in one table
-- Don't forgit that --> The columns that doesn't exist in the view should allow 4things 
-- to make the DML works --> (IDENTITY, ALLOW NULL, DEFAULT VALUE, DERIVED) Else it won't run
-- Here I can Do (INSERT, UPDATE), I can't DELETE 


-- Indexed View
CREATE VIEW Vdata
WITH SCHEMA BINDING
AS
   SELECT Ins_name, Salary
   FROM dbo.Instructor
   WHERE Dep_ID = 10


ALTER TABLE Instructor ALTER COLUMN Ins_degree VARCHAR(50) --> It will run because 
-- Ins_degree column doesn't exist in the view

ALTER TABLE Instructor ALTER COLUMN Ins_name VARCHAR(100) --> ERROR --> Because Ins_name
-- column exists in the view --> the view takes a copy of it from the table of Instructor


-- There are 3phases that I should write the name of the Schema in the query
   -- 1. If I make a scalar function (When I call the scalar function)
   -- 2. If I make an indexed view
   -- 3. If I use a database and I want to select data from another database 

INSERT INTO Vcairo
VALUES(321,'ali', 'cairo') --> It is normal

-- If I want to insert the address of Alex --> It will be inserted normally --> It means 
INSERT INTO Vcairo -- that It inserts in the main table not in the view 
VALUES(321,'ali', 'alex')

-- If you want the (UPDATE , INSERT, DELETE) to be in the range of the view --> you will 
-- use --> (with check option) in the creation of the view--> It is like making a 
-- check constraint for the view

ALTER VIEW Vcairo(Sid, Sname, Saddress)
AS
   SELECT St_ID, FirstName, Address
   FROM Students
   WHERE Address = 'cairo'
   WITH CHECK OPTION --> 
-- I tell him here --> When you insert in the view --> insert for the people that their
-- address is cairo only

INSERT INTO Vcairo --> ERROR --> Because of (with check option) --> the address must be 
VALUES(321,'ali', 'alex') -- cairo 

-- With check option --> check the where condition before making any insert

---------------------------------------------------------------------------------
-- Index
-- Temp tables
-- Pivot
-- View
-- Merge
----------------------------------------------
-- Merge

-- There are many ways to write the Merge

-- The first way
MERGE INTO LastTransaction AS T
USING DailyTransaction AS S
ON T.id = S.did
WHEN MATCHED THEN
   UPDATE 
      SET T.myvalue = S.dval
WHEN NOT MATCHED THEN
   INSERT 
      VALUES(S.did, S.dname, S.dval); --> You should put (;) in the last of the query


-- The second way
-- make the source table as a subquery
MERGE INTO LastTransaction AS T
USING (Subquery) AS S -->
ON T.id = S.did
WHEN MATCHED THEN
   UPDATE 
      SET T.myvalue = S.dval
WHEN NOT MATCHED THEN
   INSERT 
      VALUES(S.did, S.dname, S.dval);


-- The third way
-- I will put a condition before (THEN) 
MERGE INTO LastTransaction AS T
USING DailyTransaction AS S
ON T.id = S.did
WHEN MATCHED AND S.dval > T.myvalue THEN -->
   UPDATE 
      SET T.myvalue = S.dval
WHEN NOT MATCHED THEN
   INSERT 
      VALUES(S.did, S.dname, S.dval);


-- The Fourth way
-- I will put (BY TARGET) before (THEN) that exists in the part of (NOT MATCHED) 
--> It means the thing that exists in the source and don't exist in the target 
MERGE INTO LastTransaction AS T
USING DailyTransaction AS S
ON T.id = S.did
WHEN MATCHED AND S.dval > T.myvalue THEN 
   UPDATE 
      SET T.myvalue = S.dval
WHEN NOT MATCHED BY TARGET THEN -->
   INSERT 
      VALUES(S.did, S.dname, S.dval);


-- The Fifth way
-- I will put (BY SOURCE) before (THEN) that exists in the part of (NOT MATCHED) 
MERGE INTO LastTransaction AS T
USING DailyTransaction AS S
ON T.id = S.did
WHEN MATCHED AND S.dval > T.myvalue THEN 
   UPDATE 
      SET T.myvalue = S.dval
WHEN NOT MATCHED BY SOURCE THEN -->
   DELETE;


-- The word (TARGET) references to the table that exists besides the MERGE
-- The word (SOURCE) references to the table that exists besides the USING

-- NOT MATCHED BY TARGET --> It means that the thing that exists in the source and doesn't
-- exist in the target 

-- NOT MATCHED BY SOURCE --> It means that the thing that exists in the target and doesn't
-- exist in the source

