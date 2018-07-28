CREATE TABLE [dbo].[c_Authority_Category] (
    [authority_type]            VARCHAR (24) NOT NULL,
    [authority_category]        VARCHAR (24) NOT NULL,
    [description]               VARCHAR (80) NULL,
    [sort_sequence]             SMALLINT     NULL,
    [bill_procedure_assessment] CHAR (1)     NULL
);

