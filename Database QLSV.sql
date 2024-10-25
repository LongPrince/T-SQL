CREATE DATABASE QuanLySinhVien;
USE QuanLySinhVien;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName NVARCHAR(50),
    Age INT,
    Email NVARCHAR(50)
);

CREATE TABLE Classes (
    ClassID INT PRIMARY KEY,
    ClassName NVARCHAR(50)
);

CREATE TABLE ClassStudent (
    ClassID INT,
    StudentID INT,
    PRIMARY KEY (ClassID, StudentID)
);

CREATE TABLE Subjects (
    SubjectID INT PRIMARY KEY,
    SubjectName NVARCHAR(50)
);

CREATE TABLE Marks (
    SubjectID INT,
    StudentID INT,
    Mark INT
);

INSERT INTO Students (StudentID, StudentName, Age, Email) VALUES
(1, 'Nguyen Quang An', 18, 'an@yahoo.com'),
(2, 'Nguyen Cong Vinh', 20, 'vinh@gmail.com'),
(3, 'Nguyen Van Quyen', 19, 'quyen'),
(4, 'Pham Thanh Binh', 25, 'binh@com'),
(5, 'Nguyen Van Tai Em', 30, 'taiem@sport.vn');

INSERT INTO Classes (ClassID, ClassName) VALUES
(1, 'C0706L'),
(2, 'C0708G');

INSERT INTO ClassStudent (ClassID, StudentID) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(2, 5);

INSERT INTO Subjects (SubjectID, SubjectName) VALUES
(1, 'SQL'),
(2, 'Java'),
(3, 'C'),
(4, 'Visual Basic');

INSERT INTO Marks (SubjectID, StudentID, Mark) VALUES
(1, 1, 8),
(2, 1, 4),
(1, 1, 9),
(1, 3, 7),
(1, 4, 3),
(2, 5, 5),
(3, 3, 8),
(3, 5, 1),
(2, 4, 3);
