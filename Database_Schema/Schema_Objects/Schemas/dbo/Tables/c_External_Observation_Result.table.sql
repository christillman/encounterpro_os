CREATE TABLE [dbo].[c_External_Observation_Result] (
    [external_source]                      VARCHAR (24) NOT NULL,
    [external_observation]                 VARCHAR (64) NOT NULL,
    [external_observation_result]          VARCHAR (64) NOT NULL,
    [result_type]                          VARCHAR (12) NOT NULL,
    [description]                          VARCHAR (80) NULL,
    [result_sequence]                      SMALLINT     NULL,
    [result_unit]                          VARCHAR (24) NULL,
    [external_observation_result_sequence] INT          IDENTITY (1, 1) NOT NULL,
    [observation_id]                       VARCHAR (24) NULL
);

