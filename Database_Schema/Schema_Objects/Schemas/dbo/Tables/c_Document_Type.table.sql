CREATE TABLE [dbo].[c_Document_Type] (
    [document_type]   VARCHAR (255)    NOT NULL,
    [description]     VARCHAR (80)     NULL,
    [SchemaLocation]  VARCHAR (255)    NULL,
    [SampleDocument]  TEXT             NULL,
    [filetype]        VARCHAR (24)     NULL,
    [DefaultEncoding] VARCHAR (12)     NOT NULL,
    [document_format] VARCHAR (24)     NOT NULL,
    [owner_id]        INT              NOT NULL,
    [schema_owner_id] INT              NOT NULL,
    [id]              UNIQUEIDENTIFIER NOT NULL,
    [last_updated]    DATETIME         NOT NULL,
    [status]          VARCHAR (12)     NOT NULL
);



