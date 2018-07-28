CREATE TABLE [dbo].[p_Observation_Location] (
    [cpr_id]                        VARCHAR (12)     NOT NULL,
    [observation_sequence]          INT              NOT NULL,
    [observation_location_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [observation_id]                VARCHAR (24)     NOT NULL,
    [collect_perform_flag]          CHAR (1)         NULL,
    [location]                      VARCHAR (24)     NOT NULL,
    [treatment_id]                  INT              NULL,
    [encounter_id]                  INT              NULL,
    [attachment_id]                 INT              NULL,
    [created]                       DATETIME         NULL,
    [created_by]                    VARCHAR (24)     NOT NULL,
    [id]                            UNIQUEIDENTIFIER NOT NULL
);

