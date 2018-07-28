CREATE TABLE [dbo].[c_Procedure_Type] (
    [procedure_type] VARCHAR (12)     NOT NULL,
    [description]    VARCHAR (80)     NULL,
    [sort_sequence]  SMALLINT         NULL,
    [button]         VARCHAR (64)     NULL,
    [icon]           VARCHAR (64)     NULL,
    [id]             UNIQUEIDENTIFIER NOT NULL
);



