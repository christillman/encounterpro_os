CREATE TABLE [dbo].[c_component_interface_route_property] (
    [subscriber_owner_id] INT              NOT NULL,
    [interfaceserviceid]  INT              NOT NULL,
    [transportsequence]   INT              NOT NULL,
    [property_sequence]   INT              IDENTITY (1, 1) NOT NULL,
    [property]            VARCHAR (80)     NULL,
    [value]               VARCHAR (80)     NULL,
    [id]                  UNIQUEIDENTIFIER NOT NULL,
    [last_updated]        DATETIME         NULL
);



