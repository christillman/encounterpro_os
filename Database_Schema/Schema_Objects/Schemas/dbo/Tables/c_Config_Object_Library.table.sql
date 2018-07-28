CREATE TABLE [dbo].[c_Config_Object_Library] (
    [config_object_id]        UNIQUEIDENTIFIER NOT NULL,
    [config_object_type]      VARCHAR (24)     NOT NULL,
    [context_object]          VARCHAR (24)     NOT NULL,
    [description]             VARCHAR (80)     NOT NULL,
    [long_description]        TEXT             NULL,
    [config_object_category]  VARCHAR (80)     NULL,
    [production_version]      INT              NULL,
    [production_version_date] DATETIME         NULL,
    [beta_version]            INT              NULL,
    [beta_version_date]       DATETIME         NULL,
    [testing_version]         INT              NULL,
    [testing_version_date]    DATETIME         NULL,
    [owner_id]                INT              NOT NULL,
    [owner_description]       VARCHAR (80)     NOT NULL,
    [created]                 DATETIME         NOT NULL,
    [created_by]              VARCHAR (24)     NOT NULL,
    [status]                  VARCHAR (12)     NOT NULL,
    [copyright_status]        VARCHAR (24)     NOT NULL,
    [copyable]                BIT              NOT NULL,
    [license_data]            VARCHAR (2000)   NULL,
    [license_status]          VARCHAR (24)     NULL,
    [license_expiration_date] DATETIME         NULL,
    [latest_version]          INT              NULL,
    [latest_version_date]     DATETIME         NULL,
    [latest_version_status]   VARCHAR (12)     NULL
);



