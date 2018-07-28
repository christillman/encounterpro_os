CREATE TABLE [dbo].[c_Consultant] (
    [specialty_id]  VARCHAR (24)     NOT NULL,
    [consultant_id] VARCHAR (24)     NOT NULL,
    [description]   VARCHAR (80)     NULL,
    [first_name]    VARCHAR (20)     NULL,
    [middle_name]   VARCHAR (20)     NULL,
    [last_name]     VARCHAR (40)     NULL,
    [degree]        VARCHAR (24)     NULL,
    [name_prefix]   VARCHAR (12)     NULL,
    [name_suffix]   VARCHAR (12)     NULL,
    [address1]      VARCHAR (40)     NULL,
    [address2]      VARCHAR (40)     NULL,
    [city]          VARCHAR (40)     NULL,
    [state]         VARCHAR (20)     NULL,
    [zip]           VARCHAR (12)     NULL,
    [phone]         VARCHAR (32)     NULL,
    [phone2]        VARCHAR (32)     NULL,
    [fax]           VARCHAR (32)     NULL,
    [contact]       VARCHAR (40)     NULL,
    [email]         VARCHAR (64)     NULL,
    [sort_sequence] SMALLINT         NULL,
    [id]            UNIQUEIDENTIFIER NOT NULL,
    [owner_id]      INT              NULL
);



