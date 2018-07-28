CREATE TABLE [dbo].[c_Vial_Type] (
    [vial_type]             VARCHAR (24) NOT NULL,
    [full_strength_ratio]   INT          NOT NULL,
    [dilute_from_vial_type] VARCHAR (24) NULL,
    [dilute_ratio]          INT          NULL,
    [default_amount]        REAL         NULL,
    [default_unit]          VARCHAR (24) NULL
);



