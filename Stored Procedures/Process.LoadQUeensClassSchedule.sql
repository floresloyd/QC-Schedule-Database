CREATE OR ALTER PROCEDURE Process.LoadQueensClassSchedule
AS
BEGIN

	-- Call Process.usp_UserAuthorization 
    EXEC Process.usp_UserAuthorization @UserAuthorizationKey = 1;

	-- Call Process.CreateDataTypes
    EXEC Process.CreateDataTypes @UserAuthorizationKey = 1;

	-- Call Process.Course
    EXEC Process.Course @UserAuthorizationKey = 1;

	-- Call Process.Instructors
    EXEC Process.Instructors @UserAuthorizationKey = 6;

    -- Call Process.Building
    EXEC Process.Building @UserAuthorizationKey = 4;

	-- Call Process.Room
    EXEC Process.Room @UserAuthorizationKey = 4;

    -- Call Process.ModeOfInstruction
    EXEC Process.ModeOfInstruction @UserAuthorizationKey = 5;


    -- Call Process.ClassTable
    EXEC Process.ClassTable @UserAuthorizationKey = 3;

	-- Call Process.Department
    EXEC Process.Department @UserAuthorizationKey = 1;
       
END;
GO

SELECT * FROM Group3.Department
