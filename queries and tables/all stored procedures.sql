
USE SMSPORTAL22;
GO


ALTER PROCEDURE sp_AuthenticateSystemOperator
    @Email NVARCHAR(50),
    @PasswordHash VARBINARY(64)
AS
BEGIN
    SELECT OperatorID, Username, Email, CreatedOn
    FROM SystemOperator
    WHERE Email = @Email AND PasswordHash = @PasswordHash;
END;
GO

--proc to create VendorAdmin
CREATE PROCEDURE sp_CreateVendorAdmin
    @VendorName NVARCHAR(100),
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(256),
    @ResultMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    -- Check for duplicate vendor name
    IF EXISTS (SELECT 1 FROM VendorTable WHERE VendorName = @VendorName)
    BEGIN
        SET @ResultMessage = 'Vendor name already exists.';
        RETURN;
    END

    -- Check for duplicate email
    IF EXISTS (SELECT 1 FROM VendorTable WHERE Email = @Email)
    BEGIN
        SET @ResultMessage = 'Email is already associated with another vendor.';
        RETURN;
    END

    -- Insert vendor admin
    INSERT INTO VendorTable (VendorName, Email, PasswordHash)
    VALUES (@VendorName, @Email, @PasswordHash);

    SET @ResultMessage = 'Vendor admin created successfully.';
END;
GO

--alter sp_CreateVendorAdmin proc
ALTER PROCEDURE sp_CreateVendorAdmin
    @VendorName NVARCHAR(100),
    @UserName NVARCHAR(100),
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(256),
    @ResultMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    -- Check for duplicate vendor name
    IF EXISTS (SELECT 1 FROM VendorTable WHERE VendorName = @VendorName)
    BEGIN
        SET @ResultMessage = 'Vendor name already exists.';
        RETURN;
    END

    -- Check for duplicate email
    IF EXISTS (SELECT 1 FROM VendorTable WHERE Email = @Email)
    BEGIN
        SET @ResultMessage = 'Email is already associated with another vendor.';
        RETURN;
    END

    -- Check for duplicate username
    IF EXISTS (SELECT 1 FROM VendorTable WHERE UserName = @UserName)
    BEGIN
        SET @ResultMessage = 'Username is already taken.';
        RETURN;
    END

    -- Insert vendor admin
    INSERT INTO VendorTable (VendorName, UserName, Email, PasswordHash)
    VALUES (@VendorName, @UserName, @Email, @PasswordHash);

    SET @ResultMessage = 'Vendor admin created successfully.';
END;
GO


ALTER PROCEDURE sp_AuthenticateVendorAdmin
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(64)
AS
BEGIN
    SELECT *
    FROM VendorTable
    WHERE Email = @Email
      AND PasswordHash = @PasswordHash
END;
GO


----creating vendor user 
ALTER PROCEDURE [dbo].[sp_CreateVendorUser]
    @VendorName NVARCHAR(100),
    @Username NVARCHAR(50),
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(256),
    @ResultMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    DECLARE @VendorID INT;

    -- Get VendorID from VendorTable using VendorName
    SELECT @VendorID = VendorID FROM VendorTable WHERE VendorName = @VendorName;

    IF @VendorID IS NULL
    BEGIN
        SET @ResultMessage = 'Vendor not found.';
        RETURN;
    END

    -- Check for duplicate email
    IF EXISTS (SELECT 1 FROM VendorUser WHERE Email = @Email)
    BEGIN
        SET @ResultMessage = 'Email already exists.';
        RETURN;
    END

    -- Check for duplicate username
    IF EXISTS (SELECT 1 FROM VendorUser WHERE Username = @Username)
    BEGIN
        SET @ResultMessage = 'Username already exists.';
        RETURN;
    END

    -- Insert new user
    INSERT INTO VendorUser (VendorID, Username, Email, PasswordHash, Role)
    VALUES (@VendorID, @Username, @Email, @PasswordHash, 'User');

    SET @ResultMessage = 'Vendor user created successfully.';
END
GO

---Validating vendor user

ALTER PROCEDURE sp_ValidateVendorUserByEmail
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(256) 
AS
BEGIN
    SELECT *
    FROM VendorUser
    WHERE Email = @Email AND PasswordHash = @PasswordHash
END;
GO
