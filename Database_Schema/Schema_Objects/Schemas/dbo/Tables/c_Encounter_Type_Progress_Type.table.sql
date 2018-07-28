CREATE TABLE [dbo].[c_Encounter_Type_Progress_Type] (
    [encounter_type]               VARCHAR (24) NOT NULL,
    [progress_type]                VARCHAR (24) NOT NULL,
    [display_flag]                 CHAR (1)     NULL,
    [progress_key_required_flag]   CHAR (1)     NULL,
    [progress_key_enumerated_flag] CHAR (1)     NULL,
    [progress_key_object]          VARCHAR (24) NULL,
    [sort_sequence]                SMALLINT     NULL
);

