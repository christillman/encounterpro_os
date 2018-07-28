CREATE TABLE [dbo].[c_Message_Part] (
    [message_type]          VARCHAR (24) NOT NULL,
    [message_part_sequence] INT          IDENTITY (1, 1) NOT NULL,
    [part_type]             VARCHAR (12) NULL,
    [part_table]            VARCHAR (32) NULL,
    [part_order]            SMALLINT     NULL,
    [part_unique]           CHAR (1)     NULL,
    [part_query]            TEXT         NULL
);



