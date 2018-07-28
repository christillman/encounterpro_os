CREATE TABLE [dbo].[p_Patient_WP_Archive] (
    [patient_workplan_id]             INT              NOT NULL,
    [cpr_id]                          VARCHAR (12)     NULL,
    [workplan_id]                     INT              NOT NULL,
    [workplan_type]                   VARCHAR (12)     NOT NULL,
    [in_office_flag]                  CHAR (1)         NULL,
    [mode]                            VARCHAR (32)     NULL,
    [last_step_dispatched]            SMALLINT         NULL,
    [last_step_date]                  DATETIME         NULL,
    [encounter_id]                    INT              NULL,
    [problem_id]                      INT              NULL,
    [treatment_id]                    INT              NULL,
    [observation_sequence]            INT              NULL,
    [attachment_id]                   INT              NULL,
    [description]                     VARCHAR (80)     NULL,
    [ordered_by]                      VARCHAR (24)     NOT NULL,
    [owned_by]                        VARCHAR (24)     NULL,
    [parent_patient_workplan_item_id] INT              NULL,
    [status]                          VARCHAR (12)     NULL,
    [created_by]                      VARCHAR (24)     NOT NULL,
    [created]                         DATETIME         NULL,
    [id]                              UNIQUEIDENTIFIER NOT NULL
) ON [Workflow];



