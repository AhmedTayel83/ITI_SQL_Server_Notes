-- Question 1 Display the Department id, name and id and the first name of its manager.

SELECT  DEP.Dep_ID , DEP.Dep_Name , EMP.Emp_ID , EMP.FirstName 
FROM
Employee EMP
INNER JOIN Department DEP
ON  DEP.ManagerID = EMP.Emp_ID;


-- Question 2 Retrieve a list of all courses along with their corresponding topics, 
-- displaying the course name and topic name for each record

SELECT C.Crs_Name , T.Topic_Name
FROM Course C
INNER JOIN Topic T
ON C.Crs_ID = T.Crs_ID;


-- Question 3 Display the full data about all the dependence associated with the name (first ,last) 
-- as "EmployeeFullName" of the employee they depend on him/her.

SELECT D.* , (EMP.FirstName + ' ' + EMP.MiddleName + ' ' + EMP.LastName) AS EmployeeFullName
FROM Employee EMP
INNER JOIN Dependant D
ON EMP.Emp_ID = D.Emp_ID;


-- Question 4 Display the Id, name and address of the employess in Cairo or Alex city.

SELECT Emp_ID , FirstName , Address
FROM Employee 
WHERE Address IN ('Cairo','Alex');


-- Question 5 Display the employees full data with a name starts with "a" letter.

SELECT *
FROM Employee
WHERE FirstName LIKE 'a%';


-- Question 6 display all the employees in department 1 whose salary from 1000 to 5000 LE monthly
--a.	 (use And)
--b.	(use Between)
SELECT *
FROM Employee
WHERE Dep_ID = 1 AND Salary BETWEEN 1000 AND 5000;


-- Question 7 Retrieve the Ids, first and last names of all students who have a grade greater 
-- than or equal to 80 and a course duration greater than or equal to 80

SELECT St.St_ID , FirstName , St.LastName 
FROM Student St
INNER JOIN Student_Course St_CS
ON St.St_ID = St_CS.St_ID
WHERE St_CS.Grade >= 80 AND St_CS.Evalution >= 80;


-- Question 8 Find the names (first,middle,last) of the students who directly supervised with Noha Mohamed.


SELECT St.FirstName , St.MiddleName , St.LastName
FROM Student St
INNER JOIN Student Su
ON St.Supervisor_ID = Su.St_ID
WHERE Su.FirstName = 'Noha' AND Su.MiddleName = 'Mohamed';


-- Question 9 Retrieve the names (first, middle, last), hour rate, and EvolutionGrade of all 
-- instructors and the names of the courses they are teaching, sorted by the course name

SELECT I.FirstName , I.MiddleName , I.LastName , 
I.HourRate , In_Cs.EvoultionGrade , C.Crs_Name
FROM Instructor I
INNER JOIN Instructor_Course In_Cs
ON I.Ins_ID = In_Cs.Ins_ID
INNER JOIN Course C
ON C.Crs_ID = In_CS.Crs_ID
ORDER BY C.Crs_Name;


-- Question 10 Retrieve a list of all employees, including those who are assigned to 
-- a department and those who are not.

SELECT * 
FROM Employee EMP
LEFT JOIN Department DEP
ON DEP.Dep_ID = EMP.Dep_ID;


-- Question 11 Display All Data of the managers and direct employees

SELECT * FROM Employee

SELECT *
FROM Employee EMP
INNER JOIN Employee MNG
ON EMP.Emp_ID = MNG.Manager_ID;


-- Question 12 Display All Employees data and the data of their dependents 
-- even if they have no dependents

SELECT *
FROM Employee EMP
LEFT JOIN Dependant D
ON EMP.Emp_ID = D.Emp_ID;


-- Question 13 Insert your personal data to the employee table as a new employee 
-- in department number 10, SSN = 1000, manager id = 1, salary=3000.

INSERT INTO Employee (SSN, FirstName, Dep_ID, Manager_ID, Salary)
VALUES (1000, 'Ahmed', 10, 1, 3000);


-- Question 14 Insert another employee with personal data your friend as new employee in department 
-- number 10, SSN = 1010, but don’t enter any value for salary or supervisor number to him.

INSERT INTO Employee (SSN, FirstName, Dep_ID)
VALUES (1010, 'Yahya', 10);

-- a.Upgrade your salary by 20 % of its last value.

UPDATE Employee
SET Salary = Salary * 1.2
WHERE SSN = 1000;


