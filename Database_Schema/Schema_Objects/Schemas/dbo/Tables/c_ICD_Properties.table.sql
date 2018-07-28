CREATE TABLE [dbo].[c_ICD_Properties] (
    [icd_9_code]               VARCHAR (12) NOT NULL,
    [icd_property_sequence]    INT          IDENTITY (1, 1) NOT NULL,
    [icd_property_type]        VARCHAR (24) NOT NULL,
    [icd_property_heading]     VARCHAR (80) NULL,
    [description]              VARCHAR (80) NOT NULL,
    [long_description]         TEXT         NULL,
    [referenced_icd_from_code] VARCHAR (12) NOT NULL,
    [referenced_icd_to_code]   VARCHAR (12) NOT NULL
);



