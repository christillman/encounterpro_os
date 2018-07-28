CREATE TABLE [dbo].[c_Maintenance_Policy] (
    [maintenance_rule_id]       INT          NOT NULL,
    [policy_sequence]           INT          IDENTITY (1, 1) NOT NULL,
    [policy_event]              VARCHAR (40) NOT NULL,
    [include_new_flag]          CHAR (1)     NOT NULL,
    [time_offset_amount]        INT          NULL,
    [time_offset_unit]          VARCHAR (24) NULL,
    [action_workplan_id]        INT          NULL,
    [action_workplan_recipient] VARCHAR (24) NULL,
    [created]                   DATETIME     NOT NULL,
    [created_by]                VARCHAR (24) NOT NULL
);



