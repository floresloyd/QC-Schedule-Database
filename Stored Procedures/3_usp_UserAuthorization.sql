USE QueensClassSchedule;
GO

-- Creating the renamed stored procedure
CREATE OR ALTER PROCEDURE Process.usp_UserAuthorization 
    @UserAuthorizationKey INT
AS
BEGIN
    DECLARE
        @StartTime DATETIME2 = sysdatetime(),
        @WorkFlowDescription NVARCHAR(100) = 'Create User Authorization Table',
        @WorkFlowStepTableRowCount INT;

    -- Checking if the table exists
    IF OBJECT_ID('Process.UserAuthorization', 'U') IS NULL
    BEGIN
        -- Create the table if it does not exist
        CREATE TABLE Process.[UserAuthorization](
            [UserAuthorizationKey] INT NOT NULL,
            [ClassTime] NCHAR(5) NULL,
            [IndividualProject] NVARCHAR(60) NULL,
            [GroupMemberLastName] NVARCHAR(35) NOT NULL,
            [GroupMemberFirstName] NVARCHAR(25) NOT NULL,
            [GroupName] NVARCHAR(20) NOT NULL,
            [DateAdded] DATETIME2(7) NULL
        ) ON [PRIMARY];

        -- Adding default values
        ALTER TABLE Process.[UserAuthorization] 
            ADD DEFAULT (N'PROJECT 3 DESIGN QUEENSCOLLEGECLASSOFFERINGS DATABASE') FOR [IndividualProject];

        ALTER TABLE Process.[UserAuthorization] 
            ADD DEFAULT (sysutcdatetime()) FOR [DateAdded];

        ALTER TABLE Process.[UserAuthorization] 
            WITH CHECK ADD CHECK  (([ClassTime]='9:15'));
    END

    -- Populating the table with data
    INSERT INTO Process.[UserAuthorization] 
        ([UserAuthorizationKey], [ClassTime], [IndividualProject], [GroupMemberLastName], [GroupMemberFirstName], [GroupName])
    VALUES
        (1, '9:15', 'PROJECT 3 DESIGN QUEENSCOLLEGECLASSOFFERINGS DATABASE', 'Flores', 'Loyd', 'Group 3'),
        (2, '9:15', 'PROJECT 3 DESIGN QUEENSCOLLEGECLASSOFFERINGS DATABASE', 'Mikhaylov', 'Roni', 'Group 3'),
        (3, '9:15', 'PROJECT 3 DESIGN QUEENSCOLLEGECLASSOFFERINGS DATABASE', 'Shoeb', 'Jawwad', 'Group 3'),
        (4, '9:15', 'PROJECT 3 DESIGN QUEENSCOLLEGECLASSOFFERINGS DATABASE', 'Hasan', 'Mohammed', 'Group 3'),
        (5, '9:15', 'PROJECT 3 DESIGN QUEENSCOLLEGECLASSOFFERINGS DATABASE', 'Shah', 'Kishan', 'Group 3'),
        (6, '9:15', 'PROJECT 3 DESIGN QUEENSCOLLEGECLASSOFFERINGS DATABASE', 'Chen', 'Zhihan', 'Group 3');

    SELECT @WorkFlowStepTableRowCount = COUNT(*) FROM Process.[UserAuthorization];
    EXEC [Process].[usp_TrackWorkFlow] @StartTime, @WorkFlowDescription, @WorkFlowStepTableRowCount, @UserAuthorizationKey;
END;
GO
