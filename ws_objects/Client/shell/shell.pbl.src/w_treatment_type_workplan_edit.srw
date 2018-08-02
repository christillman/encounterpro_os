$PBExportHeader$w_treatment_type_workplan_edit.srw
forward
global type w_treatment_type_workplan_edit from w_window_base
end type
type pb_done from u_picture_button within w_treatment_type_workplan_edit
end type
type pb_cancel from u_picture_button within w_treatment_type_workplan_edit
end type
type st_title from statictext within w_treatment_type_workplan_edit
end type
type st_1 from statictext within w_treatment_type_workplan_edit
end type
type st_workplan_description_title from statictext within w_treatment_type_workplan_edit
end type
type pb_down from picturebutton within w_treatment_type_workplan_edit
end type
type pb_up from picturebutton within w_treatment_type_workplan_edit
end type
type st_page from statictext within w_treatment_type_workplan_edit
end type
type dw_workplans from u_dw_pick_list within w_treatment_type_workplan_edit
end type
type cb_new_treatment_mode from commandbutton within w_treatment_type_workplan_edit
end type
end forward

global type w_treatment_type_workplan_edit from w_window_base
integer x = 200
integer y = 200
integer width = 2426
integer height = 1432
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_title st_title
st_1 st_1
st_workplan_description_title st_workplan_description_title
pb_down pb_down
pb_up pb_up
st_page st_page
dw_workplans dw_workplans
cb_new_treatment_mode cb_new_treatment_mode
end type
global w_treatment_type_workplan_edit w_treatment_type_workplan_edit

type variables
string treatment_type

end variables

forward prototypes
public subroutine mode_menu (long pl_row)
public function integer select_workplan (ref long pl_workplan_id, ref string ps_workplan_description)
end prototypes

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

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Change Workplan assigned to this treatment mode"
	popup.button_titles[popup.button_count] = "Change Workplan"
	buttons[popup.button_count] = "CHANGE"
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
	CASE "DELETE"
		ls_temp = "Are you sure you wish to delete the treatment mode '" + dw_workplans.object.treatment_mode[pl_row] + "'?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			dw_workplans.deleterow(pl_row)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public function integer select_workplan (ref long pl_workplan_id, ref string ps_workplan_description);str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_workplan_of_type_pick_list"
popup.title = "Select Workplan"
popup.datacolumn = 1
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "Treatment"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

pl_workplan_id = long(popup_return.items[1])
ps_workplan_description = popup_return.descriptions[1]

return 1



end function

on w_treatment_type_workplan_edit.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.st_1=create st_1
this.st_workplan_description_title=create st_workplan_description_title
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.dw_workplans=create dw_workplans
this.cb_new_treatment_mode=create cb_new_treatment_mode
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_workplan_description_title
this.Control[iCurrent+6]=this.pb_down
this.Control[iCurrent+7]=this.pb_up
this.Control[iCurrent+8]=this.st_page
this.Control[iCurrent+9]=this.dw_workplans
this.Control[iCurrent+10]=this.cb_new_treatment_mode
end on

on w_treatment_type_workplan_edit.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.st_1)
destroy(this.st_workplan_description_title)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.dw_workplans)
destroy(this.cb_new_treatment_mode)
end on

event open;call super::open;str_popup popup

popup = message.powerobjectparm

st_title.text = popup.title

if popup.data_row_count <> 1 then
	log.log(this, "w_treatment_type_workplan_edit.open.0008", "Invalid Parameters", 4)
	close(this)
	return
end if

treatment_type = popup.items[1]

dw_workplans.settransobject(sqlca)
dw_workplans.retrieve(treatment_type)

dw_workplans.set_page(1, pb_up, pb_down, st_page)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_treatment_type_workplan_edit
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_treatment_type_workplan_edit
end type

type pb_done from u_picture_button within w_treatment_type_workplan_edit
integer x = 2098
integer y = 1144
integer taborder = 10
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;integer li_sts

li_sts = dw_workplans.update()
if li_sts < 0 then return
	
close(parent)



end event

type pb_cancel from u_picture_button within w_treatment_type_workplan_edit
integer x = 78
integer y = 1144
integer taborder = 30
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;close(parent)


end event

type st_title from statictext within w_treatment_type_workplan_edit
integer width = 2418
integer height = 132
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_treatment_type_workplan_edit
integer x = 256
integer y = 192
integer width = 443
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Treatment Mode"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_workplan_description_title from statictext within w_treatment_type_workplan_edit
integer x = 1070
integer y = 192
integer width = 1102
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Workplan Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down from picturebutton within w_treatment_type_workplan_edit
integer x = 2034
integer y = 964
integer width = 137
integer height = 116
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
alignment htextalign = left!
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_workplans.current_page
li_last_page = dw_workplans.last_page

dw_workplans.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from picturebutton within w_treatment_type_workplan_edit
integer x = 2181
integer y = 964
integer width = 137
integer height = 116
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
alignment htextalign = left!
end type

event clicked;integer li_page

li_page = dw_workplans.current_page

dw_workplans.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_treatment_type_workplan_edit
integer x = 1733
integer y = 964
integer width = 293
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "99 of 99"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_workplans from u_dw_pick_list within w_treatment_type_workplan_edit
integer x = 69
integer y = 244
integer width = 2267
integer height = 704
integer taborder = 20
string dataobject = "dw_treatment_type_workplan_edit"
boolean border = false
end type

event selected;call super::selected;mode_menu(selected_row)
clear_selected()


end event

type cb_new_treatment_mode from commandbutton within w_treatment_type_workplan_edit
integer x = 878
integer y = 1068
integer width = 667
integer height = 112
integer taborder = 70
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
if li_sts <= 0 then return
dw_workplans.object.workplan_id[ll_row] = ll_workplan_id
dw_workplans.object.workplan_description[ll_row] = ls_workplan_description

end event

