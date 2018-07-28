CREATE TABLE [dbo].[c_Drug_Compound] (
    [drug_id]             VARCHAR (24)     NOT NULL,
    [compound_sequence]   INT              IDENTITY (1, 1) NOT NULL,
    [constituent_drug_id] VARCHAR (24)     NOT NULL,
    [percentage]          DECIMAL (6, 3)   NULL,
    [administer_amount]   REAL             NULL,
    [administer_unit]     VARCHAR (12)     NULL,
    [sort_sequence]       SMALLINT         NULL,
    [id]                  UNIQUEIDENTIFIER NOT NULL
);



