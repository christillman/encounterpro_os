CREATE TABLE [dbo].[o_User_Logins] (
    [user_id]            VARCHAR (24) NOT NULL,
    [action_id]          INT          IDENTITY (1, 1) NOT NULL,
    [computer_id]        INT          NOT NULL,
    [office_id]          VARCHAR (4)  NOT NULL,
    [action]             VARCHAR (24) NOT NULL,
    [action_time]        DATETIME     NOT NULL,
    [session_start_time] DATETIME     NULL,
    [session_id]         INT          NULL,
    [scribe_for_user_id] VARCHAR (24) NULL,
    [action_for_user_id] VARCHAR (24) NULL,
    [action_status]      VARCHAR (12) NOT NULL
);



