CREATE TABLE [dbo].[c_Database_Status] (
    [customer_id]               INT              NOT NULL,
    [major_release]             INT              NOT NULL,
    [database_version]          VARCHAR (4)      NOT NULL,
    [database_mode]             VARCHAR (16)     NOT NULL,
    [database_status]           VARCHAR (12)     NOT NULL,
    [database_id]               UNIQUEIDENTIFIER NOT NULL,
    [master_configuration_date] DATETIME         NULL,
    [modification_level]        INT              NULL,
    [last_scripts_update]       DATETIME         NULL,
    [beta_flag]                 BIT              NOT NULL,
    [vax_component_id]          UNIQUEIDENTIFIER NULL,
    [vax_component_version]     INT              NULL
);



