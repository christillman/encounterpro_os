﻿CREATE TABLE [dbo].[c_User_Progress] (
    [user_id]                VARCHAR (24)     NOT NULL,
    [user_progress_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [progress_user_id]       VARCHAR (24)     NOT NULL,
    [progress_date_time]     DATETIME         NOT NULL,
    [progress_type]          VARCHAR (24)     NOT NULL,
    [progress_key]           VARCHAR (40)     NULL,
    [progress_value]         VARCHAR (40)     NULL,
    [progress]               TEXT             NULL,
    [created]                DATETIME         NOT NULL,
    [created_by]             VARCHAR (24)     NOT NULL,
    [id]                     UNIQUEIDENTIFIER NOT NULL,
    [current_flag]           CHAR (1)         NOT NULL,
    [c_actor_id]             UNIQUEIDENTIFIER NULL
);


