﻿CREATE TABLE [dbo].[p_Attachment] (
    [attachment_id]            INT              IDENTITY (1, 1) NOT NULL,
    [cpr_id]                   VARCHAR (12)     NULL,
    [encounter_id]             INT              NULL,
    [problem_id]               INT              NULL,
    [treatment_id]             INT              NULL,
    [observation_sequence]     INT              NULL,
    [attachment_type]          VARCHAR (24)     NULL,
    [attachment_tag]           VARCHAR (80)     NULL,
    [attachment_file_path]     VARCHAR (128)    NULL,
    [attachment_file]          VARCHAR (128)    NULL,
    [extension]                VARCHAR (24)     NULL,
    [attachment_text]          TEXT             NULL,
    [attachment_image]         IMAGE            NULL,
    [storage_flag]             CHAR (1)         NULL,
    [attachment_date]          DATETIME         NULL,
    [attachment_folder]        VARCHAR (40)     NULL,
    [box_id]                   INT              NULL,
    [item_id]                  INT              NULL,
    [attached_by]              VARCHAR (24)     NULL,
    [created]                  DATETIME         NULL,
    [created_by]               VARCHAR (24)     NULL,
    [status]                   VARCHAR (12)     NULL,
    [id]                       UNIQUEIDENTIFIER NOT NULL,
    [context_object]           VARCHAR (24)     NULL,
    [object_key]               INT              NULL,
    [default_grant]            BIT              NOT NULL,
    [interpreted]              BIT              NOT NULL,
    [owner_id]                 INT              NULL,
    [interfaceserviceid]       INT              NULL,
    [transportsequence]        INT              NULL,
    [patient_workplan_item_id] INT              NULL
) TEXTIMAGE_ON [ATTACHMENTS];


