CREATE TABLE [dbo].[c_Drug_Package_Dispense] (
    [drug_id]           VARCHAR (24) NOT NULL,
    [package_id]        VARCHAR (24) NOT NULL,
    [dispense_sequence] INT          IDENTITY (1, 1) NOT NULL,
    [dispense_amount]   REAL         NULL,
    [dispense_unit]     VARCHAR (12) NULL
);



