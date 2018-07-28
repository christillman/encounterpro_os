CREATE TABLE [dbo].[c_Location_Domain] (
    [location_domain] VARCHAR (12)     NOT NULL,
    [description]     VARCHAR (40)     NULL,
    [id]              UNIQUEIDENTIFIER NOT NULL,
    [owner_id]        INT              NOT NULL,
    [last_updated]    DATETIME         NOT NULL,
    [status]          VARCHAR (12)     NOT NULL
);



