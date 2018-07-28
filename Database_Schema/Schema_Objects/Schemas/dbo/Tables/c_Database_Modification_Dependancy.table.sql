CREATE TABLE [dbo].[c_Database_Modification_Dependancy] (
    [system_id]                       VARCHAR (24) NOT NULL,
    [major_release]                   INT          NOT NULL,
    [database_version]                VARCHAR (4)  NOT NULL,
    [modification_level]              INT          NOT NULL,
    [version]                         VARCHAR (12) NOT NULL,
    [min_database_modification_level] INT          NOT NULL,
    [max_database_modification_level] INT          NULL
);



