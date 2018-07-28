CREATE TABLE [dbo].[c_Drug_HCPCS] (
    [drug_id]            VARCHAR (24) NOT NULL,
    [hcpcs_sequence]     INT          NOT NULL,
    [administer_amount]  REAL         NULL,
    [administer_unit]    VARCHAR (12) NULL,
    [hcpcs_procedure_id] VARCHAR (24) NULL
);



