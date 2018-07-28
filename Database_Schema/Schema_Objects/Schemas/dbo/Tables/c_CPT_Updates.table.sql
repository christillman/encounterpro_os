CREATE TABLE [dbo].[c_CPT_Updates] (
    [cpt_sequence]          INT          IDENTITY (1, 1) NOT NULL,
    [cpt_code]              VARCHAR (24) NOT NULL,
    [procedure_type]        VARCHAR (12) NULL,
    [procedure_category_id] VARCHAR (24) NULL,
    [modifier]              VARCHAR (2)  NULL,
    [other_modifiers]       VARCHAR (12) NULL,
    [units]                 REAL         NULL,
    [default_bill_flag]     CHAR (1)     NULL,
    [new_procedure_desc]    VARCHAR (80) NULL,
    [long_description]      TEXT         NULL,
    [from_cpt]              VARCHAR (12) NULL,
    [from_desc]             VARCHAR (80) NULL,
    [vaccine_id]            VARCHAR (24) NULL,
    [bill_assessment_id]    VARCHAR (24) NULL,
    [well_encounter_flag]   CHAR (1)     NULL,
    [from_assess_id]        VARCHAR (24) NULL,
    [procedure_id]          VARCHAR (24) NULL,
    [operation]             VARCHAR (24) NOT NULL,
    [update_year]           INT          NULL,
    [comment]               VARCHAR (80) NULL,
    [from_long_desc]        TEXT         NULL
);



