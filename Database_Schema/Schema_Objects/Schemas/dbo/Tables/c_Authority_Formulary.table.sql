CREATE TABLE [dbo].[c_Authority_Formulary] (
    [authority_formulary_id]       INT          IDENTITY (1, 1) NOT NULL,
    [authority_id]                 VARCHAR (24) NOT NULL,
    [authority_formulary_sequence] INT          NOT NULL,
    [icd_9_code]                   VARCHAR (12) NULL,
    [treatment_type]               VARCHAR (24) NOT NULL,
    [treatment_key]                VARCHAR (40) NOT NULL,
    [formulary_code]               VARCHAR (24) NOT NULL
);

