CREATE TABLE [dbo].[c_component_interface_object_log] (
    [interfaceserviceid]                INT              NOT NULL,
    [object_sequence]                   INT              IDENTITY (1, 1) NOT NULL,
    [cpr_id]                            VARCHAR (12)     NOT NULL,
    [context_object]                    VARCHAR (24)     NOT NULL,
    [object_key]                        INT              NOT NULL,
    [document_patient_workplan_item_id] INT              NULL,
    [object_status]                     VARCHAR (12)     NOT NULL,
    [id]                                UNIQUEIDENTIFIER NOT NULL
);



