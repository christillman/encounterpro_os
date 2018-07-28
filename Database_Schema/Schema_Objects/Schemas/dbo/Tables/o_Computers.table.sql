CREATE TABLE [dbo].[o_Computers] (
    [computer_id]         INT              IDENTITY (1, 1) NOT NULL,
    [computername]        VARCHAR (40)     NOT NULL,
    [logon_id]            VARCHAR (40)     NOT NULL,
    [description]         VARCHAR (80)     NULL,
    [office_id]           VARCHAR (4)      NULL,
    [status]              VARCHAR (12)     NULL,
    [id]                  UNIQUEIDENTIFIER NOT NULL,
    [last_spid]           INT              NULL,
    [last_login_date]     DATETIME         NULL,
    [connected_flag]      CHAR (1)         NOT NULL,
    [last_connected_date] DATETIME         NULL
);

