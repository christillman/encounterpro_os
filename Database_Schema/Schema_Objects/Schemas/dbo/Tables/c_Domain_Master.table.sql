CREATE TABLE [dbo].[c_Domain_Master] (
    [domain_id]          VARCHAR (24)     NOT NULL,
    [name]               VARCHAR (80)     NULL,
    [description]        VARCHAR (210)    NOT NULL,
    [domain_scope]       VARCHAR (24)     NULL,
    [domain_table]       VARCHAR (50)     NULL,
    [domain_attribute]   VARCHAR (80)     NULL,
    [created]            DATETIME         NOT NULL,
    [created_by]         VARCHAR (24)     NOT NULL,
    [id]                 UNIQUEIDENTIFIER NOT NULL,
    [last_updated]       DATETIME         NOT NULL,
    [epro_object]        VARCHAR (24)     NULL,
    [map_cardinality]    VARCHAR (12)     DEFAULT ('ManyToOne') NOT NULL,
    [missing_map_action] VARCHAR (24)     NULL,
    [param_class]        VARCHAR (40)     NULL,
    [param_query]        TEXT             NULL,
    [item_owner]         VARCHAR (12)     DEFAULT ('Customer') NOT NULL,
    [equivalence_flag]   CHAR (1)         DEFAULT ('N') NOT NULL
);



