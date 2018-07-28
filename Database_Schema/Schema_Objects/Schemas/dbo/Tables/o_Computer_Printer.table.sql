CREATE TABLE [dbo].[o_Computer_Printer] (
    [computer_id]      INT           NOT NULL,
    [printer_sequence] INT           IDENTITY (1, 1) NOT NULL,
    [printer]          VARCHAR (128) NOT NULL,
    [driver]           VARCHAR (128) NOT NULL,
    [port]             VARCHAR (32)  NOT NULL,
    [display_name]     VARCHAR (64)  NULL,
    [last_discovered]  DATETIME      DEFAULT (getdate()) NOT NULL,
    [fax_flag]         CHAR (1)      DEFAULT ('N') NOT NULL
);



