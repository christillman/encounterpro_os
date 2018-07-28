CREATE TABLE [dbo].[r_Assessment_Treatment_Efficacy] (
    [assessment_id]  VARCHAR (24) NOT NULL,
    [treatment_type] VARCHAR (24) NOT NULL,
    [treatment_key]  VARCHAR (64) NOT NULL,
    [rating]         NUMERIC (18) NULL
);

