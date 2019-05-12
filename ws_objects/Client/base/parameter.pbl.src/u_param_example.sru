$PBExportHeader$u_param_example.sru
forward
global type u_param_example from nonvisualobject
end type
end forward

global type u_param_example from nonvisualobject
end type
global u_param_example u_param_example

type variables

// Simply declare u_param types here so they don't show up as unused. 
// This object is not meant to be used itself.
// They are instantiated as referenced from the database in c_Component_Param, 
// so may not have many other references in the app.

u_param_assessment example_u_param_assessment
u_param_color example_u_param_color
u_param_component example_u_param_component
u_param_config_object_datafile example_u_param_config_object_datafile
u_param_datawindow_syntax example_u_param_datawindow_syntax
u_param_date example_u_param_date
u_param_date_range example_u_param_date_range
u_param_display_script example_u_param_display_script
u_param_document_recipient_route example_u_param_document_recipient_route
u_param_drug example_u_param_drug
u_param_enum example_u_param_enum
u_param_external_source example_u_param_external_source
u_param_menu example_u_param_menu
u_param_multiline example_u_param_multiline
u_param_observation_location_perform example_u_param_observation_location_perform
u_param_observation_multiple example_u_param_observation_multiple
u_param_observation_result example_u_param_observation_result
u_param_observation_single example_u_param_observation_single
u_param_patient example_u_param_patient
u_param_patient_material example_u_param_patient_material
u_param_popup example_u_param_popup
u_param_popup_single example_u_param_popup_single
u_param_procedure example_u_param_procedure
u_param_property example_u_param_property
u_param_report example_u_param_report
u_param_script example_u_param_script
u_param_string example_u_param_string
// u_param_string_single example_u_param_string_single
u_param_user example_u_param_user
u_param_workplan example_u_param_workplan
u_param_xml_creator_script example_u_param_xml_creator_script
u_param_yesno example_u_param_yesno

end variables
on u_param_example.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_param_example.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

