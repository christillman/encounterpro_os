CREATE TABLE [dbo].[c_Maintenance_Protocol_Item] (
    [maintenance_rule_id]    INT          NOT NULL,
    [protocol_sequence]      INT          NOT NULL,
    [protocol_item_sequence] INT          IDENTITY (1, 1) NOT NULL,
    [description]            VARCHAR (80) NOT NULL,
    [context_object]         VARCHAR (24) NOT NULL,
    [assessment_type]        VARCHAR (24) NULL,
    [assessment_id]          VARCHAR (24) NULL,
    [treatment_type]         VARCHAR (24) NULL,
    [treatment_key]          VARCHAR (40) NULL,
    [created]                DATETIME     NOT NULL,
    [created_by]             VARCHAR (24) NOT NULL
);



