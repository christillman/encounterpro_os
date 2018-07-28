CREATE TABLE [dbo].[x_Translation_Rule] (
    [external_application_id] VARCHAR (24)     NOT NULL,
    [integration_operation]   VARCHAR (24)     NOT NULL,
    [epro_source_flag]        CHAR (1)         NOT NULL,
    [translation_set]         VARCHAR (24)     NOT NULL,
    [add_record_flag]         CHAR (1)         NOT NULL,
    [update_record_flag]      CHAR (1)         NOT NULL,
    [add_record_rule]         VARCHAR (24)     NOT NULL,
    [default_value]           VARCHAR (24)     NULL,
    [created]                 DATETIME         NOT NULL,
    [created_by]              VARCHAR (24)     NOT NULL,
    [status]                  VARCHAR (12)     NOT NULL,
    [id]                      UNIQUEIDENTIFIER NOT NULL
);



