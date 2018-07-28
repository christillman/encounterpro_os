CREATE TABLE [dbo].[c_Observation_Result_Set_Item] (
    [result_set_id]      INT          NOT NULL,
    [result_sequence]    SMALLINT     NOT NULL,
    [result_type]        VARCHAR (12) NULL,
    [result_unit]        VARCHAR (12) NULL,
    [result]             VARCHAR (80) NULL,
    [result_amount_flag] VARCHAR (1)  NULL,
    [abnormal_flag]      VARCHAR (1)  NULL,
    [sort_sequence]      SMALLINT     NULL,
    [severity]           SMALLINT     NULL
);



