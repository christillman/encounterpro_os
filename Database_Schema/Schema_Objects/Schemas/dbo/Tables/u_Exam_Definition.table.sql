CREATE TABLE [dbo].[u_Exam_Definition] (
    [root_observation_id] VARCHAR (24) NOT NULL,
    [exam_sequence]       INT          IDENTITY (1, 1) NOT NULL,
    [description]         VARCHAR (40) NULL,
    [default_flag]        CHAR (1)     NULL
);

