USE [SMSPORTAL22]
GO
/****** Object:  StoredProcedure [dbo].[sp_AuthenticateSystemOperator]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AuthenticateSystemOperator]
    @Email NVARCHAR(50),
    @PasswordHash VARBINARY(64)
AS
BEGIN
    SELECT OperatorID, Username, Email, CreatedOn
    FROM SystemOperator
    WHERE Email = @Email AND PasswordHash = @PasswordHash;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_AuthenticateUser]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AuthenticateUser]
    @Username NVARCHAR(50),
    @PasswordHash NVARCHAR(256),
    @ResultCode INT OUTPUT
AS
BEGIN
    DECLARE @UserID INT;
    SELECT @UserID = UserID FROM VendorUser
    WHERE Username = @Username AND PasswordHash = @PasswordHash AND Locked = 0;

    IF @UserID IS NOT NULL
    BEGIN
        UPDATE VendorUser SET FailedLoginAttempts = 0 WHERE UserID = @UserID;
        SET @ResultCode = 1;
    END
    ELSE
    BEGIN
        UPDATE VendorUser SET FailedLoginAttempts = FailedLoginAttempts + 1
        WHERE Username = @Username;

        IF EXISTS (SELECT 1 FROM VendorUser WHERE Username = @Username AND FailedLoginAttempts >= 3)
            UPDATE VendorUser SET Locked = 1 WHERE Username = @Username;

        SET @ResultCode = 0;
    END

    DECLARE @AuditUserID INT;
    SELECT @AuditUserID = UserID FROM VendorUser WHERE Username = @Username;

    INSERT INTO AuditTrail(UserID, Action, Outcome)
    VALUES (@AuditUserID, 'Login Attempt', IIF(@ResultCode = 1, 'Success', 'Failure'));
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_AuthenticateVendorAdmin]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AuthenticateVendorAdmin]
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
/****** Object:  StoredProcedure [dbo].[sp_CheckDuplicateVendorAdmin]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CheckDuplicateVendorAdmin]
    @VendorName NVARCHAR(100),
    @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CASE 
            WHEN EXISTS (SELECT 1 FROM VendorTable WHERE VendorName = @VendorName) THEN 'VendorNameExists'
            WHEN EXISTS (SELECT 1 FROM VendorTable WHERE Email = @Email) THEN 'EmailExists'
            ELSE 'OK'
        END AS Result;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_CheckDuplicateVendorUser]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_CheckDuplicateVendorUser]
    @Username NVARCHAR(50),
    @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM VendorUser WHERE Username = @Username)
    BEGIN
        SELECT 'UsernameExists' AS Result;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM VendorUser WHERE Email = @Email)
    BEGIN
        SELECT 'EmailExists' AS Result;
        RETURN;
    END

    SELECT 'Available' AS Result;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_CreateVendorAdmin]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CreateVendorAdmin]
    @VendorName NVARCHAR(100),
    @UserName NVARCHAR(100),
    @Email NVARCHAR(100),
    @PasswordHash VARBINARY(64), -- 
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
/****** Object:  StoredProcedure [dbo].[sp_CreateVendorUser]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CreateVendorUser]
    @VendorName NVARCHAR(100),
    @Username NVARCHAR(50),
    @Email NVARCHAR(100),
    @PasswordHash VARBINARY(64), -- 
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
/****** Object:  StoredProcedure [dbo].[sp_DeductCredits]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeductCredits]
    @VendorID INT,
    @CreditsToDeduct INT
AS
BEGIN
    DECLARE @CurrentCredits INT;
    SELECT @CurrentCredits = Credits FROM VendorTable WHERE VendorID = @VendorID;

    IF @CurrentCredits >= @CreditsToDeduct
    BEGIN
        UPDATE VendorTable SET Credits = Credits - @CreditsToDeduct WHERE VendorID = @VendorID;
    END
    ELSE
    BEGIN
        RAISERROR('Insufficient credits.', 16, 1);
    END
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteVendorAdmin]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteVendorAdmin]
    @VendorID INT
AS
BEGIN
    DELETE FROM VendorTable WHERE VendorID = @VendorID;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllVendorAdmins]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAllVendorAdmins]
AS
BEGIN
    SELECT VendorID, VendorName, UserName, Email, CreatedOn
    FROM VendorTable
    ORDER BY CreatedOn DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetVendorAdminById]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetVendorAdminById]
    @VendorID INT
AS
BEGIN
    SELECT VendorID, VendorName, UserName, Email
    FROM VendorTable
    WHERE VendorID = @VendorID;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InsertSMSInbox]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertSMSInbox]
    @FileUploadID INT,
    @Message NVARCHAR(MAX),
    @PhoneNumber NVARCHAR(20),
    @Email NVARCHAR(150)
AS
BEGIN
    INSERT INTO PortalSMSInbox (FileUploadID, Message, PhoneNumber, Email)
    VALUES (@FileUploadID, @Message, @PhoneNumber, @Email);
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_MarkFileAsProcessed]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_MarkFileAsProcessed]
    @FileID INT
AS
BEGIN
    UPDATE SMSFileUpload
    SET Processed = 1, ProcessedDate = GETDATE(), Status = 'PROCESSED'
    WHERE FileID = @FileID;
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_MarkSMSSent]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_MarkSMSSent]
    @SMSID INT
AS
BEGIN
    UPDATE PortalSMSInbox
    SET Sent = 1, Status = 'SUCCESS', SentDate = GETDATE()
    WHERE SMSID = @SMSID;
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_MoveToOutbox]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_MoveToOutbox]
    @SMSID INT
AS
BEGIN
    INSERT INTO PortalSMSOutboxCompleted (SMSID, Message, PhoneNumber, Email, SentDate, VendorTranID)
    SELECT SMSID, Message, PhoneNumber, Email, SentDate, VendorTranID
    FROM PortalSMSInbox WHERE SMSID = @SMSID;
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_QueueSMS]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_QueueSMS]
    @SMSID INT
AS
BEGIN
    INSERT INTO PortalSMSQueue (SMSID) VALUES (@SMSID);
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateVendorAdmin]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateVendorAdmin]
    @VendorID INT,
    @VendorName NVARCHAR(100),
    @UserName NVARCHAR(100),
    @Email NVARCHAR(100)
AS
BEGIN
    UPDATE VendorTable
    SET VendorName = @VendorName,
        UserName = @UserName,
        Email = @Email
    WHERE VendorID = @VendorID;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_UploadSMSFile]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UploadSMSFile]
    @VendorID INT,
    @UploadedBy INT,
    @Message NVARCHAR(MAX),
    @FilePath NVARCHAR(500),
    @IsTemplate BIT,
    @IsScheduled BIT,
    @ScheduledStartTime DATETIME = NULL
AS
BEGIN
    INSERT INTO SMSFileUpload (VendorID, UploadedBy, Message, FilePath, IsTemplate, IsScheduled, ScheduledStartTime)
    VALUES (@VendorID, @UploadedBy, @Message, @FilePath, @IsTemplate, @IsScheduled, @ScheduledStartTime);
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_ValidateVendorUserByEmail]    Script Date: 07/07/2025 00:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ValidateVendorUserByEmail]
    @Email NVARCHAR(100),
    @PasswordHash VARBINARY(64) -- 

AS
BEGIN
    SELECT *
    FROM VendorUser
    WHERE Email = @Email AND PasswordHash = @PasswordHash
END;

GO
