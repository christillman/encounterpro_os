CREATE TABLE [dbo].[c_Procedure_Coding] (
    [procedure_id]    VARCHAR (24) NOT NULL,
    [authority_id]    VARCHAR (24) NOT NULL,
    [cpt_code]        VARCHAR (24) NULL,
    [modifier]        VARCHAR (2)  NULL,
    [other_modifiers] VARCHAR (12) NULL,
    [units]           FLOAT        NULL,
    [charge]          MONEY        NULL
);

