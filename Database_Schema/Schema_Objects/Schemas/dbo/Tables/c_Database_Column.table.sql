CREATE TABLE [dbo].[c_Database_Column] (
    [tablename]               VARCHAR (64) NOT NULL,
    [columnname]              VARCHAR (64) NOT NULL,
    [column_sequence]         INT          NOT NULL,
    [column_datatype]         VARCHAR (32) NOT NULL,
    [column_length]           INT          NOT NULL,
    [column_identity]         BIT          NOT NULL,
    [column_nullable]         BIT          NOT NULL,
    [column_definition]       VARCHAR (64) NOT NULL,
    [default_constraint]      BIT          NOT NULL,
    [default_constraint_name] VARCHAR (64) NULL,
    [default_constraint_text] VARCHAR (64) NULL,
    [modification_level]      INT          NOT NULL,
    [last_updated]            DATETIME     NOT NULL
);



