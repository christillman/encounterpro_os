CREATE TABLE [dbo].[o_Service_Schedule_Attribute] (
    [user_id]                    VARCHAR (24)  NOT NULL,
    [service_sequence]           INT           NOT NULL,
    [service_attribute_sequence] INT           IDENTITY (1, 1) NOT NULL,
    [attribute]                  VARCHAR (64)  NOT NULL,
    [value]                      VARCHAR (255) NULL
);



