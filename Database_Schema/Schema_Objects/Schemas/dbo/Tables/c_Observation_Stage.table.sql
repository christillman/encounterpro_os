CREATE TABLE [dbo].[c_Observation_Stage] (
    [observation_id]    VARCHAR (24) NOT NULL,
    [stage]             INT          NOT NULL,
    [stage_description] VARCHAR (32) NULL,
    [last_updated]      DATETIME     NULL,
    [updated_by]        VARCHAR (24) NULL
);



