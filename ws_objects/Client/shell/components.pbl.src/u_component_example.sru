$PBExportHeader$u_component_example.sru
forward
global type u_component_example from nonvisualobject
end type
end forward

global type u_component_example from nonvisualobject
end type
global u_component_example u_component_example

type variables

// Simply declare u_component types here so they don't show up as unused. 
// This object is not meant to be used itself.
// They are instantiated as referenced from the database in c_Component_Type, 
// so may not have many other references in the app.

u_component_alert example_u_component_alert
u_component_attachment example_u_component_attachment
u_component_base_class example_u_component_base_class
u_component_billing example_u_component_billing
//u_component_chartpage example_u_component_chartpage
u_component_coding example_u_component_coding
u_component_config_object example_u_component_config_object
u_component_document example_u_component_document
u_component_document_receiver example_u_component_document_receiver
u_component_drug example_u_component_drug
//u_component_e_prescribing example_u_component_e_prescribing
u_component_epie_base example_u_component_epie_base
u_component_incoming example_u_component_incoming
u_component_message_creator example_u_component_message_creator
u_component_message_handler example_u_component_message_handler
u_component_message_stream example_u_component_message_stream
u_component_messageserver example_u_component_messageserver
u_component_nomenclature example_u_component_nomenclature
u_component_observation example_u_component_observation
u_component_outgoing example_u_component_outgoing
u_component_property example_u_component_property
u_component_report example_u_component_report
u_component_route example_u_component_route
u_component_schedule example_u_component_schedule
u_component_security example_u_component_security
u_component_send_report example_u_component_send_report
u_component_service example_u_component_service
u_component_service_db_maintenance example_u_component_service_db_maintenance
u_component_treatment example_u_component_treatment
u_component_wp_item_document example_u_component_wp_item_document
u_component_xml_handler example_u_component_xml_handler
end variables
on u_component_example.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_component_example.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

