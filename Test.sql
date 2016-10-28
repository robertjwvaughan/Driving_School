/*
	A database that hosts information of a driving school
*/

--Table Drop--
DROP TABLE lesson;
DROP TABLE instructor;
DROP TABLE student;

--Student Table--
CREATE TABLE student(
  sID NUMBER(6),
  sName VARCHAR2(50) NOT NULL,
  sAddress VARCHAR2(50) NOT NULL,
  sEmail VARCHAR2(30) DEFAULT 'unknown@unknown.com',
  
  CONSTRAINT student_pk PRIMARY KEY (sID),
  CONSTRAINT sEmail_chk CHECK (sEmail LIKE '%@%')
);

--Instructor Table--
CREATE TABLE instructor(
  instructorID NUMBER(6) NOT NULL,
  instName VARCHAR2(50) NOT NULL, 
  instLessonPrice NUMBER(4,2) NOT NULL,
  instEmail VARCHAR2(30) NOT NULL,
  
  CONSTRAINT instructor_pk PRIMARY KEY (instructorID),
  CONSTRAINT instEmail_chk CHECK (instEmail LIKE '%@%'),
  CONSTRAINT instLessonPrice_chk CHECK (instLessonPrice BETWEEN 42.50 AND 61.50)
);

--Lesson Table CONTAINS DEPENDENCY ON STUDENT AND INSTRUCTOR--
CREATE TABLE lesson(
  studentID NUMBER(6),
  instructorID NUMBER(6),
  lessonDate DATE,
  lessonDuration NUMBER(1),
  
  CONSTRAINT lesson_pk PRIMARY KEY (studentID, instructorID, lessonDate),
  
  CONSTRAINT studentID_fk FOREIGN KEY (studentID) REFERENCES student(sID),
  CONSTRAINT instructorID_fk FOREIGN KEY (instructorID) REFERENCES instructor(instructorID),
  
  CONSTRAINT lesson_chk CHECK (lessonDuration BETWEEN 1 AND 4)
);

--Inserting values--
INSERT INTO student VALUES(1001, 'D. Smith', '11 The Hool, London', 'ds@mail.com');
INSERT INTO student VALUES(1002, 'A. Byrne', 'Sycamores, Blackrock Rd, Dublin', DEFAULT);
INSERT INTO student VALUES(1003, 'X. Dobbs', 'Windings, Greystones, Wicklow', 'xd@mail.com');

INSERT INTO instructor VALUES(1001, 'A. Golden', 47.50, 'goldie@mail.com');
INSERT INTO instructor VALUES(1002, 'J. Kearns', 60.70, 'jk@mail.com');
INSERT INTO instructor VALUES(1003, 'K. Jones', 50.50, 'kj@mail.com');

INSERT INTO lesson VALUES(1001, 1001, '01 Jun 2016', 2);
INSERT INTO lesson VALUES(1001, 1002, '01 Sep 2016', 3);
INSERT INTO lesson VALUES(1002, 1002, '01 Jan 2016', 4);

/*
SElECT * FROM lesson;
SElECT * FROM instructor;
SElECT * FROM student;
*/

SELECT sName "Student Name", sAddress "Student Address"
FROM student;

SELECT sName "Student Name", sAddress "Student Address", lessonDate
FROM student
JOIN lesson
ON student.sID = lesson.studentID
WHERE lesson.lessonDate 
BETWEEN '01 Jan 2016' AND '30 Jun 2016';

SELECT sName "Student Name", sAddress "Student Address", lessonDate, instname
FROM student
JOIN lesson
ON student.sID = lesson.studentID
JOIN instructor
ON lesson.instructorID = instructor.instructorID
WHERE lesson.lessonDate 
BETWEEN '01 Jan 2016' AND '30 Jun 2016';

SELECT 'Student ' || sName || ' book a driving lesson costing ' || to_char(instLessonPrice, 'fmU99.00') || ' on ' || TO_CHAR(lessonDate, 'DD MM YYYY') || ' with instrcutor ' || instName as "String"
FROM student
JOIN lesson
ON student.sID = lesson.studentID
JOIN instructor
ON lesson.instructorID = instructor.instructorID
WHERE lesson.lessonDate 
BETWEEN '01 Jan 2016' AND '30 Jun 2016';

SELECT instName, to_char(instLessonPrice, 'fmU99.00') AS "Price",
CASE
  WHEN INSTR(instName, '.') = 0
  THEN 'NOT N USE'
  ELSE TO_CHAR(INSTR(instName, '.'))
END "Positioned at" 
FROM INSTRUCTOR
WHERE instLessonPrice > 50
ORDER BY instLessonPrice DESC;


COMMIT;
