CREATE TABLE [dbo].[p_Observation_Result_Qualifier] (
    [cpr_id]               VARCHAR (12)     NOT NULL,
    [treatment_id]         INT              NOT NULL,
    [observation_sequence] INT              NOT NULL,
    [location]             VARCHAR (24)     NOT NULL,
    [result_sequence]      SMALLINT         NOT NULL,
    [qualifier_domain_id]  INT              NOT NULL,
    [qualifier]            VARCHAR (40)     NOT NULL,
    [prefix]               VARCHAR (40)     NULL,
    [observation_id]       VARCHAR (24)     NOT NULL,
    [encounter_id]         INT              NOT NULL,
    [attachment_id]        INT              NULL,
    [created]              DATETIME         NULL,
    [created_by]           VARCHAR (24)     NULL,
    [id]                   UNIQUEIDENTIFIER NOT NULL
);

