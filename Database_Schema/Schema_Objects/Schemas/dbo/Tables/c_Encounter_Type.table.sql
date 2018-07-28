CREATE TABLE [dbo].[c_Encounter_Type] (
    [encounter_type]              VARCHAR (24)     NOT NULL,
    [description]                 VARCHAR (80)     NULL,
    [default_role]                VARCHAR (24)     NULL,
    [sort_order]                  INT              NULL,
    [bill_flag]                   CHAR (1)         NULL,
    [default_indirect_flag]       CHAR (1)         NULL,
    [button]                      VARCHAR (64)     NULL,
    [icon]                        VARCHAR (64)     NULL,
    [display_format]              VARCHAR (40)     NULL,
    [status]                      VARCHAR (12)     NULL,
    [id]                          UNIQUEIDENTIFIER NOT NULL,
    [visit_code_group]            VARCHAR (24)     NULL,
    [close_encounter_workplan_id] INT              NULL,
    [display_script_id]           INT              NULL,
    [coding_mode]                 VARCHAR (12)     NOT NULL,
    [coding_new_list_id]          VARCHAR (24)     NULL,
    [coding_est_list_id]          VARCHAR (24)     NULL,
    [created]                     DATETIME         NOT NULL,
    [created_by]                  VARCHAR (24)     NULL,
    [owner_id]                    INT              NOT NULL,
    [version]                     INT              NOT NULL
);

