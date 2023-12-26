-- Create the stored procedure
CREATE OR ALTER PROCEDURE dbo.CreateSchemas 

AS
BEGIN

    -- Create the Group3 schema
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'Group3')
    BEGIN
        EXEC('CREATE SCHEMA Group3;');
    END;

    -- Create the Udt schema
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'udt')
    BEGIN
        EXEC('CREATE SCHEMA udt;');
    END;

    -- Create the Process schema
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'Process')
    BEGIN
        EXEC('CREATE SCHEMA Process;');
    END;

END;
