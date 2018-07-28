CREATE TABLE [dbo].[p_Assessment_Treatment] (
    [cpr_id]         VARCHAR (12)     NOT NULL,
    [problem_id]     INT              NOT NULL,
    [treatment_id]   INT              NOT NULL,
    [treatment_goal] VARCHAR (80)     NULL,
    [encounter_id]   INT              NOT NULL,
    [created]        DATETIME         NULL,
    [created_by]     VARCHAR (24)     NULL,
    [id]             UNIQUEIDENTIFIER NOT NULL
);

