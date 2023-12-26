
CREATE OR ALTER PROCEDURE Process.ClassTable
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE
        @StartTime DATETIME2 = sysdatetime(),
        @WorkFlowDescription NVARCHAR(100) = 'Create and Populate Group3.Class',
        @WorkFlowStepTableRowCount INT;

    -- Create the Class table in Group3 schema
    CREATE TABLE Group3.Class (
        ClassId Udt.SurrogateKeyInt PRIMARY KEY IDENTITY(1,1),
        Semester Udt.SemesterType,
        Section Udt.SectionType,
        CourseId Udt.SurrogateKeyInt,
        InstructorID Udt.SurrogateKeyInt,
        StartTime Udt.Timetype,
        EndTime Udt.Timetype,
        [Day] Udt.[DayName],
        Enrolled Udt.CountType,
        Limit Udt.CountType,
        RoomId Udt.SurrogateKeyInt,
        ModeOfInstructionID Udt.SurrogateKeyInt,
        FOREIGN KEY (CourseId) REFERENCES Group3.Course,
        FOREIGN KEY (InstructorID) REFERENCES Group3.Instructors([InstructorID]),
        FOREIGN KEY (RoomId) REFERENCES Group3.Room([RoomId]),
        FOREIGN KEY (ModeOfInstructionID) REFERENCES Group3.ModeOfInstruction([ModeId])
    );

    -- Insert data into Group3.Class
    INSERT INTO Group3.Class(Semester, Section, CourseId, InstructorID, 
    StartTime, EndTime, [Day], Enrolled, Limit, RoomId, ModeOfInstructionID)
    SELECT 
        OFFERINGS.Semester, 
        OFFERINGS.Sec, 
        Course.CourseId, 
        Instructors.InstructorID, 
        CASE 
            WHEN CHARINDEX(' - ', Time) > 0 THEN 
                SUBSTRING(Time, 1, CHARINDEX(' - ', Time) - 1)
            ELSE 
                Time -- Or NULL, if you want to return NULL when ' - ' is not found
        END AS StartTime, 
        CASE 
            WHEN CHARINDEX(' - ', Time) > 0 THEN 
                SUBSTRING(Time, CHARINDEX(' - ', Time) + 3, LEN(Time))
            ELSE 
                NULL -- Assuming EndTime should be NULL if ' - ' is not found
        END AS EndTime, 
        OFFERINGS.[Day], 
        OFFERINGS.Enrolled, 
        OFFERINGS.Limit, 
        r.RoomId, 
        ModeOfInstruction.ModeID

    FROM
        [Uploadfile].[CurrentSemesterCourseOfferings] AS OFFERINGS
    LEFT JOIN
        Group3.Course AS Course 
		ON 
		(Trim(SUBSTRING([Course (hr, crd)], 1, CHARINDEX('(', [Course (hr, crd)]) - 1)) = Course.CourseName
		AND
		OFFERINGS.Code=Course.CourseCode
		)
    LEFT JOIN
        Group3.Instructors AS Instructors ON OFFERINGS.Instructor = Instructors.FullName
    LEFT JOIN
        (Group3.Room r INNER JOIN Group3.Building as b ON r.BuildingId=b.buildingId) 
    ON
        SUBSTRING(Location, CHARINDEX(' ', Location) + 1, LEN(Location)) = r.RoomNo
    AND
        LEFT(Location, CHARINDEX(' ', Location + ' ') - 1) = b.BuildingName
    INNER JOIN
        Group3.ModeOfInstruction AS ModeOfInstruction ON OFFERINGS.[Mode of Instruction] = ModeOfInstruction.ModeOfInstruction;

    SELECT @WorkFlowStepTableRowCount = COUNT(*) FROM Group3.Class;
    EXEC [Process].[usp_TrackWorkFlow] @StartTime, @WorkFlowDescription, @WorkFlowStepTableRowCount, @UserAuthorizationKey;
END;
