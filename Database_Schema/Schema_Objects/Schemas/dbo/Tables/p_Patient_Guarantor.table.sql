CREATE TABLE [dbo].[p_Patient_Guarantor] (
    [cpr_id]                     VARCHAR (12)     NOT NULL,
    [guarantor_sequence]         INT              IDENTITY (1, 1) NOT NULL,
    [pm_guarantor_id]            VARCHAR (24)     NOT NULL,
    [guarantor_last_name]        VARCHAR (40)     NOT NULL,
    [guarantor_first_name]       VARCHAR (20)     NOT NULL,
    [guarantor_middle_name]      VARCHAR (20)     NOT NULL,
    [guarantor_name_suffix]      VARCHAR (12)     NOT NULL,
    [guarantor_name_prefix]      VARCHAR (12)     NOT NULL,
    [guarantor_degree]           VARCHAR (20)     NOT NULL,
    [guarantor_address_line_1]   VARCHAR (40)     NOT NULL,
    [guarantor_address_line_2]   VARCHAR (40)     NOT NULL,
    [guarantor_city]             VARCHAR (40)     NOT NULL,
    [guarantor_state]            VARCHAR (20)     NOT NULL,
    [guarantor_zip]              VARCHAR (12)     NOT NULL,
    [guarantor_country]          VARCHAR (20)     NOT NULL,
    [guarantor_phone_number]     VARCHAR (32)     NOT NULL,
    [guarantor_phone_number_alt] VARCHAR (32)     NOT NULL,
    [guarantor_date_of_birth]    DATETIME         NULL,
    [guarantor_relationship]     VARCHAR (24)     NOT NULL,
    [guarantor_ssn]              VARCHAR (12)     NOT NULL,
    [guarantor_priority]         VARCHAR (24)     NOT NULL,
    [created]                    DATETIME         NOT NULL,
    [created_by]                 VARCHAR (24)     NOT NULL,
    [modified]                   DATETIME         NULL,
    [modified_by]                VARCHAR (24)     NULL,
    [status]                     VARCHAR (12)     NOT NULL,
    [status_changed_date]        DATETIME         NULL,
    [status_changed_by]          VARCHAR (24)     NULL,
    [id]                         UNIQUEIDENTIFIER NOT NULL
);



