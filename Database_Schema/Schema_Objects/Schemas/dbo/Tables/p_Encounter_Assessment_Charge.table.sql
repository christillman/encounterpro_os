CREATE TABLE [dbo].[p_Encounter_Assessment_Charge] (
    [cpr_id]              VARCHAR (12)     NOT NULL,
    [encounter_id]        INT              NOT NULL,
    [problem_id]          INT              NOT NULL,
    [encounter_charge_id] INT              NOT NULL,
    [bill_flag]           CHAR (1)         NOT NULL,
    [created]             DATETIME         NULL,
    [created_by]          VARCHAR (24)     NULL,
    [id]                  UNIQUEIDENTIFIER NOT NULL,
    [bill_flag_master]    CHAR (1)         NULL,
    [billing_sequence]    SMALLINT         NULL
);



