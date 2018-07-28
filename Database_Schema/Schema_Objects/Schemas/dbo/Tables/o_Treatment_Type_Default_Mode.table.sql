CREATE TABLE [dbo].[o_Treatment_Type_Default_Mode] (
    [treatment_type] VARCHAR (24) NOT NULL,
    [treatment_key]  VARCHAR (40) NOT NULL,
    [office_id]      CHAR (4)     NOT NULL,
    [treatment_mode] VARCHAR (24) NOT NULL,
    [created]        DATETIME     NOT NULL,
    [created_by]     VARCHAR (24) NOT NULL
);

