CREATE TABLE [dbo].[c_Unit_Conversion] (
    [unit_from]             VARCHAR (12) NOT NULL,
    [unit_to]               VARCHAR (12) NOT NULL,
    [conversion_factor]     REAL         NULL,
    [conversion_difference] REAL         NULL,
    [unit_from_metric_flag] CHAR (1)     NULL
);



