CREATE TABLE [dbo].[c_Administration_Frequency] (
    [administer_frequency] VARCHAR (12)     NOT NULL,
    [description]          VARCHAR (80)     NULL,
    [frequency]            SMALLINT         NULL,
    [sort_sequence]        SMALLINT         NULL,
    [status]               VARCHAR (8)      NOT NULL,
    [id]                   UNIQUEIDENTIFIER NOT NULL
);



