CREATE TABLE [dbo].[p_Material_Used] (
    [cpr_id]                 VARCHAR (12) NOT NULL,
    [encounter_id]           INT          NOT NULL,
    [treatment_sequence]     SMALLINT     NOT NULL,
    [material_id]            VARCHAR (24) NOT NULL,
    [material_item_sequence] SMALLINT     NOT NULL,
    [description]            VARCHAR (80) NULL,
    [attachment_id]          INT          NULL,
    [created]                DATETIME     NULL,
    [created_by]             VARCHAR (24) NULL
);



