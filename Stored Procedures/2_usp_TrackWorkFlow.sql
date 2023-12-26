USE [QueensClassSchedule]; -- Replace with your actual database name
GO

-- Check if the 'Process' schema exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Process')
BEGIN
    -- Create the 'Process' schema
    EXEC('CREATE SCHEMA [Process]');
END
GO

-- Creating a new stored procedure named usp_TrackWorkFlow in the Process schema
CREATE PROCEDURE [Process].[usp_TrackWorkFlow]
    -- Defining parameters that the stored procedure will accept
    @StartTime DATETIME2,
    @WorkFlowDescription NVARCHAR(100),
    @WorkFlowStepTableRowCount INT,
    @UserAuthorizationKey INT
AS
BEGIN
    -- SET XACT_ABORT ON will roll back a transaction if a run-time error occurs
    SET XACT_ABORT ON;

    -- SET NOCOUNT ON prevents the message that shows the count of rows affected by a T-SQL statement
    SET NOCOUNT ON;

    -- Starting a try block to catch and handle errors
    BEGIN TRY
        -- Beginning a new transaction
        BEGIN TRANSACTION;

        -- Checking if the Process.WorkflowSteps table exists in the database
        IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
                       WHERE TABLE_SCHEMA = 'Process' 
                       AND  TABLE_NAME = 'WorkflowSteps')
        BEGIN
            -- Creating the Process.WorkflowSteps table if it does not exist
            CREATE TABLE Process.WorkflowSteps (
                WorkFlowStepKey INT IDENTITY(1,1) PRIMARY KEY, -- Auto-incremented primary key
                WorkFlowStepDescription NVARCHAR(100) NOT NULL, -- Description field
                WorkFlowStepTableRowCount INT NULL DEFAULT 0, -- Row count with default value 0
                StartingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME()), -- Start time with default current system time
                EndingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME()), -- End time with default current system time
                ClassTime CHAR(5) NULL DEFAULT ('09:15'), -- Class time with default value
                UserAuthorizationKey INT NOT NULL -- User authorization key
            );
        END

        -- Inserting the data received as parameters into the Process.WorkflowSteps table
        INSERT INTO Process.WorkflowSteps (
            WorkFlowStepDescription, 
            WorkFlowStepTableRowCount, 
            StartingDateTime, 
            UserAuthorizationKey
        )
        VALUES (
            @WorkFlowDescription, 
            @WorkFlowStepTableRowCount, 
            @StartTime, 
            @UserAuthorizationKey
        );

        -- Committing the transaction to make the changes permanent
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Catch block to handle exceptions
        -- Rolling back the transaction in case of error
        ROLLBACK TRANSACTION;

        -- Capturing the error message and raising an error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END
GO
