$PBExportHeader$u_component_document_growth_chart.sru
forward
global type u_component_document_growth_chart from u_component_document
end type
end forward

global type u_component_document_growth_chart from u_component_document
end type
global u_component_document_growth_chart u_component_document_growth_chart

type variables

end variables

forward prototypes
protected function integer xx_do_source ()
end prototypes

protected function integer xx_do_source ();w_window_base lw_window
str_growth_chart_settings lstr_growth_chart_settings
string ls_return
boolean lb_well_data_only
boolean lb_suppress_display
string ls_growth_chart
string ls_growth_ages
string ls_graph_infant_child
integer li_sts
blob lbl_image_file

get_attribute("well_data_only", lb_well_data_only, true)
if lb_well_data_only then
	lstr_growth_chart_settings.visit_types = "Well"
else
	lstr_growth_chart_settings.visit_types = "All"
end if

get_attribute("show_user_interface", lstr_growth_chart_settings.show_user_interface, false)
get_attribute("return_file_type", lstr_growth_chart_settings.return_file_type)
get_attribute("width", lstr_growth_chart_settings.image_width)
get_attribute("height", lstr_growth_chart_settings.image_height)


get_attribute("suppress_display", lb_suppress_display, false)
if lb_suppress_display then
	lstr_growth_chart_settings.ok_button_title = "Finished"
else
	lstr_growth_chart_settings.ok_button_title = "OK"
end if

get_attribute("background_color", lstr_growth_chart_settings.background_color)
if isnull(lstr_growth_chart_settings.background_color) then
	lstr_growth_chart_settings.background_color = color_white
end if

// This attribute is looked at only for backward compatibility.  With the new attributes the age is included in the chart selection
ls_growth_ages = get_attribute("growth_ages")
CHOOSE CASE lower(ls_growth_ages)
	CASE "infants", "infant"
		ls_graph_infant_child = "Infant"
	CASE "children", "child"
		ls_graph_infant_child = "Child"
	CASE ELSE
		If daysafter(current_patient.date_of_birth,today()) < 365 * 3 then 
			ls_graph_infant_child = "Infant"
		Else
			ls_graph_infant_child = "Child"
		End If
END CHOOSE

ls_growth_chart = get_attribute("growth_chart")
CHOOSE CASE lower(ls_growth_chart)
	CASE "weight vs age"  // obsolete do not use
		lstr_growth_chart_settings.graph_infant_child = ls_graph_infant_child
		lstr_growth_chart_settings.graph_type = "Weight"
	CASE "length vs age"  // obsolete do not use
		lstr_growth_chart_settings.graph_infant_child = ls_graph_infant_child
		lstr_growth_chart_settings.graph_type = "Height"
	CASE "length vs weight"  // obsolete do not use
		lstr_growth_chart_settings.graph_infant_child = ls_graph_infant_child
		lstr_growth_chart_settings.graph_type = "WEIGHTVSHEIGHT"
	CASE "bmi vs age"  // obsolete do not use
		lstr_growth_chart_settings.graph_infant_child = "Child"
		lstr_growth_chart_settings.graph_type = "BMI"
	CASE "head circumference vs age"  // obsolete do not use
		lstr_growth_chart_settings.graph_infant_child = "Infant"
		lstr_growth_chart_settings.graph_type = "HC"
	CASE "infant weight vs age"
		lstr_growth_chart_settings.graph_infant_child = "Infant"
		lstr_growth_chart_settings.graph_type = "Weight"
	CASE "infant length vs age"
		lstr_growth_chart_settings.graph_infant_child = "Infant"
		lstr_growth_chart_settings.graph_type = "Height"
	CASE "infant length vs weight"
		lstr_growth_chart_settings.graph_infant_child = "Infant"
		lstr_growth_chart_settings.graph_type = "WEIGHTVSHEIGHT"
	CASE "infant head circumference vs age"
		lstr_growth_chart_settings.graph_infant_child = "Infant"
		lstr_growth_chart_settings.graph_type = "HC"
	CASE "child weight vs age"
		lstr_growth_chart_settings.graph_infant_child = "Child"
		lstr_growth_chart_settings.graph_type = "Weight"
	CASE "child length vs age"
		lstr_growth_chart_settings.graph_infant_child = "Child"
		lstr_growth_chart_settings.graph_type = "Height"
	CASE "child length vs weight"
		lstr_growth_chart_settings.graph_infant_child = "Child"
		lstr_growth_chart_settings.graph_type = "WEIGHTVSHEIGHT"
	CASE "child bmi vs age"
		lstr_growth_chart_settings.graph_infant_child = "Child"
		lstr_growth_chart_settings.graph_type = "BMI"
	CASE ELSE
		lstr_growth_chart_settings.graph_infant_child = ls_graph_infant_child
		lstr_growth_chart_settings.graph_type = "Weight"
END CHOOSE

lstr_growth_chart_settings.graph_unit_preference = upper(get_attribute("unit_preference"))
if isnull(lstr_growth_chart_settings.graph_unit_preference) then
	lstr_growth_chart_settings.graph_unit_preference = "METRIC"
end if

lstr_growth_chart_settings.legend = upper(get_attribute("legend_placement"))
if isnull(lstr_growth_chart_settings.legend) then
	lstr_growth_chart_settings.legend = "None"
end if

openwithparm(lw_window, lstr_growth_chart_settings, "w_growth_charts")
lstr_growth_chart_settings = message.powerobjectparm

// User pressed "Cancel"
if isnull(lstr_growth_chart_settings.return_file_path) then return 0  

// Error conditions
if lstr_growth_chart_settings.return_file_path = "-1" then return -1
if not fileexists(lstr_growth_chart_settings.return_file_path) then return -1

// Read graph file
li_sts = log.file_read(lstr_growth_chart_settings.return_file_path, lbl_image_file)
if li_sts <= 0 then 
	log.log(this, "u_component_document_growth_chart.xx_do_source.0121", "Error reading image file", 4)
	return -1
end if

// Add returned graph to document list
observation_count = 1
observations[1].result_count = 0
observations[1].attachment_list.attachment_count = 1
observations[1].attachment_list.attachments[1].attachment_type = "FILE"
observations[1].attachment_list.attachments[1].extension = lstr_growth_chart_settings.return_file_type
observations[1].attachment_list.attachments[1].attachment_comment_title = lstr_growth_chart_settings.graph_title
observations[1].attachment_list.attachments[1].attachment = lbl_image_file

observations[1].attachment_list.attachments[1].attached_by_user_id = current_user.user_id

return 1

end function

on u_component_document_growth_chart.create
call super::create
end on

on u_component_document_growth_chart.destroy
call super::destroy
end on

