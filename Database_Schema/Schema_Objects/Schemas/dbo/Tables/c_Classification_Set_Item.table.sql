CREATE TABLE [dbo].[c_Classification_Set_Item] (
    [classification_set_id] INT              NOT NULL,
    [item_sequence]         INT              IDENTITY (1, 1) NOT NULL,
    [description]           VARCHAR (80)     NOT NULL,
    [content_object_type]   VARCHAR (24)     NOT NULL,
    [property]              VARCHAR (64)     NOT NULL,
    [operator]              VARCHAR (24)     NOT NULL,
    [value]                 VARCHAR (255)    NOT NULL,
    [id]                    UNIQUEIDENTIFIER NOT NULL,
    [status]                VARCHAR (12)     NOT NULL,
    [created]               DATETIME         NOT NULL,
    [created_by]            VARCHAR (24)     NOT NULL
);



