CREATE TABLE [dbo].[c_Folder_Selection] (
    [folder_selection_id] INT          IDENTITY (1, 1) NOT NULL,
    [context_object]      VARCHAR (24) NOT NULL,
    [context_object_type] VARCHAR (40) NULL,
    [attachment_type]     VARCHAR (24) NULL,
    [extension]           VARCHAR (24) NULL,
    [folder]              VARCHAR (40) NOT NULL,
    [auto_select_flag]    CHAR (1)     NOT NULL,
    [sort_sequence]       INT          NULL
);



