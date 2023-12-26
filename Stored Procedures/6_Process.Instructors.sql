CREATE OR ALTER PROCEDURE [Process].[Instructors]
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE
        @StartTime DATETIME2 = sysdatetime(),
        @WorkFlowDescription NVARCHAR(100) = 'Create and Populate Group3.Instructors',
        @WorkFlowStepTableRowCount INT;

    -- Create udt.SurrogateKeyInt if it does not exist
    IF NOT EXISTS (SELECT * FROM sys.types WHERE name = 'SurrogateKeyInt' AND is_user_defined = 1)
    BEGIN
        CREATE TYPE udt.SurrogateKeyInt FROM int;
    END

    -- Create udt.NameType if it does not exist
    IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'NameType' AND is_user_defined = 1)
    BEGIN
        CREATE TYPE udt.NameType FROM nvarchar(40);
    END

    -- Drop the table if it exists and create a new one
    DROP TABLE IF EXISTS Group3.Instructors;
    CREATE TABLE Group3.Instructors(
        InstructorID udt.SurrogateKeyInt PRIMARY KEY IDENTITY(1,1) NOT NULL,
        FirstName udt.NameType,
        LastName udt.NameType,
        FullName udt.NameType
    );

    -- Insert data into Group3.Instructors
    INSERT INTO Group3.Instructors(FullName, LastName, FirstName)
    SELECT DISTINCT
        Instructor,
        SUBSTRING(Instructor, 1, CHARINDEX(',', Instructor + ',') - 1) AS LastName,
        SUBSTRING(Instructor, CHARINDEX(',', Instructor + ',') + 1, LEN(Instructor)) AS FirstName
    FROM
        Uploadfile.CurrentSemesterCourseOfferings
    WHERE
        Instructor != ',';

    -- Execute the workflow tracking procedure
    SELECT @WorkFlowStepTableRowCount = COUNT(*) FROM Group3.Instructors;
    EXEC [Process].[usp_TrackWorkFlow] @StartTime, @WorkFlowDescription, @WorkFlowStepTableRowCount, @UserAuthorizationKey;
END;
