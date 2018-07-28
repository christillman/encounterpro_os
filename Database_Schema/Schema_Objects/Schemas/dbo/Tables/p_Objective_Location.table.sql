CREATE TABLE [dbo].[p_Objective_Location] (
    [cpr_id]                        VARCHAR (12) NOT NULL,
    [treatment_id]                  INT          NOT NULL,
    [observation_id]                VARCHAR (24) NOT NULL,
    [observation_location_sequence] INT          IDENTITY (1, 1) NOT NULL,
    [collect_perform_flag]          CHAR (1)     NULL,
    [location]                      VARCHAR (24) NOT NULL,
    [encounter_id]                  INT          NOT NULL,
    [attachment_id]                 INT          NULL,
    [created]                       DATETIME     NULL,
    [created_by]                    VARCHAR (24) NOT NULL
);



