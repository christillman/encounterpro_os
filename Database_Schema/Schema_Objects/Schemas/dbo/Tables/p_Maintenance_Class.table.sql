CREATE TABLE [dbo].[p_Maintenance_Class] (
    [maintenance_rule_id] INT          NOT NULL,
    [cpr_id]              VARCHAR (12) NOT NULL,
    [status_date]         DATETIME     NOT NULL,
    [in_class_flag]       CHAR (1)     NOT NULL,
    [on_protocol_flag]    CHAR (1)     NOT NULL,
    [is_controlled]       CHAR (1)     NOT NULL,
    [current_flag]        CHAR (1)     NOT NULL
);



