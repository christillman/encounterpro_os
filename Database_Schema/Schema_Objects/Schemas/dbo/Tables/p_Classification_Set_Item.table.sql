CREATE TABLE [dbo].[p_Classification_Set_Item] (
    [cpr_id]                     VARCHAR (12)     NOT NULL,
    [classification_set_id]      INT              NOT NULL,
    [item_sequence]              INT              NOT NULL,
    [description]                VARCHAR (80)     NOT NULL,
    [summary_context_object]     VARCHAR (24)     NOT NULL,
    [summary_object_key]         INT              NOT NULL,
    [target_context_object]      VARCHAR (24)     NOT NULL,
    [target_context_object_type] VARCHAR (24)     NOT NULL,
    [when_flag]                  VARCHAR (8)      NOT NULL,
    [property]                   VARCHAR (64)     NOT NULL,
    [operator]                   VARCHAR (24)     NOT NULL,
    [value]                      VARCHAR (255)    NOT NULL,
    [normal_present]             BIT              NOT NULL,
    [abnormal_present]           BIT              NOT NULL,
    [normal_past]                BIT              NOT NULL,
    [abnormal_past]              BIT              NOT NULL,
    [last_changed]               DATETIME         NOT NULL,
    [id]                         UNIQUEIDENTIFIER NOT NULL,
    [created]                    DATETIME         NOT NULL,
    [created_by]                 VARCHAR (24)     NOT NULL
);



