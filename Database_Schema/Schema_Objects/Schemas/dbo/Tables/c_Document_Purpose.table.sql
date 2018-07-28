CREATE TABLE [dbo].[c_Document_Purpose] (
    [context_object]              VARCHAR (24)     NOT NULL,
    [purpose]                     VARCHAR (40)     NOT NULL,
    [description]                 VARCHAR (80)     NOT NULL,
    [new_object_workplan_id]      INT              NULL,
    [existing_object_workplan_id] INT              NULL,
    [owner_id]                    INT              NOT NULL,
    [created]                     DATETIME         NOT NULL,
    [created_by]                  VARCHAR (24)     NOT NULL,
    [last_updated]                DATETIME         NOT NULL,
    [id]                          UNIQUEIDENTIFIER NOT NULL
);



