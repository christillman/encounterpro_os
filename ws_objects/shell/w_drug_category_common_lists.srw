HA$PBExportHeader$w_drug_category_common_lists.srw
forward
global type w_drug_category_common_lists from w_window_base
end type
type cb_clear_all from commandbutton within w_drug_category_common_lists
end type
type cb_set_all from commandbutton within w_drug_category_common_lists
end type
type st_cat_title from statictext within w_drug_category_common_lists
end type
type dw_drug_categories from u_dw_pick_list within w_drug_category_common_lists
end type
type st_title from statictext within w_drug_category_common_lists
end type
type pb_cancel from u_picture_button within w_drug_category_common_lists
end type
type pb_done from u_picture_button within w_drug_category_common_lists
end type
type st_page from statictext within w_drug_category_common_lists
end type
type pb_up from u_picture_button within w_drug_category_common_lists
end type
type pb_down from u_picture_button within w_drug_category_common_lists
end type
end forward

global type w_drug_category_common_lists from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_clear_all cb_clear_all
cb_set_all cb_set_all
st_cat_title st_cat_title
dw_drug_categories dw_drug_categories
st_title st_title
pb_cancel pb_cancel
pb_done pb_done
st_page st_page
pb_up pb_up
pb_down pb_down
end type
global w_drug_category_common_lists w_drug_category_common_lists

type variables
string 		drug_id
u_ds_data	common_drug_category_list

end variables

forward prototypes
public function integer save_changes ()
end prototypes

public function integer save_changes ();integer li_sts

li_sts = common_drug_category_list.update()
if li_sts < 0 then return -1


return 1

end function

on w_drug_category_common_lists.create
int iCurrent
call super::create
this.cb_clear_all=create cb_clear_all
this.cb_set_all=create cb_set_all
this.st_cat_title=create st_cat_title
this.dw_drug_categories=create dw_drug_categories
this.st_title=create st_title
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_clear_all
this.Control[iCurrent+2]=this.cb_set_all
this.Control[iCurrent+3]=this.st_cat_title
this.Control[iCurrent+4]=this.dw_drug_categories
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.pb_cancel
this.Control[iCurrent+7]=this.pb_done
this.Control[iCurrent+8]=this.st_page
this.Control[iCurrent+9]=this.pb_up
this.Control[iCurrent+10]=this.pb_down
end on

on w_drug_category_common_lists.destroy
call super::destroy
destroy(this.cb_clear_all)
destroy(this.cb_set_all)
destroy(this.st_cat_title)
destroy(this.dw_drug_categories)
destroy(this.st_title)
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
end on

event open;call super::open;String ls_category_id
String ls_find
long ll_rows,i,ll_row

str_popup popup

popup = message.powerobjectparm

st_title.text = "Categories for Drug " + popup.title
//st_description.text = popup.title
drug_id = popup.item

dw_drug_categories.settransobject(sqlca)

dw_drug_categories.multiselect = true
ll_rows = dw_drug_categories.retrieve()
if ll_rows < 0 then
	log.log(this, "open", "Error getting drug categories", 4)
	close(this)
	return
end if

// Up/down buttons
dw_drug_categories.last_page = 0
dw_drug_categories.set_page(1, pb_up,pb_down,st_page)

common_drug_category_list = CREATE u_ds_data
common_drug_category_list.set_dataobject("dw_drug_drug_category_pick_list")
ll_rows = common_drug_category_list.retrieve(drug_id)
if ll_rows < 0 then
	log.log(this, "open", "Error getting common drug categories", 4)
	close(this)
	return
end if

// Flag the existing categories
for i = 1 to ll_rows
	ls_category_id = common_drug_category_list.object.drug_category_id[i]
	ls_find = "drug_category_id='" + ls_category_id + "'"
	ll_row = dw_drug_categories.find(ls_find, 1, dw_drug_categories.rowcount())
	if ll_row > 0 then
		dw_drug_categories.object.selected_flag[ll_row] = 1
	end if
next
end event

event close;if not isnull(common_drug_category_list) and isvalid(common_drug_category_list) then DESTROY common_drug_category_list
end event

type pb_epro_help from w_window_base`pb_epro_help within w_drug_category_common_lists
end type

type cb_clear_all from commandbutton within w_drug_category_common_lists
integer x = 2240
integer y = 1152
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;string ls_category_id
string ls_find
long ll_row
long i

for i = 1 to dw_drug_categories.rowcount()
	dw_drug_categories.object.selected_flag[i] = 0
	ls_category_id = dw_drug_categories.object.drug_category_id[i]
	ls_find = "drug_category_id='" + ls_category_id + "'"
	ll_row = common_drug_category_list.find(ls_find, 1, common_drug_category_list.rowcount())
	if ll_row > 0 then
		ll_row = common_drug_category_list.deleterow(ll_row)
	end if
next

end event

type cb_set_all from commandbutton within w_drug_category_common_lists
integer x = 2240
integer y = 948
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set All"
end type

event clicked;string ls_category_id
string ls_find
long ll_row
long i

for i = 1 to dw_drug_categories.rowcount()
	dw_drug_categories.object.selected_flag[i] = 1
	ls_category_id = dw_drug_categories.object.drug_category_id[i]
	ls_find = "drug_category_id='" + ls_category_id + "'"
	ll_row = common_drug_category_list.find(ls_find, 1, common_drug_category_list.rowcount())
	if ll_row <= 0 then
		ll_row = common_drug_category_list.insertrow(0)
		common_drug_category_list.object.drug_category_id[ll_row] = ls_category_id
		common_drug_category_list.object.drug_id = drug_id
	end if
next

end event

type st_cat_title from statictext within w_drug_category_common_lists
integer x = 887
integer y = 304
integer width = 1147
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Drug Categories"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_drug_categories from u_dw_pick_list within w_drug_category_common_lists
integer x = 928
integer y = 392
integer width = 1061
integer height = 1336
integer taborder = 10
string dataobject = "dw_drug_categories"
boolean border = false
end type

event selected(long selected_row);string ls_category_id
string ls_find
long ll_row

ls_category_id = object.drug_category_id[selected_row]
ls_find = "drug_category_id='" + ls_category_id + "'"
ll_row = common_drug_category_list.find(ls_find, 1, common_drug_category_list.rowcount())
if ll_row <= 0 then
	ll_row = common_drug_category_list.insertrow(0)
	common_drug_category_list.object.drug_category_id[ll_row] = ls_category_id
	common_drug_category_list.object.drug_id[ll_row] = drug_id
end if
end event

event unselected(long unselected_row);string ls_category_id
string ls_find
long ll_row

ls_category_id = object.drug_category_id[unselected_row]
ls_find = "drug_category_id='" + ls_category_id + "'"
ll_row = common_drug_category_list.find(ls_find, 1, common_drug_category_list.rowcount())
if ll_row > 0 then
	ll_row = common_drug_category_list.deleterow(ll_row)
end if

end event

type st_title from statictext within w_drug_category_common_lists
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
string text = "Categories for Drug"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_drug_category_common_lists
integer x = 101
integer y = 1560
integer taborder = 0
boolean bringtotop = true
boolean cancel = true
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;close(parent)

end event

type pb_done from u_picture_button within w_drug_category_common_lists
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
if li_sts <= 0 then return

close(parent)

end event

type st_page from statictext within w_drug_category_common_lists
integer x = 2112
integer y = 292
integer width = 402
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
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_drug_category_common_lists
boolean visible = false
integer x = 2217
integer y = 396
integer width = 137
integer height = 116
integer taborder = 11
boolean bringtotop = true
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_drug_categories.current_page

dw_drug_categories.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_drug_category_common_lists
boolean visible = false
integer x = 2030
integer y = 396
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

li_page = dw_drug_categories.current_page
li_last_page = dw_drug_categories.last_page

dw_drug_categories.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

