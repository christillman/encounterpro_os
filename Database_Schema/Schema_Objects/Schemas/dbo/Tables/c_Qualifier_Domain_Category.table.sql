CREATE TABLE [dbo].[c_Qualifier_Domain_Category] (
    [qualifier_domain_category_id] INT              IDENTITY (1, 1) NOT NULL,
    [description]                  VARCHAR (80)     NOT NULL,
    [prefix]                       VARCHAR (40)     NULL,
    [qualifier_class]              VARCHAR (12)     NOT NULL,
    [sort_sequence]                SMALLINT         NULL,
    [id]                           UNIQUEIDENTIFIER NOT NULL
);



