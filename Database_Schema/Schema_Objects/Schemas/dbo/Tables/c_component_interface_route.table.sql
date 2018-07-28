CREATE TABLE [dbo].[c_component_interface_route] (
    [ownerid]               INT              NOT NULL,
    [subscriber_owner_id]   INT              NOT NULL,
    [interfaceservicetype]  VARCHAR (80)     NOT NULL,
    [interfaceserviceid]    INT              NOT NULL,
    [interfacedescription]  VARCHAR (80)     NOT NULL,
    [transportsequence]     INT              NOT NULL,
    [transportdescription]  VARCHAR (80)     NOT NULL,
    [commcomponent]         VARCHAR (24)     NOT NULL,
    [documenttype]          VARCHAR (255)    NULL,
    [direction]             VARCHAR (1)      NOT NULL,
    [epie_transform]        VARCHAR (1)      NOT NULL,
    [handlerclass]          VARCHAR (128)    NULL,
    [handlerassembly]       VARCHAR (255)    NULL,
    [always]                INT              NULL,
    [start]                 DATETIME         NULL,
    [freq]                  FLOAT            NULL,
    [status]                VARCHAR (12)     NOT NULL,
    [lastreceived]          DATETIME         NULL,
    [lastrun]               DATETIME         NULL,
    [id]                    UNIQUEIDENTIFIER NOT NULL,
    [last_updated]          DATETIME         NULL,
    [purpose]               VARCHAR (40)     NULL,
    [document_route_suffix] VARCHAR (20)     NULL
);



