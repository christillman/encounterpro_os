CREATE TABLE [dbo].[r_Efficacy_Data] (
    [clinicaleventid] UNIQUEIDENTIFIER NOT NULL,
    [eventdate]       DATETIME         NOT NULL,
    [owner_id]        INT              NOT NULL,
    [assessment_id]   VARCHAR (24)     NOT NULL,
    [treatment_type]  VARCHAR (24)     NOT NULL,
    [treatment_key]   VARCHAR (64)     NOT NULL,
    [effectiveness]   VARCHAR (24)     NOT NULL
);



