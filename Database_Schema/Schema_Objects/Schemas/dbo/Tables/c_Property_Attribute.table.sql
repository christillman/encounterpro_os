CREATE TABLE [dbo].[c_Property_Attribute] (
    [property_id]        INT           NOT NULL,
    [attribute_sequence] INT           IDENTITY (1, 1) NOT NULL,
    [attribute]          VARCHAR (64)  NOT NULL,
    [value]              VARCHAR (255) NULL
);



