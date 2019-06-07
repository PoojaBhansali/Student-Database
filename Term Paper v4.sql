create database SCHEDULE;
use SCHEDULE;

create table Student_t
(NetID varchar(6) not null,
StudentName varchar(50) not null,
Major varchar(4) not null,
GradSem varchar(20),
CONSTRAINT Student_PK PRIMARY KEY (NetID));

create table Instructor_t
(InstructorName varchar(50) not null,
InstructorOffice varchar(20),
CONSTRAINT Instructor_PK PRIMARY KEY (InstructorName));

create table Course_t
(CourseNumber varchar(15) not null,
CourseName varchar(80) not null, 
CreditHours integer not null,
InstructorName varchar(50) not null,
CourseRoom varchar(9) not null,
CONSTRAINT Course_PK PRIMARY KEY (CourseNumber),
CONSTRAINT Course_FK FOREIGN KEY (InstructorName) REFERENCES Instructor_t(InstructorName));

create table CourseBook_t
(CourseBook varchar(100),
CourseBookPub varchar(100) not null,
CourseNumber varchar(15) not null,
CONSTRAINT CourseBook_PK PRIMARY KEY (CourseBook),
CONSTRAINT CourseBook_FK FOREIGN KEY (CourseNumber) REFERENCES Course_t(CourseNumber));

create table CourseTaken_t
(NetID varchar(6) not null,
CourseNumber varchar(15) not null,
PRIMARY KEY (NetID, CourseNumber),
CONSTRAINT CourseTaken_FK1 FOREIGN KEY (NetID) REFERENCES Student_t(NetID),
CONSTRAINT CourseTaken_FK2 FOREIGN KEY (CourseNumber) REFERENCES Course_t(CourseNumber));

insert into Student_t VALUES
('gs6262','Pooja Bhansali','MSBA','Spring 2020'),
('xz2433','Chanyuan Wen','MSBA','Spring 2020'),
('zw7657','Travis Alderman','MSBA','Spring 2020'),
('sp6566','Munahil Murrieum','MSBA','Fall 2019');

insert into Instructor_t VALUES
('Jiming Wu','VBT 355'),
('Chongqi Wu','VBT 406B'),
('Jyotishka Ray','VBT 342'),
('Lan Wang','VBT 345'),
('Zinovy Radovilsky','VBT 350'),
('Ryan Lampe','VBT 324');

insert into Course_t VALUES
('BAN 601', 'Tech Fundamentals for Analytics',3,'Jiming Wu','VBT 222'),
('BAN 602', 'Quantitative Fundatmentals',3,'Chongqi Wu','Online'),
('BAN 610', 'Database Mgmt & Applications',3,'Jyotishka Ray','MH 2038'),
('BAN 612', 'Data Analytics',3,'Lan Wang','SC N119'),
('BAN 620', 'Data Mining',3,'Zinovy Radovilsky','VBT 219'),
('BAN 630', 'Optimization Methods for Analytics',3,'Chongqi Wu','VBT 137'),
('ECON 610', 'Advanced Econometrics',3,'Ryan Lampe','SC N110'),
('BAN 632', 'Big Data Technology and Applications',3,'Jiming Wu','VBT 219');

insert into CourseBook_t VALUES
('Python for Everybody','CreateSpace Independent Publishing Platform', 'BAN 601'),
('Java for Beignners','McGraw-Hill Education', 'BAN 601'),
('Statistics for Business and Economics','Cengage Learning', 'BAN 602'),
('Modern Database Management','Pearson', 'BAN 610'),
('Python for Data Analysis','O Reilly Media', 'BAN 612'),
('Data Science from Scratch','O Reilly Media', 'BAN 612'),
('Data Mining for Business Analytics','Wiley', 'BAN 620'),
('Practical Management Science','Cengage Learning', 'BAN 630'),
('Introductory Econometrics A Modern Approach','Cengage Learning', 'ECON 610'),
('Hadoop: The Definitive Guide','O Reilly Media', 'BAN 632');

insert into CourseTaken_t VALUES
('gs6262','BAN 601'),
('gs6262','BAN 602'),
('gs6262','BAN 610'),
('gs6262','BAN 612'),
('gs6262','BAN 620'),
('xz2433','BAN 601'),
('xz2433','BAN 602'),
('xz2433','BAN 610'),
('xz2433','BAN 612'),
('xz2433','BAN 630'),
('xz2433','ECON 610'),
('zw7657','BAN 601'),
('zw7657','BAN 602'),
('zw7657','BAN 610'),
('zw7657','BAN 620'),
('sp6566','BAN 601'),
('sp6566','BAN 602'),
('sp6566','BAN 612'),
('sp6566','BAN 610'),
('sp6566','BAN 620'),
('sp6566','BAN 630'),
('sp6566','BAN 632');

--Query 1
SELECT GradSem, count(NetID) AS 'Number of Students'
FROM Student_t
GROUP BY GradSem

--Query 2
SELECT StudentName, Major FROM Student_t
WHERE NetID in (SELECT NetID FROM CourseTaken_t WHERE CourseNumber= 'BAN 610')

--Query 3
SELECT NetID, StudentName FROM Student_t WHERE NetID in
(SELECT NetID from CourseTaken_t
GROUP BY NetID
HAVING COUNT(CourseNumber) > 5)

--Query 4
SELECT NetID, SUM(CreditHours) AS 'Total Credit Hours' FROM 
(SELECT DISTINCT Course_t.CourseNumber, CourseTaken_t.NetID, Course_t.CourseName, Course_t.CreditHours
FROM Course_T
INNER JOIN CourseTaken_t ON CourseTaken_t.CourseNumber = Course_t.CourseNumber) Temp_Course_t
GROUP BY NetID

--Query 5
SELECT InstructorName, COUNT(CourseBook) AS 'Number of Course Books'
FROM Course_t, CourseBook_t
WHERE Course_t.CourseNumber = CourseBook_t.CourseNumber
GROUP BY InstructorName