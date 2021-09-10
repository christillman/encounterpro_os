$PBExportHeader$w_procedure_extra_charges_edit.srw
forward
global type w_procedure_extra_charges_edit from w_window_base
end type
type st_title from statictext within w_procedure_extra_charges_edit
end type
type dw_extra_charges from u_dw_pick_list within w_procedure_extra_charges_edit
end type
type cb_new from commandbutton within w_procedure_extra_charges_edit
end type
type cb_delete from commandbutton within w_procedure_extra_charges_edit
end type
type cb_move_up from commandbutton within w_procedure_extra_charges_edit
end type
type cb_move_down from commandbutton within w_procedure_extra_charges_edit
end type
type cb_sort from commandbutton within w_procedure_extra_charges_edit
end type
type cb_ok from commandbutton within w_procedure_extra_charges_edit
end type
end forward

global type w_procedure_extra_charges_edit from w_window_base
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
st_title st_title
dw_extra_charges dw_extra_charges
cb_new cb_new
cb_delete cb_delete
cb_move_up cb_move_up
cb_move_down cb_move_down
cb_sort cb_sort
cb_ok cb_ok
end type
global w_procedure_extra_charges_edit w_procedure_extra_charges_edit

type variables
string procedure_id
string procedure_type



end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer li_sts

li_sts = dw_extra_charges.retrieve(procedure_id)
if li_sts < 0 then return -1

cb_move_down.enabled = false
cb_move_up.enabled = false
cb_delete.enabled = false

Return 1



end function

event open;call super::open;string ls_description

procedure_id = message.stringparm

SELECT procedure_type, description
INTO :procedure_type, :ls_description
FROM c_Procedure
WHERE procedure_id = :procedure_id;
if not tf_check() then
	close(this)
	return
end if

if len(ls_description) > 0 then
	st_title.text = "Extra Charges for " + ls_description
end if

dw_extra_charges.settransobject(sqlca)


refresh()

end event

on w_procedure_extra_charges_edit.create
int iCurrent
call super::create
this.st_title=create st_title
this.dw_extra_charges=create dw_extra_charges
this.cb_new=create cb_new
this.cb_delete=create cb_delete
this.cb_move_up=create cb_move_up
this.cb_move_down=create cb_move_down
this.cb_sort=create cb_sort
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.dw_extra_charges
this.Control[iCurrent+3]=this.cb_new
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.cb_move_up
this.Control[iCurrent+6]=this.cb_move_down
this.Control[iCurrent+7]=this.cb_sort
this.Control[iCurrent+8]=this.cb_ok
end on

on w_procedure_extra_charges_edit.destroy
call super::destroy
destroy(this.st_title)
destroy(this.dw_extra_charges)
destroy(this.cb_new)
destroy(this.cb_delete)
destroy(this.cb_move_up)
destroy(this.cb_move_down)
destroy(this.cb_sort)
destroy(this.cb_ok)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_procedure_extra_charges_edit
integer x = 0
integer y = 0
boolean enabled = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_procedure_extra_charges_edit
end type

type st_title from statictext within w_procedure_extra_charges_edit
integer width = 2926
integer height = 184
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Extra Charges"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_extra_charges from u_dw_pick_list within w_procedure_extra_charges_edit
integer y = 192
integer width = 1637
integer height = 1616
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_procedure_extra_charges"
boolean vscrollbar = true
boolean border = false
end type

event selected;if selected_row < rowcount() then
	cb_move_down.enabled = true
else
	cb_move_down.enabled = false
end if

if selected_row > 1 then
	cb_move_up.enabled = true
else
	cb_move_up.enabled = false
end if

cb_delete.enabled = true

end event

event unselected;cb_move_down.enabled = false
cb_move_up.enabled = false
cb_delete.enabled = false

end event

type cb_new from commandbutton within w_procedure_extra_charges_edit
integer x = 2057
integer y = 420
integer width = 416
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New"
end type

event clicked;str_popup popup
str_popup_return popup_return
str_picked_procedures lstr_procedures
long i
long ll_row
integer li_sts

popup.data_row_count = 1
popup.items[1] = procedure_type
popup.multiselect = true
openwithparm(w_pick_procedures, popup)
lstr_procedures = message.powerobjectparm
if lstr_procedures.procedure_count < 1 then return

for i = 1 to lstr_procedures.procedure_count
	// Insert new extra charge
	ll_row = dw_extra_charges.insertrow(0)
	dw_extra_charges.object.procedure_id[ll_row] = procedure_id
	dw_extra_charges.object.extra_procedure_id[ll_row] = lstr_procedures.procedures[i].procedure_id
	dw_extra_charges.object.order_flag[ll_row] = 'Auto'
	dw_extra_charges.object.sort_sequence[ll_row] = ll_row
next

// Update to Database
li_sts = dw_extra_charges.update()
If Not tf_check() Then Return


refresh()

end event

type cb_delete from commandbutton within w_procedure_extra_charges_edit
integer x = 2057
integer y = 600
integer width = 416
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;long ll_row
str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you wish to delete the selected extra charge?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

ll_row = dw_extra_charges.get_selected_row()
if ll_row <= 0 then return

dw_extra_charges.deleterow(ll_row)
dw_extra_charges.update()


end event

type cb_move_up from commandbutton within w_procedure_extra_charges_edit
integer x = 2057
integer y = 904
integer width = 416
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Up"
end type

event clicked;long i
long ll_rowcount
long ll_row

ll_row = dw_extra_charges.get_selected_row()
if ll_row <= 1 then return

ll_rowcount = dw_extra_charges.rowcount()

for i = 1 to ll_rowcount
	if i = ll_row - 1 then
		dw_extra_charges.object.sort_sequence[i] = ll_row
	elseif i = ll_row then
		dw_extra_charges.object.sort_sequence[i] = ll_row - 1
	else
		dw_extra_charges.object.sort_sequence[i] = i
	end if
next

dw_extra_charges.update()

dw_extra_charges.sort()

end event

type cb_move_down from commandbutton within w_procedure_extra_charges_edit
integer x = 2057
integer y = 1056
integer width = 416
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Down"
end type

event clicked;long i
long ll_rowcount
long ll_row


ll_rowcount = dw_extra_charges.rowcount()

ll_row = dw_extra_charges.get_selected_row()
if ll_row < 1 or i >= ll_rowcount then return

for i = 1 to ll_rowcount
	if i = ll_row + 1 then
		dw_extra_charges.object.sort_sequence[i] = ll_row
	elseif i = ll_row then
		dw_extra_charges.object.sort_sequence[i] = ll_row + 1
	else
		dw_extra_charges.object.sort_sequence[i] = i
	end if
next

dw_extra_charges.update()

dw_extra_charges.sort()

end event

type cb_sort from commandbutton within w_procedure_extra_charges_edit
integer x = 2057
integer y = 1208
integer width = 416
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sort"
end type

event clicked;long i
long ll_rowcount


ll_rowcount = dw_extra_charges.rowcount()
dw_extra_charges.setsort("description a")
dw_extra_charges.sort()


for i = 1 to ll_rowcount
	dw_extra_charges.object.sort_sequence[i] = i
next

dw_extra_charges.update()

dw_extra_charges.setsort("sort_sequence a")
dw_extra_charges.sort()

end event

type cb_ok from commandbutton within w_procedure_extra_charges_edit
integer x = 2473
integer y = 1660
integer width = 402
integer height = 112
integer taborder = 80
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

event clicked;close(parent)


end event

