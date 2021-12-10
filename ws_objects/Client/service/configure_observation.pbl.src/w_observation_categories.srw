$PBExportHeader$w_observation_categories.srw
forward
global type w_observation_categories from w_window_base
end type
type st_cat_title from statictext within w_observation_categories
end type
type dw_categories from u_dw_pick_list within w_observation_categories
end type
type st_1 from statictext within w_observation_categories
end type
type st_observation from statictext within w_observation_categories
end type
type st_title from statictext within w_observation_categories
end type
type pb_cancel from u_picture_button within w_observation_categories
end type
type pb_done from u_picture_button within w_observation_categories
end type
type st_treatment_type from statictext within w_observation_categories
end type
type pb_up from u_picture_button within w_observation_categories
end type
type pb_down from u_picture_button within w_observation_categories
end type
type st_page from statictext within w_observation_categories
end type
end forward

global type w_observation_categories from w_window_base
integer x = 0
integer y = 0
integer height = 1832
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_cat_title st_cat_title
dw_categories dw_categories
st_1 st_1
st_observation st_observation
st_title st_title
pb_cancel pb_cancel
pb_done pb_done
st_treatment_type st_treatment_type
pb_up pb_up
pb_down pb_down
st_page st_page
end type
global w_observation_categories w_observation_categories

type variables
string observation_id
string treatment_type

u_ds_data categories

end variables

forward prototypes
public function integer save_changes ()
end prototypes

public function integer save_changes ();integer li_sts

li_sts = categories.update()
if li_sts < 0 then return -1

return 1

end function

on w_observation_categories.create
int iCurrent
call super::create
this.st_cat_title=create st_cat_title
this.dw_categories=create dw_categories
this.st_1=create st_1
this.st_observation=create st_observation
this.st_title=create st_title
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.st_treatment_type=create st_treatment_type
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_cat_title
this.Control[iCurrent+2]=this.dw_categories
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_observation
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.pb_cancel
this.Control[iCurrent+7]=this.pb_done
this.Control[iCurrent+8]=this.st_treatment_type
this.Control[iCurrent+9]=this.pb_up
this.Control[iCurrent+10]=this.pb_down
this.Control[iCurrent+11]=this.st_page
end on

on w_observation_categories.destroy
call super::destroy
destroy(this.st_cat_title)
destroy(this.dw_categories)
destroy(this.st_1)
destroy(this.st_observation)
destroy(this.st_title)
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.st_treatment_type)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
end on

event open;call super::open;str_popup popup
long ll_rows
string ls_treatment_type
string ls_observation_category_id
long i
string ls_find
long ll_row

popup = message.powerobjectparm

if popup.data_row_count <> 2 then
	log.log(this, "w_observation_categories:open", "Invalid Parameters", 4)
	close(this)
	return
end if

observation_id = popup.items[1]
if isnull(popup.title) or trim(popup.title) = "" then
	st_observation.text = datalist.observation_description(observation_id)
else
	st_observation.text = popup.title
end if

treatment_type = popup.items[2]
st_treatment_type.text = datalist.treatment_type_description(treatment_type)

dw_categories.settransobject(sqlca)

dw_categories.multiselect = true
ll_rows = dw_categories.retrieve(treatment_type)
if ll_rows < 0 then
	log.log(this, "w_observation_categories:open", "Error getting all categories", 4)
	close(this)
	return
end if

categories = CREATE u_ds_data
categories.set_dataobject("dw_observation_observation_cat_list")
ll_rows = categories.retrieve(observation_id, treatment_type)
if ll_rows < 0 then
	log.log(this, "w_observation_categories:open", "Error getting observation categories", 4)
	close(this)
	return
end if

// Flag the existing categories as selected
for i = 1 to ll_rows
	ls_observation_category_id = categories.object.observation_category_id[i]
	ls_find = "observation_category_id='" + ls_observation_category_id + "'"
	ll_row = dw_categories.find(ls_find, 1, dw_categories.rowcount())
	if ll_row > 0 then
		dw_categories.object.selected_flag[ll_row] = 1
	end if
next

dw_categories.set_page(1, st_page.text)
if dw_categories.last_page > 1 then
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

end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_categories
end type

type st_cat_title from statictext within w_observation_categories
integer x = 869
integer y = 412
integer width = 1147
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Categories"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_categories from u_dw_pick_list within w_observation_categories
integer x = 869
integer y = 500
integer width = 1147
integer height = 1188
integer taborder = 10
string dataobject = "dw_observation_cat_display_selected"
boolean border = false
end type

event selected;integer li_exists_flag
string ls_observation_category_id
string ls_find
long ll_row

ls_observation_category_id = object.observation_category_id[selected_row]
ls_find = "observation_category_id='" + ls_observation_category_id + "'"
ll_row = categories.find(ls_find, 1, categories.rowcount())
if ll_row <= 0 then
	ll_row = categories.insertrow(0)
	categories.object.treatment_type[ll_row] = treatment_type
	categories.object.observation_category_id[ll_row] = ls_observation_category_id
	categories.object.observation_id[ll_row] = observation_id
end if

end event

event unselected;integer li_exists_flag
string ls_treatment_type
string ls_observation_category_id
string ls_find
long ll_row

ls_observation_category_id = object.observation_category_id[unselected_row]
ls_find = "observation_category_id='" + ls_observation_category_id + "'"
ll_row = categories.find(ls_find, 1, categories.rowcount())
if ll_row > 0 then
	ll_row = categories.deleterow(ll_row)
end if

end event

type st_1 from statictext within w_observation_categories
integer x = 485
integer y = 260
integer width = 535
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Treatment Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_observation from statictext within w_observation_categories
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
long backcolor = 7191717
string text = "observation description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_observation_categories
integer width = 2921
integer height = 116
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Categories Associated with Observation"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_observation_categories
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

type pb_done from u_picture_button within w_observation_categories
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

type st_treatment_type from statictext within w_observation_categories
integer x = 1106
integer y = 252
integer width = 928
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_observation_categories
integer x = 2016
integer y = 508
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_categories.current_page

dw_categories.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_observation_categories
integer x = 2016
integer y = 640
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_categories.current_page
li_last_page = dw_categories.last_page

dw_categories.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_observation_categories
integer x = 1874
integer y = 440
integer width = 288
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

