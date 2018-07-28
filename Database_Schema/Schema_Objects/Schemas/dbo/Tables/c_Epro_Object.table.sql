CREATE TABLE [dbo].[c_Epro_Object] (
    [epro_object]                   VARCHAR (24)     NOT NULL,
    [object_type]                   VARCHAR (24)     NOT NULL,
    [description]                   VARCHAR (40)     NOT NULL,
    [default_which_object]          VARCHAR (255)    NULL,
    [base_tablename]                VARCHAR (64)     NULL,
    [base_table_key_column]         VARCHAR (64)     NULL,
    [base_table_filter]             VARCHAR (255)    NULL,
    [base_table_sort]               VARCHAR (255)    NULL,
    [default_display_property_name] VARCHAR (64)     NULL,
    [object_help]                   VARCHAR (1024)   NULL,
    [id]                            UNIQUEIDENTIFIER NOT NULL,
    [last_updated]                  DATETIME         NOT NULL,
    [base_table_query]              TEXT             NULL,
    [default_ordinal]               NCHAR (10)       NULL
);



