USE [QueensClassSchedule];
GO

-- Creating the stored procedure
CREATE PROCEDURE Process.Room
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @StartTime DATETIME2 = sysdatetime(),
        @WorkFlowDescription NVARCHAR(100) = 'Create and Populate Group3.Room',
        @WorkFlowStepTableRowCount INT;

    -- Create the Room table
    CREATE TABLE Group3.Room (
        RoomId udt.SurrogateKeyInt PRIMARY KEY IDENTITY(1,1), -- Primary Key
        RoomNo udt.RoomNo, -- Room number
        BuildingId udt.SurrogateKeyInt, -- Foreign Key
        FOREIGN KEY (BuildingId) REFERENCES Group3.Building(BuildingId) -- Foreign Key Constraint
    );

    -- Insert data into Group3.Room
    INSERT INTO Group3.Room (RoomNo, BuildingId)
    SELECT
        RoomNo,
        BuildingId
    FROM
        (
            SELECT DISTINCT
                SUBSTRING(cso.Location, CHARINDEX(' ', cso.Location) + 1, LEN(cso.Location)) AS RoomNo,
                b.BuildingId
            FROM
                Uploadfile.CurrentSemesterCourseOfferings cso
            INNER JOIN
                Group3.Building b ON b.BuildingName = LEFT(cso.Location, CHARINDEX(' ', cso.Location) - 1)
            WHERE
                cso.Location IS NOT NULL AND CHARINDEX(' ', cso.Location) > 0
        ) AS UniqueRooms
    GROUP BY
        RoomNo, BuildingId;

    SELECT @WorkFlowStepTableRowCount = COUNT(*) FROM Group3.Room;
    EXEC [Process].[usp_TrackWorkFlow] @StartTime, @WorkFlowDescription, @WorkFlowStepTableRowCount, @UserAuthorizationKey;
END;
