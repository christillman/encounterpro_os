CREATE TABLE [dbo].[em_Component_Rule_Item] (
    [em_documentation_guide] VARCHAR (24) NOT NULL,
    [em_component]           VARCHAR (24) NOT NULL,
    [em_component_level]     INT          NOT NULL,
    [rule_id]                INT          NOT NULL,
    [item_sequence]          INT          NOT NULL,
    [em_type]                VARCHAR (24) NULL,
    [min_em_type_level]      INT          NULL
);



