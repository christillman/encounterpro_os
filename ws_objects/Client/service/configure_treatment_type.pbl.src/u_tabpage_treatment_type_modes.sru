$PBExportHeader$u_tabpage_treatment_type_modes.sru
forward
global type u_tabpage_treatment_type_modes from u_tabpage
end type
type cb_new_treatment_mode from commandbutton within u_tabpage_treatment_type_modes
end type
type dw_workplans from u_dw_pick_list within u_tabpage_treatment_type_modes
end type
type st_workplan_description_title from statictext within u_tabpage_treatment_type_modes
end type
type st_1 from statictext within u_tabpage_treatment_type_modes
end type
end forward

global type u_tabpage_treatment_type_modes from u_tabpage
integer width = 2802
integer height = 1000
cb_new_treatment_mode cb_new_treatment_mode
dw_workplans dw_workplans
st_workplan_description_title st_workplan_description_title
st_1 st_1
end type
global u_tabpage_treatment_type_modes u_tabpage_treatment_type_modes

type variables
string treatment_type

end variables

forward prototypes
public function integer select_workplan (ref long pl_workplan_id, ref string ps_workplan_description)
public subroutine mode_menu (long pl_row)
public subroutine refresh ()
public function integer initialize (string ps_key)
end prototypes

public function integer select_workplan (ref long pl_workplan_id, ref string ps_workplan_description);str_c_workplan lstr_workplan
w_pick_workplan lw_window
str_workplan_context lstr_workplan_context

lstr_workplan_context.context_object = "Treatment"
lstr_workplan_context.in_office_flag = "?" // Let the user choose

openwithparm(lw_window, lstr_workplan_context, "w_pick_workplan")
lstr_workplan = message.powerobjectparm
if isnull(lstr_workplan.workplan_id) then return 0

pl_workplan_id = lstr_workplan.workplan_id
ps_workplan_description = lstr_workplan.description

return 1



end function

public subroutine mode_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
integer li_step_number
string ls_temp
long i
integer li_temp
long ll_lastrow
long ll_workplan_id
string ls_workplan_description
w_window_base lw_edit_window
string ls_id

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Change Workplan assigned to this treatment mode"
	popup.button_titles[popup.button_count] = "Change Workplan"
	buttons[popup.button_count] = "CHANGE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit this workplan"
	popup.button_titles[popup.button_count] = "Edit Workplan"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Treatment Mode"
	popup.button_titles[popup.button_count] = "Delete Mode"
	buttons[popup.button_count] = "DELETE"
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
	CASE "CHANGE"
		li_sts = select_workplan(ll_workplan_id, ls_workplan_description)
		if li_sts <= 0 then return
		dw_workplans.object.workplan_id[pl_row] = ll_workplan_id
		dw_workplans.object.workplan_description[pl_row] = ls_workplan_description
		dw_workplans.update()
	CASE "DELETE"
		ls_temp = "Are you sure you wish to delete the treatment mode '" + dw_workplans.object.treatment_mode[pl_row] + "'?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			dw_workplans.deleterow(pl_row)
			dw_workplans.update()
		end if
	CASE "EDIT"
		ll_workplan_id = dw_workplans.object.workplan_id[pl_row]
		
		SELECT CAST(id AS varchar(40))
		INTO :ls_id
		FROM c_workplan
		WHERE workplan_id = :ll_workplan_id;
		if not tf_check() then return
		if sqlca.sqlcode = 100 then return
		
		popup.data_row_count = 2
		popup.items[1] = ls_id
		popup.items[2] = "true"
		
		openwithparm(lw_edit_window, popup, "w_Workplan_definition_display")
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public subroutine refresh ();dw_workplans.settransobject(sqlca)
dw_workplans.retrieve(treatment_type)


end subroutine

public function integer initialize (string ps_key);treatment_type = ps_key

this.event trigger resize_tabpage()

return 1

end function

on u_tabpage_treatment_type_modes.create
int iCurrent
call super::create
this.cb_new_treatment_mode=create cb_new_treatment_mode
this.dw_workplans=create dw_workplans
this.st_workplan_description_title=create st_workplan_description_title
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_new_treatment_mode
this.Control[iCurrent+2]=this.dw_workplans
this.Control[iCurrent+3]=this.st_workplan_description_title
this.Control[iCurrent+4]=this.st_1
end on

on u_tabpage_treatment_type_modes.destroy
call super::destroy
destroy(this.cb_new_treatment_mode)
destroy(this.dw_workplans)
destroy(this.st_workplan_description_title)
destroy(this.st_1)
end on

event resize_tabpage;call super::resize_tabpage;long ll_width

ll_width = (dw_workplans.width - 137)

dw_workplans.object.treatment_mode.width = int(ll_width / 3)
dw_workplans.object.workplan_description.width = int(2 * ll_width / 3)



end event

type cb_new_treatment_mode from commandbutton within u_tabpage_treatment_type_modes
integer x = 1065
integer y = 852
integer width = 667
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Treatment Mode"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_find
long ll_row
long ll_workplan_id
string ls_workplan_description
integer li_sts

popup.title = "Enter New Treatment Mode"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_find = "treatment_mode='" + popup_return.items[1] + "'"
ll_row = dw_workplans.find(ls_find, 1, dw_workplans.rowcount())
if ll_row > 0 then
	openwithparm(w_pop_message, "That treatment mode already exists in this treatment type.")
	return
end if

ll_row = dw_workplans.insertrow(0)
dw_workplans.object.treatment_type[ll_row] = treatment_type
dw_workplans.object.treatment_mode[ll_row] = popup_return.items[1]


li_sts = select_workplan(ll_workplan_id, ls_workplan_description)
if li_sts <= 0 then
	dw_workplans.deleterow(ll_row)
end if

dw_workplans.object.workplan_id[ll_row] = ll_workplan_id
dw_workplans.object.workplan_description[ll_row] = ls_workplan_description

dw_workplans.update()

end event

type dw_workplans from u_dw_pick_list within u_tabpage_treatment_type_modes
integer x = 261
integer y = 124
integer width = 2336
integer height = 704
integer taborder = 10
string dataobject = "dw_treatment_type_workplan_edit"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;mode_menu(selected_row)
clear_selected()


end event

type st_workplan_description_title from statictext within u_tabpage_treatment_type_modes
integer x = 1038
integer y = 4
integer width = 1467
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Workplan Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within u_tabpage_treatment_type_modes
integer x = 274
integer y = 4
integer width = 763
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Treatment Mode"
alignment alignment = center!
boolean focusrectangle = false
end type

