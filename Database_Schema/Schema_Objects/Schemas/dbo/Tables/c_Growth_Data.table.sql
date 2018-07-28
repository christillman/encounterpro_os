CREATE TABLE [dbo].[c_Growth_Data] (
    [measurement]   VARCHAR (12) NOT NULL,
    [sex]           CHAR (1)     NOT NULL,
    [age_months]    SMALLINT     NOT NULL,
    [percentile_5]  REAL         NULL,
    [percentile_10] REAL         NULL,
    [percentile_25] REAL         NULL,
    [percentile_50] REAL         NULL,
    [percentile_75] REAL         NULL,
    [percentile_90] REAL         NULL,
    [percentile_95] REAL         NULL
);



