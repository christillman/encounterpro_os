CREATE TABLE [dbo].[p_Letter] (
    [cpr_id]        VARCHAR (12)     NOT NULL,
    [encounter_id]  INT              NOT NULL,
    [letter_id]     INT              IDENTITY (1, 1) NOT NULL,
    [letter_type]   VARCHAR (24)     NULL,
    [description]   VARCHAR (80)     NULL,
    [attachment_id] INT              NULL,
    [created]       DATETIME         NULL,
    [created_by]    VARCHAR (24)     NULL,
    [id]            UNIQUEIDENTIFIER NOT NULL
);



