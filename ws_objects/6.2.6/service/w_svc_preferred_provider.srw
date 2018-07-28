HA$PBExportHeader$w_svc_preferred_provider.srw
forward
global type w_svc_preferred_provider from w_svc_generic
end type
type dw_authorities from u_dw_pick_list within w_svc_preferred_provider
end type
type dw_providers from u_dw_pick_list within w_svc_preferred_provider
end type
type cb_set from commandbutton within w_svc_preferred_provider
end type
type cb_clear from commandbutton within w_svc_preferred_provider
end type
type cb_2 from commandbutton within w_svc_preferred_provider
end type
type cb_category from commandbutton within w_svc_preferred_provider
end type
type cb_specialty from commandbutton within w_svc_preferred_provider
end type
type cb_new from commandbutton within w_svc_preferred_provider
end type
type cb_1 from commandbutton within w_svc_preferred_provider
end type
type pb_provider_up from u_picture_button within w_svc_preferred_provider
end type
type pb_provider_down from u_picture_button within w_svc_preferred_provider
end type
type st_provider_page from statictext within w_svc_preferred_provider
end type
type pb_authority_up from u_picture_button within w_svc_preferred_provider
end type
type pb_authority_down from u_picture_button within w_svc_preferred_provider
end type
type st_authority from statictext within w_svc_preferred_provider
end type
type st_1 from statictext within w_svc_preferred_provider
end type
end forward

global type w_svc_preferred_provider from w_svc_generic
dw_authorities dw_authorities
dw_providers dw_providers
cb_set cb_set
cb_clear cb_clear
cb_2 cb_2
cb_category cb_category
cb_specialty cb_specialty
cb_new cb_new
cb_1 cb_1
pb_provider_up pb_provider_up
pb_provider_down pb_provider_down
st_provider_page st_provider_page
pb_authority_up pb_authority_up
pb_authority_down pb_authority_down
st_authority st_authority
st_1 st_1
end type
global w_svc_preferred_provider w_svc_preferred_provider

type variables
string authority_id
string authority_type='%'
string authority_category='%'
string specialty_id='%'

u_ds_data preferred_providers
end variables

forward prototypes
public function integer refresh_authorities ()
public function integer refresh_providers ()
end prototypes

public function integer refresh_authorities ();long ll_rows

dw_authorities.setredraw(false)
ll_rows = dw_authorities.retrieve(authority_type,authority_category,'OK')

dw_providers.visible = false
cb_set.visible = false
cb_clear.visible = false
pb_provider_up.visible = false
pb_provider_down.visible = false
st_provider_page.visible = false

dw_authorities.set_page(1,pb_authority_up,pb_authority_down,st_authority)
dw_authorities.setredraw(true)
return ll_rows
end function

public function integer refresh_providers ();string ls_null
long i,ll_rowcount

setnull(ls_null)
dw_providers.setredraw(false)
ll_rowcount =  dw_providers.retrieve(ls_null,specialty_id,authority_id)
// Preferred Providers
preferred_providers.update()
preferred_providers.retrieve(authority_id)
If ll_rowcount > 0 Then
	dw_providers.visible = true
	cb_set.visible = true
	cb_clear.visible = true
	for i = 1 to ll_rowcount
		if dw_providers.object.authority_id[i] = authority_id then
			dw_providers.object.selected_flag[i] = 1
		else
			dw_providers.object.selected_flag[i] = 0
		end If
	next
Else
	dw_providers.visible = false
	cb_set.visible = false
	cb_clear.visible = false
End If
dw_providers.set_page(1,pb_provider_up,pb_provider_down,st_provider_page)
dw_providers.setredraw(true)

Return ll_rowcount
end function

on w_svc_preferred_provider.create
int iCurrent
call super::create
this.dw_authorities=create dw_authorities
this.dw_providers=create dw_providers
this.cb_set=create cb_set
this.cb_clear=create cb_clear
this.cb_2=create cb_2
this.cb_category=create cb_category
this.cb_specialty=create cb_specialty
this.cb_new=create cb_new
this.cb_1=create cb_1
this.pb_provider_up=create pb_provider_up
this.pb_provider_down=create pb_provider_down
this.st_provider_page=create st_provider_page
this.pb_authority_up=create pb_authority_up
this.pb_authority_down=create pb_authority_down
this.st_authority=create st_authority
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_authorities
this.Control[iCurrent+2]=this.dw_providers
this.Control[iCurrent+3]=this.cb_set
this.Control[iCurrent+4]=this.cb_clear
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_category
this.Control[iCurrent+7]=this.cb_specialty
this.Control[iCurrent+8]=this.cb_new
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.pb_provider_up
this.Control[iCurrent+11]=this.pb_provider_down
this.Control[iCurrent+12]=this.st_provider_page
this.Control[iCurrent+13]=this.pb_authority_up
this.Control[iCurrent+14]=this.pb_authority_down
this.Control[iCurrent+15]=this.st_authority
this.Control[iCurrent+16]=this.st_1
end on

on w_svc_preferred_provider.destroy
call super::destroy
destroy(this.dw_authorities)
destroy(this.dw_providers)
destroy(this.cb_set)
destroy(this.cb_clear)
destroy(this.cb_2)
destroy(this.cb_category)
destroy(this.cb_specialty)
destroy(this.cb_new)
destroy(this.cb_1)
destroy(this.pb_provider_up)
destroy(this.pb_provider_down)
destroy(this.st_provider_page)
destroy(this.pb_authority_up)
destroy(this.pb_authority_down)
destroy(this.st_authority)
destroy(this.st_1)
end on

event open;call super::open;preferred_providers = Create u_ds_data
preferred_providers.set_dataobject("dw_preferred_provider")
preferred_providers.settransobject(SQLCA)
refresh_authorities()
end event

event close;call super::close;destroy preferred_providers
end event

type pb_epro_help from w_svc_generic`pb_epro_help within w_svc_preferred_provider
boolean visible = true
integer x = 41
integer y = 1616
end type

type st_config_mode_menu from w_svc_generic`st_config_mode_menu within w_svc_preferred_provider
end type

type cb_finished from w_svc_generic`cb_finished within w_svc_preferred_provider
end type

event cb_finished::clicked;preferred_providers.update()
super::event clicked()
end event

type cb_be_back from w_svc_generic`cb_be_back within w_svc_preferred_provider
end type

type cb_cancel from w_svc_generic`cb_cancel within w_svc_preferred_provider
end type

type st_title from w_svc_generic`st_title within w_svc_preferred_provider
integer width = 2917
string text = "Preferred Provider"
end type

type dw_authorities from u_dw_pick_list within w_svc_preferred_provider
integer x = 37
integer y = 160
integer width = 1161
integer height = 1136
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_insurance_display_list"
boolean border = false
end type

event selected(long selected_row);call super::selected;string ls_null

Setnull(ls_null)
if selected_row <= 0 then return

authority_id = object.authority_id[selected_row]
// update the list 
preferred_providers.update()
refresh_providers()

end event

event unselected(long unselected_row);call super::unselected;dw_providers.visible = false
cb_set.visible = false
cb_clear.visible = false
pb_provider_up.visible = false
pb_provider_down.visible = false

end event

event constructor;call super::constructor;settransobject(sqlca)
end event

type dw_providers from u_dw_pick_list within w_svc_preferred_provider
integer x = 1422
integer y = 160
integer width = 1175
integer height = 1128
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_sp_get_preferred_provider"
boolean border = false
end type

event constructor;call super::constructor;settransobject(sqlca)
multiselect = true
end event

event selected(long selected_row);call super::selected;string ls_authority_id
string ls_consultant_id
long	 ll_row

ls_authority_id = object.authority_id[selected_row]
ls_consultant_id = object.consultant_id[selected_row]
If isnull(ls_authority_id) OR len(ls_authority_id) = 0 Then
	object.selected_flag[selected_row] = 1
	object.authority_id[selected_row] = authority_id
	ll_row = preferred_providers.insertrow(0)
	preferred_providers.object.consultant_id[ll_row] = ls_consultant_id
	preferred_providers.object.authority_id[ll_row] = authority_id
End If
end event

event unselected(long unselected_row);call super::unselected;string ls_authority_id,ls_null
long	 ll_find

setnull(ls_null)
object.selected_flag[unselected_row] = 0
object.authority_id[unselected_row] = ls_null
ll_find = preferred_providers.find("authority_id='"+authority_id+"'",1,preferred_providers.rowcount())
If ll_find > 0 Then preferred_providers.deleterow(ll_find)
end event

type cb_set from commandbutton within w_svc_preferred_provider
integer x = 2619
integer y = 684
integer width = 247
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set All"
end type

event clicked;integer i
long    ll_row
string  ls_consultant_id

dw_providers.setredraw(false)
dw_providers.setfilter("isnull(authority_id)")
dw_providers.filter()

// filter out the unassigned providers list and assign authorities
For i = 1 to dw_providers.rowcount()
	dw_providers.object.selected_flag[i] = 1
	dw_providers.object.authority_id[i] = authority_id
	ls_consultant_id = dw_providers.object.consultant_id[i]
	
	ll_row = preferred_providers.insertrow(0)
	preferred_providers.object.authority_id[ll_row] = authority_id
	preferred_providers.object.consultant_id[ll_row] = ls_consultant_id
Next

dw_providers.setfilter("")
dw_providers.filter()
dw_providers.setredraw(true)

end event

type cb_clear from commandbutton within w_svc_preferred_provider
integer x = 2619
integer y = 836
integer width = 238
integer height = 112
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;integer i
long    ll_find
string  ls_null

setnull(ls_null)
dw_providers.setredraw(false)
dw_providers.setfilter("not isnull(authority_id)")
dw_providers.filter()

// filter out the unassigned providers list and assign authorities
For i = 1 to dw_providers.rowcount()
	dw_providers.object.selected_flag[i] = 0
	dw_providers.object.authority_id[i] = ls_null
	
	ll_find = preferred_providers.find("authority_id='"+authority_id+"'",1,preferred_providers.rowcount())
	if ll_find > 0 then preferred_providers.deleterow(ll_find)
Next

dw_providers.setfilter("")
dw_providers.filter()
dw_providers.setredraw(true)
end event

type cb_2 from commandbutton within w_svc_preferred_provider
integer x = 73
integer y = 1344
integer width = 521
integer height = 112
integer taborder = 51
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Authority Type"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_authority_type_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<All>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	authority_type = "%"
	text = "<All>"
else
	authority_type = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

refresh_authorities()

end event

type cb_category from commandbutton within w_svc_preferred_provider
integer x = 649
integer y = 1344
integer width = 549
integer height = 112
integer taborder = 61
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Authority Category"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_authority_category_pick_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.add_blank_row = true
popup.blank_text = "<All>"
popup.argument_count = 1
popup.argument[1] = authority_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	authority_category = "%"
	text = "<All>"
else
	authority_category = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

refresh_authorities()

end event

type cb_specialty from commandbutton within w_svc_preferred_provider
integer x = 1431
integer y = 1408
integer width = 1175
integer height = 128
integer taborder = 51
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<ALL>"
end type

event clicked;string ls_null
str_popup popup
str_popup_return popup_return

setnull(ls_null)
popup.dataobject = "dw_specialty_list"
popup.datacolumn = 2
popup.displaycolumn = 1
popup.add_blank_row = true
popup.blank_text = "<All>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	specialty_id = "%"
	text = "<All>"
else
	specialty_id = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

refresh_providers()
end event

type cb_new from commandbutton within w_svc_preferred_provider
integer x = 2615
integer y = 1028
integer width = 261
integer height = 112
integer taborder = 51
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Prov"
end type

event clicked;string ls_service

ls_service = service.get_attribute("provider_service")
if isnull(ls_service) then ls_service = 'CONFIG_SPECIALTIES_CONS'
service_list.do_service(ls_service)
refresh_providers()
end event

type cb_1 from commandbutton within w_svc_preferred_provider
integer x = 645
integer y = 1488
integer width = 567
integer height = 112
integer taborder = 61
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Authority"
end type

event clicked;string ls_service

ls_service = service.get_attribute("authority_service")
if isnull(ls_service) then ls_service = 'CONFIG_INSURANCE_CARRIER'
service_list.do_service(ls_service)
refresh_authorities()
end event

type pb_provider_up from u_picture_button within w_svc_preferred_provider
integer x = 2597
integer y = 168
integer width = 151
integer height = 124
integer taborder = 11
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_providers.current_page

dw_providers.set_page(li_page - 1, st_provider_page.text)

if li_page <= 2 then enabled = false
pb_provider_down.enabled = true

end event

type pb_provider_down from u_picture_button within w_svc_preferred_provider
integer x = 2597
integer y = 300
integer width = 151
integer height = 124
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_providers.current_page
li_last_page = dw_providers.last_page

dw_providers.set_page(li_page + 1, st_provider_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_provider_up.enabled = true

end event

type st_provider_page from statictext within w_svc_preferred_provider
integer x = 2597
integer y = 428
integer width = 142
integer height = 116
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 1/1"
boolean focusrectangle = false
end type

type pb_authority_up from u_picture_button within w_svc_preferred_provider
integer x = 1207
integer y = 168
integer width = 151
integer height = 124
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_authorities.current_page

dw_authorities.set_page(li_page - 1, st_authority.text)

if li_page <= 2 then enabled = false
pb_authority_down.enabled = true

end event

type pb_authority_down from u_picture_button within w_svc_preferred_provider
integer x = 1207
integer y = 300
integer width = 151
integer height = 124
integer taborder = 31
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_authorities.current_page
li_last_page = dw_authorities.last_page

dw_authorities.set_page(li_page + 1, st_authority.text)

if li_page >= li_last_page - 1 then enabled = false
pb_authority_up.enabled = true

end event

type st_authority from statictext within w_svc_preferred_provider
integer x = 1211
integer y = 428
integer width = 142
integer height = 116
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 1/1"
boolean focusrectangle = false
end type

type st_1 from statictext within w_svc_preferred_provider
integer x = 1623
integer y = 1308
integer width = 878
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Specialty"
alignment alignment = center!
boolean focusrectangle = false
end type

