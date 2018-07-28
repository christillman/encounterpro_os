CREATE TABLE [dbo].[c_Component_Definition] (
    [component_id]            VARCHAR (24)     NOT NULL,
    [component_type]          VARCHAR (24)     NOT NULL,
    [system_id]               VARCHAR (24)     NOT NULL,
    [system_type]             VARCHAR (24)     NOT NULL,
    [system_category]         VARCHAR (40)     NOT NULL,
    [component_install_type]  VARCHAR (24)     NULL,
    [component]               VARCHAR (24)     NOT NULL,
    [component_class]         VARCHAR (128)    NULL,
    [description]             VARCHAR (80)     NULL,
    [license_data]            VARCHAR (2000)   NULL,
    [license_status]          VARCHAR (24)     NOT NULL,
    [license_expiration_date] DATETIME         NULL,
    [normal_version]          INT              NULL,
    [testing_version]         INT              NULL,
    [id]                      UNIQUEIDENTIFIER NOT NULL,
    [status]                  VARCHAR (12)     NOT NULL,
    [owner_id]                INT              NULL,
    [created]                 DATETIME         NOT NULL,
    [last_updated]            DATETIME         NOT NULL
);



