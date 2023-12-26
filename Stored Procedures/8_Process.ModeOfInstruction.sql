CREATE OR ALTER PROCEDURE Process.ModeOfInstruction
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE
        @StartTime DATETIME2 = sysdatetime(),
        @WorkFlowDescription NVARCHAR(100) = 'Create and Populate Group3.ModeOfInstruction',
        @WorkFlowStepTableRowCount INT;

    -- Create udt schema if it does not exist
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'udt')
    BEGIN
        EXEC('CREATE SCHEMA udt');
    END

    -- Create Group3 schema if it does not exist
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Group3')
    BEGIN
        EXEC('CREATE SCHEMA Group3');
    END

    -- Drop existing ModeOfInstruction table if it exists
    IF OBJECT_ID('Group3.ModeOfInstruction', 'U') IS NOT NULL
    BEGIN
        DROP TABLE Group3.ModeOfInstruction;
    END

    -- Create the ModeOfInstruction table using the UDTs
    CREATE TABLE Group3.ModeOfInstruction (
        ModeId INT PRIMARY KEY IDENTITY(1,1), -- Assuming ModeId is an identity column
        ModeOfInstruction NVARCHAR(100) -- Replace NVARCHAR(100) with the actual data type and size
        -- Add other columns as needed
    );

    -- Populate the ModeOfInstruction table
    INSERT INTO Group3.ModeOfInstruction (ModeOfInstruction)
    SELECT DISTINCT([Mode of Instruction])
    FROM Uploadfile.CurrentSemesterCourseOfferings;

    SELECT @WorkFlowStepTableRowCount = COUNT(*) FROM Group3.ModeOfInstruction;
    EXEC [Process].[usp_TrackWorkFlow] @StartTime, @WorkFlowDescription, @WorkFlowStepTableRowCount, @UserAuthorizationKey;
END;
