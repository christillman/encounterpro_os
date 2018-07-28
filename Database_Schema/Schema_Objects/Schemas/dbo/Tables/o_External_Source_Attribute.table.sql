CREATE TABLE [dbo].[o_External_Source_Attribute] (
    [external_source]    VARCHAR (24)  NOT NULL,
    [attribute_sequence] INT           IDENTITY (1, 1) NOT NULL,
    [computer_id]        INT           NULL,
    [office_id]          VARCHAR (4)   NULL,
    [attribute]          VARCHAR (64)  NOT NULL,
    [value]              VARCHAR (255) NULL
);



