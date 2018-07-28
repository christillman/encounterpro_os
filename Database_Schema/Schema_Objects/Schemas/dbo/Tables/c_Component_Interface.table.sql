CREATE TABLE [dbo].[c_Component_Interface] (
    [subscriber_owner_id]  INT              NOT NULL,
    [interfaceServiceId]   INT              NOT NULL,
    [owner_id]             INT              NOT NULL,
    [interfaceServiceType] VARCHAR (80)     NOT NULL,
    [sortSequence]         INT              NOT NULL,
    [description]          VARCHAR (50)     NOT NULL,
    [document_route]       VARCHAR (24)     NULL,
    [receive_flag]         CHAR (1)         NOT NULL,
    [send_flag]            CHAR (1)         NOT NULL,
    [serviceState]         VARCHAR (20)     NOT NULL,
    [status]               VARCHAR (12)     NOT NULL,
    [created]              DATETIME         NOT NULL,
    [id]                   UNIQUEIDENTIFIER NOT NULL,
    [last_updated]         DATETIME         NOT NULL
);



