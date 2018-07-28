CREATE TABLE [dbo].[c_Maintenance_Assessment] (
    [maintenance_rule_id]     INT          NOT NULL,
    [assessment_id]           VARCHAR (24) NOT NULL,
    [assessment_current_flag] CHAR (1)     NULL,
    [primary_flag]            CHAR (1)     NULL,
    [icd_9_code]              VARCHAR (12) NULL
);



