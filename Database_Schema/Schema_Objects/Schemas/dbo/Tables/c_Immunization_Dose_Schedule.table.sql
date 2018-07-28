CREATE TABLE [dbo].[c_Immunization_Dose_Schedule] (
    [disease_id]                 INT           NOT NULL,
    [dose_schedule_sequence]     INT           IDENTITY (1, 1) NOT NULL,
    [dose_number]                INT           NOT NULL,
    [patient_age_range_id]       INT           NULL,
    [first_dose_age_range_id]    INT           NULL,
    [last_dose_age_range_id]     INT           NULL,
    [last_dose_interval_amount]  INT           NULL,
    [last_dose_interval_unit_id] VARCHAR (24)  NULL,
    [sort_sequence]              INT           NULL,
    [dose_text]                  VARCHAR (255) NULL
);



