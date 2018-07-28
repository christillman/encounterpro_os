$PBExportHeader$w_observation_treatment_types.srw
forward
global type w_observation_treatment_types from w_window_base
end type
type cb_add_treatment_type from commandbutton within w_observation_treatment_types
end type
type st_1 from statictext within w_observation_treatment_types
end type
type dw_treatment_types from u_dw_pick_list within w_observation_treatment_types
end type
type st_observation from statictext within w_observation_treatment_types
end type
type st_title from statictext within w_observation_treatment_types
end type
type pb_cancel from u_picture_button within w_observation_treatment_types
end type
type pb_done from u_picture_button within w_observation_treatment_types
end type
type pb_up from u_picture_button within w_observation_treatment_types
end type
type pb_down from u_picture_button within w_observation_treatment_types
end type
type st_page from statictext within w_observation_treatment_types
end type
type dw_categories from datawindow within w_observation_treatment_types
end type
type st_2 from statictext within w_observation_treatment_types
end type
type cb_remove_treatment_type from commandbutton within w_observation_treatment_types
end type
end forward

global type w_observation_treatment_types from w_window_base
integer x = 0
integer y = 0
integer height = 1832
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_add_treatment_type cb_add_treatment_type
st_1 st_1
dw_treatment_types dw_treatment_types
st_observation st_observation
st_title st_title
pb_cancel pb_cancel
pb_done pb_done
pb_up pb_up
pb_down pb_down
st_page st_page
dw_categories dw_categories
st_2 st_2
cb_remove_treatment_type cb_remove_treatment_type
end type
global w_observation_treatment_types w_observation_treatment_types

type variables
string observation_id
u_ds_data categories

end variables

forward prototypes
public function integer save_changes ()
public subroutine set_treatment_type (string ps_treatment_type)
end prototypes

public function integer save_changes ();integer li_sts

li_sts = dw_treatment_types.update()
if li_sts < 0 then return -1


return 1

end function

public subroutine set_treatment_type (string ps_treatment_type);string ls_filter

if isnull(ps_treatment_type) then
	dw_categories.reset()
	return
end if

dw_categories.settransobject(sqlca)
dw_categories.retrieve(observation_id, ps_treatment_type)

cb_remove_treatment_type.enabled = true

end subroutine

on w_observation_treatment_types.create
int iCurrent
call super::create
this.cb_add_treatment_type=create cb_add_treatment_type
this.st_1=create st_1
this.dw_treatment_types=create dw_treatment_types
this.st_observation=create st_observation
this.st_title=create st_title
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.dw_categories=create dw_categories
this.st_2=create st_2
this.cb_remove_treatment_type=create cb_remove_treatment_type
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_treatment_type
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_treatment_types
this.Control[iCurrent+4]=this.st_observation
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.pb_cancel
this.Control[iCurrent+7]=this.pb_done
this.Control[iCurrent+8]=this.pb_up
this.Control[iCurrent+9]=this.pb_down
this.Control[iCurrent+10]=this.st_page
this.Control[iCurrent+11]=this.dw_categories
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.cb_remove_treatment_type
end on

on w_observation_treatment_types.destroy
call super::destroy
destroy(this.cb_add_treatment_type)
destroy(this.st_1)
destroy(this.dw_treatment_types)
destroy(this.st_observation)
destroy(this.st_title)
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.dw_categories)
destroy(this.st_2)
destroy(this.cb_remove_treatment_type)
end on

event open;call super::open;str_popup popup
long ll_rows
string ls_treatment_type
string ls_observation_category_id
long i
string ls_find
long ll_row

popup = message.powerobjectparm

if popup.data_row_count <> 1 then
	log.log(this, "open", "Invalid Parameters", 4)
	close(this)
	return
end if

observation_id = popup.items[1]
if isnull(popup.title) or trim(popup.title) = "" then
	st_observation.text = datalist.observation_description(observation_id)
else
	st_observation.text = popup.title
end if

dw_treatment_types.settransobject(sqlca)

ll_rows = dw_treatment_types.retrieve(observation_id)
if ll_rows < 0 then
	log.log(this, "open", "Error getting treatment types", 4)
	close(this)
	return
end if
dw_treatment_types.set_page(1, st_page.text)
if dw_treatment_types.last_page > 1 then
	pb_up.visible = true
	pb_down.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
	st_page.visible = true
else
	pb_up.visible = false
	pb_down.visible = false
	st_page.visible = false
end if

if ll_rows > 0 then
	dw_treatment_types.object.selected_flag[1] = 1
	ls_treatment_type = dw_treatment_types.object.treatment_type[1]
	set_treatment_type(ls_treatment_type)
else
	cb_remove_treatment_type.enabled = false
end if



end event

event close;call super::close;if not isnull(categories) and isvalid(categories) then DESTROY categories
end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_treatment_types
end type

type cb_add_treatment_type from commandbutton within w_observation_treatment_types
integer x = 1646
integer y = 384
integer width = 695
integer height = 112
integer taborder = 20
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
long ll_row
string ls_find

popup.dataobject = "dw_observation_treatment_types"
popup.datacolumn = 2
popup.displaycolumn = 4
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_find = "treatment_type='" + popup_return.items[1] + "'"
ll_row = dw_treatment_types.find(ls_find, 1, dw_treatment_types.rowcount())
if ll_row <= 0 then
	dw_treatment_types.clear_selected()
	ll_row = dw_treatment_types.insertrow(0)
	dw_treatment_types.object.observation_id[ll_row] = observation_id
	dw_treatment_types.object.treatment_type[ll_row] = popup_return.items[1]
	dw_treatment_types.object.description[ll_row] = popup_return.descriptions[1]
	dw_treatment_types.object.selected_flag[ll_row] = 1
end if

dw_treatment_types.scrolltorow(ll_row)
dw_treatment_types.recalc_page(st_page.text)
if dw_treatment_types.last_page <= 1 then
	pb_up.visible = false
	pb_down.visible = false
	st_page.visible = false
else
	pb_up.visible = true
	pb_down.visible = true
	st_page.visible = true
	if dw_treatment_types.current_page < dw_treatment_types.last_page then
		pb_down.enabled = true
	else
		pb_down.enabled = false
	end if
	if dw_treatment_types.current_page > 1 then
		pb_up.enabled = true
	else
		pb_up.enabled = false
	end if
end if
set_treatment_type(popup_return.items[1])



end event

type st_1 from statictext within w_observation_treatment_types
integer x = 379
integer y = 288
integer width = 1056
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Treatment Types"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_treatment_types from u_dw_pick_list within w_observation_treatment_types
integer x = 379
integer y = 376
integer width = 1056
integer height = 1104
integer taborder = 10
string dataobject = "dw_observation_treatment_type_edit"
boolean border = false
end type

event selected;call super::selected;string ls_treatment_type

ls_treatment_type = dw_treatment_types.object.treatment_type[selected_row]
set_treatment_type(ls_treatment_type)

end event

event unselected;call super::unselected;string ls_null

setnull(ls_null)

set_treatment_type(ls_null)

cb_remove_treatment_type.enabled = false

end event

type st_observation from statictext within w_observation_treatment_types
integer y = 120
integer width = 2921
integer height = 96
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "observation description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_observation_treatment_types
integer width = 2921
integer height = 116
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Treatment Types Associated with Observation"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_observation_treatment_types
integer x = 101
integer y = 1560
integer taborder = 0
boolean bringtotop = true
boolean cancel = true
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;close(parent)


end event

type pb_done from u_picture_button within w_observation_treatment_types
event clicked pbm_bnclicked
integer x = 2569
integer y = 1560
integer taborder = 40
boolean default = true
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;integer li_sts

li_sts = save_changes()

close(parent)

end event

type pb_up from u_picture_button within w_observation_treatment_types
integer x = 1426
integer y = 384
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_treatment_types.current_page

dw_treatment_types.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_observation_treatment_types
integer x = 1426
integer y = 516
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_treatment_types.current_page
li_last_page = dw_treatment_types.last_page

dw_treatment_types.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_observation_treatment_types
integer x = 1285
integer y = 316
integer width = 288
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_categories from datawindow within w_observation_treatment_types
integer x = 1819
integer y = 860
integer width = 690
integer height = 608
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "dw_observation_category_display"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event clicked;integer li_sts
str_popup popup
long ll_row
string ls_treatment_type

li_sts = save_changes()
if li_sts < 0 then return


ll_row = dw_treatment_types.get_selected_row()
if ll_row <= 0 then return

ls_treatment_type = dw_treatment_types.object.treatment_type[ll_row]

popup.data_row_count = 2
popup.items[1] = observation_id
popup.items[2] = ls_treatment_type

openwithparm(w_observation_categories, popup)

set_treatment_type(ls_treatment_type)


end event

type st_2 from statictext within w_observation_treatment_types
integer x = 1819
integer y = 784
integer width = 690
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
string text = "Categories"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_remove_treatment_type from commandbutton within w_observation_treatment_types
integer x = 1650
integer y = 540
integer width = 695
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Remove Treatment Type"
end type

event clicked;long ll_row

ll_row = dw_treatment_types.get_selected_row()
if ll_row <= 0 then return

dw_treatment_types.deleterow(0)

end event

