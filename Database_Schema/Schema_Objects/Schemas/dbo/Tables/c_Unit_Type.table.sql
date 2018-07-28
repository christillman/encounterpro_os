CREATE TABLE [dbo].[c_Unit_Type] (
    [unit_type]    VARCHAR (12)     NOT NULL,
    [description]  VARCHAR (80)     NULL,
    [component_id] VARCHAR (24)     NULL,
    [id]           UNIQUEIDENTIFIER NOT NULL
);

