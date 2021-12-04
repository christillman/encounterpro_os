$PBExportHeader$u_tabpage_vaccine_schedule_schedule.sru
forward
global type u_tabpage_vaccine_schedule_schedule from u_tabpage_vaccine_schedule_base
end type
type st_rule_count from statictext within u_tabpage_vaccine_schedule_schedule
end type
type pb_dose_number_up from picturebutton within u_tabpage_vaccine_schedule_schedule
end type
type st_dose_number from statictext within u_tabpage_vaccine_schedule_schedule
end type
type cb_copy_rules from commandbutton within u_tabpage_vaccine_schedule_schedule
end type
type cb_save_changes from commandbutton within u_tabpage_vaccine_schedule_schedule
end type
type cb_add_rule from commandbutton within u_tabpage_vaccine_schedule_schedule
end type
type st_dose_number_title from statictext within u_tabpage_vaccine_schedule_schedule
end type
type st_disease_title from statictext within u_tabpage_vaccine_schedule_schedule
end type
type dw_disease from u_dw_pick_list within u_tabpage_vaccine_schedule_schedule
end type
type st_disease_group_title from statictext within u_tabpage_vaccine_schedule_schedule
end type
type st_disease_group from statictext within u_tabpage_vaccine_schedule_schedule
end type
type dw_dose_schedule from u_dw_pick_list within u_tabpage_vaccine_schedule_schedule
end type
type pb_dose_number_down from picturebutton within u_tabpage_vaccine_schedule_schedule
end type
end forward

global type u_tabpage_vaccine_schedule_schedule from u_tabpage_vaccine_schedule_base
integer width = 3698
st_rule_count st_rule_count
pb_dose_number_up pb_dose_number_up
st_dose_number st_dose_number
cb_copy_rules cb_copy_rules
cb_save_changes cb_save_changes
cb_add_rule cb_add_rule
st_dose_number_title st_dose_number_title
st_disease_title st_disease_title
dw_disease dw_disease
st_disease_group_title st_disease_group_title
st_disease_group st_disease_group
dw_dose_schedule dw_dose_schedule
pb_dose_number_down pb_dose_number_down
end type
global u_tabpage_vaccine_schedule_schedule u_tabpage_vaccine_schedule_schedule

type variables
u_ds_data dose_schedule

string current_disease_group
long current_disease_id

boolean first_time = true

long new_rule_sequence = 0

end variables

forward prototypes
public function integer initialize ()
public subroutine set_defaults ()
public subroutine refresh ()
public function integer ds_row (long pl_dw_row)
public function integer copy_rules (long pl_from_disease_id, long pl_to_disease_id)
public function integer save_changes ()
end prototypes

public function integer initialize ();long ll_count
u_ds_data luo_data

dose_schedule = CREATE u_ds_data
dose_schedule.set_dataobject("dw_c_immunization_dose_schedule")

ll_count = dose_schedule.retrieve()
if ll_count < 0 then return -1

setnull(current_disease_group)
setnull(current_disease_id)

return 1

end function

public subroutine set_defaults ();u_ds_data luo_data
long ll_count

st_dose_number.text = "1"

setnull(current_disease_group)
setnull(current_disease_id)

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_disease_group")
ll_count = luo_data.retrieve()
if ll_count > 0 then
	current_disease_group = luo_data.object.disease_group[1]
	st_disease_group.text = luo_data.object.description[1]
	
	dw_disease.settransobject(sqlca)
	ll_count = dw_disease.retrieve(current_disease_group)
	if ll_count > 0 then
		dw_disease.object.selected_flag[1] = 1
		current_disease_id = dw_disease.object.disease_id[1]
	end if
end if

end subroutine

public subroutine refresh ();string ls_find
long ll_ds_row
long ll_new_row
long ll_count
long i
boolean lb_found
long ll_patient_age_range_id
long ll_first_dose_age_range_id
long ll_last_dose_age_range_id
long ll_last_dose_interval_amouint
string ls_last_dose_interval_unit_id
long ll_dose_schedule_sequence
long ll_sort_sequence
string ls_dose_text
real lr_amount
long ll_disease_count
long ll_disease_row

if first_time and isnull(current_disease_id) then
	set_defaults()
end if

first_time = false

dw_dose_schedule.reset()

if isnull(current_disease_group) then
	setnull(current_disease_id)
	dw_disease.reset()
	ll_disease_count = 0
else
	dw_disease.settransobject(sqlca)
	ll_disease_count = dw_disease.retrieve(current_disease_group)
end if

if isnull(current_disease_id) or ll_disease_count = 0 then
	cb_copy_rules.enabled = false
	cb_add_rule.enabled = false
	return
else
	ll_disease_row = dw_disease.find("disease_id=" + string(current_disease_id), 1, ll_disease_count)
	if ll_disease_row > 0 then
		dw_disease.object.selected_flag[ll_disease_row] = 1
	else
		// If the previous current_disease_id is not found then pick the first disease
		dw_disease.object.selected_flag[1] = 1
		current_disease_id = dw_disease.object.disease_id[1]
	end if
end if

cb_add_rule.enabled = true

if long(st_dose_number.text) > 1 then
	pb_dose_number_down.enabled = true
else
	pb_dose_number_down.enabled = false
end if

dose_schedule.sort()
ll_count = dose_schedule.rowcount()
lb_found = false

ls_find = "disease_id=" + string(current_disease_id)
ls_find += " and dose_number=" + st_dose_number.text
ll_ds_row = dose_schedule.find(ls_find, 1, ll_count)
DO WHILE ll_ds_row > 0 and ll_ds_row <= ll_count
	ll_dose_schedule_sequence = dose_schedule.object.dose_schedule_sequence[ll_ds_row]
	ll_patient_age_range_id = dose_schedule.object.patient_age_range_id[ll_ds_row]
	ll_first_dose_age_range_id = dose_schedule.object.first_dose_age_range_id[ll_ds_row]
	ll_last_dose_age_range_id = dose_schedule.object.last_dose_age_range_id[ll_ds_row]
	ll_last_dose_interval_amouint = dose_schedule.object.last_dose_interval_amount[ll_ds_row]
	ls_last_dose_interval_unit_id = dose_schedule.object.last_dose_interval_unit_id[ll_ds_row]
	ll_sort_sequence = dose_schedule.object.sort_sequence[ll_ds_row]
	ls_dose_text = dose_schedule.object.dose_text[ll_ds_row]

	ll_new_row = dw_dose_schedule.insertrow(0)
	dw_dose_schedule.object.dose_schedule_sequence[ll_new_row] = ll_dose_schedule_sequence
	dw_dose_schedule.object.patient_age_range[ll_new_row] = datalist.age_range_description(ll_patient_age_range_id)
	dw_dose_schedule.object.first_dose_age_range[ll_new_row] = datalist.age_range_description(ll_first_dose_age_range_id)
	dw_dose_schedule.object.last_dose_age_range[ll_new_row] = datalist.age_range_description(ll_last_dose_age_range_id)
	lr_amount = ll_last_dose_interval_amouint
	dw_dose_schedule.object.last_dose_interval[ll_new_row] = f_pretty_amount_unit(lr_amount, ls_last_dose_interval_unit_id)
	dw_dose_schedule.object.dose_text[ll_new_row] = ls_dose_text
	
	dw_dose_schedule.object.sort_sequence[ll_new_row] = ll_new_row
	if isnull(ll_sort_sequence) or ll_sort_sequence <> ll_new_row then
		dose_schedule.object.sort_sequence[ll_ds_row] = ll_new_row
	end if
	
	lb_found = true

	ll_ds_row = dose_schedule.find(ls_find, ll_ds_row + 1, ll_count + 1)
LOOP

st_rule_count.text = "Rule Count = " + string(dw_dose_schedule.rowcount())

cb_copy_rules.enabled = lb_found

dw_dose_schedule.setfocus()

end subroutine

public function integer ds_row (long pl_dw_row);long ll_dose_schedule_sequence
string ls_find
long ll_row


ll_dose_schedule_sequence = dw_dose_schedule.object.dose_schedule_sequence[pl_dw_row]

ls_find = "disease_id=" + string(current_disease_id)
ls_find += " and dose_schedule_sequence=" + string(ll_dose_schedule_sequence)
ll_row = dose_schedule.find(ls_find, 1, dose_schedule.rowcount())
if ll_row > 0 then
	return ll_row
else
	return -1
end if

end function

public function integer copy_rules (long pl_from_disease_id, long pl_to_disease_id);string ls_find_from
long ll_row_from
string ls_find_to
long ll_row_to
long ll_rowcount

// Remove any rules already there for the target disease
ls_find_to = "disease_id=" + string(pl_to_disease_id)
ll_row_to = dose_schedule.find(ls_find_to, 1, dose_schedule.rowcount())
DO WHILE ll_row_to > 0 and ll_row_to <= dose_schedule.rowcount()
	dose_schedule.deleterow(ll_row_to)
	ll_row_to = dose_schedule.find(ls_find_to, 1, dose_schedule.rowcount())
LOOP

// Add the rules
ll_rowcount = dose_schedule.rowcount()
ls_find_from = "disease_id=" + string(pl_from_disease_id)
ll_row_from = dose_schedule.find(ls_find_from, 1, ll_rowcount)
DO WHILE ll_row_from > 0 and ll_row_from <= ll_rowcount
	ll_row_to = dose_schedule.insertrow(0)
	
	new_rule_sequence -= 1
	dose_schedule.object.disease_id[ll_row_to] = pl_to_disease_id
	dose_schedule.object.dose_schedule_sequence[ll_row_to] = new_rule_sequence
	dose_schedule.object.dose_number[ll_row_to] = dose_schedule.object.dose_number[ll_row_from]
	dose_schedule.object.patient_age_range_id[ll_row_to] = dose_schedule.object.patient_age_range_id[ll_row_from]
	dose_schedule.object.first_dose_age_range_id[ll_row_to] = dose_schedule.object.first_dose_age_range_id[ll_row_from]
	dose_schedule.object.last_dose_age_range_id[ll_row_to] = dose_schedule.object.last_dose_age_range_id[ll_row_from]
	dose_schedule.object.last_dose_interval_amount[ll_row_to] = dose_schedule.object.last_dose_interval_amount[ll_row_from]
	dose_schedule.object.last_dose_interval_unit_id[ll_row_to] = dose_schedule.object.last_dose_interval_unit_id[ll_row_from]
	dose_schedule.object.sort_sequence[ll_row_to] = dose_schedule.object.sort_sequence[ll_row_from]
	dose_schedule.object.dose_text[ll_row_to] = dose_schedule.object.dose_text[ll_row_from]
	
	ll_row_from = dose_schedule.find(ls_find_from, ll_row_from + 1, ll_rowcount + 1)
LOOP


return 1

end function

public function integer save_changes ();integer li_sts

li_sts = dose_schedule.update()
if li_sts > 0 then
	openwithparm(w_pop_message, "Vaccine Schedule Rules were successfully saved")
	my_parent_tab.rule_changes = false
	return 1
else
	openwithparm(w_pop_message, "And error occured saving the Vaccine Schedule Rules")
	return -1
end if

end function

on u_tabpage_vaccine_schedule_schedule.create
int iCurrent
call super::create
this.st_rule_count=create st_rule_count
this.pb_dose_number_up=create pb_dose_number_up
this.st_dose_number=create st_dose_number
this.cb_copy_rules=create cb_copy_rules
this.cb_save_changes=create cb_save_changes
this.cb_add_rule=create cb_add_rule
this.st_dose_number_title=create st_dose_number_title
this.st_disease_title=create st_disease_title
this.dw_disease=create dw_disease
this.st_disease_group_title=create st_disease_group_title
this.st_disease_group=create st_disease_group
this.dw_dose_schedule=create dw_dose_schedule
this.pb_dose_number_down=create pb_dose_number_down
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_rule_count
this.Control[iCurrent+2]=this.pb_dose_number_up
this.Control[iCurrent+3]=this.st_dose_number
this.Control[iCurrent+4]=this.cb_copy_rules
this.Control[iCurrent+5]=this.cb_save_changes
this.Control[iCurrent+6]=this.cb_add_rule
this.Control[iCurrent+7]=this.st_dose_number_title
this.Control[iCurrent+8]=this.st_disease_title
this.Control[iCurrent+9]=this.dw_disease
this.Control[iCurrent+10]=this.st_disease_group_title
this.Control[iCurrent+11]=this.st_disease_group
this.Control[iCurrent+12]=this.dw_dose_schedule
this.Control[iCurrent+13]=this.pb_dose_number_down
end on

on u_tabpage_vaccine_schedule_schedule.destroy
call super::destroy
destroy(this.st_rule_count)
destroy(this.pb_dose_number_up)
destroy(this.st_dose_number)
destroy(this.cb_copy_rules)
destroy(this.cb_save_changes)
destroy(this.cb_add_rule)
destroy(this.st_dose_number_title)
destroy(this.st_disease_title)
destroy(this.dw_disease)
destroy(this.st_disease_group_title)
destroy(this.st_disease_group)
destroy(this.dw_dose_schedule)
destroy(this.pb_dose_number_down)
end on

event resize_tabpage;call super::resize_tabpage;

cb_add_rule.y = height - cb_add_rule.height - 50

cb_copy_rules.x = ( width - cb_copy_rules.width) / 2
cb_copy_rules.y = cb_add_rule.y

cb_save_changes.x = width - cb_save_changes.width - cb_add_rule.x
cb_save_changes.y = cb_add_rule.y

dw_dose_schedule.x = ( width - dw_dose_schedule.width ) / 2
dw_dose_schedule.height = cb_add_rule.y - dw_dose_schedule.y - 50

st_dose_number_title.x = dw_dose_schedule.x
st_dose_number.x = st_dose_number_title.x + st_dose_number_title.width + 20
pb_dose_number_down.x = st_dose_number.x + st_dose_number.width + 20
pb_dose_number_up.x = pb_dose_number_down.x + pb_dose_number_down.width + 20
st_rule_count.x = pb_dose_number_down.x + pb_dose_number_down.width + 50

st_disease_group_title.x = dw_dose_schedule.x + 200
st_disease_group.x = st_disease_group_title.x

st_disease_title.x = dw_dose_schedule.x + dw_dose_schedule.width - st_disease_title.width - 200
dw_disease.x = st_disease_title.x

st_rule_count.x = pb_dose_number_up.x + pb_dose_number_up.width + 20
st_rule_count.y = pb_dose_number_up.y + pb_dose_number_up.height - st_rule_count.height
end event

type st_rule_count from statictext within u_tabpage_vaccine_schedule_schedule
integer x = 1778
integer y = 432
integer width = 489
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Rule Count = 99 "
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_dose_number_up from picturebutton within u_tabpage_vaccine_schedule_schedule
integer x = 1605
integer y = 380
integer width = 137
integer height = 116
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;if isnumber(st_dose_number.text) then
	st_dose_number.text = string(long(st_dose_number.text) + 1)
else
	st_dose_number.text = "1"
end if

refresh()

end event

type st_dose_number from statictext within u_tabpage_vaccine_schedule_schedule
integer x = 1143
integer y = 392
integer width = 279
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "1"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_copy_rules from commandbutton within u_tabpage_vaccine_schedule_schedule
integer x = 1536
integer y = 1396
integer width = 631
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copy Rule(s) To ..."
end type

event clicked;integer li_sts
str_popup popup
str_popup_return popup_return
u_ds_data luo_data
string ls_sql
long ll_count
string ls_copy_to_disease_group
long ll_copy_to_disease_id
string ls_copy_to_disease_name
long i

if isnull(current_disease_group) or isnull(current_disease_id) then return

popup.data_row_count = 3
popup.items[1] = "All Other Diseases in this Disease Group"
popup.items[2] = "All Diseases in Another Disease Group"
popup.items[3] = "Specific Disease"

luo_data = CREATE u_ds_data

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		ls_sql = "SELECT disease_id FROM c_Disease_Group_Item WHERE disease_group = '" + current_disease_group + "' AND disease_id <> " + string(current_disease_id)
		ll_count = luo_data.load_query(ls_sql)
		if ll_count < 0 then return
		if ll_count = 0 then
			openwithparm(w_pop_message, "This disease group has no other diseases")
			return
		end if
		openwithparm(w_pop_yes_no, "This operation will copy the rules for all dose numbers.  Are you sure you want to replace the rules in the other ~"" + current_disease_group + "~" diseases with these rules?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
	CASE 2
		popup.data_row_count = 0
		popup.dataobject = "dw_c_disease_group"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		ls_copy_to_disease_group = popup_return.items[1]
		
		ls_sql = "SELECT disease_id FROM c_Disease_Group_Item WHERE disease_group = '" + ls_copy_to_disease_group + "'"
		ll_count = luo_data.load_query(ls_sql)
		if ll_count < 0 then return
		if ll_count = 0 then
			openwithparm(w_pop_message, "The selected disease group has no diseases")
			return
		end if

		openwithparm(w_pop_yes_no, "This operation will copy the rules for all dose numbers.  Are you sure you want to replace the rules for all of the ~"" + ls_copy_to_disease_group + "~" diseases with these rules?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
	CASE 3
		popup.data_row_count = 0
		popup.dataobject = "dw_disease_list"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		ll_copy_to_disease_id = long(popup_return.items[1])
		ls_copy_to_disease_name = popup_return.descriptions[1]
		
		ls_sql = "SELECT disease_id FROM c_Disease WHERE disease_id = " + string(ll_copy_to_disease_id)
		ll_count = luo_data.load_query(ls_sql)
		if ll_count < 0 then return
		if ll_count = 0 then
			openwithparm(w_pop_message, "The selected disease could not be found")  // This should never happen
			return
		end if
		
		openwithparm(w_pop_yes_no, "This operation will copy the rules for all dose numbers.  Are you sure you want to replace the rules for the ~"" + ls_copy_to_disease_name + "~" disease with these rules?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
END CHOOSE

// If we get here with records in luo_data, then the operation is to copy all of the rules for the current_disease_id to
// each disease_id in luo_data, replacing any rules already there for those diseases


for i = 1 to luo_data.rowcount()
	ll_copy_to_disease_id = luo_data.object.disease_id[i]
	if ll_copy_to_disease_id = current_disease_id then continue // if the target group happens to include the current disease, skip it

	li_sts = copy_rules(current_disease_id, ll_copy_to_disease_id)
next

DESTROY luo_data

my_parent_tab.rule_changes = true

end event

type cb_save_changes from commandbutton within u_tabpage_vaccine_schedule_schedule
integer x = 3008
integer y = 1400
integer width = 471
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save Changes"
end type

event clicked;integer li_sts

li_sts = save_changes()
if li_sts < 0 then return

end event

type cb_add_rule from commandbutton within u_tabpage_vaccine_schedule_schedule
integer x = 297
integer y = 1396
integer width = 402
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Rule"
end type

event clicked;long ll_ds_row
long ll_dw_row

if isnull(current_disease_id) then return

new_rule_sequence -= 1

ll_ds_row = dose_schedule.insertrow(0)
dose_schedule.object.disease_id[ll_ds_row] = current_disease_id
dose_schedule.object.dose_schedule_sequence[ll_ds_row] = new_rule_sequence
dose_schedule.object.dose_number[ll_ds_row] = long(st_dose_number.text)

ll_dw_row = dw_dose_schedule.insertrow(0)
dw_dose_schedule.object.dose_schedule_sequence[ll_dw_row] = new_rule_sequence
dw_dose_schedule.object.sort_sequence[ll_dw_row] = ll_dw_row
dw_dose_schedule.scrolltorow(ll_dw_row)

my_parent_tab.rule_changes = true

end event

type st_dose_number_title from statictext within u_tabpage_vaccine_schedule_schedule
integer x = 352
integer y = 404
integer width = 759
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Rules For Dose Number"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_disease_title from statictext within u_tabpage_vaccine_schedule_schedule
integer x = 2386
integer y = 12
integer width = 704
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Disease"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_disease from u_dw_pick_list within u_tabpage_vaccine_schedule_schedule
integer x = 2382
integer y = 84
integer width = 809
integer height = 408
integer taborder = 0
string dataobject = "dw_diseases_in_group_small"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;current_disease_id = dw_disease.object.disease_id[selected_row]

refresh()

end event

event unselected;call super::unselected;setnull(current_disease_id)

refresh()

end event

type st_disease_group_title from statictext within u_tabpage_vaccine_schedule_schedule
integer x = 242
integer y = 12
integer width = 1225
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Disease Group"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_disease_group from statictext within u_tabpage_vaccine_schedule_schedule
integer x = 242
integer y = 84
integer width = 1225
integer height = 100
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
long ll_count

popup.dataobject = "dw_c_disease_group"
popup.datacolumn = 1
popup.displaycolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

current_disease_group = popup_return.items[1]
text = popup_return.descriptions[1]

ll_count = dw_disease.retrieve(current_disease_group)
if ll_count > 0 then
	dw_disease.object.selected_flag[1] = 1
	current_disease_id = dw_disease.object.disease_id[1]
else
	setnull(current_disease_id)
end if

st_dose_number.text = "1"


refresh()

end event

type dw_dose_schedule from u_dw_pick_list within u_tabpage_vaccine_schedule_schedule
integer x = 73
integer y = 516
integer width = 3593
integer height = 852
integer taborder = 30
string dataobject = "dw_dose_schedule_edit"
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;string ls_itemname
long ll_ds_row
string ls_dose_text

ls_itemname = dwo.name

ll_ds_row = ds_row(row)
if ll_ds_row <= 0 then return

if lower(ls_itemname) = "dose_text" then
	dose_schedule.object.dose_text[ll_ds_row] = data
	my_parent_tab.rule_changes = true
end if

end event

event clicked;call super::clicked;string ls_temp
string ls_itemname
long ll_ds_row
long ll_ds_other_row
string ls_dose_text
str_popup_return popup_return
integer li_sts
long ll_age_range_id
str_popup popup
long ll_null
string ls_number
string ls_unit
long ll_last_dose_interval_amount
string ls_last_dose_interval_unit_id
real lr_amount
string ls_interval_message = "Please enter the interval as a number followed by a space followed by one of the following units:  Day, Week, Month, Year"
setnull(ll_null)

accepttext()

ls_itemname = dwo.name

ll_ds_row = ds_row(row)
if ll_ds_row <= 0 then return

CHOOSE CASE lower(ls_itemname)
	CASE "patient_age_range", "first_dose_age_range", "last_dose_age_range"
		ll_age_range_id = dose_schedule.getitemnumber(ll_ds_row, ls_itemname + "_id")
		if ll_age_range_id > 0 then
			popup.data_row_count = 2
			popup.items[1] = "Clear Age Range"
			popup.items[2] = "Change Age Range"
			
			openwithparm(w_pop_pick, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then return
			if popup_return.item_indexes[1] = 1 then
				dose_schedule.setitem( ll_ds_row, ls_itemname + "_id", ll_null)
				setitem(row, ls_itemname, "")
				my_parent_tab.rule_changes = true
				return
			end if
		end if
		
		openwithparm(w_age_range_selection,"Immunization")
		popup_return = Message.powerobjectparm
		If popup_return.item_count < 1 Then return
		
		setitem(row, ls_itemname, popup_return.descriptions[1])
		dose_schedule.setitem( ll_ds_row, ls_itemname + "_id", long(popup_return.items[1]))
		my_parent_tab.rule_changes = true
	CASE "last_dose_interval"
		popup.item = getitemstring(row, "last_dose_interval")
		popup.title = "Enter the minimum interval between the previous dose and this dose"
		popup.multiselect = true
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		if trim(popup_return.items[1]) = "" then
			// User cleared the interval
			object.last_dose_interval[row] = ""
			setnull(ll_last_dose_interval_amount)
			setnull(ls_last_dose_interval_unit_id)
			dose_schedule.object.last_dose_interval_amount[ll_ds_row] = ll_last_dose_interval_amount
			dose_schedule.object.last_dose_interval_unit_id[ll_ds_row] = ls_last_dose_interval_unit_id
			my_parent_tab.rule_changes = true
			return
		end if
		
		f_split_string(popup_return.items[1], " ", ls_number, ls_unit)
		ls_number = trim(ls_number)
		ls_unit = trim(ls_unit)
		if len(ls_number) = 0 or len(ls_unit) = 0 or not isnumber(ls_number) then
			openwithparm(w_pop_message, ls_interval_message)
			return
		end if
		
		ll_last_dose_interval_amount = long(ls_number)
		if ll_last_dose_interval_amount <= 0 then
			openwithparm(w_pop_message, ls_interval_message)
			return
		end if
		
		CHOOSE CASE left(upper(trim(ls_unit)), 1)
			CASE "D"
				ls_last_dose_interval_unit_id = "DAY"
			CASE "W"
				ls_last_dose_interval_unit_id = "WEEK"
			CASE "M"
				ls_last_dose_interval_unit_id = "MONTH"
			CASE "Y"
				ls_last_dose_interval_unit_id = "YEAR"
			CASE ELSE
				openwithparm(w_pop_message, ls_interval_message)
				return
		END CHOOSE
		
		lr_amount = ll_last_dose_interval_amount
		ls_temp = f_pretty_amount_unit(lr_amount, ls_last_dose_interval_unit_id)
		object.last_dose_interval[row] = ls_temp
		dose_schedule.object.last_dose_interval_amount[ll_ds_row] = ll_last_dose_interval_amount
		dose_schedule.object.last_dose_interval_unit_id[ll_ds_row] = ls_last_dose_interval_unit_id
		my_parent_tab.rule_changes = true
	CASE "p_move_up"
		if row > 1 then
			ll_ds_other_row = ds_row(row - 1)
			if ll_ds_other_row <= 0 then return
			
			object.sort_sequence[row] = row - 1
			dose_schedule.object.sort_sequence[ll_ds_row] = row - 1
			
			object.sort_sequence[row - 1] = row
			dose_schedule.object.sort_sequence[ll_ds_other_row] = row
			sort()
			my_parent_tab.rule_changes = true
		end if
	CASE "p_move_down"
		if row < rowcount() then
			ll_ds_other_row = ds_row(row + 1)
			if ll_ds_other_row <= 0 then return
			
			object.sort_sequence[row] = row + 1
			dose_schedule.object.sort_sequence[ll_ds_row] = row + 1
			
			object.sort_sequence[row + 1] = row
			dose_schedule.object.sort_sequence[ll_ds_other_row] = row
			sort()
			my_parent_tab.rule_changes = true
		end if
	CASE "p_delete"
		openwithparm(w_pop_yes_no, "Are you sure you want to delete this rule?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		deleterow(row)
		dose_schedule.deleterow(ll_ds_row)
		
		st_rule_count.text = "Rule Count = " + string(dw_dose_schedule.rowcount())
		my_parent_tab.rule_changes = true
END CHOOSE

//if lower(ls_itemname) = "dose_text" then
//	ls_dose_text = object.dose_text[row]
//	dose_schedule.object.dose_text[ll_ds_row] = ls_dose_text
//end if
//
end event

event losefocus;call super::losefocus;accepttext()

end event

type pb_dose_number_down from picturebutton within u_tabpage_vaccine_schedule_schedule
integer x = 1445
integer y = 380
integer width = 137
integer height = 116
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;if isnumber(st_dose_number.text) then
	if long(st_dose_number.text) > 1 then
		st_dose_number.text = string(long(st_dose_number.text) - 1)
	end if
else
	st_dose_number.text = "1"
end if

refresh()


end event

