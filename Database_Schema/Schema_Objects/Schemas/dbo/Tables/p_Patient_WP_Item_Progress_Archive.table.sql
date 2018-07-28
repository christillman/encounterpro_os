CREATE TABLE [dbo].[p_Patient_WP_Item_Progress_Archive] (
    [patient_workplan_id]           INT              NOT NULL,
    [patient_workplan_item_id]      INT              NOT NULL,
    [patient_workplan_item_prog_id] INT              NOT NULL,
    [cpr_id]                        VARCHAR (12)     NULL,
    [encounter_id]                  INT              NULL,
    [user_id]                       VARCHAR (24)     NOT NULL,
    [progress_date_time]            DATETIME         NOT NULL,
    [progress_type]                 VARCHAR (24)     NOT NULL,
    [created]                       DATETIME         NULL,
    [created_by]                    VARCHAR (24)     NOT NULL,
    [id]                            UNIQUEIDENTIFIER NOT NULL
) ON [Workflow];



