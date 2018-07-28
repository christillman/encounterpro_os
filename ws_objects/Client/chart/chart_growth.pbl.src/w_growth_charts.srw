$PBExportHeader$w_growth_charts.srw
forward
global type w_growth_charts from w_window_base
end type
type cb_send_to from commandbutton within w_growth_charts
end type
type st_infant_title from statictext within w_growth_charts
end type
type st_visits_title_1 from statictext within w_growth_charts
end type
type cb_unit_preference from commandbutton within w_growth_charts
end type
type cb_ok from commandbutton within w_growth_charts
end type
type st_infant_weight from statictext within w_growth_charts
end type
type st_child_weight from statictext within w_growth_charts
end type
type st_child_title from statictext within w_growth_charts
end type
type st_infant_height from statictext within w_growth_charts
end type
type st_child_height from statictext within w_growth_charts
end type
type st_infant_hgtwgt from statictext within w_growth_charts
end type
type st_child_hgtwgt from statictext within w_growth_charts
end type
type st_infant_hc from statictext within w_growth_charts
end type
type st_child_bmi from statictext within w_growth_charts
end type
type st_chart_type from statictext within w_growth_charts
end type
type st_well_visits from statictext within w_growth_charts
end type
type st_all_visits from statictext within w_growth_charts
end type
type st_visits_title_2 from statictext within w_growth_charts
end type
type st_unit_preference_title from statictext within w_growth_charts
end type
type st_legend_title from statictext within w_growth_charts
end type
type rb_legend_bottom from radiobutton within w_growth_charts
end type
type rb_legend_right from radiobutton within w_growth_charts
end type
type rb_legend_none from radiobutton within w_growth_charts
end type
type cb_cancel from commandbutton within w_growth_charts
end type
type gr_growth from u_gr_growth_chart within w_growth_charts
end type
end forward

global type w_growth_charts from w_window_base
integer width = 2962
integer height = 1896
string title = "Growth Charts"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
cb_send_to cb_send_to
st_infant_title st_infant_title
st_visits_title_1 st_visits_title_1
cb_unit_preference cb_unit_preference
cb_ok cb_ok
st_infant_weight st_infant_weight
st_child_weight st_child_weight
st_child_title st_child_title
st_infant_height st_infant_height
st_child_height st_child_height
st_infant_hgtwgt st_infant_hgtwgt
st_child_hgtwgt st_child_hgtwgt
st_infant_hc st_infant_hc
st_child_bmi st_child_bmi
st_chart_type st_chart_type
st_well_visits st_well_visits
st_all_visits st_all_visits
st_visits_title_2 st_visits_title_2
st_unit_preference_title st_unit_preference_title
st_legend_title st_legend_title
rb_legend_bottom rb_legend_bottom
rb_legend_right rb_legend_right
rb_legend_none rb_legend_none
cb_cancel cb_cancel
gr_growth gr_growth
end type
global w_growth_charts w_growth_charts

type variables
str_growth_chart_settings growth_chart_settings 
u_component_service service


end variables

forward prototypes
public function integer refresh ()
public function integer savetofile ()
public function integer set_graph_size (long pl_width, long pl_height)
public function integer save_graph_to_file ()
end prototypes

public function integer refresh ();

if growth_chart_settings.background_color > 0 then
	gr_growth.backcolor = growth_chart_settings.background_color
end if

cb_unit_preference.Text = growth_chart_settings.graph_unit_preference

st_child_bmi.Backcolor = color_object
st_child_height.Backcolor = color_object
st_child_hgtwgt.Backcolor = color_object
st_child_weight.Backcolor = color_object

st_infant_hc.Backcolor = color_object
st_infant_height.Backcolor = color_object
st_infant_hgtwgt.Backcolor = color_object
st_infant_weight.Backcolor = color_object

CHOOSE CASE upper(growth_chart_settings.graph_type)
	CASE "WEIGHT"
		If growth_chart_settings.graph_infant_child = "Infant" then
			st_infant_weight.Backcolor = color_object_selected
		else
			st_child_weight.Backcolor = color_object_selected
		end if
	CASE "HEIGHT"
		If growth_chart_settings.graph_infant_child = "Infant" then
			st_infant_height.Backcolor = color_object_selected
		else
			st_child_height.Backcolor = color_object_selected
		end if
	CASE "WEIGHTVSHEIGHT"
		If growth_chart_settings.graph_infant_child = "Infant" then
			st_infant_hgtwgt.Backcolor = color_object_selected
		else
			st_child_hgtwgt.Backcolor = color_object_selected
		end if
	CASE "HC"
		growth_chart_settings.graph_infant_child = "Infant"
		st_infant_hc.Backcolor = color_object_selected
	CASE "BMI"
		growth_chart_settings.graph_infant_child = "Child"
		st_child_bmi.Backcolor = color_object_selected
END CHOOSE

if upper(growth_chart_settings.visit_types) = "WELL" then
	st_all_visits.Backcolor = color_object
	st_well_visits.Backcolor = color_object_selected
else
	st_all_visits.Backcolor = color_object_selected
	st_well_visits.Backcolor = color_object
end if

CHOOSE CASE lower(growth_chart_settings.legend)
	CASE "left"
//		rb_legend_none.checked = true
		gr_growth.legend = atleft!
	CASE "right"
		rb_legend_right.checked = true
		gr_growth.legend = atright!
	CASE "top"
//		rb_legend_none.checked = true
		gr_growth.legend = attop!
	CASE "bottom"
		rb_legend_bottom.checked = true
		gr_growth.legend = atbottom!
	CASE "none"
		rb_legend_none.checked = true
		gr_growth.legend = nolegend!
END CHOOSE
	

gr_growth.display_growth_chart(growth_chart_settings.graph_infant_child, growth_chart_settings.graph_type, growth_chart_settings.visit_types, growth_chart_settings.graph_unit_preference)


return 1

end function

public function integer savetofile ();string ls_path
string ls_file
string ls_filter
integer li_sts
String	ls_filename,ls_drive,ls_directory,ls_extension

// The called didn't specify a path so prompt the user for one
ls_path = trim(gr_growth.graph_title)
if not isnull(current_patient) then
	if not isnull(current_patient.billing_id) then
		ls_path += " " + trim(current_patient.billing_id)
	end if
end if

ls_filter = "bmp files (*.bmp), *.bmp, jpg files (*.jpg), *.jpg, gif files (*.gif), *.gif"
ls_filter += ",png files (*.png), *.png, wmf files (*.wmf), *.wmf, tif files (*.tif), *.tif"
ls_filter += ",emf files (*.emf), *.emf"
ls_filter += ",xls files (*.xls), *.xls"
ls_filter += ",html files (*.html), *.html"
ls_filter += ",pdf files (*.pdf), *.pdf"
ls_filter += ",psr files (*.psr), *.psr"
ls_filter += ",xsflo files (*.xsflo), *.xsflo"


li_sts = GetFileSaveName("Select File", ls_path, ls_file, "bmp", ls_filter)
if li_sts <= 0 then return 0

f_parse_filepath(ls_path, ls_drive, ls_directory, ls_filename, ls_extension)

if isnull(ls_extension) or trim(ls_extension) = "" then
	ls_extension = "bmp"
	ls_path += ".bmp"
end if

li_sts = f_save_graph_to_file(gr_growth, growth_chart_settings.image_width , growth_chart_settings.image_height, ls_extension, ls_path)
if li_sts > 0 and fileexists(ls_path) then
	openwithparm(w_pop_message, "Growth chart image successfully saved to " + ls_path)
else
	openwithparm(w_pop_message, "Growth chart image save failed")
end if

end function

public function integer set_graph_size (long pl_width, long pl_height);long ll_width_pbunits
long ll_height_pbunits
double ld_desired_aspect_ratio

//////////////////////////////////////////////////////////////////////////////////////////////////
// Size the graph control according to the desired dimensions
//////////////////////////////////////////////////////////////////////////////////////////////////

if pl_height > 100 AND pl_width > 100 then
	ld_desired_aspect_ratio = double(pl_width) / double(pl_height)
	f_convert_inches_to_pbunits(pl_width, pl_height, ll_width_pbunits, ll_height_pbunits)
	
	gr_growth.resize(ll_width_pbunits, ll_height_pbunits)
end if



return 1

end function

public function integer save_graph_to_file ();long ll_printjob
string ls_temp
string ls_printer
long ll_width_pbunits
long ll_height_pbunits
double ld_current_aspect_ratio
double ld_desired_aspect_ratio
long ll_backcolor
borderstyle le_borderstyle
integer li_sts
saveastype le_saveastype
long ll_graph_width
long ll_graph_height
boolean lb_resized

ld_current_aspect_ratio = double(gr_growth.width) / double(gr_growth.height)
le_borderstyle = gr_growth.borderstyle
gr_growth.borderstyle = StyleBox!
ll_graph_width = gr_growth.width
ll_graph_height = gr_growth.height
lb_resized = false

//////////////////////////////////////////////////////////////////////////////////////////////////
// Determine the output file
//////////////////////////////////////////////////////////////////////////////////////////////////
if isnull(growth_chart_settings.return_file_path ) or trim(growth_chart_settings.return_file_path) = "" then
	growth_chart_settings.return_file_path = f_temp_file(growth_chart_settings.return_file_type)
end if

//////////////////////////////////////////////////////////////////////////////////////////////////
// Determine the saving method
//////////////////////////////////////////////////////////////////////////////////////////////////
CHOOSE CASE growth_chart_settings.return_file_type
	CASE "xls"
		le_saveastype = Excel8!
	CASE "html"
		le_saveastype = HTMLTable!
	CASE "pdf"
		le_saveastype = PSReport!
	CASE "psr"
		le_saveastype = XML!
	CASE "xsflo"
		le_saveastype = XSLFO!
	CASE "emf"
		setnull(le_saveastype)
//		le_saveastype = EMF!
	CASE "bmp"
		setnull(le_saveastype)
	CASE "jpg"
		setnull(le_saveastype)
	CASE "gif"
		setnull(le_saveastype)
	CASE "png"
		setnull(le_saveastype)
	CASE "wmf"
		setnull(le_saveastype)
	CASE "tif"
		setnull(le_saveastype)
	CASE ELSE
END CHOOSE

//////////////////////////////////////////////////////////////////////////////////////////////////
// Save the graph to the file
//////////////////////////////////////////////////////////////////////////////////////////////////

if isnull(le_saveastype) then
	gr_growth.clipboard()
	
	li_sts = common_thread.eprolibnet4.SaveClipboardToFile(growth_chart_settings.return_file_path)
	if li_sts <= 0 then
		log.log(this, "open", "Error converting graph image to file", 4)
		setnull(growth_chart_settings.return_file_path)
	end if
else
	li_sts = gr_growth.SaveAs(growth_chart_settings.return_file_path, le_saveastype, true)
	if li_sts <= 0 then
		log.log(this, "open", "Error saving graph image to file", 4)
		setnull(growth_chart_settings.return_file_path)
	end if
end if

gr_growth.borderstyle = le_borderstyle

return 1

end function

on w_growth_charts.create
int iCurrent
call super::create
this.cb_send_to=create cb_send_to
this.st_infant_title=create st_infant_title
this.st_visits_title_1=create st_visits_title_1
this.cb_unit_preference=create cb_unit_preference
this.cb_ok=create cb_ok
this.st_infant_weight=create st_infant_weight
this.st_child_weight=create st_child_weight
this.st_child_title=create st_child_title
this.st_infant_height=create st_infant_height
this.st_child_height=create st_child_height
this.st_infant_hgtwgt=create st_infant_hgtwgt
this.st_child_hgtwgt=create st_child_hgtwgt
this.st_infant_hc=create st_infant_hc
this.st_child_bmi=create st_child_bmi
this.st_chart_type=create st_chart_type
this.st_well_visits=create st_well_visits
this.st_all_visits=create st_all_visits
this.st_visits_title_2=create st_visits_title_2
this.st_unit_preference_title=create st_unit_preference_title
this.st_legend_title=create st_legend_title
this.rb_legend_bottom=create rb_legend_bottom
this.rb_legend_right=create rb_legend_right
this.rb_legend_none=create rb_legend_none
this.cb_cancel=create cb_cancel
this.gr_growth=create gr_growth
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_send_to
this.Control[iCurrent+2]=this.st_infant_title
this.Control[iCurrent+3]=this.st_visits_title_1
this.Control[iCurrent+4]=this.cb_unit_preference
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.st_infant_weight
this.Control[iCurrent+7]=this.st_child_weight
this.Control[iCurrent+8]=this.st_child_title
this.Control[iCurrent+9]=this.st_infant_height
this.Control[iCurrent+10]=this.st_child_height
this.Control[iCurrent+11]=this.st_infant_hgtwgt
this.Control[iCurrent+12]=this.st_child_hgtwgt
this.Control[iCurrent+13]=this.st_infant_hc
this.Control[iCurrent+14]=this.st_child_bmi
this.Control[iCurrent+15]=this.st_chart_type
this.Control[iCurrent+16]=this.st_well_visits
this.Control[iCurrent+17]=this.st_all_visits
this.Control[iCurrent+18]=this.st_visits_title_2
this.Control[iCurrent+19]=this.st_unit_preference_title
this.Control[iCurrent+20]=this.st_legend_title
this.Control[iCurrent+21]=this.rb_legend_bottom
this.Control[iCurrent+22]=this.rb_legend_right
this.Control[iCurrent+23]=this.rb_legend_none
this.Control[iCurrent+24]=this.cb_cancel
this.Control[iCurrent+25]=this.gr_growth
end on

on w_growth_charts.destroy
call super::destroy
destroy(this.cb_send_to)
destroy(this.st_infant_title)
destroy(this.st_visits_title_1)
destroy(this.cb_unit_preference)
destroy(this.cb_ok)
destroy(this.st_infant_weight)
destroy(this.st_child_weight)
destroy(this.st_child_title)
destroy(this.st_infant_height)
destroy(this.st_child_height)
destroy(this.st_infant_hgtwgt)
destroy(this.st_child_hgtwgt)
destroy(this.st_infant_hc)
destroy(this.st_child_bmi)
destroy(this.st_chart_type)
destroy(this.st_well_visits)
destroy(this.st_all_visits)
destroy(this.st_visits_title_2)
destroy(this.st_unit_preference_title)
destroy(this.st_legend_title)
destroy(this.rb_legend_bottom)
destroy(this.rb_legend_right)
destroy(this.rb_legend_none)
destroy(this.cb_cancel)
destroy(this.gr_growth)
end on

event open;call super::open;string ls_classname
boolean lb_found
integer li_sts


lb_found = false
if isvalid(message.powerobjectparm) and not isnull(message.powerobjectparm) then
	ls_classname = message.powerobjectparm.classname()
	if lower(ls_classname) = "str_growth_chart_settings" then
		growth_chart_settings = message.powerobjectparm
		lb_found = true
	elseif lower(left(ls_classname, 19)) = "u_component_service" then
		service = message.powerobjectparm
	end if
end if

if lb_found then
	cb_cancel.visible = true
else
	cb_cancel.visible = false
	
	growth_chart_settings.show_user_interface = true
	
	If daysafter(current_patient.date_of_birth,today()) < 365 * 3 then 
		growth_chart_settings.graph_infant_child = "Infant"
	Else
		growth_chart_settings.graph_infant_child = "Child"
	End If
	
	growth_chart_settings.graph_type = "Weight"
	growth_chart_settings.graph_unit_preference = "METRIC"
	
	growth_chart_settings.visit_types = "Well"
	
	growth_chart_settings.legend = "None"
	
	growth_chart_settings.background_color = color_button
end if

title = current_patient.id_line()

gr_growth.patient_info = current_patient.name_fml()
if not isnull(current_patient.date_of_birth) then
	gr_growth.patient_info += space(6) + "DOB: " + string(current_patient.date_of_birth)
end if
if not isnull(current_patient.billing_id) then
	gr_growth.patient_info += space(6) + "ID: " + current_patient.billing_id
end if

if len(growth_chart_settings.ok_button_title) > 0 then
	cb_ok.text = growth_chart_settings.ok_button_title
else
	cb_ok.text = "OK"
end if



if not growth_chart_settings.show_user_interface then
	// resize the graph control
	set_graph_size(growth_chart_settings.image_width , growth_chart_settings.image_height)
	
	// Draw graph
	refresh()
	
	// If we're generating an image file then we'll be using the graph.clipboard() method to capture the image.  Unfortunately
	// the clipboard method does not respond to a resize until it is made visible.  This will cause a brief screen flicker but will
	// end up with a correctly sized graph image.  Were going to keep the window invisible for now and finish the saving in the
	// post_open script.
	visible = false
	postevent("post_open")
	return
end if

refresh()


end event

event resize;call super::resize;
if not growth_chart_settings.show_user_interface then return	

st_chart_type.x = width - st_chart_type.width - 50

st_infant_title.x = st_chart_type.x
st_infant_hc.x = st_chart_type.x
st_infant_height.x = st_chart_type.x
st_infant_hgtwgt.x = st_chart_type.x
st_infant_weight.x = st_chart_type.x
st_visits_title_1.x = st_chart_type.x
st_visits_title_2.x = st_chart_type.x
st_well_visits.x = st_chart_type.x
st_unit_preference_title.x = st_chart_type.x

st_child_title.x = st_chart_type.x + st_chart_type.width - st_child_title.width
st_child_bmi.x = st_child_title.x
st_child_height.x = st_child_title.x
st_child_hgtwgt.x = st_child_title.x
st_child_weight.x = st_child_title.x
st_all_visits.x = st_child_title.x

cb_unit_preference.x = st_unit_preference_title.x + ((st_unit_preference_title.width - cb_unit_preference.width) / 2)

cb_send_to.x = st_unit_preference_title.x + ((st_unit_preference_title.width - cb_send_to.width) / 2)

cb_ok.x = st_unit_preference_title.x + ((st_unit_preference_title.width - cb_ok.width) / 2)
cb_ok.y = height - cb_ok.height - 130

cb_cancel.y = cb_ok.y

gr_growth.width = st_chart_type.x - gr_growth.x - 50
gr_growth.height = cb_cancel.y - gr_growth.y - 30



st_legend_title.y = gr_growth.y + gr_growth.height + 30
rb_legend_bottom.y =st_legend_title.y
rb_legend_none.y = st_legend_title.y
rb_legend_right.y = st_legend_title.y

rb_legend_right.x = gr_growth.x + (gr_growth.width - rb_legend_right.width) / 2
rb_legend_bottom.x = rb_legend_right.x - rb_legend_bottom.width - 20
st_legend_title.x = rb_legend_bottom.x - st_legend_title.width - 20
rb_legend_none.x = rb_legend_right.x + rb_legend_right.width + 20


end event

event post_open;call super::post_open;integer li_sts

// save file and return
visible = true

li_sts = save_graph_to_file()
if li_sts > 0 and fileexists(growth_chart_settings.return_file_path) then
	growth_chart_settings.graph_title = gr_growth.title
else
	log.log(this, "open", "Error saving graph image to file", 4)
	setnull(growth_chart_settings.return_file_path)
end if

//	cb_ok.event POST clicked()
closewithreturn(this, growth_chart_settings)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_growth_charts
integer x = 2894
integer y = 220
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_growth_charts
integer x = 27
integer y = 1536
integer height = 52
end type

type cb_send_to from commandbutton within w_growth_charts
integer x = 2487
integer y = 1432
integer width = 379
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Send To"
end type

event clicked;str_popup popup
str_popup_return popup_return

// If there were no choices, then have the user pick between user and patient
popup.title = "Send Growth Chart To ..."
popup.data_row_count = 3
popup.items[1] = "Printer"
popup.items[2] = "Clipboard"
popup.items[3] = "File"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0


CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		f_print_graph(gr_growth)
	CASE 2
		gr_growth.clipboard()
	CASE 3
		savetofile()
END CHOOSE


end event

type st_infant_title from statictext within w_growth_charts
integer x = 2427
integer y = 120
integer width = 233
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Infant"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_visits_title_1 from statictext within w_growth_charts
integer x = 2427
integer y = 800
integer width = 494
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Include Data From"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_unit_preference from commandbutton within w_growth_charts
integer x = 2519
integer y = 1224
integer width = 311
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Metric"
end type

event clicked;if upper(growth_chart_settings.graph_unit_preference) = "METRIC" then
	growth_chart_settings.graph_unit_preference = "ENGLISH"
else
	growth_chart_settings.graph_unit_preference = "METRIC"
end if

refresh()

end event

type cb_ok from commandbutton within w_growth_charts
integer x = 2414
integer y = 1660
integer width = 503
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;string ls_filepath
integer li_sts
str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "OK"

if len(growth_chart_settings.return_file_type) > 0 then
	li_sts = f_save_graph_to_file(gr_growth, growth_chart_settings.image_width , growth_chart_settings.image_height, growth_chart_settings.return_file_type, ls_filepath)
	if li_sts > 0 and fileexists(ls_filepath) then
		growth_chart_settings.return_file_path = ls_filepath
		growth_chart_settings.graph_title = gr_growth.title
	else
		log.log(this, "open", "Error saving graph image to file", 4)
		setnull(growth_chart_settings.return_file_path)
		if growth_chart_settings.show_user_interface then
			openwithparm(w_pop_message, "An error occured saving the image file")
			return
		else
			popup_return.items[1] = "ERROR"
		end if
	end if
end if

if isvalid(service) and not isnull(service) then
	closewithreturn(parent, popup_return)
else
	closewithreturn(parent, growth_chart_settings)
end if

end event

type st_infant_weight from statictext within w_growth_charts
integer x = 2427
integer y = 204
integer width = 233
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Weight"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;
growth_chart_settings.graph_infant_child = "Infant"
growth_chart_settings.graph_type = "Weight"

refresh()


end event

type st_child_weight from statictext within w_growth_charts
integer x = 2688
integer y = 204
integer width = 233
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Weight"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;
growth_chart_settings.graph_infant_child = "Child"
growth_chart_settings.graph_type = "Weight"

refresh()


end event

type st_child_title from statictext within w_growth_charts
integer x = 2688
integer y = 120
integer width = 233
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Child"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_infant_height from statictext within w_growth_charts
integer x = 2427
integer y = 324
integer width = 233
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Length"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;
growth_chart_settings.graph_infant_child = "Infant"
growth_chart_settings.graph_type = "Height"

refresh()


end event

type st_child_height from statictext within w_growth_charts
integer x = 2688
integer y = 324
integer width = 233
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Height"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;
growth_chart_settings.graph_infant_child = "Child"
growth_chart_settings.graph_type = "Height"

refresh()


end event

type st_infant_hgtwgt from statictext within w_growth_charts
integer x = 2427
integer y = 444
integer width = 233
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "LgtWgt"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;
growth_chart_settings.graph_infant_child = "Infant"
growth_chart_settings.graph_type = "WEIGHTVSHEIGHT"

refresh()


end event

type st_child_hgtwgt from statictext within w_growth_charts
integer x = 2688
integer y = 444
integer width = 233
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "HgtWgt"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;
growth_chart_settings.graph_infant_child = "Child"
growth_chart_settings.graph_type = "WEIGHTVSHEIGHT"

refresh()


end event

type st_infant_hc from statictext within w_growth_charts
integer x = 2427
integer y = 564
integer width = 233
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "HC"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;
growth_chart_settings.graph_infant_child = "Infant"
growth_chart_settings.graph_type = "HC"

refresh()


end event

type st_child_bmi from statictext within w_growth_charts
integer x = 2688
integer y = 564
integer width = 233
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "BMI"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;
growth_chart_settings.graph_infant_child = "Child"
growth_chart_settings.graph_type = "BMI"

refresh()


end event

type st_chart_type from statictext within w_growth_charts
integer x = 2427
integer y = 40
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Chart Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_well_visits from statictext within w_growth_charts
integer x = 2427
integer y = 876
integer width = 233
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Well"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;
growth_chart_settings.visit_types = "Well"

refresh()


end event

type st_all_visits from statictext within w_growth_charts
integer x = 2688
integer y = 876
integer width = 233
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;
growth_chart_settings.visit_types = "All"

refresh()


end event

type st_visits_title_2 from statictext within w_growth_charts
integer x = 2427
integer y = 976
integer width = 498
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Encounters"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_unit_preference_title from statictext within w_growth_charts
integer x = 2427
integer y = 1144
integer width = 494
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "English/Metric"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_legend_title from statictext within w_growth_charts
integer x = 366
integer y = 1676
integer width = 306
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Legend:"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_legend_bottom from radiobutton within w_growth_charts
integer x = 718
integer y = 1676
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Bottom"
end type

event clicked;growth_chart_settings.legend = "bottom"
gr_growth.legend = atbottom!

end event

type rb_legend_right from radiobutton within w_growth_charts
integer x = 1166
integer y = 1676
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Right"
boolean checked = true
end type

event clicked;growth_chart_settings.legend = "right"
gr_growth.legend = atright!

end event

type rb_legend_none from radiobutton within w_growth_charts
integer x = 1614
integer y = 1676
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "No Legend"
end type

event clicked;growth_chart_settings.legend = "none"
gr_growth.legend = nolegend!

end event

type cb_cancel from commandbutton within w_growth_charts
integer x = 18
integer y = 1676
integer width = 338
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

setnull(growth_chart_settings.return_file_path)

if isvalid(service) and not isnull(service) then
	popup_return.item_count = 1
	popup_return.items[1] = "CANCEL"
	closewithreturn(parent, popup_return)
else
	closewithreturn(parent, growth_chart_settings)
end if

end event

type gr_growth from u_gr_growth_chart within w_growth_charts
integer x = 23
integer y = 28
integer width = 2350
integer height = 1616
boolean bringtotop = true
end type

