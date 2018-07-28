CREATE TABLE [dbo].[c_Attachment_Extension_Attribute] (
    [extension]          VARCHAR (24)  NOT NULL,
    [attribute_sequence] INT           IDENTITY (1, 1) NOT NULL,
    [attribute]          VARCHAR (64)  NOT NULL,
    [value]              VARCHAR (255) NULL,
    [current_flag]       CHAR (1)      NOT NULL,
    [created]            DATETIME      NOT NULL
);



