CREATE TABLE [dbo].[c_Actor_Route_Purpose] (
    [actor_id]               INT              NOT NULL,
    [route_purpose_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [document_route]         VARCHAR (24)     NOT NULL,
    [purpose]                VARCHAR (40)     NOT NULL,
    [allow_flag]             CHAR (1)         NOT NULL,
    [current_flag]           VARCHAR (12)     NOT NULL,
    [created]                DATETIME         NOT NULL,
    [created_by]             VARCHAR (24)     NULL,
    [id]                     UNIQUEIDENTIFIER NOT NULL,
    [c_actor_id]             UNIQUEIDENTIFIER NULL
);



