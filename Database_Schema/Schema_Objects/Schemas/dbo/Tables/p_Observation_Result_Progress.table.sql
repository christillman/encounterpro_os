CREATE TABLE [dbo].[p_Observation_Result_Progress] (
    [cpr_id]                   VARCHAR (12)     NOT NULL,
    [observation_sequence]     INT              NOT NULL,
    [location_result_sequence] INT              NOT NULL,
    [result_progress_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [encounter_id]             INT              NULL,
    [treatment_id]             INT              NULL,
    [user_id]                  VARCHAR (24)     NOT NULL,
    [progress_date_time]       DATETIME         NOT NULL,
    [progress_type]            VARCHAR (24)     NOT NULL,
    [progress_key]             VARCHAR (40)     NULL,
    [progress_value]           VARCHAR (40)     NULL,
    [progress]                 TEXT             NULL,
    [current_flag]             CHAR (1)         NOT NULL,
    [created]                  DATETIME         NOT NULL,
    [created_by]               VARCHAR (24)     NOT NULL,
    [id]                       UNIQUEIDENTIFIER NOT NULL
);



