CREATE TABLE [dbo].[o_Event_Component_Trigger] (
    [event]              VARCHAR (24) NOT NULL,
    [component_sequence] SMALLINT     NOT NULL,
    [component_type]     VARCHAR (24) NULL,
    [component]          VARCHAR (24) NULL,
    [component_id]       VARCHAR (24) NULL,
    [trigger_status]     VARCHAR (12) NULL
);



