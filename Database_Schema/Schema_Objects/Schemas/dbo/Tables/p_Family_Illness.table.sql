CREATE TABLE [dbo].[p_Family_Illness] (
    [cpr_id]                  VARCHAR (12)     NOT NULL,
    [family_history_sequence] INT              NOT NULL,
    [family_illness_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [encounter_id]            INT              NOT NULL,
    [assessment_id]           VARCHAR (24)     NULL,
    [age]                     SMALLINT         NULL,
    [comment]                 TEXT             NULL,
    [attachment_id]           INT              NULL,
    [created]                 DATETIME         NULL,
    [created_by]              VARCHAR (24)     NULL,
    [id]                      UNIQUEIDENTIFIER NOT NULL
);



