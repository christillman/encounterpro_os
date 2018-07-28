CREATE TABLE [dbo].[c_Drug_Instruction] (
    [instruction_id]          VARCHAR (24) NOT NULL,
    [drug_id]                 VARCHAR (24) NULL,
    [package_id]              VARCHAR (24) NULL,
    [administration_sequence] INT          NULL,
    [default_flag]            CHAR (1)     NOT NULL,
    [instruction]             TEXT         NULL,
    [instruction_for]         CHAR (1)     NULL
);



