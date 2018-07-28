CREATE TABLE [dbo].[o_Report_Attribute] (
    [report_id]          UNIQUEIDENTIFIER NOT NULL,
    [office_id]          VARCHAR (4)      NOT NULL,
    [attribute_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [attribute]          VARCHAR (64)     NOT NULL,
    [value]              VARCHAR (255)    NULL
);



