CREATE TABLE [dbo].[o_Users] (
    [user_id]            VARCHAR (24) NOT NULL,
    [computer_id]        INT          NOT NULL,
    [office_id]          VARCHAR (4)  NOT NULL,
    [in_service]         CHAR (1)     NULL,
    [spid]               INT          NULL,
    [login_date]         DATETIME     NULL,
    [scribe_for_user_id] VARCHAR (24) NULL
);



