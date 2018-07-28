CREATE TABLE [dbo].[c_Age_Range] (
    [age_range_id]       INT              IDENTITY (1, 1) NOT NULL,
    [age_range_category] VARCHAR (24)     NOT NULL,
    [description]        VARCHAR (40)     NULL,
    [age_from]           INT              NULL,
    [age_from_unit]      VARCHAR (24)     NULL,
    [age_to]             INT              NULL,
    [age_to_unit]        VARCHAR (24)     NULL,
    [sort_sequence]      SMALLINT         NULL,
    [owner_id]           INT              NOT NULL,
    [status]             VARCHAR (12)     NOT NULL,
    [last_updated]       DATETIME         NULL,
    [id]                 UNIQUEIDENTIFIER NULL
);



