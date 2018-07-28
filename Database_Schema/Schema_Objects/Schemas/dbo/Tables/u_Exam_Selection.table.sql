CREATE TABLE [dbo].[u_Exam_Selection] (
    [exam_sequence]           INT          NOT NULL,
    [exam_selection_sequence] INT          IDENTITY (1, 1) NOT NULL,
    [treatment_type]          VARCHAR (24) NOT NULL,
    [user_id]                 VARCHAR (24) NOT NULL,
    [age_range_id]            INT          NULL,
    [sex]                     CHAR (1)     NULL,
    [race]                    VARCHAR (12) NULL,
    [sort_sequence]           SMALLINT     NULL
);

