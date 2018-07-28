CREATE TABLE [dbo].[c_Observation_Type] (
    [observation_type]       VARCHAR (24)  NOT NULL,
    [default_composite_flag] CHAR (1)      NULL,
    [display_flag]           CHAR (1)      NULL,
    [display_style]          VARCHAR (255) NULL,
    [sort_sequence]          SMALLINT      NULL,
    [abbreviation]           VARCHAR (4)   NULL
);



