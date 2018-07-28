CREATE TABLE [dbo].[c_Maintenance_Treatment] (
    [maintenance_rule_id]            INT          NOT NULL,
    [maintenance_treatment_sequence] INT          IDENTITY (1, 1) NOT NULL,
    [treatment_type]                 VARCHAR (24) NOT NULL,
    [treatment_key]                  VARCHAR (40) NOT NULL,
    [description]                    VARCHAR (80) NOT NULL,
    [open_flag]                      CHAR (1)     NOT NULL,
    [primary_flag]                   CHAR (1)     NOT NULL,
    [created]                        DATETIME     NOT NULL,
    [created_by]                     VARCHAR (24) NOT NULL
);



