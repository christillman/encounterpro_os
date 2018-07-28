CREATE TABLE [dbo].[c_Config_Object_Version] (
    [config_object_id]         UNIQUEIDENTIFIER NOT NULL,
    [version]                  INT              NOT NULL,
    [description]              VARCHAR (80)     NOT NULL,
    [version_description]      TEXT             NULL,
    [config_object_type]       VARCHAR (24)     NOT NULL,
    [owner_id]                 INT              NOT NULL,
    [created]                  DATETIME         NOT NULL,
    [created_by]               VARCHAR (24)     NOT NULL,
    [created_from_version]     INT              NULL,
    [checked_in]               DATETIME         NULL,
    [status]                   VARCHAR (12)     NOT NULL,
    [status_date_time]         DATETIME         NOT NULL,
    [release_status]           VARCHAR (12)     NULL,
    [release_status_date_time] DATETIME         NULL,
    [objectdata]               IMAGE            NULL,
    [checked_out_by]           VARCHAR (24)     NULL,
    [object_encoding_method]   VARCHAR (12)     NULL
);



