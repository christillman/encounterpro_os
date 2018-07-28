CREATE TABLE [dbo].[c_Drug_Package] (
    [drug_id]                 VARCHAR (24) NOT NULL,
    [package_id]              VARCHAR (24) NOT NULL,
    [sort_order]              SMALLINT     NULL,
    [prescription_flag]       VARCHAR (1)  NULL,
    [default_dispense_amount] REAL         NULL,
    [default_dispense_unit]   VARCHAR (12) NULL,
    [take_as_directed]        CHAR (1)     NULL,
    [hcpcs_procedure_id]      VARCHAR (24) NULL
);



