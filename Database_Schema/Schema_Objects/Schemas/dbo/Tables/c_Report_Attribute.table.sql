CREATE TABLE [dbo].[c_Report_Attribute] (
    [report_id]           UNIQUEIDENTIFIER NOT NULL,
    [attribute_sequence]  INT              IDENTITY (1, 1) NOT NULL,
    [attribute]           VARCHAR (64)     NOT NULL,
    [value]               VARCHAR (255)    NULL,
    [component_attribute] CHAR (1)         NOT NULL,
    [objectdata]          IMAGE            NULL,
    [component_id]        UNIQUEIDENTIFIER NULL,
    [last_modified]       DATETIME         NOT NULL
);



