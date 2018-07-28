CREATE TABLE [dbo].[c_Location] (
    [location_domain] VARCHAR (12)     NOT NULL,
    [location]        VARCHAR (24)     NOT NULL,
    [description]     VARCHAR (40)     NULL,
    [sort_sequence]   SMALLINT         NULL,
    [diffuse_flag]    CHAR (1)         NULL,
    [status]          VARCHAR (12)     NULL,
    [id]              UNIQUEIDENTIFIER NOT NULL,
    [owner_id]        INT              NOT NULL
);



