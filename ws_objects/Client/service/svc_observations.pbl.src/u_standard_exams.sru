$PBExportHeader$u_standard_exams.sru
forward
global type u_standard_exams from userobject
end type
type pb_page_down from u_picture_button within u_standard_exams
end type
type cb_menu from commandbutton within u_standard_exams
end type
type pb_page_up from u_picture_button within u_standard_exams
end type
type cb_set from commandbutton within u_standard_exams
end type
type st_page from statictext within u_standard_exams
end type
type dw_exams from u_dw_pick_list within u_standard_exams
end type
end forward

global type u_standard_exams from userobject
integer width = 457
integer height = 1096
long backcolor = 33538240
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event exam_selected ( long pl_exam_sequence )
event previous_exam_selected ( long pl_treatment_id )
event set_exam_defaults ( long pl_exam_sequence,  string ps_user_id )
event clear_exam_defaults ( long pl_exam_sequence,  string ps_user_id )
pb_page_down pb_page_down
cb_menu cb_menu
pb_page_up pb_page_up
cb_set cb_set
st_page st_page
dw_exams dw_exams
end type
global u_standard_exams u_standard_exams

type variables
u_component_service service
u_component_treatment treatment

u_ds_data u_exam_selection

string mode = "USER"

long exam_sequence

string root_observation_id

end variables

forward prototypes
public subroutine set_disabled ()
public subroutine set_enabled ()
public function integer initialize (u_component_service puo_service)
public function long pick_previous_exam ()
public function integer display_exams ()
end prototypes

public subroutine set_disabled ();integer i

for i = 1 to dw_exams.rowcount()
	dw_exams.object.disabled_flag[i] = 1
next

dw_exams.enabled = false

cb_menu.visible = false

pb_page_up.visible = false
pb_page_down.visible = false

end subroutine

public subroutine set_enabled ();integer i

for i = 1 to dw_exams.rowcount()
	dw_exams.object.disabled_flag[i] = 0
next

dw_exams.enabled = true

cb_menu.visible = true

if dw_exams.last_page >= 2 then
	pb_page_up.visible = true
	pb_page_down.visible = true
else
	pb_page_up.visible = false
	pb_page_down.visible = false
end if

end subroutine

public function integer initialize (u_component_service puo_service);service = puo_service
if isnull(service.treatment) then
	log.log(this, "u_standard_exams.initialize:0003", "No treatment object", 4)
	return -1
end if

treatment = service.treatment

root_observation_id = service.root_observation_id()
if isnull(root_observation_id) then
	log.log(this, "u_standard_exams.initialize:0011", "No root observation_id", 4)
	return -1
end if

u_exam_selection = CREATE u_ds_data

exam_sequence = 0

return 1

end function

public function long pick_previous_exam ();long ll_treatment_id
str_popup popup
str_popup_return popup_return
u_ds_data luo_data
long ll_null

setnull(ll_null)

popup.dataobject = "dw_previous_exams"
popup.argument_count = 4
popup.argument[1] = current_patient.cpr_id
popup.argument[2] = treatment.treatment_type
popup.argument[3] = treatment.observation_id
popup.argument[4] = string(treatment.treatment_id)
popup.displaycolumn = 1
popup.datacolumn = 1
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ll_null

ll_treatment_id = long(popup_return.items[1])

return ll_treatment_id

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
//string ls_find
//long ll_treatment_id
//str_treatment_description lstra_treatments[]
//integer li_count
//integer i
//integer li_index
//str_popup popup
//str_popup_return popup_return
//
//setnull(ll_treatment_id)
//
//// This is one of the very few places where we want to compare with the actual treatment observation_id
//// instead of the screen's root_observation_id.  This is because we need to determine if this treatment
//// was ever ordered before, and we define the same treatment as being the same treatment type and same
//// treatment observation_id.
//ls_find = "treatment_type='" + treatment.treatment_type + "'"
//ls_find += " and observation_id = '" + treatment.observation_id + "'"
//ls_find += " and treatment_id<>" + string(treatment.treatment_id)
//li_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
//if li_count <= 0 then
//	return ll_treatment_id
//end if
//
//// Display the treatments in reverse order
//li_index = 0
//for i = li_count to 1 step -1
//	li_index += 1
//	popup.items[li_index] = string(lstra_treatments[i].begin_date, date_format_string)
//	if not isnull(lstra_treatments[i].treatment_description) then
//		popup.items[li_index] += " - " + lstra_treatments[i].treatment_description
//	end if
//next
//
//popup.data_row_count = li_count
//openwithparm(w_pop_pick, popup)
//popup_return = message.powerobjectparm
//if popup_return.item_count <> 1 then return ll_treatment_id
//
//// We displayed the treatments in reverse order, so invert the users selection to get the treatment_id
//ll_treatment_id = lstra_treatments[1 + li_count - popup_return.item_indexes[1]].treatment_id
//
//return ll_treatment_id
//
end function

public function integer display_exams ();integer li_count
integer li_sts
string ls_temp
long ll_row
string ls_find

if mode = "USER" then
	dw_exams.dataobject = "dw_sp_default_exam_selection"
	dw_exams.settransobject(sqlca)
	li_sts = dw_exams.retrieve(root_observation_id, current_patient.cpr_id, treatment.treatment_type, current_user.user_id)
	if li_sts < 0 then
		log.log(this, "u_standard_exams.display_exams:0012", "Error loading exam selections", 4)
		return -1
	end if
else
	dw_exams.dataobject = "dw_exam_pick_by_root_small"
	dw_exams.settransobject(sqlca)
	li_sts = dw_exams.retrieve(root_observation_id)
	if li_sts < 0 then
		log.log(this, "u_standard_exams.display_exams:0020", "Error loading exam selections", 4)
		return -1
	end if
end if

// This is one of the very few places where we want to compare with the actual treatment observation_id
// instead of the screen's root_observation_id.  This is because we need to determine if this treatment
// was ever ordered before, and we define the same treatment as being the same treatment type and same
// treatment observation_id.
ls_find = "treatment_type='" + treatment.treatment_type + "'"
ls_find += " and observation_id = '" + treatment.observation_id + "'"
ls_find += " and treatment_id<>" + string(treatment.treatment_id)
li_count = current_patient.treatments.count_treatments(ls_find)
if li_count > 0 then
	ll_row = dw_exams.insertrow(1)
	dw_exams.object.description[ll_row] = "<Previous Exam>"
end if

cb_menu.width = width - 4
cb_menu.y = height - cb_menu.height
cb_set.y = cb_menu.y - cb_set.height - 12
pb_page_up.y = cb_set.y
pb_page_down.y = cb_set.y
dw_exams.height = cb_set.y - 12

pb_page_up.x = width - pb_page_up.width - 4
pb_page_down.x = pb_page_up.x - pb_page_down.width - 12

dw_exams.width = width
dw_exams.object.description.width = width - 27

dw_exams.set_page(1, pb_page_up, pb_page_down, st_page)
st_page.visible = false

return 1

end function

on u_standard_exams.create
this.pb_page_down=create pb_page_down
this.cb_menu=create cb_menu
this.pb_page_up=create pb_page_up
this.cb_set=create cb_set
this.st_page=create st_page
this.dw_exams=create dw_exams
this.Control[]={this.pb_page_down,&
this.cb_menu,&
this.pb_page_up,&
this.cb_set,&
this.st_page,&
this.dw_exams}
end on

on u_standard_exams.destroy
destroy(this.pb_page_down)
destroy(this.cb_menu)
destroy(this.pb_page_up)
destroy(this.cb_set)
destroy(this.st_page)
destroy(this.dw_exams)
end on

type pb_page_down from u_picture_button within u_standard_exams
integer x = 151
integer y = 860
integer width = 137
integer height = 116
integer taborder = 30
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;string ls_temp

dw_exams.set_page(dw_exams.current_page + 1, ls_temp)
if dw_exams.current_page >= dw_exams.last_page then
	enabled = false
end if

pb_page_up.enabled = true

end event

type cb_menu from commandbutton within u_standard_exams
integer y = 984
integer width = 443
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Std Results..."
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_exam_sequence

popup.data_row_count = 3
popup.items[1] = treatment.treatment_type
popup.items[2] = root_observation_id

// disabled_flag
if dw_exams.enabled then
	popup.items[3] = "N"
else
	popup.items[3] = "Y"
end if

openwithparm(w_standard_exams, popup)
popup_return = message.powerobjectparm

display_exams()

if popup_return.item_count <= 0 then return

ll_exam_sequence = long(popup_return.items[1])

parent.event POST exam_selected(ll_exam_sequence)

end event

type pb_page_up from u_picture_button within u_standard_exams
integer x = 297
integer y = 860
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;string ls_temp

dw_exams.set_page(dw_exams.current_page - 1, ls_temp)
if dw_exams.current_page < 2 then
	enabled = false
end if

pb_page_down.enabled = true

end event

type cb_set from commandbutton within u_standard_exams
integer y = 860
integer width = 142
integer height = 116
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set"
end type

event clicked;long ll_row
string ls_temp
string ls_description
long ll_exam_sequence
str_popup popup
str_popup_return popup_return

ll_row = dw_exams.get_selected_row()

if ll_row <= 0 then
	ll_exam_sequence = datalist.observation_default_exam_sequence(root_observation_id)
	ls_description = datalist.exam_description(ll_exam_sequence)
else
	ll_exam_sequence = dw_exams.object.exam_sequence[ll_row]
	ls_description = dw_exams.object.description[ll_row]
end if


popup.data_row_count = 2
popup.items[1] = "Set Personal Results"
popup.items[2] = "Clear Personal Results"

if current_user.check_privilege("Common Exams") then
	popup.data_row_count = 3
	popup.items[3] = "Set Common Results"
end if

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		ls_temp = "Are you sure you wish to set your personal results for the standard exam '" + ls_description + "' to the selected items?"
		openwithparm(w_pop_ok, ls_temp)
		if message.doubleparm <> 1 then return
		parent.event post set_exam_defaults(ll_exam_sequence, current_user.user_id)
	CASE 2
		ls_temp = "Are you sure you wish to clear your personal results and revert to the common results for the standard exam '" + ls_description + "'?"
		openwithparm(w_pop_ok, ls_temp)
		if message.doubleparm <> 1 then return
		parent.event post clear_exam_defaults(ll_exam_sequence, current_user.user_id)
	CASE 3
		ls_temp = "Are you sure you wish to set the common results for the standard exam '" + ls_description + "' to the selected items?"
		openwithparm(w_pop_ok, ls_temp)
		if message.doubleparm <> 1 then return
		parent.event post set_exam_defaults(ll_exam_sequence, current_user.common_list_id())
END CHOOSE


end event

type st_page from statictext within u_standard_exams
boolean visible = false
integer x = 73
integer y = 512
integer width = 288
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_exams from u_dw_pick_list within u_standard_exams
integer width = 462
integer height = 840
integer taborder = 10
string dataobject = "dw_sp_default_exam_selection"
boolean border = false
end type

event selected;long ll_treatment_id

exam_sequence = object.exam_sequence[selected_row]

// If the exam_sequence is null it means that the user
// selected the <previous exams> option
if isnull(exam_sequence) then
	ll_treatment_id = pick_previous_exam()
	if not isnull(ll_treatment_id) then
		parent.event POST previous_exam_selected(ll_treatment_id)
	end if
	clear_selected()
else
	parent.event POST exam_selected(exam_sequence)
end if


end event

event unselected;call super::unselected;exam_sequence = 0

end event

