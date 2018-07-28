HA$PBExportHeader$w_observation_coding_elements.srw
forward
global type w_observation_coding_elements from w_window_base
end type
type st_cat_title from statictext within w_observation_coding_elements
end type
type dw_observation_elements from u_dw_pick_list within w_observation_coding_elements
end type
type st_observation from statictext within w_observation_coding_elements
end type
type st_title from statictext within w_observation_coding_elements
end type
type st_page from statictext within w_observation_coding_elements
end type
type pb_up from u_picture_button within w_observation_coding_elements
end type
type pb_down from u_picture_button within w_observation_coding_elements
end type
type cb_add_element from commandbutton within w_observation_coding_elements
end type
type cb_done from commandbutton within w_observation_coding_elements
end type
type cb_remove_element from commandbutton within w_observation_coding_elements
end type
type st_result_count_title from statictext within w_observation_coding_elements
end type
type st_result_count from statictext within w_observation_coding_elements
end type
end forward

global type w_observation_coding_elements from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_cat_title st_cat_title
dw_observation_elements dw_observation_elements
st_observation st_observation
st_title st_title
st_page st_page
pb_up pb_up
pb_down pb_down
cb_add_element cb_add_element
cb_done cb_done
cb_remove_element cb_remove_element
st_result_count_title st_result_count_title
st_result_count st_result_count
end type
global w_observation_coding_elements w_observation_coding_elements

type variables
string observation_id

long result_count

end variables

on w_observation_coding_elements.create
int iCurrent
call super::create
this.st_cat_title=create st_cat_title
this.dw_observation_elements=create dw_observation_elements
this.st_observation=create st_observation
this.st_title=create st_title
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_add_element=create cb_add_element
this.cb_done=create cb_done
this.cb_remove_element=create cb_remove_element
this.st_result_count_title=create st_result_count_title
this.st_result_count=create st_result_count
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_cat_title
this.Control[iCurrent+2]=this.dw_observation_elements
this.Control[iCurrent+3]=this.st_observation
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.st_page
this.Control[iCurrent+6]=this.pb_up
this.Control[iCurrent+7]=this.pb_down
this.Control[iCurrent+8]=this.cb_add_element
this.Control[iCurrent+9]=this.cb_done
this.Control[iCurrent+10]=this.cb_remove_element
this.Control[iCurrent+11]=this.st_result_count_title
this.Control[iCurrent+12]=this.st_result_count
end on

on w_observation_coding_elements.destroy
call super::destroy
destroy(this.st_cat_title)
destroy(this.dw_observation_elements)
destroy(this.st_observation)
destroy(this.st_title)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_add_element)
destroy(this.cb_done)
destroy(this.cb_remove_element)
destroy(this.st_result_count_title)
destroy(this.st_result_count)
end on

event open;call super::open;str_popup popup
long ll_rows
string ls_specialty_id
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

dw_observation_elements.settransobject(sqlca)

ll_rows = dw_observation_elements.retrieve(observation_id)
if ll_rows < 0 then
	log.log(this, "open", "Error getting observation elements", 4)
	close(this)
	return
end if

// Up/down buttons
dw_observation_elements.set_page(1, pb_up, pb_down, st_page)


SELECT result_count
INTO :result_count
FROM c_Observation
WHERE observation_id = :observation_id;
if not tf_check() then return

if not isnull(result_count) then
	st_result_count.text = string(result_count)
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_coding_elements
integer x = 2071
integer y = 1676
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_observation_coding_elements
integer x = 18
integer y = 1664
end type

type st_cat_title from statictext within w_observation_coding_elements
integer x = 165
integer y = 292
integer width = 2514
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Coding Elements"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_observation_elements from u_dw_pick_list within w_observation_coding_elements
integer x = 165
integer y = 376
integer width = 2514
integer height = 888
integer taborder = 10
string dataobject = "dw_em_observation_element_list"
boolean border = false
end type

event selected(long selected_row);call super::selected;cb_remove_element.enabled = true

end event

event unselected(long unselected_row);call super::unselected;cb_remove_element.enabled = false

end event

type st_observation from statictext within w_observation_coding_elements
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

type st_title from statictext within w_observation_coding_elements
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
string text = "Observation Coding Elements"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_page from statictext within w_observation_coding_elements
integer x = 2514
integer y = 308
integer width = 297
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_observation_coding_elements
boolean visible = false
integer x = 2674
integer y = 384
integer width = 137
integer height = 116
integer taborder = 11
boolean bringtotop = true
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_observation_elements.current_page

dw_observation_elements.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_observation_coding_elements
boolean visible = false
integer x = 2674
integer y = 508
integer width = 137
integer height = 116
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_observation_elements.current_page
li_last_page = dw_observation_elements.last_page

dw_observation_elements.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type cb_add_element from commandbutton within w_observation_coding_elements
integer x = 1559
integer y = 1328
integer width = 581
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Element"
end type

event clicked;long ll_row
str_popup popup
str_popup_return popup_return
integer li_sts

popup.title = st_observation.text

openwithparm(w_coding_element_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 4 then return

ll_row = dw_observation_elements.insertrow(0)
dw_observation_elements.object.em_component[ll_row] = popup_return.items[1]
dw_observation_elements.object.em_type[ll_row] = popup_return.items[2]
dw_observation_elements.object.em_category[ll_row] = popup_return.items[3]
dw_observation_elements.object.em_element[ll_row] = popup_return.items[4]
dw_observation_elements.object.observation_id[ll_row] = observation_id

li_sts = dw_observation_elements.update()

end event

type cb_done from commandbutton within w_observation_coding_elements
integer x = 2432
integer y = 1672
integer width = 402
integer height = 112
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;close(parent)

end event

type cb_remove_element from commandbutton within w_observation_coding_elements
integer x = 722
integer y = 1328
integer width = 581
integer height = 112
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Remove Element"
end type

event clicked;long ll_row
integer li_sts

ll_row = dw_observation_elements.get_selected_row()
if ll_row > 0 then
	dw_observation_elements.deleterow(ll_row)
	li_sts = dw_observation_elements.update()
end if

end event

type st_result_count_title from statictext within w_observation_coding_elements
integer x = 379
integer y = 1500
integer width = 1778
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Default result count when results haven~'t been entered yet:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_result_count from statictext within w_observation_coding_elements
integer x = 2199
integer y = 1480
integer width = 402
integer height = 112
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
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_result_count

popup.realitem = real(result_count)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

ll_result_count = long(popup_return.realitem)

UPDATE c_Observation
SET result_count = :ll_result_count
WHERE observation_id = :observation_id;
if not tf_check() then return

result_count = ll_result_count
text = string(result_count)


end event

