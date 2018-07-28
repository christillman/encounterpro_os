CREATE TABLE [dbo].[o_Component_Base_Attribute] (
    [component_type]     VARCHAR (24)  NOT NULL,
    [office_id]          VARCHAR (4)   NOT NULL,
    [attribute_sequence] INT           IDENTITY (1, 1) NOT NULL,
    [attribute]          VARCHAR (64)  NOT NULL,
    [value]              VARCHAR (255) NULL
);



