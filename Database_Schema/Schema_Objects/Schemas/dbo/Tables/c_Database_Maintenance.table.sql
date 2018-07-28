CREATE TABLE [dbo].[c_Database_Maintenance] (
    [action_id]         INT           IDENTITY (1, 1) NOT NULL,
    [logon_id]          VARCHAR (40)  NOT NULL,
    [computername]      VARCHAR (40)  NOT NULL,
    [server]            VARCHAR (40)  NOT NULL,
    [database_name]     VARCHAR (40)  NOT NULL,
    [action]            VARCHAR (24)  NOT NULL,
    [action_date]       DATETIME      NOT NULL,
    [action_argument]   VARCHAR (255) NULL,
    [build]             VARCHAR (12)  NULL,
    [db_revision]       INT           NULL,
    [comment]           VARCHAR (255) NULL,
    [completion_status] VARCHAR (12)  NOT NULL
);

