$PBExportHeader$w_pick_location_domain.srw
forward
global type w_pick_location_domain from w_window_base
end type
type pb_cancel from u_picture_button within w_pick_location_domain
end type
type pb_done from u_picture_button within w_pick_location_domain
end type
type st_cat_title from statictext within w_pick_location_domain
end type
type st_title from statictext within w_pick_location_domain
end type
type cb_new_location_domain from commandbutton within w_pick_location_domain
end type
type dw_location_domains from u_dw_pick_list within w_pick_location_domain
end type
type dw_locations from u_dw_pick_list within w_pick_location_domain
end type
type st_q_title from statictext within w_pick_location_domain
end type
type pb_help from u_pb_help_button within w_pick_location_domain
end type
type pb_up from u_picture_button within w_pick_location_domain
end type
type pb_down from u_picture_button within w_pick_location_domain
end type
type st_page from statictext within w_pick_location_domain
end type
type st_desc from statictext within w_pick_location_domain
end type
type st_desc_search from statictext within w_pick_location_domain
end type
type cb_clear_filter from commandbutton within w_pick_location_domain
end type
end forward

global type w_pick_location_domain from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_cancel pb_cancel
pb_done pb_done
st_cat_title st_cat_title
st_title st_title
cb_new_location_domain cb_new_location_domain
dw_location_domains dw_location_domains
dw_locations dw_locations
st_q_title st_q_title
pb_help pb_help
pb_up pb_up
pb_down pb_down
st_page st_page
st_desc st_desc
st_desc_search st_desc_search
cb_clear_filter cb_clear_filter
end type
global w_pick_location_domain w_pick_location_domain

type variables

string location_domain



end variables

on w_pick_location_domain.create
int iCurrent
call super::create
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.st_cat_title=create st_cat_title
this.st_title=create st_title
this.cb_new_location_domain=create cb_new_location_domain
this.dw_location_domains=create dw_location_domains
this.dw_locations=create dw_locations
this.st_q_title=create st_q_title
this.pb_help=create pb_help
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_desc=create st_desc
this.st_desc_search=create st_desc_search
this.cb_clear_filter=create cb_clear_filter
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_cancel
this.Control[iCurrent+2]=this.pb_done
this.Control[iCurrent+3]=this.st_cat_title
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.cb_new_location_domain
this.Control[iCurrent+6]=this.dw_location_domains
this.Control[iCurrent+7]=this.dw_locations
this.Control[iCurrent+8]=this.st_q_title
this.Control[iCurrent+9]=this.pb_help
this.Control[iCurrent+10]=this.pb_up
this.Control[iCurrent+11]=this.pb_down
this.Control[iCurrent+12]=this.st_page
this.Control[iCurrent+13]=this.st_desc
this.Control[iCurrent+14]=this.st_desc_search
this.Control[iCurrent+15]=this.cb_clear_filter
end on

on w_pick_location_domain.destroy
call super::destroy
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.st_cat_title)
destroy(this.st_title)
destroy(this.cb_new_location_domain)
destroy(this.dw_location_domains)
destroy(this.dw_locations)
destroy(this.st_q_title)
destroy(this.pb_help)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_desc)
destroy(this.st_desc_search)
destroy(this.cb_clear_filter)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts
string ls_location_domain
long ll_rows
string ls_find
long ll_row

popup_return.item_count = 0

ls_location_domain = message.stringparm

dw_location_domains.settransobject(sqlca)
dw_locations.settransobject(sqlca)

ll_rows = dw_location_domains.retrieve()
if ll_rows < 0 then
	log.log(this, "open", "Error getting location domains", 4)
	closewithreturn(this, popup_return)
	return
end if

if not isnull(ls_location_domain) then
	ls_find = "location_domain='" + ls_location_domain + "'"
	ll_row = dw_location_domains.find(ls_find, 1, ll_rows)
	if ll_row > 0 then
		dw_location_domains.object.selected_flag[ll_row] = 1
		dw_location_domains.scrolltorow(ll_row)
		dw_location_domains.event trigger selected(ll_row)
	end if
end if

pb_done.enabled = false
dw_location_domains.set_page(1, pb_up, pb_down, st_page)


end event

type pb_epro_help from w_window_base`pb_epro_help within w_pick_location_domain
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_location_domain
end type

type pb_cancel from u_picture_button within w_pick_location_domain
integer x = 87
integer y = 1568
integer taborder = 60
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_done from u_picture_button within w_pick_location_domain
integer x = 2569
integer y = 1556
integer taborder = 10
boolean bringtotop = true
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
long ll_row

ll_row = dw_location_domains.get_selected_row()
if ll_row <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = dw_location_domains.object.location_domain[ll_row]
popup_return.descriptions[1] = dw_location_domains.object.description[ll_row]

closewithreturn(parent, popup_return)

end event

type st_cat_title from statictext within w_pick_location_domain
integer x = 315
integer y = 184
integer width = 1070
integer height = 84
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
string text = "Location Domains"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_pick_location_domain
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
string text = "Select Location Domain"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_new_location_domain from commandbutton within w_pick_location_domain
integer x = 1554
integer y = 1664
integer width = 631
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Location Domain"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_description
long ll_row
integer li_sts
integer i
string ls_location_domain
string ls_suffix
string ls_prefix
integer li_count

popup.title = "Enter New Location Domain Description"
popup.item = ""
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 1 then return

ls_description = popup_return.items[1]

ll_row = dw_location_domains.insertrow(0)
ls_prefix = f_gen_key_string(ls_description, 12)
ls_location_domain = ls_prefix
// Now make sure the new key is unique
for i = 1 to 99
	SELECT count(*)
	INTO :li_count
	FROM c_Location_Domain
	WHERE location_domain = :ls_location_domain;
	if not tf_check() then return
	if li_count = 0 then exit
	ls_suffix = string(i)
	ls_location_domain = left(ls_prefix, 12 - len(ls_suffix)) + ls_suffix
next
if i = 99 then
	log.log(this, "clicked", "Unable to generate unique key (" + ls_location_domain + ")", 4)
	return
end if

dw_location_domains.object.location_domain[ll_row] = ls_location_domain
dw_location_domains.object.description[ll_row] = ls_description

li_sts = dw_location_domains.update()
if li_sts < 0 then return

dw_location_domains.clear_selected()
dw_location_domains.object.selected_flag[ll_row] = 1
dw_location_domains.scrolltorow(ll_row)
// up & dn buttons
dw_location_domains.recalc_page(st_page.text)
if dw_location_domains.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = true
	pb_down.enabled = true
end if
pb_done.enabled = true


popup.data_row_count = 1
popup.items[1] = string(ls_location_domain)
openwithparm(w_location_domain_edit, popup)


dw_locations.retrieve(ls_location_domain)


end event

type dw_location_domains from u_dw_pick_list within w_pick_location_domain
integer x = 347
integer y = 268
integer width = 1161
integer height = 1364
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_location_domain_list"
boolean border = false
boolean livescroll = false
end type

event selected;call super::selected;location_domain = dw_location_domains.object.location_domain[selected_row]

dw_locations.retrieve(location_domain)

pb_done.enabled = true

end event

event unselected;call super::unselected;
pb_done.enabled = false
dw_locations.reset()
dw_locations.settransobject(sqlca)

end event

type dw_locations from u_dw_pick_list within w_pick_location_domain
integer x = 1797
integer y = 688
integer width = 955
integer height = 828
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_location_display_list_small"
boolean hscrollbar = true
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_popup popup
string ls_location_domain
long ll_row

ll_row = dw_location_domains.get_selected_row()
if ll_row <= 0 then return

ls_location_domain = dw_location_domains.object.location_domain[ll_row]

popup.data_row_count = 1
popup.items[1] = string(ls_location_domain)
openwithparm(w_location_domain_edit, popup)

retrieve(ls_location_domain)

end event

type st_q_title from statictext within w_pick_location_domain
integer x = 1797
integer y = 608
integer width = 955
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Locations"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_help from u_pb_help_button within w_pick_location_domain
integer x = 2661
integer y = 16
integer taborder = 20
boolean bringtotop = true
end type

type pb_up from u_picture_button within w_pick_location_domain
boolean visible = false
integer x = 1509
integer y = 272
integer width = 137
integer height = 116
integer taborder = 11
boolean bringtotop = true
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_location_domains.current_page

dw_location_domains.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_location_domain
boolean visible = false
integer x = 1509
integer y = 396
integer width = 137
integer height = 116
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_location_domains.current_page
li_last_page = dw_location_domains.last_page

dw_location_domains.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type st_page from statictext within w_pick_location_domain
integer x = 1326
integer y = 200
integer width = 320
integer height = 60
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

type st_desc from statictext within w_pick_location_domain
integer x = 1723
integer y = 276
integer width = 407
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Filter"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;String ls_filter,ls_description
str_popup_return popup_return


openwithparm(w_pop_get_string_abc, "contains", parent)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_description = lower(popup_return.items[1])

st_desc_search.text = popup_return.descriptions[1]
st_desc_search.visible = true
cb_clear_filter.visible = true
backcolor = color_object_selected

//current_search = "DESCRIPTION"

ls_filter = "lower(description) like '"+ls_description+"'"
dw_location_domains.Setfilter(ls_filter)
dw_location_domains.filter()

end event

type st_desc_search from statictext within w_pick_location_domain
boolean visible = false
integer x = 2181
integer y = 276
integer width = 640
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
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

type cb_clear_filter from commandbutton within w_pick_location_domain
boolean visible = false
integer x = 2478
integer y = 396
integer width = 343
integer height = 88
integer taborder = 31
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear Filter"
end type

event clicked;dw_location_domains.Setfilter("")
dw_location_domains.filter()
visible = false
st_desc_search.visible = false
st_desc.backcolor = color_object


end event

