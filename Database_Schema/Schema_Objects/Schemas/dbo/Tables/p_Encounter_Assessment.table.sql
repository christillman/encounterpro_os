CREATE TABLE [dbo].[p_Encounter_Assessment] (
    [cpr_id]                VARCHAR (12)     NOT NULL,
    [encounter_id]          INT              NOT NULL,
    [problem_id]            INT              NOT NULL,
    [assessment_sequence]   SMALLINT         NULL,
    [assessment_billing_id] INT              NULL,
    [assessment_id]         VARCHAR (24)     NULL,
    [bill_flag]             CHAR (1)         NOT NULL,
    [created]               DATETIME         NULL,
    [created_by]            VARCHAR (24)     NULL,
    [id]                    UNIQUEIDENTIFIER NOT NULL,
    [icd_9_code]            VARCHAR (12)     NULL,
    [posted]                CHAR (1)         NOT NULL,
    [exclusive_link]        CHAR (1)         NOT NULL
);



