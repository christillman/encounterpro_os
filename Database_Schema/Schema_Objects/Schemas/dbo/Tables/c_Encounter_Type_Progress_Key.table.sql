CREATE TABLE [dbo].[c_Encounter_Type_Progress_Key] (
    [encounter_type] VARCHAR (24) NOT NULL,
    [progress_type]  VARCHAR (24) NOT NULL,
    [progress_key]   VARCHAR (40) NOT NULL,
    [sort_sequence]  SMALLINT     NULL
);

