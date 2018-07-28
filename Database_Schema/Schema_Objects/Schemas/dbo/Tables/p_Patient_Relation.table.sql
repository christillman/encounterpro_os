CREATE TABLE [dbo].[p_Patient_Relation] (
    [cpr_id]                      VARCHAR (12) NOT NULL,
    [relation_sequence]           INT          IDENTITY (1, 1) NOT NULL,
    [relation_cpr_id]             VARCHAR (12) NOT NULL,
    [relationship]                VARCHAR (24) NOT NULL,
    [maternal_sibling_flag]       CHAR (1)     NOT NULL,
    [paternal_sibling_flag]       CHAR (1)     NOT NULL,
    [parent_flag]                 CHAR (1)     NOT NULL,
    [guardian_flag]               CHAR (1)     NOT NULL,
    [guarantor_flag]              CHAR (1)     NOT NULL,
    [payor_flag]                  CHAR (1)     NOT NULL,
    [created]                     DATETIME     NOT NULL,
    [created_by]                  VARCHAR (24) NOT NULL,
    [modified]                    DATETIME     NULL,
    [modified_by]                 VARCHAR (24) NULL,
    [status]                      VARCHAR (8)  NOT NULL,
    [status_date]                 DATETIME     NOT NULL,
    [primary_decision_maker_flag] CHAR (1)     NOT NULL,
    [relation_order]              INT          NULL,
    [attachment_id]               INT          NULL
);



