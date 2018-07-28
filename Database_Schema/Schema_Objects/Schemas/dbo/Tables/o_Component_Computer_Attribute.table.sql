CREATE TABLE [dbo].[o_Component_Computer_Attribute] (
    [component_id]       VARCHAR (24)  NOT NULL,
    [computer_id]        INT           NOT NULL,
    [attribute_sequence] INT           IDENTITY (1, 1) NOT NULL,
    [attribute]          VARCHAR (64)  NOT NULL,
    [value]              VARCHAR (255) NULL
);



