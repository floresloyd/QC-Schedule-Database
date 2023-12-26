CREATE OR ALTER PROCEDURE Process.Course
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE
        @StartTime DATETIME2 = sysdatetime(),
        @WorkFlowDescription NVARCHAR(100) = 'Create and Populate Group3.Course',
        @WorkFlowStepTableRowCount INT;

    -- Create Group3 schema if it does not exist
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Group3')
    BEGIN
        EXEC('CREATE SCHEMA Group3');
    END
    
    -- Drop table if it exists
    IF OBJECT_ID('Group3.Course', 'U') IS NOT NULL
    BEGIN
        DROP TABLE Group3.Course;
    END

    -- Create the table Group3.Course using the UDTs
    CREATE TABLE Group3.Course (
        CourseId udt.SurrogateKeyInt PRIMARY KEY IDENTITY(1,1),
        CourseCode udt.CodeType,
        CourseName udt.NameType,
        CourseDescription udt.Description,
        Credits udt.smallNum,
        HoursPerWeek udt.smallNum
    );

    -- Populate the table Group3.Course
    INSERT INTO Group3.Course (CourseCode, CourseName, CourseDescription, Credits, HoursPerWeek)
    SELECT DISTINCT
        Code,
        SUBSTRING([Course (hr, crd)], 1, CHARINDEX(' (', [Course (hr, crd)]) - 1),
        Description,
        CAST(SUBSTRING([Course (hr, crd)], CHARINDEX('(', [Course (hr, crd)]) + 1, CHARINDEX(',', [Course (hr, crd)]) - CHARINDEX('(', [Course (hr, crd)]) - 1) AS float),
        CAST(SUBSTRING([Course (hr, crd)], CHARINDEX(',', [Course (hr, crd)]) + 2, CHARINDEX(')', [Course (hr, crd)]) - CHARINDEX(',', [Course (hr, crd)]) - 2) AS float)
    FROM
        Uploadfile.CurrentSemesterCourseOfferings;

    SELECT @WorkFlowStepTableRowCount = COUNT(*) FROM Group3.Course;
    EXEC [Process].[usp_TrackWorkFlow] @StartTime, @WorkFlowDescription, @WorkFlowStepTableRowCount, @UserAuthorizationKey;
END;


