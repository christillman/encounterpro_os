CREATE TABLE [dbo].[c_XML_Code] (
    [code_id]          INT              IDENTITY (1, 1) NOT NULL,
    [owner_id]         INT              NOT NULL,
    [code_domain]      VARCHAR (40)     NOT NULL,
    [code_version]     VARCHAR (40)     NULL,
    [code]             VARCHAR (80)     NULL,
    [epro_domain]      VARCHAR (64)     NOT NULL,
    [epro_id]          VARCHAR (64)     NULL,
    [unique_flag]      BIT              NOT NULL,
    [created]          DATETIME         NOT NULL,
    [created_by]       VARCHAR (24)     NOT NULL,
    [last_updated]     DATETIME         NOT NULL,
    [id]               UNIQUEIDENTIFIER NOT NULL,
    [mapping_owner_id] INT              NOT NULL,
    [code_description] VARCHAR (80)     NULL,
    [epro_description] VARCHAR (80)     NULL,
    [epro_owner_id]    INT              NOT NULL,
    [status]           VARCHAR (12)     NOT NULL,
    [description]      VARCHAR (128)    NULL
);



