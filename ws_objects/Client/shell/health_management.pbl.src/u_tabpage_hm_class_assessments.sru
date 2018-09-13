$PBExportHeader$u_tabpage_hm_class_assessments.sru
forward
global type u_tabpage_hm_class_assessments from u_tabpage_hm_class_base
end type
type st_title from statictext within u_tabpage_hm_class_assessments
end type
type cb_add_assessment from commandbutton within u_tabpage_hm_class_assessments
end type
type dw_assessments from u_dw_pick_list within u_tabpage_hm_class_assessments
end type
end forward

global type u_tabpage_hm_class_assessments from u_tabpage_hm_class_base
integer width = 3063
st_title st_title
cb_add_assessment cb_add_assessment
dw_assessments dw_assessments
end type
global u_tabpage_hm_class_assessments u_tabpage_hm_class_assessments

type variables

end variables

forward prototypes
public function integer add_assessment ()
public subroutine assessment_menu (long pl_row)
public subroutine refresh ()
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
end prototypes

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
		log.log(this, "u_tabpage_hm_class_assessments.add_assessment:0038", "assessment_type not found for assessment (" + lstr_assessments.assessments[i].assessment_id + ")", 4)
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
	dw_assessments.object.maintenance_rule_id[ll_row] = HMClassTab.hm_class.maintenance_rule_id
	dw_assessments.object.primary_flag[ll_row] = ls_primary_flag
	dw_assessments.object.assessment_type[ll_row] = ls_assessment_type
	dw_assessments.object.assessment_type_description[ll_row] = ls_description
	dw_assessments.object.button[ll_row] = ls_button
	dw_assessments.object.icon_open[ll_row] = ls_icon_open
	dw_assessments.object.icon_closed[ll_row] = ls_icon_closed
next

li_sts = dw_assessments.update()
if li_sts < 0 then return -1

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
		li_sts = dw_assessments.update()
	CASE "NONCURRENT"
		dw_assessments.object.assessment_current_flag[pl_row] = "N"
		li_sts = dw_assessments.update()
	CASE "PRIMARY"
		for i = 1 to dw_assessments.rowcount()
			if i = pl_row then
				dw_assessments.object.primary_flag[i] = "Y"
			else
				dw_assessments.object.primary_flag[i] = "N"
			end if
		next
		li_sts = dw_assessments.update()
	CASE "REMOVE"
		openwithparm(w_pop_yes_no, "Are you sure you wish to remove this assessment?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		dw_assessments.deleterow(pl_row)
		li_sts = dw_assessments.update()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public subroutine refresh ();integer li_sts

li_sts = dw_assessments.retrieve(HMClassTab.hm_class.maintenance_rule_id)

return

end subroutine

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);long i
long ll_row

// Set the object positions
st_title.width = width

dw_assessments.x = ((width - dw_assessments.width) / 2) - 110
dw_assessments.height = height - 300

cb_add_assessment.x = (width - cb_add_assessment.width) / 2
cb_add_assessment.y = dw_assessments.y + dw_assessments.height + 36

dw_assessments.settransobject(sqlca)
//for i = 1 to HMClassTab.hm_class.assessment_count
//	ll_row = dw_assessments.insertrow(0)
//	dw_assessments.object.property[ll_row] = HMClassTab.hm_class.assessment[i].property
//	dw_assessments.object.property_display[ll_row] = wordcap(f_string_substitute(HMClassTab.hm_class.assessment[i].property, "_", " "))
//	dw_assessments.object.value[ll_row] = HMClassTab.hm_class.assessment[i].value
//	dw_assessments.object.operation[ll_row] = HMClassTab.hm_class.assessment[i].operation
//	if isnull(HMClassTab.hm_class.assessment[i].value) then
//		dw_assessments.object.value_display[ll_row] = "<Any>"
//	else
//		dw_assessments.object.value_display[ll_row] = f_property_value_display(HMClassTab.hm_class.assessment[i].property, HMClassTab.hm_class.assessment[i].value)
//	end if
//next

return 1


end function

on u_tabpage_hm_class_assessments.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_add_assessment=create cb_add_assessment
this.dw_assessments=create dw_assessments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_add_assessment
this.Control[iCurrent+3]=this.dw_assessments
end on

on u_tabpage_hm_class_assessments.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_add_assessment)
destroy(this.dw_assessments)
end on

type st_title from statictext within u_tabpage_hm_class_assessments
integer width = 2889
integer height = 100
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Class Assessments"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_add_assessment from commandbutton within u_tabpage_hm_class_assessments
integer x = 1234
integer y = 1372
integer width = 512
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Assessment"
end type

event clicked;add_assessment()
end event

type dw_assessments from u_dw_pick_list within u_tabpage_hm_class_assessments
integer y = 108
integer width = 2107
integer height = 1216
integer taborder = 10
string dataobject = "dw_maintenance_rule_assessments"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;assessment_menu(selected_row)
clear_selected()

end event

