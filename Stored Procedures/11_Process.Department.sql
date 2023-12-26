CREATE OR ALTER PROCEDURE Process.Department
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE
        @StartTime DATETIME2 = sysdatetime(),
        @WorkFlowDescription NVARCHAR(100) = 'Create and Populate Group3.Department',
        @WorkFlowStepTableRowCount INT;

    -- Check and create 'udt' schema if not exists
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'udt')
    BEGIN
        EXEC ('CREATE SCHEMA udt');
    END

    -- Check and create 'Group3' schema if not exists
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Group3')
    BEGIN
        EXEC ('CREATE SCHEMA Group3');
    END

    -- Drop 'Group3.Department' table if it exists
    IF OBJECT_ID('Group3.Department', 'U') IS NOT NULL
    BEGIN
        DROP TABLE Group3.Department;
    END

    -- Create 'Group3.Department' table
    CREATE TABLE Group3.Department (
        DepartmentID udt.SurrogateKeyInt PRIMARY KEY IDENTITY(1,1), 
        Department udt.Description
    );

    -- Populate 'Group3.Department' table
    INSERT INTO Group3.Department (Department)
    SELECT DISTINCT
        SUBSTRING([Course (hr, crd)], 1, CHARINDEX(' ', [Course (hr, crd)]) - 1) AS Department
    FROM
        uploadfile.currentsemestercourseofferings
    WHERE
        [Course (hr, crd)] IS NOT NULL AND 
        CHARINDEX(' ', [Course (hr, crd)]) > 0 AND 
        NOT EXISTS (
            SELECT 1 FROM Group3.Department 
            WHERE Department = SUBSTRING([Course (hr, crd)], 1, CHARINDEX(' ', [Course (hr, crd)]) - 1)
        );

    -- Count rows in 'Group3.Department'
    SELECT @WorkFlowStepTableRowCount = COUNT(*) 
    FROM Group3.Department;

    -- Execute 'usp_TrackWorkFlow'
    EXEC [Process].[usp_TrackWorkFlow] 
        @StartTime, 
        @WorkFlowDescription, 
        @WorkFlowStepTableRowCount, 
        @UserAuthorizationKey;
END;
