CREATE TABLE [dbo].[o_User_Service] (
    [office_id]   CHAR (4)     NOT NULL,
    [user_id]     VARCHAR (24) NOT NULL,
    [service]     VARCHAR (24) NOT NULL,
    [access_flag] CHAR (1)     NOT NULL,
    [created]     DATETIME     NULL,
    [created_by]  VARCHAR (24) NOT NULL
);

