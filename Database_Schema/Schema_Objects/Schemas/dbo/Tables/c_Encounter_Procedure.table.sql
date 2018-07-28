CREATE TABLE [dbo].[c_Encounter_Procedure] (
    [encounter_type] VARCHAR (12) NOT NULL,
    [new_flag]       CHAR (1)     NOT NULL,
    [procedure_id]   VARCHAR (24) NOT NULL,
    [description]    VARCHAR (80) NULL,
    [sort_sequence]  SMALLINT     NULL
);



