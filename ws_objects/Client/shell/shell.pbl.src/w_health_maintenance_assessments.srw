$PBExportHeader$w_health_maintenance_assessments.srw
forward
global type w_health_maintenance_assessments from w_window_base
end type
type pb_done from u_picture_button within w_health_maintenance_assessments
end type
type pb_cancel from u_picture_button within w_health_maintenance_assessments
end type
type st_rule_description from statictext within w_health_maintenance_assessments
end type
type st_rule_desc_title from statictext within w_health_maintenance_assessments
end type
type cb_page from commandbutton within w_health_maintenance_assessments
end type
type st_no_alternate_codes from statictext within w_health_maintenance_assessments
end type
type dw_assessments from u_dw_pick_list within w_health_maintenance_assessments
end type
type st_procs_title from statictext within w_health_maintenance_assessments
end type
type st_add_assessment from statictext within w_health_maintenance_assessments
end type
type st_title from statictext within w_health_maintenance_assessments
end type
end forward

global type w_health_maintenance_assessments from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_rule_description st_rule_description
st_rule_desc_title st_rule_desc_title
cb_page cb_page
st_no_alternate_codes st_no_alternate_codes
dw_assessments dw_assessments
st_procs_title st_procs_title
st_add_assessment st_add_assessment
st_title st_title
end type
global w_health_maintenance_assessments w_health_maintenance_assessments

type variables
long maintenance_rule_id
end variables

forward prototypes
public function integer get_assessments ()
public subroutine assessment_menu (long pl_row)
public function integer add_assessment ()
end prototypes

public function integer get_assessments ();dw_assessments.retrieve(maintenance_rule_id)

dw_assessments.set_page(1, cb_page.text)

return 1

end function

public subroutine assessment_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
long i
string ls_assessment_current_flag


ls_assessment_current_flag = dw_assessments.object.assessment_current_flag[pl_row]

if ls_assessment_current_flag = "Y" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Apply if patient has ever been diagnosed with assessment"
	popup.button_titles[popup.button_count] = "All Diagnoses"
	buttons[popup.button_count] = "NONCURRENT"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Only apply to patient if this assessment is open"
	popup.button_titles[popup.button_count] = "Open Diagnoses"
	buttons[popup.button_count] = "CURRENT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Set this assessment as the primary assessment"
	popup.button_titles[popup.button_count] = "Set Primary"
	buttons[popup.button_count] = "PRIMARY"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove assessment From This Maintenance Rule"
	popup.button_titles[popup.button_count] = "Remove"
	buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "CURRENT"
		dw_assessments.object.assessment_current_flag[pl_row] = "Y"
	CASE "NONCURRENT"
		dw_assessments.object.assessment_current_flag[pl_row] = "N"
	CASE "PRIMARY"
		for i = 1 to dw_assessments.rowcount()
			if i = pl_row then
				dw_assessments.object.primary_flag[i] = "Y"
			else
				dw_assessments.object.primary_flag[i] = "N"
			end if
		next
	CASE "REMOVE"
		openwithparm(w_pop_yes_no, "Are you sure you wish to remove this assessment?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		dw_assessments.deleterow(pl_row)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public function integer add_assessment ();string ls_assessment_type
string ls_description
string ls_button
string ls_icon_open
string ls_icon_closed
integer li_sts
long ll_row
string ls_primary_flag
long i
str_picked_assessments lstr_assessments
str_popup popup


popup.data_row_count = 2
popup.items[1] = "" // assessment_type
setnull(popup.items[2]) // encounter_id

openwithparm(w_pick_assessments, popup)
lstr_assessments = message.powerobjectparm
if lstr_assessments.assessment_count <= 0 then return 0

for i = 1 to lstr_assessments.assessment_count
	SELECT t.assessment_type,
			t.description,
			t.button,
			t.icon_open,
			t.icon_closed
	INTO :ls_assessment_type,
			:ls_description,
			:ls_button,
			:ls_icon_open,
			:ls_icon_closed
	FROM c_assessment_definition p, c_assessment_Type t
	WHERE p.assessment_id = :lstr_assessments.assessments[i].assessment_id
	AND p.assessment_type = t.assessment_type;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		log.log(this, "w_health_maintenance_assessments.add_assessment.0038", "assessment_type not found for assessment (" + lstr_assessments.assessments[i].assessment_id + ")", 4)
		return -1
	end if
	
	ll_row = dw_assessments.insertrow(0)
	
	if ll_row = 1 then
		ls_primary_flag = "Y"
	else
		ls_primary_flag = "N"
	end if
	
	dw_assessments.object.assessment_id[ll_row] = lstr_assessments.assessments[i].assessment_id
	dw_assessments.object.assessment_current_flag[ll_row] = "N"
	dw_assessments.object.description[ll_row] = lstr_assessments.assessments[i].description
	dw_assessments.object.maintenance_rule_id[ll_row] = maintenance_rule_id
	dw_assessments.object.primary_flag[ll_row] = ls_primary_flag
	dw_assessments.object.assessment_type[ll_row] = ls_assessment_type
	dw_assessments.object.assessment_type_description[ll_row] = ls_description
	dw_assessments.object.button[ll_row] = ls_button
	dw_assessments.object.icon_open[ll_row] = ls_icon_open
	dw_assessments.object.icon_closed[ll_row] = ls_icon_closed
next


return 1


end function

event open;call super::open;str_popup popup
integer li_sts


popup = message.powerobjectparm
if popup.data_row_count <> 2 then
	log.log(this, "w_health_maintenance_assessments.open.0007", "Invalid Parameters", 4)
	close(this)
	return
end if

maintenance_rule_id = long(popup.items[1])
st_rule_description.text = popup.items[2]

dw_assessments.settransobject(sqlca)

get_assessments()

end event

on w_health_maintenance_assessments.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_rule_description=create st_rule_description
this.st_rule_desc_title=create st_rule_desc_title
this.cb_page=create cb_page
this.st_no_alternate_codes=create st_no_alternate_codes
this.dw_assessments=create dw_assessments
this.st_procs_title=create st_procs_title
this.st_add_assessment=create st_add_assessment
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_rule_description
this.Control[iCurrent+4]=this.st_rule_desc_title
this.Control[iCurrent+5]=this.cb_page
this.Control[iCurrent+6]=this.st_no_alternate_codes
this.Control[iCurrent+7]=this.dw_assessments
this.Control[iCurrent+8]=this.st_procs_title
this.Control[iCurrent+9]=this.st_add_assessment
this.Control[iCurrent+10]=this.st_title
end on

on w_health_maintenance_assessments.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_rule_description)
destroy(this.st_rule_desc_title)
destroy(this.cb_page)
destroy(this.st_no_alternate_codes)
destroy(this.dw_assessments)
destroy(this.st_procs_title)
destroy(this.st_add_assessment)
destroy(this.st_title)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_health_maintenance_assessments
boolean visible = true
integer x = 2656
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_health_maintenance_assessments
end type

type pb_done from u_picture_button within w_health_maintenance_assessments
integer x = 2569
integer y = 1532
integer taborder = 0
boolean default = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
integer li_sts

li_sts = dw_assessments.update()
if li_sts < 0 then return

close(parent)


end event

type pb_cancel from u_picture_button within w_health_maintenance_assessments
integer x = 119
integer y = 1532
integer taborder = 0
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;close(parent)


end event

type st_rule_description from statictext within w_health_maintenance_assessments
integer x = 965
integer y = 156
integer width = 1678
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_rule_desc_title from statictext within w_health_maintenance_assessments
integer x = 169
integer y = 172
integer width = 763
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Health Maintenance Rule:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_page from commandbutton within w_health_maintenance_assessments
integer x = 2464
integer y = 424
integer width = 370
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Page 99/99"
end type

event clicked;dw_assessments.set_page(dw_assessments.current_page + 1, text)

end event

type st_no_alternate_codes from statictext within w_health_maintenance_assessments
boolean visible = false
integer x = 736
integer y = 1052
integer width = 1504
integer height = 156
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "No Alternate Codes"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_assessments from u_dw_pick_list within w_health_maintenance_assessments
integer x = 443
integer y = 412
integer width = 1998
integer height = 1080
integer taborder = 10
string dataobject = "dw_maintenance_rule_assessments"
boolean border = false
end type

event selected;call super::selected;assessment_menu(selected_row)
clear_selected()

end event

type st_procs_title from statictext within w_health_maintenance_assessments
integer x = 1207
integer y = 348
integer width = 375
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Assessments"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_add_assessment from statictext within w_health_maintenance_assessments
integer x = 2464
integer y = 684
integer width = 370
integer height = 156
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Add Assessment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;add_assessment()


end event

type st_title from statictext within w_health_maintenance_assessments
integer width = 2926
integer height = 112
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Health Maintenance Assessments"
alignment alignment = center!
boolean focusrectangle = false
end type

