CREATE TABLE [dbo].[c_Vial_Schedule] (
    [vial_schedule] VARCHAR (24)  NOT NULL,
    [dose_number]   INT           NOT NULL,
    [vial_type]     VARCHAR (24)  NOT NULL,
    [dose_amount]   REAL          NULL,
    [dose_unit]     VARCHAR (24)  NULL,
    [comment]       VARCHAR (255) NULL
);



