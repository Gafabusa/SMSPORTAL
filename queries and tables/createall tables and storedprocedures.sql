-- CREATE DATABASE
CREATE DATABASE SMSPORTAL22;
GO

USE SMSPORTAL22;
GO

-- VENDORS TABLE
CREATE TABLE VendorTable (
    VendorID INT IDENTITY(1,1) PRIMARY KEY,
    VendorName NVARCHAR(100) NOT NULL,
    Credits INT DEFAULT 0,
    CreatedOn DATETIME DEFAULT GETDATE()
);
--altering the VendorTable----
ALTER TABLE VendorTable
ADD UserName NVARCHAR(100) NOT NULL;

ALTER TABLE VendorTable
ADD CONSTRAINT UQ_VendorTable_UserName UNIQUE (UserName);



-- USERS TABLE
CREATE TABLE VendorUser (
    UserID INT IDENTITY(1000,1) PRIMARY KEY,
    VendorID INT NOT NULL,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(256) NOT NULL,
    Role NVARCHAR(20) NOT NULL,
    IsActive BIT DEFAULT 1,
    FailedLoginAttempts INT DEFAULT 0,
    Locked BIT DEFAULT 0,
    CreatedOn DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (VendorID) REFERENCES VendorTable(VendorID)
);
--altering VendorUser
ALTER TABLE VendorUser
ALTER COLUMN PasswordHash NVARCHAR(256) NOT NULL;


-- Create SystemOperator Table
CREATE TABLE SystemOperator (
    OperatorID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARBINARY(64) NOT NULL,
    CreatedOn DATETIME DEFAULT GETDATE()
);
GO

-- Insert initial system operator (admin)
INSERT INTO SystemOperator (Username, Email, PasswordHash)
VALUES (
    'admin',
    'admin@gmail.com',
    HASHBYTES('SHA2_256', 'admin123')
);
GO

