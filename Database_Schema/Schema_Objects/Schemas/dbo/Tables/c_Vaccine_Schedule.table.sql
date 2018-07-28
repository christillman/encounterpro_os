CREATE TABLE [dbo].[c_Vaccine_Schedule] (
    [vaccine_id]        VARCHAR (24) NOT NULL,
    [schedule_sequence] SMALLINT     NOT NULL,
    [age]               REAL         NULL,
    [age_unit]          VARCHAR (8)  NULL,
    [warning_days]      SMALLINT     NULL
);



