USE [QueensClassSchedule];
GO

-- Creating the stored procedure
CREATE OR ALTER PROCEDURE Process.Building
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE
        @StartTime DATETIME2 = sysdatetime(),
        @WorkFlowDescription NVARCHAR(100) = 'Create and Populate Group3.Building',
        @WorkFlowStepTableRowCount INT;

    SET NOCOUNT ON;

    BEGIN TRY
        -- Dropping the table if it already exists and then creating it
        DROP TABLE IF EXISTS Group3.Building;
        CREATE TABLE Group3.Building (
            BuildingId udt.SurrogateKeyInt PRIMARY KEY,
            BuildingName udt.BuildingNameType
        );
        ALTER TABLE Group3.Building
        ALTER COLUMN BuildingName VARCHAR(2);

        -- Insertion logic
        WITH UniqueBuildingNames AS (
            SELECT DISTINCT LEFT(csco.Location, 2) AS ShortLocation
            FROM Uploadfile.CurrentSemesterCourseOfferings AS csco
            WHERE csco.Location IS NOT NULL AND LEN(csco.Location) >= 2
        )
        INSERT INTO Group3.Building (BuildingId, BuildingName)
        SELECT 
            (COALESCE((SELECT MAX(BuildingId) FROM Group3.Building), 0) + ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) AS NewBuildingId,
            ShortLocation
        FROM 
            UniqueBuildingNames
        WHERE 
            NOT EXISTS (
                SELECT 1 
                FROM Group3.Building 
                WHERE BuildingName = ShortLocation
            );

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH

    SELECT @WorkFlowStepTableRowCount = COUNT(*) FROM Group3.Building;
    EXEC [Process].[usp_TrackWorkFlow] @StartTime, @WorkFlowDescription, @WorkFlowStepTableRowCount, @UserAuthorizationKey;
END
GO
