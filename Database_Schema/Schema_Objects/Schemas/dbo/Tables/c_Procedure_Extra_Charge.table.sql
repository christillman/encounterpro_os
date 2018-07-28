CREATE TABLE [dbo].[c_Procedure_Extra_Charge] (
    [procedure_id]             VARCHAR (24) NOT NULL,
    [extra_procedure_sequence] INT          IDENTITY (1, 1) NOT NULL,
    [extra_procedure_id]       VARCHAR (24) NOT NULL,
    [order_flag]               VARCHAR (12) NOT NULL,
    [sort_sequence]            INT          NULL
);



