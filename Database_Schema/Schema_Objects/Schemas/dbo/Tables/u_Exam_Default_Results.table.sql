CREATE TABLE [dbo].[u_Exam_Default_Results] (
    [exam_sequence]     INT          NOT NULL,
    [branch_id]         INT          NOT NULL,
    [result_sequence]   SMALLINT     NOT NULL,
    [location]          VARCHAR (24) NOT NULL,
    [user_id]           VARCHAR (24) NOT NULL,
    [observation_id]    VARCHAR (24) NOT NULL,
    [result_value]      VARCHAR (40) NULL,
    [result_unit]       VARCHAR (24) NULL,
    [result_flag]       CHAR (1)     NOT NULL,
    [long_result_value] TEXT         NULL,
    [result]            VARCHAR (80) NULL,
    [result_type]       VARCHAR (12) NULL,
    [abnormal_flag]     CHAR (1)     NULL,
    [severity]          SMALLINT     NULL
);

