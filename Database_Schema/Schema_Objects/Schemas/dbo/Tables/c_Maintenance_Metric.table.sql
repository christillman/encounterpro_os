CREATE TABLE [dbo].[c_Maintenance_Metric] (
    [maintenance_rule_id] INT          NOT NULL,
    [metric_sequence]     INT          IDENTITY (1, 1) NOT NULL,
    [title]               VARCHAR (40) NOT NULL,
    [description]         VARCHAR (80) NOT NULL,
    [observation_id]      VARCHAR (24) NOT NULL,
    [result_sequence]     SMALLINT     NULL,
    [interval]            INT          NULL,
    [interval_unit]       VARCHAR (24) NULL,
    [created]             DATETIME     NOT NULL,
    [created_by]          VARCHAR (24) NOT NULL
);



