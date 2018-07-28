CREATE TABLE [dbo].[c_Message_Fkey] (
    [message_type]          VARCHAR (24) NOT NULL,
    [message_part_sequence] INT          NOT NULL,
    [message_fkey_sequence] INT          IDENTITY (1, 1) NOT NULL,
    [target_table]          VARCHAR (64) NOT NULL,
    [target_location]       VARCHAR (12) NULL,
    [fkey_order]            SMALLINT     NULL,
    [fkey1]                 VARCHAR (64) NULL,
    [fkey2]                 VARCHAR (64) NULL,
    [fkey3]                 VARCHAR (64) NULL,
    [fkey4]                 VARCHAR (64) NULL,
    [fkey5]                 VARCHAR (64) NULL,
    [fkey6]                 VARCHAR (64) NULL
);



