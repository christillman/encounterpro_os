CREATE TABLE [dbo].[u_Display_Script_Selection] (
    [display_script_selection_id] INT              IDENTITY (1, 1) NOT NULL,
    [display_script_id]           INT              NOT NULL,
    [context_object]              VARCHAR (24)     NULL,
    [object_key]                  VARCHAR (40)     NULL,
    [user_id]                     VARCHAR (24)     NULL,
    [sort_sequence]               INT              NULL,
    [owner_id]                    INT              NOT NULL,
    [last_updated]                DATETIME         NOT NULL,
    [id]                          UNIQUEIDENTIFIER NOT NULL,
    [status]                      VARCHAR (12)     NOT NULL
);



