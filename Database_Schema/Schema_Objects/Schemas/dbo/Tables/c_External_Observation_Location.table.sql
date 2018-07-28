CREATE TABLE [dbo].[c_External_Observation_Location] (
    [external_source]               VARCHAR (24) NOT NULL,
    [external_observation]          VARCHAR (64) NOT NULL,
    [external_observation_location] VARCHAR (64) NOT NULL,
    [result_type]                   VARCHAR (12) NOT NULL,
    [description]                   VARCHAR (80) NULL,
    [location]                      VARCHAR (24) NULL
);

