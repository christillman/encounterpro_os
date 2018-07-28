HA$PBExportHeader$u_treatment_progress.sru
forward
global type u_treatment_progress from userobject
end type
type pb_new from u_picture_button within u_treatment_progress
end type
type st_sort_title from statictext within u_treatment_progress
end type
type st_sort_desc from statictext within u_treatment_progress
end type
type st_sort_asc from statictext within u_treatment_progress
end type
type pb_down from u_picture_button within u_treatment_progress
end type
type pb_up from u_picture_button within u_treatment_progress
end type
type dw_progress from u_dw_pick_list within u_treatment_progress
end type
end forward

global type u_treatment_progress from userobject
integer width = 2802
integer height = 1012
long backcolor = 33538240
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
pb_new pb_new
st_sort_title st_sort_title
st_sort_desc st_sort_desc
st_sort_asc st_sort_asc
pb_down pb_down
pb_up pb_up
dw_progress dw_progress
end type
global u_treatment_progress u_treatment_progress

type variables
boolean initialized = false
u_component_treatment treatment

string progress_type = "PROGRESSNOTE"

string sort = "D"

end variables

forward prototypes
public subroutine sort_notes ()
public function string top_20_code ()
public function integer initialize (u_component_treatment puo_treatment)
public function integer display_progress ()
end prototypes

public subroutine sort_notes ();string ls_sort

if sort = "A" then
	ls_sort = "progress_date_time A"
else
	ls_sort = "progress_date_time D"
end if

dw_progress.setsort(ls_sort)
dw_progress.sort()

end subroutine

public function string top_20_code ();string ls_top_20_code



ls_top_20_code = progress_type + "_" + treatment.treatment_type

if not isnull(treatment.specialty_id) and trim(treatment.specialty_id) <> "" then ls_top_20_code += "_" + treatment.specialty_id

if not isnull(treatment.drug_id) and trim(treatment.drug_id) <> "" then ls_top_20_code += "_" + treatment.drug_id

if not isnull(treatment.procedure_id) and trim(treatment.procedure_id) <> "" then ls_top_20_code += "_" + treatment.procedure_id


if len(ls_top_20_code) > 40 then ls_top_20_code = left(ls_top_20_code, 40)

return ls_top_20_code

end function

public function integer initialize (u_component_treatment puo_treatment);
treatment = puo_treatment

st_sort_title.x = width - st_sort_title.width - 25
st_sort_asc.x = st_sort_title.x
st_sort_desc.x = st_sort_title.x
pb_up.x = st_sort_title.x
pb_down.x = st_sort_title.x
pb_new.x = st_sort_title.x

dw_progress.x = 0
dw_progress.y = 0
dw_progress.width = st_sort_title.x - 25
dw_progress.height = height
pb_up.y = 0
pb_down.y = height - pb_down.height

sort = "D"
st_sort_asc.backcolor = color_object
st_sort_desc.backcolor = color_object_selected

dw_progress.settransobject(sqlca)

return 1

end function

public function integer display_progress ();integer li_sts
string ls_text

li_sts = dw_progress.retrieve(current_patient.cpr_id, treatment.treatment_id, progress_type)
dw_progress.set_page(1, ls_text)
if dw_progress.last_page > 1 then
	pb_up.visible = true
	pb_down.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
else
	pb_up.visible = false
	pb_down.visible = false
end if

sort_notes()

return li_sts


end function

on u_treatment_progress.create
this.pb_new=create pb_new
this.st_sort_title=create st_sort_title
this.st_sort_desc=create st_sort_desc
this.st_sort_asc=create st_sort_asc
this.pb_down=create pb_down
this.pb_up=create pb_up
this.dw_progress=create dw_progress
this.Control[]={this.pb_new,&
this.st_sort_title,&
this.st_sort_desc,&
this.st_sort_asc,&
this.pb_down,&
this.pb_up,&
this.dw_progress}
end on

on u_treatment_progress.destroy
destroy(this.pb_new)
destroy(this.st_sort_title)
destroy(this.st_sort_desc)
destroy(this.st_sort_asc)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.dw_progress)
end on

type pb_new from u_picture_button within u_treatment_progress
integer x = 2583
integer y = 644
integer width = 137
integer height = 116
integer taborder = 30
string picturename = "icon_new.bmp"
string disabledname = "icon_new.bmp"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_progress_key
long ll_row
string ls_text

popup.title = "Please enter a title or select one from the list below"
popup.argument_count = 1
popup.argument[1] = treatment.treatment_type
popup.multiselect = true
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_progress_key = popup_return.items[1]
if trim(ls_progress_key) = "" then setnull(ls_progress_key)

popup.data_row_count = 4
popup.items[1] = top_20_code()
popup.items[2] = progress_type + "_" + treatment.treatment_type + "_GENERIC"
popup.items[3] = ""
setnull(popup.items[4])
popup.title = treatment.treatment_description

openwithparm(w_progress_note_edit, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return

if isnull(popup_return.items[1]) or trim(popup_return.items[1]) = "" then return

dw_progress.setredraw(false)

ll_row = dw_progress.insertrow(0)
dw_progress.object.cpr_id[ll_row] = current_patient.cpr_id
dw_progress.object.treatment_id[ll_row] = treatment.treatment_id
dw_progress.object.encounter_id[ll_row] = current_patient.open_encounter_id
dw_progress.object.user_id[ll_row] = current_user.user_id
dw_progress.object.progress_date_time[ll_row] = datetime(today(), now())
dw_progress.object.progress_type[ll_row] = progress_type
dw_progress.object.progress_key[ll_row] = ls_progress_key
dw_progress.object.progress[ll_row] = popup_return.items[1]
dw_progress.object.risk_level[ll_row] = long(popup_return.items[2])
dw_progress.object.created[ll_row] = datetime(today(), now())
dw_progress.object.created_by[ll_row] = current_scribe.user_id

dw_progress.object.user_full_name[ll_row] = current_user.user_full_name
dw_progress.object.user_short_name[ll_row] = current_user.user_short_name
dw_progress.object.color[ll_row] = current_user.color

dw_progress.update()

sort_notes()

dw_progress.set_page(1, ls_text)
if dw_progress.last_page > 1 then
	pb_up.visible = true
	pb_down.visible = true
	if sort = "A" then
		dw_progress.set_page(dw_progress.last_page, ls_text)
		pb_up.enabled = false
		pb_down.enabled = true
	else
		pb_up.enabled = true
		pb_down.enabled = false
	end if
else
	pb_up.visible = false
	pb_down.visible = false
end if

dw_progress.setredraw(true)

end event

type st_sort_title from statictext within u_treatment_progress
integer x = 2565
integer y = 284
integer width = 183
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Sort"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_sort_desc from statictext within u_treatment_progress
integer x = 2565
integer y = 476
integer width = 183
integer height = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desc"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;sort = "D"
backcolor = color_object_selected
st_sort_asc.backcolor = color_object

sort_notes()

end event

type st_sort_asc from statictext within u_treatment_progress
integer x = 2565
integer y = 356
integer width = 183
integer height = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Asc"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;sort = "A"
backcolor = color_object_selected
st_sort_desc.backcolor = color_object

sort_notes()

end event

type pb_down from u_picture_button within u_treatment_progress
integer x = 2565
integer y = 844
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

li_page = dw_progress.current_page
li_last_page = dw_progress.last_page

dw_progress.set_page(li_page + 1, ls_temp)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within u_treatment_progress
integer x = 2263
integer y = 116
integer width = 137
integer height = 116
integer taborder = 20
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;string ls_temp
integer li_page

li_page = dw_progress.current_page

dw_progress.set_page(li_page - 1, ls_temp)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type dw_progress from u_dw_pick_list within u_treatment_progress
integer width = 2578
integer height = 1020
integer taborder = 10
string dataobject = "dw_treatment_progress_display"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

