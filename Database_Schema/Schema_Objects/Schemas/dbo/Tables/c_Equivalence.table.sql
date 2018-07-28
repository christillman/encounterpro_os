CREATE TABLE [dbo].[c_Equivalence] (
    [object_id]            UNIQUEIDENTIFIER NOT NULL,
    [equivalence_group_id] INT              NULL,
    [created]              DATETIME         NULL,
    [created_by]           VARCHAR (24)     NULL,
    [id]                   UNIQUEIDENTIFIER NOT NULL,
    [primary_flag]         CHAR (1)         NOT NULL,
    [object_type]          VARCHAR (24)     NOT NULL,
    [object_key]           VARCHAR (64)     NOT NULL,
    [description]          VARCHAR (80)     NOT NULL,
    [owner_id]             INT              NOT NULL
);



