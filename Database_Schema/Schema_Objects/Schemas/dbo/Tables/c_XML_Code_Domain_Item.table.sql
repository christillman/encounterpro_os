CREATE TABLE [dbo].[c_XML_Code_Domain_Item] (
    [owner_id]                  INT              NOT NULL,
    [code_domain]               VARCHAR (40)     NOT NULL,
    [code_domain_item_id]       INT              IDENTITY (1, 1) NOT NULL,
    [code_version]              VARCHAR (40)     NULL,
    [code]                      VARCHAR (80)     NOT NULL,
    [code_description]          VARCHAR (80)     NULL,
    [created]                   DATETIME         NOT NULL,
    [created_by]                VARCHAR (24)     NOT NULL,
    [last_updated]              DATETIME         NOT NULL,
    [id]                        UNIQUEIDENTIFIER NOT NULL,
    [status]                    VARCHAR (12)     NOT NULL,
    [code_domain_item_owner_id] INT              NOT NULL
);



