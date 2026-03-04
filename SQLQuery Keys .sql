CREATE DATABASE Ilja1;
use Ilja1;
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName NVARCHAR(100)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Teachers (
    TeacherID INT PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE
);

CREATE TABLE Books (
    ISBN NVARCHAR(20) PRIMARY KEY,
    Title NVARCHAR(100)
);

CREATE TABLE StudentCourses (
    StudentID INT,
    CourseID INT,
    PRIMARY KEY (StudentID, CourseID)
);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY
);

CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE,
    Username NVARCHAR(50) UNIQUE
);

CREATE TABLE Employees (
    EmployeeID INT,
    PersonalCode NVARCHAR(20),
    Email NVARCHAR(100),
    CONSTRAINT PK_Employees PRIMARY KEY (EmployeeID),
    CONSTRAINT UQ_PersonalCode UNIQUE (PersonalCode),
    CONSTRAINT UQ_Email2 UNIQUE (Email)
);

CREATE TABLE Employees_New (
    EmployeeID INT IDENTITY(1,1),
    PersonalCode NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),

    CONSTRAINT PK_Employees_New2 
        PRIMARY KEY (EmployeeID),

    CONSTRAINT UQ_Employees_New_PersonalCode 
        UNIQUE (PersonalCode),

    CONSTRAINT UQ_Employees_New_Email 
        UNIQUE (Email)
);