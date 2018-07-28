CREATE TABLE [dbo].[o_Report_Printer] (
    [report_id]               UNIQUEIDENTIFIER NOT NULL,
    [report_printer_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [office_id]               VARCHAR (4)      NULL,
    [computer_id]             INT              NULL,
    [room_id]                 VARCHAR (12)     NULL,
    [printer]                 VARCHAR (64)     NOT NULL,
    [sort_sequence]           INT              NULL
);



