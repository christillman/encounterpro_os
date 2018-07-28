CREATE TABLE [dbo].[c_Message_Definition] (
    [message_type]         VARCHAR (24)  NOT NULL,
    [description]          VARCHAR (80)  NULL,
    [handler_component_id] VARCHAR (24)  NULL,
    [creator_component_id] VARCHAR (24)  NULL,
    [template_file]        VARCHAR (255) NULL
);



