CREATE TABLE [dbo].[em_Visit_Level_Rule] (
    [em_documentation_guide] VARCHAR (24)   NOT NULL,
    [visit_level]            INT            NOT NULL,
    [rule_id]                INT            NOT NULL,
    [new_flag]               CHAR (1)       NOT NULL,
    [item_count]             SMALLINT       NULL,
    [description]            VARCHAR (1024) NULL
);



