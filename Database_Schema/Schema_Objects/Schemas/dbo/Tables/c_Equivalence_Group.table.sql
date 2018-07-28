CREATE TABLE [dbo].[c_Equivalence_Group] (
    [equivalence_group_id] INT          IDENTITY (1, 1) NOT NULL,
    [object_type]          VARCHAR (24) NOT NULL,
    [description]          VARCHAR (80) NOT NULL,
    [created]              DATETIME     NULL,
    [created_by]           VARCHAR (24) NULL
);



