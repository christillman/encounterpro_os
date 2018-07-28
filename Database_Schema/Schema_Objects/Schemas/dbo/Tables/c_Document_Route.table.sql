CREATE TABLE [dbo].[c_Document_Route] (
    [document_route]      VARCHAR (24)     NOT NULL,
    [sent_status]         VARCHAR (12)     NOT NULL,
    [status]              VARCHAR (12)     NOT NULL,
    [owner_id]            INT              NOT NULL,
    [last_updated]        DATETIME         NOT NULL,
    [id]                  UNIQUEIDENTIFIER NOT NULL,
    [send_via_addressee]  INT              NULL,
    [document_type]       VARCHAR (255)    NULL,
    [communication_type]  VARCHAR (24)     NULL,
    [document_format]     VARCHAR (24)     NOT NULL,
    [sender_id_key]       VARCHAR (40)     NULL,
    [receiver_id_key]     VARCHAR (40)     NULL,
    [sending_status]      VARCHAR (12)     DEFAULT ('Sending') NOT NULL,
    [send_from]           VARCHAR (12)     DEFAULT ('Server') NOT NULL,
    [sender_component_id] VARCHAR (24)     NULL
);



