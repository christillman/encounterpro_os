HA$PBExportHeader$w_assessment_treatment_children.srw
forward
global type w_assessment_treatment_children from w_window_base
end type
type pb_down from u_picture_button within w_assessment_treatment_children
end type
type pb_up from u_picture_button within w_assessment_treatment_children
end type
type st_page from statictext within w_assessment_treatment_children
end type
type st_no_items from statictext within w_assessment_treatment_children
end type
type cb_done from commandbutton within w_assessment_treatment_children
end type
type cb_add from commandbutton within w_assessment_treatment_children
end type
type dw_treatments from u_dw_treatment_list within w_assessment_treatment_children
end type
type st_title from statictext within w_assessment_treatment_children
end type
end forward

global type w_assessment_treatment_children from w_window_base
integer x = 201
integer y = 96
integer width = 2427
integer height = 1708
windowtype windowtype = response!
pb_down pb_down
pb_up pb_up
st_page st_page
st_no_items st_no_items
cb_done cb_done
cb_add cb_add
dw_treatments dw_treatments
st_title st_title
end type
global w_assessment_treatment_children w_assessment_treatment_children

type variables
string treatment_list_id
str_assessment_treatment_definition parent_treatment_def


end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer li_sts

li_sts = dw_treatments.show_treatments(parent_treatment_def.definition_id)
dw_treatments.set_page(1, pb_up, pb_down, st_page)
if dw_treatments.rowcount() > 0 then
	st_no_items.visible = false
	dw_treatments.visible = true
else
	st_no_items.visible = true
	dw_treatments.visible = false
end if

return li_sts

end function

event open;call super::open;str_popup popup
string ls_null
string ls_in_office_flag
boolean lb_in_office
long i
long ll_rows
long ll_row
string ls_temp

setnull(ls_null)

parent_treatment_def = message.powerobjectparm

st_title.text             = parent_treatment_def.treatment_description

if (parent_treatment_def.common_list and not current_user.check_privilege("Common Treatment Lists")) then
	cb_add.visible = false
else
	cb_add.visible = true
end if

Refresh()


end event

on w_assessment_treatment_children.create
int iCurrent
call super::create
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.st_no_items=create st_no_items
this.cb_done=create cb_done
this.cb_add=create cb_add
this.dw_treatments=create dw_treatments
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_down
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.st_no_items
this.Control[iCurrent+5]=this.cb_done
this.Control[iCurrent+6]=this.cb_add
this.Control[iCurrent+7]=this.dw_treatments
this.Control[iCurrent+8]=this.st_title
end on

on w_assessment_treatment_children.destroy
call super::destroy
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.st_no_items)
destroy(this.cb_done)
destroy(this.cb_add)
destroy(this.dw_treatments)
destroy(this.st_title)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_assessment_treatment_children
integer x = 1070
integer y = 1476
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_assessment_treatment_children
integer x = 59
integer y = 1416
end type

type pb_down from u_picture_button within w_assessment_treatment_children
integer x = 2199
integer y = 348
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;string ls_temp
integer li_page
integer li_last_page

li_page = dw_treatments.current_page
li_last_page = dw_treatments.last_page

dw_treatments.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within w_assessment_treatment_children
integer x = 2199
integer y = 220
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;string ls_temp
integer li_page

li_page = dw_treatments.current_page

dw_treatments.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_assessment_treatment_children
integer x = 2199
integer y = 472
integer width = 155
integer height = 132
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
boolean focusrectangle = false
end type

type st_no_items from statictext within w_assessment_treatment_children
integer x = 297
integer y = 572
integer width = 1824
integer height = 284
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "There are no items defined for this  treatment."
boolean focusrectangle = false
end type

type cb_done from commandbutton within w_assessment_treatment_children
integer x = 1774
integer y = 1472
integer width = 539
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Done"
boolean default = true
end type

event clicked;close(parent)

end event

type cb_add from commandbutton within w_assessment_treatment_children
integer x = 82
integer y = 1472
integer width = 539
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Treatment"
end type

event clicked;integer li_sts

li_sts = dw_treatments.add_new_treatment(parent_treatment_def)

refresh()

end event

type dw_treatments from u_dw_treatment_list within w_assessment_treatment_children
integer x = 187
integer y = 220
integer width = 1993
integer height = 1192
integer taborder = 20
boolean border = false
end type

event selected;call super::selected;edit_treatment_item(selected_row)
clear_selected()

end event

type st_title from statictext within w_assessment_treatment_children
integer width = 2423
integer height = 200
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

