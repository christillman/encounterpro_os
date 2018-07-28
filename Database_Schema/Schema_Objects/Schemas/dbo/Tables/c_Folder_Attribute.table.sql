CREATE TABLE [dbo].[c_Folder_Attribute] (
    [folder]             VARCHAR (40)  NOT NULL,
    [attribute_sequence] INT           IDENTITY (1, 1) NOT NULL,
    [attribute]          VARCHAR (64)  NOT NULL,
    [value]              VARCHAR (255) NULL
);



