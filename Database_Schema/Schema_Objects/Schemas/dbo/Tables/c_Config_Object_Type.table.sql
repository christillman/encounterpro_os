CREATE TABLE [dbo].[c_Config_Object_Type] (
    [config_object_type]      VARCHAR (24)     NOT NULL,
    [description]             VARCHAR (80)     NOT NULL,
    [base_table]              VARCHAR (64)     NOT NULL,
    [config_object_key]       VARCHAR (64)     NOT NULL,
    [config_object_prefix]    VARCHAR (8)      NOT NULL,
    [creator_xml_script_guid] UNIQUEIDENTIFIER NULL,
    [creator_xml_script_id]   INT              NULL,
    [version_control]         BIT              NOT NULL,
    [created]                 DATETIME         NOT NULL,
    [created_by]              VARCHAR (24)     NOT NULL,
    [configuration_service]   VARCHAR (24)     NULL,
    [object_encoding_method]  VARCHAR (12)     NULL,
    [auto_install_flag]       BIT              DEFAULT ((1)) NOT NULL,
    [concurrent_install_flag] BIT              DEFAULT ((1)) NOT NULL
);



