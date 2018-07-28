CREATE TABLE [dbo].[o_Event_Component_Attribute] (
    [event]              VARCHAR (24) NOT NULL,
    [component_sequence] SMALLINT     NOT NULL,
    [attribute_sequence] SMALLINT     NOT NULL,
    [attribute]          VARCHAR (64) NULL,
    [value]              TEXT         NULL
);



