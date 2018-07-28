CREATE TABLE [dbo].[c_Package] (
    [package_id]          VARCHAR (24)     NOT NULL,
    [administer_method]   VARCHAR (12)     NULL,
    [description]         VARCHAR (80)     NULL,
    [administer_unit]     VARCHAR (12)     NULL,
    [dose_unit]           VARCHAR (12)     NULL,
    [administer_per_dose] REAL             NULL,
    [dosage_form]         VARCHAR (24)     NULL,
    [dose_amount]         REAL             NULL,
    [id]                  UNIQUEIDENTIFIER NOT NULL,
    [status]              VARCHAR (12)     NOT NULL
);



