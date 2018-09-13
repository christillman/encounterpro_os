$PBExportHeader$u_tabpage_hm_class_treatments.sru
forward
global type u_tabpage_hm_class_treatments from u_tabpage_hm_class_base
end type
type st_title from statictext within u_tabpage_hm_class_treatments
end type
type cb_add_treatment from commandbutton within u_tabpage_hm_class_treatments
end type
type dw_treatments from u_dw_pick_list within u_tabpage_hm_class_treatments
end type
end forward

global type u_tabpage_hm_class_treatments from u_tabpage_hm_class_base
integer width = 3063
st_title st_title
cb_add_treatment cb_add_treatment
dw_treatments dw_treatments
end type
global u_tabpage_hm_class_treatments u_tabpage_hm_class_treatments

type variables
string hm_treatment_list_id = "HealthMaintenance"

end variables

forward prototypes
public function integer add_treatment ()
public subroutine treatment_menu (long pl_row)
public subroutine refresh ()
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
end prototypes

public function integer add_treatment ();string ls_treatment_type
string ls_description
string ls_button
string ls_icon_open
string ls_icon_closed
integer li_sts
long ll_row
string ls_primary_flag
long i
str_picked_treatments lstr_treatments
str_popup popup
u_component_treatment luo_treatment
string ls_treatment_key

ls_treatment_type = f_get_treatments_list(hm_treatment_list_id)
ls_button = datalist.treatment_type_define_button(ls_treatment_type)

If Not Isnull(ls_treatment_type) Then
	luo_treatment = f_get_treatment_component(ls_treatment_type)
	If Not Isnull(luo_treatment) Then 
		luo_treatment.define_treatment()
		
		for i = 1 to luo_treatment.treatment_count
			ls_treatment_key = f_get_treatment_key(ls_treatment_type, &
													luo_treatment.treatment_definition[i].attribute_count, &
													luo_treatment.treatment_definition[i].attribute, &
													luo_treatment.treatment_definition[i].value)

			ll_row = dw_treatments.insertrow(0)
			dw_treatments.object.maintenance_rule_id[ll_row] = hmclasstab.hm_class.maintenance_rule_id
			dw_treatments.object.treatment_type[ll_row] = ls_treatment_type
			dw_treatments.object.treatment_key[ll_row] = ls_treatment_key
			dw_treatments.object.description[ll_row] = left(luo_treatment.treatment_definition[i].item_description, 80)
			dw_treatments.object.open_flag[ll_row] = "N"
			dw_treatments.object.primary_flag[ll_row] = "N"
			dw_treatments.object.created[ll_row] = datetime(today(), now())
			dw_treatments.object.created_by[ll_row] = current_scribe.user_id
			dw_treatments.object.button[ll_row] = ls_button
		next
	End If
End If

li_sts = dw_treatments.update()
if li_sts < 0 then return -1

return 1

end function

public subroutine treatment_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
long i
string ls_open_flag


ls_open_flag = dw_treatments.object.open_flag[pl_row]

if ls_open_flag = "Y" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Apply if patient has ever been treated with this treatment"
	popup.button_titles[popup.button_count] = "Any Treatment"
	buttons[popup.button_count] = "NONCURRENT"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Only apply to patient if this treatment is open"
	popup.button_titles[popup.button_count] = "Open Treatment"
	buttons[popup.button_count] = "CURRENT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Set this treatment as the primary treatment"
	popup.button_titles[popup.button_count] = "Set Primary"
	buttons[popup.button_count] = "PRIMARY"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove treatment From This Maintenance Rule"
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
		dw_treatments.object.open_flag[pl_row] = "Y"
		li_sts = dw_treatments.update()
	CASE "NONCURRENT"
		dw_treatments.object.open_flag[pl_row] = "N"
		li_sts = dw_treatments.update()
	CASE "PRIMARY"
		for i = 1 to dw_treatments.rowcount()
			if i = pl_row then
				dw_treatments.object.primary_flag[i] = "Y"
			else
				dw_treatments.object.primary_flag[i] = "N"
			end if
		next
		li_sts = dw_treatments.update()
	CASE "REMOVE"
		openwithparm(w_pop_yes_no, "Are you sure you wish to remove this treatment?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		dw_treatments.deleterow(pl_row)
		li_sts = dw_treatments.update()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public subroutine refresh ();integer li_sts

li_sts = dw_treatments.retrieve(HMClassTab.hm_class.maintenance_rule_id)

return

end subroutine

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);long i
long ll_row

// Set the object positions
st_title.width = width

dw_treatments.x = ((width - dw_treatments.width) / 2) - 110
dw_treatments.height = height - 300

cb_add_treatment.x = (width - cb_add_treatment.width) / 2
cb_add_treatment.y = dw_treatments.y + dw_treatments.height + 36

dw_treatments.settransobject(sqlca)
//for i = 1 to HMClassTab.hm_class.treatment_count
//	ll_row = dw_treatments.insertrow(0)
//	dw_treatments.object.property[ll_row] = HMClassTab.hm_class.treatment[i].property
//	dw_treatments.object.property_display[ll_row] = wordcap(f_string_substitute(HMClassTab.hm_class.treatment[i].property, "_", " "))
//	dw_treatments.object.value[ll_row] = HMClassTab.hm_class.treatment[i].value
//	dw_treatments.object.operation[ll_row] = HMClassTab.hm_class.treatment[i].operation
//	if isnull(HMClassTab.hm_class.treatment[i].value) then
//		dw_treatments.object.value_display[ll_row] = "<Any>"
//	else
//		dw_treatments.object.value_display[ll_row] = f_property_value_display(HMClassTab.hm_class.treatment[i].property, HMClassTab.hm_class.treatment[i].value)
//	end if
//next

return 1


end function

on u_tabpage_hm_class_treatments.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_add_treatment=create cb_add_treatment
this.dw_treatments=create dw_treatments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_add_treatment
this.Control[iCurrent+3]=this.dw_treatments
end on

on u_tabpage_hm_class_treatments.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_add_treatment)
destroy(this.dw_treatments)
end on

type st_title from statictext within u_tabpage_hm_class_treatments
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
string text = "Class treatments"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_add_treatment from commandbutton within u_tabpage_hm_class_treatments
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
string text = "Add Treatment"
end type

event clicked;add_treatment()
end event

type dw_treatments from u_dw_pick_list within u_tabpage_hm_class_treatments
integer y = 108
integer width = 2107
integer height = 1216
integer taborder = 10
string dataobject = "dw_maintenance_rule_treatments"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;treatment_menu(selected_row)
clear_selected()

end event

