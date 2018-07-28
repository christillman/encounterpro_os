CREATE TABLE [dbo].[c_Maintenance_Patient_Class] (
    [maintenance_rule_id]             INT              IDENTITY (1, 1) NOT NULL,
    [filter_from_maintenance_rule_id] INT              NULL,
    [maintenance_rule_type]           VARCHAR (24)     NOT NULL,
    [assessment_flag]                 CHAR (1)         NULL,
    [sex]                             CHAR (1)         NULL,
    [race]                            VARCHAR (12)     NULL,
    [description]                     VARCHAR (80)     NOT NULL,
    [age_range_id]                    INT              NULL,
    [interval]                        INT              NULL,
    [interval_unit]                   VARCHAR (24)     NULL,
    [warning_days]                    INT              NULL,
    [status]                          VARCHAR (12)     NOT NULL,
    [last_updated]                    DATETIME         NOT NULL,
    [id]                              UNIQUEIDENTIFIER NOT NULL,
    [owner_id]                        INT              NOT NULL,
    [last_reset]                      DATETIME         NULL,
    [compliance_ok_percent]           INT              NULL,
    [compliance_warning_percent]      INT              NULL,
    [measured_ok_percent]             INT              NULL,
    [measured_warning_percent]        INT              NULL,
    [controlled_ok_percent]           INT              NULL,
    [controlled_warning_percent]      INT              NULL
);



