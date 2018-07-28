HA$PBExportHeader$w_edit_treatment_type_list.srw
forward
global type w_edit_treatment_type_list from w_window_base
end type
type dw_treatment_type_list from u_dw_pick_list within w_edit_treatment_type_list
end type
type st_treatment_type_list from statictext within w_edit_treatment_type_list
end type
type st_title from statictext within w_edit_treatment_type_list
end type
type cb_add_treatment_type from commandbutton within w_edit_treatment_type_list
end type
type cb_move from commandbutton within w_edit_treatment_type_list
end type
type cb_remove from commandbutton within w_edit_treatment_type_list
end type
type cb_finished from commandbutton within w_edit_treatment_type_list
end type
type cb_cancel from commandbutton within w_edit_treatment_type_list
end type
type st_description from statictext within w_edit_treatment_type_list
end type
end forward

global type w_edit_treatment_type_list from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_treatment_type_list dw_treatment_type_list
st_treatment_type_list st_treatment_type_list
st_title st_title
cb_add_treatment_type cb_add_treatment_type
cb_move cb_move
cb_remove cb_remove
cb_finished cb_finished
cb_cancel cb_cancel
st_description st_description
end type
global w_edit_treatment_type_list w_edit_treatment_type_list

type variables
string treatment_list_id
end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long ll_count

ll_count = dw_treatment_type_list.retrieve(treatment_list_id)
if ll_count < 0 then return -1


return 1
end function

on w_edit_treatment_type_list.create
int iCurrent
call super::create
this.dw_treatment_type_list=create dw_treatment_type_list
this.st_treatment_type_list=create st_treatment_type_list
this.st_title=create st_title
this.cb_add_treatment_type=create cb_add_treatment_type
this.cb_move=create cb_move
this.cb_remove=create cb_remove
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
this.st_description=create st_description
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_treatment_type_list
this.Control[iCurrent+2]=this.st_treatment_type_list
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.cb_add_treatment_type
this.Control[iCurrent+5]=this.cb_move
this.Control[iCurrent+6]=this.cb_remove
this.Control[iCurrent+7]=this.cb_finished
this.Control[iCurrent+8]=this.cb_cancel
this.Control[iCurrent+9]=this.st_description
end on

on w_edit_treatment_type_list.destroy
call super::destroy
destroy(this.dw_treatment_type_list)
destroy(this.st_treatment_type_list)
destroy(this.st_title)
destroy(this.cb_add_treatment_type)
destroy(this.cb_move)
destroy(this.cb_remove)
destroy(this.cb_finished)
destroy(this.cb_cancel)
destroy(this.st_description)
end on

event open;call super::open;

treatment_list_id = message.stringparm
st_treatment_type_list.text = treatment_list_id

SELECT description
INTO :st_description.text
FROM c_Treatment_Type_List_Def
WHERE treatment_list_id = :treatment_list_id;
tf_check()

dw_treatment_type_list.settransobject(sqlca)

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_edit_treatment_type_list
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_edit_treatment_type_list
end type

type dw_treatment_type_list from u_dw_pick_list within w_edit_treatment_type_list
integer x = 78
integer y = 328
integer width = 1774
integer height = 1236
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_treatment_type_list_edit"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;cb_remove.enabled = true
cb_move.enabled = true

end event

event unselected;call super::unselected;cb_remove.enabled = false
cb_move.enabled = false


end event

type st_treatment_type_list from statictext within w_edit_treatment_type_list
integer x = 91
integer y = 184
integer width = 1627
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Qualifiers"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_edit_treatment_type_list
integer width = 2930
integer height = 136
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Edit Treatment Type List"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_add_treatment_type from commandbutton within w_edit_treatment_type_list
integer x = 1984
integer y = 620
integer width = 613
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Treatment Type"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_qualifier
long ll_row
integer li_sts
long i

popup.dataobject = "dw_treatment_type_edit_list"
popup.datacolumn = 2
popup.displaycolumn = 4
popup.multiselect = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 1 then return

for i = 1 to popup_return.item_count
	ll_row = dw_treatment_type_list.insertrow(0)
	dw_treatment_type_list.object.treatment_list_id[ll_row] = treatment_list_id
	dw_treatment_type_list.object.treatment_type[ll_row] = popup_return.items[i]
	dw_treatment_type_list.object.description[ll_row] = popup_return.descriptions[i]
	dw_treatment_type_list.object.sort_sequence[ll_row] = i
	dw_treatment_type_list.object.button[ll_row] = datalist.treatment_type_define_button(popup_return.items[i])
next



end event

type cb_move from commandbutton within w_edit_treatment_type_list
integer x = 1984
integer y = 932
integer width = 613
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Move"
end type

event clicked;str_popup popup

popup.objectparm = dw_treatment_type_list
openwithparm(w_pick_list_sort, popup)

end event

type cb_remove from commandbutton within w_edit_treatment_type_list
integer x = 1984
integer y = 776
integer width = 613
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Remove"
end type

event clicked;long ll_row

ll_row = dw_treatment_type_list.get_selected_row()

dw_treatment_type_list.deleterow(ll_row)

end event

type cb_finished from commandbutton within w_edit_treatment_type_list
integer x = 2450
integer y = 1664
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean default = true
end type

event clicked;integer li_sts

li_sts = dw_treatment_type_list.update()
if li_sts < 0 then
	openwithparm(w_pop_message, "Error updating treatment type list")
	return
end if


close(parent)

end event

type cb_cancel from commandbutton within w_edit_treatment_type_list
integer x = 50
integer y = 1664
integer width = 402
integer height = 112
integer taborder = 60
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

event clicked;close(parent)
end event

type st_description from statictext within w_edit_treatment_type_list
integer x = 1920
integer y = 208
integer width = 910
integer height = 272
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

