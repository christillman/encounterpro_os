CREATE TABLE [dbo].[p_Family_History] (
    [cpr_id]                  VARCHAR (12)     NOT NULL,
    [family_history_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [encounter_id]            INT              NOT NULL,
    [name]                    VARCHAR (40)     NULL,
    [relation]                VARCHAR (40)     NULL,
    [birth_year]              SMALLINT         NULL,
    [age_at_death]            SMALLINT         NULL,
    [cause_of_death]          VARCHAR (40)     NULL,
    [comment]                 TEXT             NULL,
    [attachment_id]           INT              NULL,
    [created]                 DATETIME         NULL,
    [created_by]              VARCHAR (24)     NULL,
    [id]                      UNIQUEIDENTIFIER NOT NULL
);



