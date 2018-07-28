CREATE TABLE [dbo].[c_Database_Script_Type] (
    [script_type]       VARCHAR (24) NOT NULL,
    [system_id]         VARCHAR (24) NOT NULL,
    [maintenance_mode]  VARCHAR (24) NOT NULL,
    [current_only_flag] BIT          NOT NULL,
    [maintenance_group] VARCHAR (24) NULL
);



