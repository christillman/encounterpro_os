CREATE TABLE [dbo].[c_Observation_Result_Range] (
    [observation_id]        VARCHAR (24) NOT NULL,
    [result_sequence]       SMALLINT     NOT NULL,
    [result_range_sequence] INT          IDENTITY (1, 1) NOT NULL,
    [search_sequence]       INT          NOT NULL,
    [cpr_id]                VARCHAR (12) NULL,
    [ordered_by]            VARCHAR (24) NULL,
    [sex]                   CHAR (1)     NULL,
    [age_range_id]          INT          NULL,
    [unit_id]               VARCHAR (12) NOT NULL,
    [low_limit]             REAL         NULL,
    [low_abnormal]          REAL         NULL,
    [low_normal]            REAL         NULL,
    [high_normal]           REAL         NULL,
    [high_abnormal]         REAL         NULL,
    [high_limit]            REAL         NULL,
    [inclusive_flag]        CHAR (1)     NULL,
    [very_low_nature]       VARCHAR (8)  NULL,
    [low_nature]            VARCHAR (8)  NULL,
    [high_nature]           VARCHAR (8)  NULL,
    [very_high_nature]      VARCHAR (8)  NULL,
    [very_low_severity]     SMALLINT     NULL,
    [low_severity]          SMALLINT     NULL,
    [high_severity]         SMALLINT     NULL,
    [very_high_severity]    SMALLINT     NULL,
    [normal_range]          VARCHAR (40) NULL,
    [reference_material_id] INT          NULL,
    [abnormal_workplan_id]  INT          NULL
);



