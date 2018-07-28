CREATE TABLE [dbo].[c_ICD_Code] (
    [icd_9_code]                          VARCHAR (12) NOT NULL,
    [description]                         VARCHAR (80) NOT NULL,
    [long_description]                    TEXT         NULL,
    [must_code_child_flag]                CHAR (1)     NULL,
    [nonspecific_code_flag]               CHAR (1)     NULL,
    [unspecified_code_flag]               CHAR (1)     NULL,
    [manifestation_code_flag]             CHAR (1)     NULL,
    [primary_diagnosis_only_flag]         CHAR (1)     NULL,
    [secondary_diagnosis_only_flag]       CHAR (1)     NULL,
    [medicare_secondary_payer_alert_flag] CHAR (1)     NULL,
    [revision_flag]                       CHAR (1)     NULL
);



