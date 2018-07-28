CREATE TABLE [dbo].[c_Immunization_Schedule] (
    [disease_id]        INT      NOT NULL,
    [schedule_sequence] SMALLINT NOT NULL,
    [age]               DATETIME NULL,
    [warning_days]      SMALLINT NULL
);



