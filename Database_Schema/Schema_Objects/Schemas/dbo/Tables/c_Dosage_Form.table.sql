CREATE TABLE [dbo].[c_Dosage_Form] (
    [dosage_form]               VARCHAR (15) NOT NULL,
    [description]               VARCHAR (40) NULL,
    [abbreviation]              VARCHAR (15) NULL,
    [default_administer_method] VARCHAR (12) NULL,
    [default_dose_amount]       REAL         NULL,
    [default_dose_unit]         VARCHAR (12) NULL,
    [dose_in_name_flag]         CHAR (1)     NULL,
    [default_administer_unit]   VARCHAR (12) NULL,
	rxcui						varchar(10) NULL
);



