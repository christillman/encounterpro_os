CREATE TABLE [dbo].[c_Object_Default_Progress_Type] (
    [context_object]               VARCHAR (24) NOT NULL,
    [progress_type]                VARCHAR (24) NOT NULL,
    [display_flag]                 CHAR (1)     NULL,
    [display_style]                VARCHAR (24) NULL,
    [soap_display_style]           VARCHAR (24) NULL,
    [progress_key_required_flag]   CHAR (1)     NULL,
    [progress_key_enumerated_flag] CHAR (1)     NULL,
    [progress_key_object]          VARCHAR (24) NULL,
    [sort_sequence]                SMALLINT     NULL,
    [allow_multiple_dates]         CHAR (1)     NULL
);



