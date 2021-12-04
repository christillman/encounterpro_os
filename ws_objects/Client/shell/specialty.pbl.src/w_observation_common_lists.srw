$PBExportHeader$w_observation_common_lists.srw
forward
global type w_observation_common_lists from w_window_base
end type
type cb_clear_all from commandbutton within w_observation_common_lists
end type
type cb_set_all from commandbutton within w_observation_common_lists
end type
type st_cat_title from statictext within w_observation_common_lists
end type
type dw_specialties from u_dw_pick_list within w_observation_common_lists
end type
type st_observation from statictext within w_observation_common_lists
end type
type st_title from statictext within w_observation_common_lists
end type
type pb_cancel from u_picture_button within w_observation_common_lists
end type
type pb_done from u_picture_button within w_observation_common_lists
end type
type st_page from statictext within w_observation_common_lists
end type
type pb_up from u_picture_button within w_observation_common_lists
end type
type pb_down from u_picture_button within w_observation_common_lists
end type
end forward

global type w_observation_common_lists from w_window_base
integer x = 0
integer y = 0
integer height = 1832
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_clear_all cb_clear_all
cb_set_all cb_set_all
st_cat_title st_cat_title
dw_specialties dw_specialties
st_observation st_observation
st_title st_title
pb_cancel pb_cancel
pb_done pb_done
st_page st_page
pb_up pb_up
pb_down pb_down
end type
global w_observation_common_lists w_observation_common_lists

type variables
string observation_id
u_ds_data common_observation

end variables

forward prototypes
public function integer save_changes ()
end prototypes

public function integer save_changes ();integer li_sts

li_sts = common_observation.update()
if li_sts < 0 then return -1


return 1

end function

on w_observation_common_lists.create
int iCurrent
call super::create
this.cb_clear_all=create cb_clear_all
this.cb_set_all=create cb_set_all
this.st_cat_title=create st_cat_title
this.dw_specialties=create dw_specialties
this.st_observation=create st_observation
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
this.Control[iCurrent+4]=this.dw_specialties
this.Control[iCurrent+5]=this.st_observation
this.Control[iCurrent+6]=this.st_title
this.Control[iCurrent+7]=this.pb_cancel
this.Control[iCurrent+8]=this.pb_done
this.Control[iCurrent+9]=this.st_page
this.Control[iCurrent+10]=this.pb_up
this.Control[iCurrent+11]=this.pb_down
end on

on w_observation_common_lists.destroy
call super::destroy
destroy(this.cb_clear_all)
destroy(this.cb_set_all)
destroy(this.st_cat_title)
destroy(this.dw_specialties)
destroy(this.st_observation)
destroy(this.st_title)
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
end on

event open;call super::open;str_popup popup
long ll_rows
string ls_specialty_id
long i
string ls_find
long ll_row

popup = message.powerobjectparm

if popup.data_row_count <> 1 then
	log.log(this, "w_observation_common_lists:open", "Invalid Parameters", 4)
	close(this)
	return
end if

observation_id = popup.items[1]
if isnull(popup.title) or trim(popup.title) = "" then
	st_observation.text = datalist.observation_description(observation_id)
else
	st_observation.text = popup.title
end if

dw_specialties.settransobject(sqlca)

dw_specialties.multiselect = true
ll_rows = dw_specialties.retrieve()
if ll_rows < 0 then
	log.log(this, "w_observation_common_lists:open", "Error getting specialties", 4)
	close(this)
	return
end if
// Up/down buttons

dw_specialties.last_page = 0
dw_specialties.set_page(1, st_page.text)
If dw_specialties.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
Else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
End if

common_observation = CREATE u_ds_data
common_observation.set_dataobject("dw_common_observation_list")
ll_rows = common_observation.retrieve(observation_id)
if ll_rows < 0 then
	log.log(this, "w_observation_common_lists:open", "Error getting common observations", 4)
	close(this)
	return
end if

// Flag the existing specialties
for i = 1 to ll_rows
	ls_specialty_id = common_observation.object.specialty_id[i]
	ls_find = "specialty_id='" + ls_specialty_id + "'"
	ll_row = dw_specialties.find(ls_find, 1, dw_specialties.rowcount())
	if ll_row > 0 then
		dw_specialties.object.selected_flag[ll_row] = 1
	end if
next



end event

event close;if not isnull(common_observation) and isvalid(common_observation) then DESTROY common_observation
end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_common_lists
end type

type cb_clear_all from commandbutton within w_observation_common_lists
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

event clicked;string ls_specialty_id
string ls_find
long ll_row
long i

for i = 1 to dw_specialties.rowcount()
	dw_specialties.object.selected_flag[i] = 0
	ls_specialty_id = dw_specialties.object.specialty_id[i]
	ls_find = "specialty_id='" + ls_specialty_id + "'"
	ll_row = common_observation.find(ls_find, 1, common_observation.rowcount())
	if ll_row > 0 then
		ll_row = common_observation.deleterow(ll_row)
	end if
next

end event

type cb_set_all from commandbutton within w_observation_common_lists
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

event clicked;string ls_specialty_id
string ls_find
long ll_row
long i

for i = 1 to dw_specialties.rowcount()
	dw_specialties.object.selected_flag[i] = 1
	ls_specialty_id = dw_specialties.object.specialty_id[i]
	ls_find = "specialty_id='" + ls_specialty_id + "'"
	ll_row = common_observation.find(ls_find, 1, common_observation.rowcount())
	if ll_row <= 0 then
		ll_row = common_observation.insertrow(0)
		common_observation.object.specialty_id[ll_row] = ls_specialty_id
		common_observation.object.observation_id[ll_row] = observation_id
	end if
next

end event

type st_cat_title from statictext within w_observation_common_lists
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
long backcolor = COLOR_BACKGROUND
string text = "Specialty"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_specialties from u_dw_pick_list within w_observation_common_lists
integer x = 928
integer y = 392
integer width = 1061
integer height = 1336
integer taborder = 10
string dataobject = "dw_specialty_list"
boolean border = false
end type

event selected;string ls_specialty_id
string ls_find
long ll_row

ls_specialty_id = object.specialty_id[selected_row]
ls_find = "specialty_id='" + ls_specialty_id + "'"
ll_row = common_observation.find(ls_find, 1, common_observation.rowcount())
if ll_row <= 0 then
	ll_row = common_observation.insertrow(0)
	common_observation.object.specialty_id[ll_row] = ls_specialty_id
	common_observation.object.observation_id[ll_row] = observation_id
end if

end event

event unselected;string ls_specialty_id
string ls_find
long ll_row

ls_specialty_id = object.specialty_id[unselected_row]
ls_find = "specialty_id='" + ls_specialty_id + "'"
ll_row = common_observation.find(ls_find, 1, common_observation.rowcount())
if ll_row > 0 then
	ll_row = common_observation.deleterow(ll_row)
end if

end event

type st_observation from statictext within w_observation_common_lists
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
long backcolor = COLOR_BACKGROUND
string text = "observation description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_observation_common_lists
integer width = 2921
integer height = 116
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Common Observation by Specialty"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_observation_common_lists
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

type pb_done from u_picture_button within w_observation_common_lists
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

type st_page from statictext within w_observation_common_lists
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
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_observation_common_lists
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

li_page = dw_specialties.current_page

dw_specialties.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_observation_common_lists
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

li_page = dw_specialties.current_page
li_last_page = dw_specialties.last_page

dw_specialties.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

