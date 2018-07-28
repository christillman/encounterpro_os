CREATE TABLE [dbo].[c_Qualifier_Domain] (
    [qualifier_domain_id]          INT              IDENTITY (1, 1) NOT NULL,
    [qualifier_domain_category_id] INT              NOT NULL,
    [description]                  VARCHAR (80)     NULL,
    [exclusive_flag]               CHAR (1)         NULL,
    [sort_sequence]                SMALLINT         NULL,
    [status]                       VARCHAR (12)     NULL,
    [id]                           UNIQUEIDENTIFIER NOT NULL
);



