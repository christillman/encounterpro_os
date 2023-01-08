$PBExportHeader$w_scan_more.srw
forward
global type w_scan_more from w_window_base
end type
type st_desc from statictext within w_scan_more
end type
type cb_new_box from commandbutton within w_scan_more
end type
type dw_open_boxes from u_dw_pick_list within w_scan_more
end type
type cb_close_box from commandbutton within w_scan_more
end type
type st_external_source_title from statictext within w_scan_more
end type
type dw_sources from u_dw_pick_list within w_scan_more
end type
type pb_down from u_picture_button within w_scan_more
end type
type pb_up from u_picture_button within w_scan_more
end type
type st_page from statictext within w_scan_more
end type
type cb_cancel from commandbutton within w_scan_more
end type
type st_title from statictext within w_scan_more
end type
end forward

global type w_scan_more from w_window_base
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_desc st_desc
cb_new_box cb_new_box
dw_open_boxes dw_open_boxes
cb_close_box cb_close_box
st_external_source_title st_external_source_title
dw_sources dw_sources
pb_down pb_down
pb_up pb_up
st_page st_page
cb_cancel cb_cancel
st_title st_title
end type
global w_scan_more w_scan_more

type variables
//u_component_service service

string attachment_service
string attachment_tag
string progress_type

long external_source_count
string external_source[]
boolean wia_source[]

string external_source_type

end variables

forward prototypes
public function integer show_boxes (long pl_box_id)
public function integer close_box ()
public function integer show_boxes ()
public function long new_box (string ps_box_type, string ps_description)
public function integer show_sources ()
public function integer scan (long pl_box_id, long pl_source_index)
public subroutine add_source (string ps_external_source, string ps_description, boolean pb_wia_source)
end prototypes

public function integer show_boxes (long pl_box_id);string ls_find
long ll_row, ll_rowcount


dw_open_boxes.retrieve()
if not tf_check() then return -1

ll_rowcount = dw_open_boxes.rowcount()
if ll_rowcount > 0 then
	if pl_box_id > 0 then
		ls_find = "box_id=" + string(pl_box_id)
		ll_row = dw_open_boxes.find(ls_find, 1, ll_rowcount)
		if ll_row <= 0 then
			log.log(this, "w_scan_more.show_boxes:0014", "Invalid box id (" + string(pl_box_id) + ")", 3)
			return 0
		end if
	else
		ll_row = 1
	end if
	dw_open_boxes.setitem(ll_row, "selected_flag", 1)
	return ll_row
else
	return 0
end if


end function

public function integer close_box ();string ls_find
long ll_row, ll_rowcount, ll_box_id

// DECLARE lsp_close_box PROCEDURE FOR dbo.sp_close_box  
//         @pl_box_id = :ll_box_id  ;


ll_rowcount = dw_open_boxes.rowcount()
if ll_rowcount > 0 then
	ls_find = "selected_flag=1"
	ll_row = dw_open_boxes.find(ls_find, 1, ll_rowcount)
	if ll_row > 0 then
		ll_box_id = dw_open_boxes.object.box_id[ll_row]
		SQLCA.sp_close_box(ll_box_id);
//		EXECUTE lsp_close_box;
		if not tf_check() then return -1
	else
		return 0
	end if
end if



return 1

end function

public function integer show_boxes ();string ls_find
long ll_rowcount


dw_open_boxes.retrieve()
if not tf_check() then return -1

ll_rowcount = dw_open_boxes.rowcount()
if ll_rowcount > 0 then
	dw_open_boxes.setitem(1, "selected_flag", 1)
	return 1
else
	return 0
end if


end function

public function long new_box (string ps_box_type, string ps_description);string ls_box_type
long ll_box_id

// DECLARE lsp_new_box PROCEDURE FOR dbo.sp_new_box  
//         @ps_box_type = :ps_box_type,   
//         @ps_description = :ps_description,   
//         @pl_box_id = :ll_box_id OUT ;

SQLCA.sp_new_box   ( &
         ps_box_type,    &
         ps_description,    &
         ref ll_box_id );
//EXECUTE lsp_new_box;
if not tf_check() then return -1

//FETCH lsp_new_box INTO :ll_box_id;
//if not tf_check() then return -1
//
//CLOSE lsp_new_box;

return ll_box_id



end function

public function integer show_sources ();long i
str_external_sources lstr_sources

// If no external_source_type is specified then display all available
lstr_sources = common_thread.get_external_sources(external_source_type)

for i = 1 to lstr_sources.external_source_count
	add_source(lstr_sources.external_source[i].external_source, &
					lstr_sources.external_source[i].description, &
					lstr_sources.external_source[i].wia_source)
next

dw_sources.set_page(1, pb_up, pb_down, st_page)

return 1

end function

public function integer scan (long pl_box_id, long pl_source_index);Integer li_sts
string ls_progress_type

str_attributes lstra_attributes

lstra_attributes.attribute_count = 0

f_attribute_add_attribute(lstra_attributes, "progress_type", progress_type)
f_attribute_add_attribute(lstra_attributes, "box_id", string(pl_box_id))
f_attribute_add_attribute(lstra_attributes, "external_source", external_source[pl_source_index])
f_attribute_add_attribute(lstra_attributes, "posting_list", f_attribute_find_attribute(state_attributes, "posting_list"))
f_attribute_add_attribute(lstra_attributes, "interfaceserviceid", f_attribute_find_attribute(state_attributes, "interfaceserviceid"))

li_sts = service_list.do_service(attachment_service,lstra_attributes)
If li_sts <= 0 Then Return -1

return 1


end function

public subroutine add_source (string ps_external_source, string ps_description, boolean pb_wia_source);long ll_row

ll_row = dw_sources.insertrow(0)
external_source_count = ll_row
external_source[ll_row] = ps_external_source
dw_sources.object.item[ll_row] = ps_description
wia_source[ll_row] = pb_wia_source

end subroutine

event open;call super::open;str_popup_return popup_return
integer li_sts

popup_return.items[1] = "ERROR"
popup_return.item_count = 1

state_attributes = message.powerobjectparm

dw_open_boxes.settransobject(sqlca)

show_boxes()
If dw_open_boxes.rowcount() = 1 Then
	dw_open_boxes.setitem(1, "selected_flag", 1)
End If

attachment_service = f_attribute_find_attribute(state_attributes, "attachment_service")
If isnull(attachment_service) then attachment_service = "EXTERNAL_SOURCE"

attachment_tag = f_attribute_find_attribute(state_attributes, "attachment_tag")

progress_type = f_attribute_find_attribute(state_attributes, "progress_type")
If isnull(progress_type) then progress_type = "ATTACHMENT"

external_source_type = f_attribute_find_attribute(state_attributes, "external_source_type")

postevent("post_open")

end event

on w_scan_more.create
int iCurrent
call super::create
this.st_desc=create st_desc
this.cb_new_box=create cb_new_box
this.dw_open_boxes=create dw_open_boxes
this.cb_close_box=create cb_close_box
this.st_external_source_title=create st_external_source_title
this.dw_sources=create dw_sources
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.cb_cancel=create cb_cancel
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_desc
this.Control[iCurrent+2]=this.cb_new_box
this.Control[iCurrent+3]=this.dw_open_boxes
this.Control[iCurrent+4]=this.cb_close_box
this.Control[iCurrent+5]=this.st_external_source_title
this.Control[iCurrent+6]=this.dw_sources
this.Control[iCurrent+7]=this.pb_down
this.Control[iCurrent+8]=this.pb_up
this.Control[iCurrent+9]=this.st_page
this.Control[iCurrent+10]=this.cb_cancel
this.Control[iCurrent+11]=this.st_title
end on

on w_scan_more.destroy
call super::destroy
destroy(this.st_desc)
destroy(this.cb_new_box)
destroy(this.dw_open_boxes)
destroy(this.cb_close_box)
destroy(this.st_external_source_title)
destroy(this.dw_sources)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.cb_cancel)
destroy(this.st_title)
end on

event post_open;call super::post_open;str_popup_return popup_return
integer li_sts

popup_return.items[1] = "ERROR"
popup_return.item_count = 1


li_sts = show_sources()
if li_sts <= 0 then
	openwithparm(w_pop_message, "This computer does not have any available external sources.")
	log.log(this, "w_scan_more:post", "No external sources", 4)
	closewithreturn(this, popup_return)
	return
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_scan_more
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_scan_more
end type

type st_desc from statictext within w_scan_more
integer x = 1275
integer y = 200
integer width = 379
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Open Boxes"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_new_box from commandbutton within w_scan_more
integer x = 2491
integer y = 280
integer width = 347
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Box"
end type

event clicked;long ll_box_id
str_popup popup
str_popup_return popup_return

popup.item = "Scanned Letters"
openwithparm(w_new_box, popup)
popup_return = message.powerobjectparm

if popup_return.item_count <> 2 then return

if popup_return.items[2] = "TRUE" then close_box()

ll_box_id = new_box("LETTERS", popup_return.items[1])
if ll_box_id <= 0 then
	log.log(this, "w_scan_more.cb_new_box.clicked:0015", "Unable to create new box", 4)
	return
end if

show_boxes(ll_box_id)


end event

type dw_open_boxes from u_dw_pick_list within w_scan_more
integer x = 526
integer y = 276
integer width = 1943
integer height = 604
integer taborder = 20
string dataobject = "dw_open_box_list"
boolean border = false
end type

type cb_close_box from commandbutton within w_scan_more
event clicked pbm_bnclicked
integer x = 2491
integer y = 424
integer width = 347
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close Box"
end type

event clicked;integer li_sts

li_sts = close_box()
if li_sts > 0 then show_boxes()

end event

type st_external_source_title from statictext within w_scan_more
integer x = 800
integer y = 928
integer width = 1243
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Attachment Source"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_sources from u_dw_pick_list within w_scan_more
integer x = 800
integer y = 984
integer width = 1243
integer height = 776
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_pick_generic"
boolean border = false
end type

event selected;call super::selected;integer li_pagecount
long ll_row
long ll_box_id
str_popup_return popup_return

if dw_open_boxes.rowcount() <= 0 then
	openwithparm(w_pop_message, "You must have at least one open box to import from an external source")
	clear_selected()
	return
end if

ll_row = dw_open_boxes.get_selected_row()
if ll_row <= 0 then
	openwithparm(w_pop_message, "You must select an open box before importing from an external source")
	clear_selected()
	return
end if
ll_box_id = dw_open_boxes.object.box_id[ll_row]

li_pagecount = scan(ll_box_id, selected_row)
if li_pagecount <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = string(li_pagecount)
closewithreturn(parent, popup_return)


end event

type pb_down from u_picture_button within w_scan_more
integer x = 2039
integer y = 1124
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_sources.current_page
li_last_page = dw_sources.last_page

dw_sources.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type pb_up from u_picture_button within w_scan_more
integer x = 2039
integer y = 1000
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_sources.current_page

dw_sources.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_scan_more
integer x = 1902
integer y = 936
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_scan_more
integer x = 87
integer y = 1660
integer width = 489
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_title from statictext within w_scan_more
integer width = 2917
integer height = 184
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Import Attachments"
alignment alignment = center!
boolean focusrectangle = false
end type

