CREATE OR ALTER PROCEDURE Process.CreateDataTypes 
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE
        @StartTime DATETIME2 = sysdatetime(),
        @WorkFlowDescription NVARCHAR(100) = 'Create User Defined Data Types',
        @WorkFlowStepTableRowCount INT = 0;

    -- Check if the type exists before creating
    IF TYPE_ID('udt.SurrogateKeyInt') IS NULL
        CREATE TYPE udt.SurrogateKeyInt FROM int;

    IF TYPE_ID('udt.NameType') IS NULL
        CREATE TYPE udt.NameType FROM nvarchar(40);

    IF TYPE_ID('udt.CodeType') IS NULL
        CREATE TYPE udt.CodeType FROM nvarchar(10);

    IF TYPE_ID('udt.Description') IS NULL
        CREATE TYPE udt.Description FROM nvarchar(500);

    IF TYPE_ID('udt.smallNum') IS NULL
        CREATE TYPE udt.smallNum FROM float;

    IF TYPE_ID('udt.Instruction') IS NULL
        CREATE TYPE udt.Instruction FROM nvarchar(255);

    IF TYPE_ID('udt.BuildingNameType') IS NULL
        CREATE TYPE udt.BuildingNameType FROM nvarchar(30);

    IF TYPE_ID('Udt.SemesterType') IS NULL
        CREATE TYPE Udt.SemesterType FROM nvarchar(20);

    IF TYPE_ID('Udt.SectionType') IS NULL
        CREATE TYPE Udt.SectionType FROM nvarchar(20);

    IF TYPE_ID('Udt.Timetype') IS NULL
        CREATE TYPE Udt.Timetype FROM nvarchar(20);

    IF TYPE_ID('Udt.DayName') IS NULL
        CREATE TYPE Udt.DayName FROM nvarchar(20);

    IF TYPE_ID('Udt.CountType') IS NULL
        CREATE TYPE Udt.CountType FROM int;

    IF TYPE_ID('udt.RoomNo') IS NULL
        CREATE TYPE udt.RoomNo FROM nvarchar(50);

    EXEC [Process].[usp_TrackWorkFlow] @StartTime, @WorkFlowDescription, @WorkFlowStepTableRowCount, @UserAuthorizationKey;
END;
