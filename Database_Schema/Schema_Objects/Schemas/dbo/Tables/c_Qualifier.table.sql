CREATE TABLE [dbo].[c_Qualifier] (
    [qualifier_domain_id] INT              NOT NULL,
    [qualifier_sequence]  INT              IDENTITY (1, 1) NOT NULL,
    [qualifier]           VARCHAR (40)     NULL,
    [sort_sequence]       SMALLINT         NULL,
    [id]                  UNIQUEIDENTIFIER NOT NULL
);



