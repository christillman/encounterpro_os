CREATE TABLE [dbo].[c_Classification_Set] (
    [classification_set_id]   INT              IDENTITY (1, 1) NOT NULL,
    [owner_id]                INT              NOT NULL,
    [classification_set_type] VARCHAR (24)     NOT NULL,
    [classification_set_name] VARCHAR (40)     NOT NULL,
    [description]             VARCHAR (255)    NOT NULL,
    [id]                      UNIQUEIDENTIFIER NOT NULL,
    [version]                 INT              NOT NULL,
    [status]                  VARCHAR (12)     NOT NULL,
    [created]                 DATETIME         NOT NULL,
    [created_by]              VARCHAR (24)     NOT NULL
);



