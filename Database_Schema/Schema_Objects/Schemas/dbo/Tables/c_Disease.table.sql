CREATE TABLE [dbo].[c_Disease] (
    [disease_id]               INT              NOT NULL,
    [description]              VARCHAR (80)     NULL,
    [display_flag]             CHAR (1)         NULL,
    [no_vaccine_after_disease] CHAR (1)         NULL,
    [sort_sequence]            SMALLINT         NULL,
    [status]                   VARCHAR (12)     NULL,
    [id]                       UNIQUEIDENTIFIER NOT NULL,
    [last_updated]             DATETIME         NOT NULL,
    [owner_id]                 INT              NOT NULL
);



