CREATE TABLE [dbo].[p_Observation_Comment_Save] (
    [cpr_id]                    VARCHAR (12)     NOT NULL,
    [observation_sequence]      INT              NOT NULL,
    [Observation_comment_id]    INT              IDENTITY (1, 1) NOT NULL,
    [observation_id]            VARCHAR (24)     NOT NULL,
    [comment_date_time]         DATETIME         NOT NULL,
    [comment_type]              VARCHAR (24)     NOT NULL,
    [comment_title]             VARCHAR (48)     NULL,
    [short_comment]             VARCHAR (40)     NULL,
    [comment]                   TEXT             NULL,
    [abnormal_flag]             CHAR (1)         NULL,
    [severity]                  SMALLINT         NULL,
    [treatment_id]              INT              NULL,
    [encounter_id]              INT              NULL,
    [attachment_id]             INT              NULL,
    [user_id]                   VARCHAR (24)     NOT NULL,
    [current_flag]              CHAR (1)         NOT NULL,
    [root_observation_sequence] INT              NULL,
    [created_by]                VARCHAR (24)     NOT NULL,
    [created]                   DATETIME         NULL,
    [id]                        UNIQUEIDENTIFIER NOT NULL
);



