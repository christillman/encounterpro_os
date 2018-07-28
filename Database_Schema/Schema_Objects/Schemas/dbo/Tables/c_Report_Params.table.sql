CREATE TABLE [dbo].[c_Report_Params] (
    [report_id]         VARCHAR (24) NOT NULL,
    [param_sequence]    SMALLINT     NOT NULL,
    [param_class]       VARCHAR (40) NOT NULL,
    [param_title]       VARCHAR (80) NULL,
    [token1]            VARCHAR (40) NULL,
    [token2]            VARCHAR (40) NULL,
    [token3]            VARCHAR (40) NULL,
    [token4]            VARCHAR (40) NULL,
    [initial1]          VARCHAR (40) NULL,
    [initial2]          VARCHAR (40) NULL,
    [initial3]          VARCHAR (40) NULL,
    [initial4]          VARCHAR (40) NULL,
    [required_flag]     CHAR (1)     NULL,
    [config_or_runtime] CHAR (1)     NULL,
    [helptext]          TEXT         NULL,
    [query]             TEXT         NULL
);



