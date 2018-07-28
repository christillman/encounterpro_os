CREATE TABLE [dbo].[c_XML_Class_Selection] (
    [xml_class_selection_id] INT              IDENTITY (1, 1) NOT NULL,
    [xml_root_tag]           VARCHAR (80)     NULL,
    [xml_namespace]          VARCHAR (255)    NULL,
    [xml_schema]             VARCHAR (255)    NULL,
    [xml_class]              VARCHAR (40)     NOT NULL,
    [sort_sequence]          INT              NULL,
    [status]                 VARCHAR (12)     NOT NULL,
    [created]                DATETIME         NOT NULL,
    [created_by]             VARCHAR (24)     NULL,
    [id]                     UNIQUEIDENTIFIER NOT NULL,
    [last_updated]           DATETIME         NOT NULL
);



