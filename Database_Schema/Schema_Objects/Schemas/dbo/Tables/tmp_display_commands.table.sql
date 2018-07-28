CREATE TABLE [dbo].[tmp_display_commands] (
    [command_id]      INT           IDENTITY (1, 1) NOT NULL,
    [context_object]  VARCHAR (24)  NULL,
    [display_command] VARCHAR (255) NULL,
    [command]         VARCHAR (255) NULL,
    [arguments]       VARCHAR (255) NULL,
    [description]     VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([command_id] ASC) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);



