CREATE TABLE [dbo].[p_Patient_WP_Item_Attribute_Archive] (
    [patient_workplan_item_id] INT              NOT NULL,
    [attribute_sequence]       INT              NOT NULL,
    [patient_workplan_id]      INT              NOT NULL,
    [cpr_id]                   VARCHAR (12)     NULL,
    [attribute]                VARCHAR (64)     NOT NULL,
    [message]                  TEXT             NULL,
    [created_by]               VARCHAR (24)     NOT NULL,
    [created]                  DATETIME         NULL,
    [id]                       UNIQUEIDENTIFIER NOT NULL,
    [value_short]              VARCHAR (50)     NULL,
    [actor_id]                 INT              NULL,
    [value]                    AS               (convert(varchar(255),[value_short]))
) ON [Workflow] TEXTIMAGE_ON [Workflow];



