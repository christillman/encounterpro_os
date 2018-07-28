CREATE TABLE [dbo].[c_ICD_Updates] (
    [icd_9_code]             VARCHAR (50) NOT NULL,
    [icd_sequence]           INT          IDENTITY (600, 1) NOT NULL,
    [operation]              VARCHAR (50) NOT NULL,
    [new_description]        VARCHAR (80) NULL,
    [long_description]       TEXT         NULL,
    [from_description]       VARCHAR (80) NULL,
    [assessment_type]        VARCHAR (12) NULL,
    [assessment_category_id] VARCHAR (12) NULL,
    [from_icd9]              VARCHAR (50) NULL,
    [update_year]            INT          NULL,
    [comment]                VARCHAR (80) NULL,
    [assessment_id]          VARCHAR (24) NULL
);



