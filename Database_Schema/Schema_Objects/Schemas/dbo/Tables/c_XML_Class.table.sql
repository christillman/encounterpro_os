CREATE TABLE [dbo].[c_XML_Class] (
    [xml_class]                    VARCHAR (40)     NOT NULL,
    [description]                  VARCHAR (80)     NOT NULL,
    [render_transform_material_id] INT              NULL,
    [render_transform_extension]   VARCHAR (24)     NULL,
    [xml_handler_class]            VARCHAR (80)     NULL,
    [xml_creator_class]            VARCHAR (80)     NULL,
    [root_context_object]          VARCHAR (24)     NULL,
    [created]                      DATETIME         NULL,
    [created_by]                   VARCHAR (24)     NULL,
    [id]                           UNIQUEIDENTIFIER NOT NULL,
    [handler_component_id]         VARCHAR (24)     NULL,
    [creator_component_id]         VARCHAR (24)     NULL,
    [creator_display_script_id]    INT              NULL,
    [handler_display_script_id]    INT              NULL,
    [root_element]                 VARCHAR (64)     NULL,
    [file_extension]               VARCHAR (24)     NULL,
    [config_object]                VARCHAR (24)     NULL,
    [xml_schema]                   VARCHAR (255)    NULL,
    [last_updated]                 DATETIME         NOT NULL,
    [owner_id]                     INT              NOT NULL
);



