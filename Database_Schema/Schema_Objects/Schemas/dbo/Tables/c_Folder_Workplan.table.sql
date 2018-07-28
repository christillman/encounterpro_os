CREATE TABLE [dbo].[c_Folder_Workplan] (
    [folder]            VARCHAR (40) NOT NULL,
    [workplan_sequence] INT          IDENTITY (1, 1) NOT NULL,
    [workplan_id]       INT          NOT NULL,
    [owned_by]          VARCHAR (24) NULL,
    [sort_sequence]     INT          NULL
);



