CREATE TABLE [dbo].[p_Observation] (
    [cpr_id]                      VARCHAR (12)     NOT NULL,
    [observation_sequence]        INT              IDENTITY (1, 1) NOT NULL,
    [observation_id]              VARCHAR (24)     NOT NULL,
    [description]                 VARCHAR (80)     NOT NULL,
    [problem_id]                  INT              NULL,
    [treatment_id]                INT              NULL,
    [encounter_id]                INT              NULL,
    [attachment_id]               INT              NULL,
    [result_expected_date]        DATETIME         NULL,
    [observation_tag]             VARCHAR (12)     NULL,
    [abnormal_flag]               CHAR (1)         NULL,
    [severity]                    SMALLINT         NULL,
    [composite_flag]              CHAR (1)         NULL,
    [parent_observation_sequence] INT              NULL,
    [stage]                       INT              NULL,
    [stage_description]           VARCHAR (32)     NULL,
    [observed_by]                 VARCHAR (24)     NULL,
    [service]                     VARCHAR (24)     NULL,
    [branch_sort_sequence]        SMALLINT         NULL,
    [created]                     DATETIME         NULL,
    [created_by]                  VARCHAR (24)     NULL,
    [id]                          UNIQUEIDENTIFIER NOT NULL,
    [original_branch_id]          INT              NULL,
    [event_id]                    VARCHAR (40)     NULL
);



