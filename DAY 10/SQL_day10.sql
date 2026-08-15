-- Cursor --> It is a way to deal with result set row by row
-- It is like I want to make for loop for rows

SELECT *
FROM emp
WHERE eage > 20 --> The thing that returns from any query called result set (one block that
-- has your data) --> I want to loop on this data to make this data comes row by row that
-- I can work with each row alone

-- To loop on the result set , you should work on the cursor --> 
-- The steps --> 
  -- 1. DECLARE Cursor --> It means I begine define the SELECT Statement that you will work 
                       -- on it
  -- 2. DECLARE Variables --> You want to declare variables to assign your values in them 
                          -- we define the number of the variables from the number of the 
                          -- columns that returned from the query
  -- 3. Open Cursor --> It places the pointer at the first row
  -- 4. Fetch row --> It takes your rows and transefer it to the memory
  -- 5. @@fetch_statu = 0 --> It is a Global Variable that returns one of 3 values (0, 1, 2)
                          -- each number of them has a meaning 
                          --> If it returns 0 --> It means that I can fetch the rows correctly 
                          --> If it returns 1 --> It means there are rows but when he transefer 
                          -- it to the memory , he finds a problem --> it means there are rows
                          -- but I can't fetch them
                          --> If it returns 2 --> It means there were rows but I already
                          -- finished them 

                          -- In this case after the checking on fetch --> I will begin see 
                          -- what the processing that I want to do on the rows

                          -- The Fetch moves me to the next row until arriving the last row
                          -- I will still existing in this loop until finishing all rows 

                          -- If the fetch equal to zero --> I will look at my processing , Else
                          -- I will make Close Cursor then Deallocate Cursor

  -- 6. Close Cursor --> It saves the pointer --> If I have a loop I will loop on 10 rows
                     -- in it --> I make a loop until 5 rows then I want to stop the loop
                     -- and do another thing first then return to complete the loop --> to
                     -- make it --> I will do (Close Cursor) then when I want to complete
                     -- the loop --> I will do (Open Cursor) --> It will make you start from
                     -- the position you stoped at it 
  -- 7. Deallocate Cursor --> It means you remove all memory that the cursor use it when he 
                          -- was working


-- Note that it is DECLARE NOT CREATE --> because the cursor is not a database object --> 
-- It is only a thing that works on the memory

-- Note that the Cursor always works forward not backward

-- The difference between the Close Cursor and the Deallocate Cursor -->
-- If I do Close Cursor , I can do Open again then it will start from the position that it
-- stoped at it
-- If I do Deallocate Cursor , I can't do open again because I desteroy the space that 
-- exists in the memory --> If you want to work on the cursor again you should make declare 
-- for the cursor and start the steps fro the begining 

SELECT St_ID, FirstName
FROM Student
WHERE Address = 'cairo' --> When you run this query , you will find a rows / result set 
                        -- (one block) 

-- I will put the previous query in a Cursor 
DECLARE c1 CURSOR
FOR SELECT St_ID, FirstName
  FROM Student
  WHERE Address = 'cairo'
FOR READ ONLY -- FOR UPDATE --> It is the behaviour of the cursor --> When I loop on the 
-- CURSOR --> I will loop and show the rows only OR I will loop and through that I will 
-- update the data 
-- The default is --> FOR UPDATE 

-- Then I will declare variables with the same number of the returned table
DECLARE @id INT, @name VARCHAR(20)
OPEN c1 
FETCH c1 INTO @id, @name
WHILE @@FETCH_STATUS = 0
   BEGIN
      SELECT @id, @name
      FETCH c1 INTO @id, @name --> To prevent the infinite loop --> It is like as counter++
   END
CLOSE c1
DEALLOCATE c1 --> I will run the lines from line 65 to line 84 in the same batch (in the same time)
--> After run the query I will find the result be (scattered) separated --> each row returned
-- as a result set belongs to itself 

SELECT FirstName
FROM Student
WHERE FirstName IS NOT NULL
--> I want the result to be shown as a one cell [Ahmed, Amr, Mona.........]
--> I want a list with student names separated by column
--> I will make a loop on the names and I will concat these names with a variable then 
-- finally I will show the variable that has all names in one time

DECLARE c1 CURSOR
FOR SELECT FirstName
   FROM Student
   WHERE FirstName IS NOT NULL
FOR READ ONLY 
--> Here I want to declare 2 variables --> One variable that takes the FirstName and another
-- variable that takes all names concated with each other
DECLARE @name VARCHAR(20), @allnames VARCHAR(300) = ''
OPEN c1
FETCH c1 INTO @name
WHILE @@FETCH_STATUS = 0
   BEGIN
       SET @allnames = CONCAT(@allnames,',',@name)
       FETCH c1 INTO @name --> To prevent the infinite loop
   END
CLOSE c1
DEALLOCATE c1


DECLARE c1 CURSOR
FOR SELECT FirstName
   FROM Student
   WHERE FirstName IS NOT NULL AND Address = 'cairo'
FOR READ ONLY 
--> Here I want to declare 2 variables --> One variable that takes the FirstName and another
-- variable that takes all names concated with each other
DECLARE @name VARCHAR(20), @allnames VARCHAR(300) = ''
OPEN c1
FETCH c1 INTO @name
WHILE @@FETCH_STATUS = 0
   BEGIN
       SET @allnames = CONCAT(@allnames,',',@name)
       FETCH c1 INTO @name --> To prevent the infinite loop
   END
CLOSE c1
DEALLOCATE c1

-- I want to make a cursor for update 
-- I want to make a loop on the employees's salary then I will delete the employees that 
-- their salary less than 3000 and I will update the employees that their salary greater
-- than 3000 

DECLARE c1 CURSOR
FOR SELECT Salary 
   FROM Instructor
FOR UPDATE --> It means that I will update the table --> I will use (UPDATE, DELETE, INSERT)

DECLARE @sal INT
OPEN c1
FETCH c1 INTO @sal
WHILE @@FETCH_STATUS = 0
   BEGIN
      IF @sal >= 3000
         UPDATE Instructor
            SET Salary = @sal * 1.20
            WHERE CURRENT OF c1 --> It means where the cursor (pointer) stop now 
      ELSE
         UPDATE Instructor
            SET Salary = @sal * 1.10
            WHERE CURRENT OF c1
      FETCH c1 INTO @sal
   END
CLOSE c1
DEALLOCATE c1

-----------------------------------------------
-- There is a specific pattern that has been repeated --> such as in many times Amr comes 
-- after Ahmed --> We want to make a cursor that tells us how many times Amr comes After 
-- Ahmed

DECLARE c1 CURSOR
FOR SELECT FirstName
   FROM Student
FOR READ ONLY 

DECLARE @name VARCHAR(20), @counter INT = 0, @flag INT = 0
OPEN c1
FETCH c1 INTO @name
WHILE @@FETCH_STATUS = 0
   BEGIN
      IF @name = 'ahmed'
        BEGIN
           SET @flag = 1
        END
      IF @name = 'amr'
        BEGIN
           IF @flag = 1
             BEGIN
                SET @counter += 1
                SET @flag =0
             END
        END
      FETCH c1 INTO @name
   END
SELECT @counter
CLOSE c1
DEALLOCATE c1
-----------------------------------------------------------------------
-- Types of backups:
---------------------
-- Full backup --> takes a backub of data from the creation of the database to the time 
               -- the time that you want to make a backub in it now 
-- Diffrential backup --> takes a backup of data that takes the difference between him and 
                      -- the last full backup that was exists 
                      --> Note that, To make the Diffrential backup you should do a full 
                      -- backup in the first
                      --> Note that the Diffrential backup and the Full backup make backup
                      -- from the mdf
-- Transaction log backup --> makes a backup from the log file (ldf) --> The log file 
                          -- contains the queries with their time and with the name of the 
                          -- persone that run them 
                          --> makes a backup from the log file --> he will see the last 
                          -- backup that exists and will take the queries of this backup
                          --> It looks at the last backup regardless of its type and
                          -- takes the queries that run in this time and make a backup for
                          -- them then make the log file be empty

-- Filegroup backup


-- The only way to restore the data at any time is with using Transaction log backup

-- How to create the query of the backup to make it run automatically

-- BACKUP DATABASE Database_Name
-- TO DISK = 'bath of the file'

BACKUP DATABASE ITI_SYSTEM --> this query make a full backup
TO DISK = 'D:\ITI_SYSTEM.bak'

-- I want this query to be run every day at 12 AM --> This called jobs
-- We have child service bottom the main service (Database Engine) -->
-- Their name is SQL Server Agent --> It is a child service bottom the main service

-- There is a thing bottom the SQL Server Agent called a job 
-- A job --> is a query that has been run in a specific time 
-- A job is considered as some of steps 

-- The query of the backup and the restore have been run on the master database 

-- To make Diffrential backup --> you will use (with differential)
BACKUP DATABASE ITI_SYSTEM --> this query make a full backup
TO DISK = 'D:\ITI_SYSTEM.bak'
WITH DIFFERENTIAL
---------------------------------------------------------------

-- Advanced Queries

-- IDENTITY column with insert
-- Only one IDENTITY column in the table not allowed for multiple IDENTITIES

CREATE TABLE dbo.T1 
(
 Column_1 INT,
 Column_2 VARCHAR(30),
 Column_3 INT IDENTITY PRIMARY KEY
);
GO

SELECT * FROM T1

DELETE FROM T1 WHERE Column_3 BETWEEN 3 AND 8 
--> If I insert values after the delete --> It will make an IDENTITY Gab --> 1,2,9,10,11
--> We know that you can't write in the IDENTITY Column --> If we try to full the Gap and
-- Insert the number 4 in the IDENTITY --> It will raise an ERROR
-- There is information that says that the IDENTITY is a properity on the table --> so
-- we can switch on and switch off it

INSERT T1 VALUES(1,'Row #1');
INSERT T1 (Column_2) VALUES ('Row #2')
GO
SET IDENTITY_INSERT T1 ON; --> When we make it ON , we can insert values now in the IDENTITY column 
SET IDENTITY_INSERT T2 OFF; --> This is the default 
GO
INSERT INTO T1 (Column_3, Column_1, Column_2) VALUES
(4, 1, 'Explicit IDENTITY Value');
INSERT INTO T1 (Column_3, Column_1, Column_2) VALUES
(7, 777, 'Eman');
GO 
SELECT Column_1, Column_2, Column_3
FROM T1;

DROP TABLE T1

-- If you want to return the IDENTITY to a specific position --> There is a line of code to 
-- reset the IDENTITY --> dbcc checkident(TableName, RESEED, 1)
dbcc checkident(T1, RESEED, 3) --> The IDENTITY will return to the number 3 --> you can 
-- insert from it

-- If I want to return the IDENTITY number that I stop on it now --> I will use the 
-- Global variable (@@IDENTITY)
SELECT @@IDENTITY
-- There is another way using IDENT_CURRENT that takes the name of the table that I want 
-- to know the IDENTITY number that I stop on it now
SELECT IDENT_CURRENT('T1')

-- IDENTITY limitations
   -- The IDENTITY column of a table contains a unique, system_generated ID number for each
   -- row in the table

   -- Adaptive Server stores in memory blocks of potential ID numbers for each table

   -- It stores the last-used value and the block's maximum value
-------------------------------------------------------------------------
-- Types of INSERT Statement
   -- Simple INSERT
   -- INSERT Constructor --> INSERT more than one row in the same time
   -- INSERT Based ON SELECT --> I take a data from a table and INSERT with it
   -- INSERT Based ON EXECUTE --> I use it with the Stored Procedure
   -- Bulk INSERT
--------------------------------
-- Bulk INSERT --> It means that you have a file and you want to take this data and INSERT
-- it in a table

BULK INSERT emp --> This is the name of the table that you want to INSERT the data in it
FROM 'D:\mydata.txt' --> The path of the file
WITH (fieldterminator = ',')--> The Format of the file

-- Import Export Wizard
--------------------------------------------------------------------
-- Snapshot --> Read only database (90% empty database) (10% has the data that you update it in the database)
---------------
--> It is a thing like a backup but It is lighter than the backup
-- When you make update (UPDATE, DELETE) on the database --> The snapshot make 
-- (Copy on Write) --> takes a copy of the data that you update it and store it in the
-- Snapshot and delete the pointer that pointed to this data in the database
-- Snapshot doesn't have a log file

-- Snapshot
-- Read Only DB
-- Used for reporting only
-- Capture DB in the time of taking snapshot
-- I can take more than of snapshot for the same DB in different times
-- Used only with NTFS format only
-- Copy on write Concept

-- DB Snapshots
-- Use Database Snapshots to: "testing reporting and handling errors"
-- 1) Maintain historical data for report generation
-- 2) Mirror data to free up resources
-- 3) Safeguard against administrative error
-- 4) Safeguard against user error
-- 5) Manage a test database

USE AdventureWorks
CREATE DATABASE AdventureWorks_Snap_01
ON
(
 name = 'AdventureWorks_Data', --> DB data file name
 filename = 'D:\db\adventure.ss'
)
AS SNAPSHOT OF AdventureWorks --> Database attach name

-- Create Snapshot for database that has more one data file
CREATE DATABASE MyNewDB_snapshot01 ON
   (NAME = df1, FILENAME = 'C:\df1_01.ss'),
   (NAME = df2, FILENAME = 'C:\df2_01.ss'),
   (NAME = df3, FILENAME = 'C:\df3_01.ss'),
   (NAME = df4, FILENAME = 'C:\df4_01.ss')
AS SNAPSHOT OF MyNewDB;

-- Test snapshot
USE AdventureWorks;
SELECT BirthDate FROM HumanResources.Employee
WHERE EmployeeID = 1

USE AdventureWorks_Snap_01;
SELECT BirthDate FROM HumanResources.Employee
WHERE EmployeeID = 1

USE AdventureWorks;
UPDATE HumanResources.Employee
SET BirthDate = '1988-10-10'
WHERE EmployeeID = 1

-- We can't update or edit snapshot, it's read only database.
USE AdventureWorks_Snap_01;
UPDATE HumanResources.Employee
SET Birthdate = '1988-10-10'
WHERE EmployeeID = 1

-- Reverting (restoring) from snapshot
-- Cannot revert with db is corrupted or deleted
USE MASTER;
RESTORE DATABASE AdventureWorks
FROM DATABASE_SNAPSHOT = 'AdventureWorks_Snap_01' -- snapshot name in object explorer

-- Drop db snapshot
DROP DATABASE AdventureWorks_Snap_01

-- Snapshots Vs. Backup:
-- 1) Snapshot can used to retrieve data directly, 
-- without need to restore the main database
-- ( Can used while the source database exist in the same time)
-- ,while backups can't.
-- 2) Reverting snapshot does not work in an offline or corrupted
-- database. While backup does.


CREATE DATABASE ITI_SNAP --> To run this Query I should use the Master database first
ON
(
 name = 'ITI_SYSTEM', --> The name of the mdf file on the hard disk
 filename = 'D:\ITI_SNAP.ss' --> The file that will be created on the hard disk
)
AS SNAPSHOT OF ITI_SYSTEM

SELECT * FROM Student --> To run this Query I should use the ITI_SYSTEM database first

SELECT * FROM Student --> To run this Query I should use the ITI_SNAP database snapshot first

-- If I want to restore the data from the snapshot I should be in the same server
RESTORE DATABASE ITI_SYSTEM --> To run this Query I should use the Master database first 
FROM DATABASE_SNAPSHOT = 'ITI_SNAP' --> snapshot name in object explorer
--> After runing this query it should return the database to its shape in the time that 
-- I take the snapshot 

-- The differences between the snapshot and the backup

-- The backup --> has the data and the metadata , I can transfer it to another server

-- The snapshot --> exists in the same server , It is a read only database , Usually it 
-- doesn't have data , It has pointers that point to the data 

-----------------------------------------------------------
-- Cursor
-- Backup
-- Snapshot
-- SQLCLR
------------------------
-- SQLCLR (Structured Query Language Common Language Runtime)
-- CLR (Common Language Runtime) --> is the compiler of the visual studio 
-- (the compiler of the C#)

-- SQLCLR --> It is a way that makes you do the things that you make them in SQL --> make
-- them with the code of the C# 

-- SQLCLR 
------------Function --> The runtime engine of C# is faster than the runtime engine of SQL
------------New data type   sp_addtype --> It doesn't make a datatype but It makes an alias name for your datatype
            --> [class, struct] --> I can't do them with SQL but I can do them with C#
            
-- First, You should enable for the SQLCLR in SQL Server 
SP_CONFIGURE 'clr_enable', 1
GO
RECONFIGURE

