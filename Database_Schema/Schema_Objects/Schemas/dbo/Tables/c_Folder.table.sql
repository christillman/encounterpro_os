CREATE TABLE [dbo].[c_Folder] (
    [folder]                 VARCHAR (40)     NOT NULL,
    [context_object]         VARCHAR (50)     NOT NULL,
    [context_object_type]    VARCHAR (24)     NULL,
    [description]            VARCHAR (255)    NOT NULL,
    [status]                 VARCHAR (12)     NOT NULL,
    [sort_sequence]          INT              NULL,
    [workplan_required_flag] CHAR (1)         NOT NULL,
    [id]                     UNIQUEIDENTIFIER NOT NULL
);



