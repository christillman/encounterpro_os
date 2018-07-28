CREATE TABLE [dbo].[c_Unit] (
    [unit_id]                   VARCHAR (12)     NOT NULL,
    [description]               VARCHAR (40)     NULL,
    [unit_type]                 VARCHAR (12)     NULL,
    [pretty_fraction]           VARCHAR (12)     NULL,
    [plural_flag]               VARCHAR (1)      NULL,
    [print_unit]                CHAR (1)         NULL,
    [abbreviation]              VARCHAR (8)      NULL,
    [id]                        UNIQUEIDENTIFIER NOT NULL,
    [display_mask]              VARCHAR (40)     NULL,
    [prefix]                    VARCHAR (12)     NULL,
    [major_unit_display_suffix] VARCHAR (24)     NULL,
    [minor_unit_display_suffix] VARCHAR (24)     NULL,
    [major_unit_input_suffixes] VARCHAR (24)     NULL,
    [minor_unit_input_suffixes] VARCHAR (24)     NULL,
    [multiplier]                INT              NULL,
    [display_minor_units]       CHAR (1)         NULL
);



