$PBExportHeader$u_tab_vaccine_diseases.sru
forward
global type u_tab_vaccine_diseases from tab
end type
type tabpage_vaccines from userobject within u_tab_vaccine_diseases
end type
type st_dise_page from statictext within tabpage_vaccines
end type
type pb_dise_down from u_picture_button within tabpage_vaccines
end type
type pb_dise_up from u_picture_button within tabpage_vaccines
end type
type st_vacc_page from statictext within tabpage_vaccines
end type
type pb_up from u_picture_button within tabpage_vaccines
end type
type pb_down from u_picture_button within tabpage_vaccines
end type
type cb_adminproc from commandbutton within tabpage_vaccines
end type
type cb_makers from commandbutton within tabpage_vaccines
end type
type cb_alpha from commandbutton within tabpage_vaccines
end type
type st_1 from statictext within tabpage_vaccines
end type
type cb_add_disease from commandbutton within tabpage_vaccines
end type
type cb_new_vaccine from commandbutton within tabpage_vaccines
end type
type cb_up from commandbutton within tabpage_vaccines
end type
type cb_down from commandbutton within tabpage_vaccines
end type
type cb_edit from commandbutton within tabpage_vaccines
end type
type dw_vac_diseases from u_dw_pick_list within tabpage_vaccines
end type
type dw_vaccines from u_dw_pick_list within tabpage_vaccines
end type
type tabpage_vaccines from userobject within u_tab_vaccine_diseases
st_dise_page st_dise_page
pb_dise_down pb_dise_down
pb_dise_up pb_dise_up
st_vacc_page st_vacc_page
pb_up pb_up
pb_down pb_down
cb_adminproc cb_adminproc
cb_makers cb_makers
cb_alpha cb_alpha
st_1 st_1
cb_add_disease cb_add_disease
cb_new_vaccine cb_new_vaccine
cb_up cb_up
cb_down cb_down
cb_edit cb_edit
dw_vac_diseases dw_vac_diseases
dw_vaccines dw_vaccines
end type
type tabpage_diseases from userobject within u_tab_vaccine_diseases
end type
type st_page from statictext within tabpage_diseases
end type
type pb_vacc_up from u_picture_button within tabpage_diseases
end type
type pb_vacc_down from u_picture_button within tabpage_diseases
end type
type st_dis_page from statictext within tabpage_diseases
end type
type pb_dis_up from u_picture_button within tabpage_diseases
end type
type pb_dis_down from u_picture_button within tabpage_diseases
end type
type st_2 from statictext within tabpage_diseases
end type
type dw_disease_vaccines from u_dw_pick_list within tabpage_diseases
end type
type cb_add_vaccine from commandbutton within tabpage_diseases
end type
type cb_edit_d from commandbutton within tabpage_diseases
end type
type cb_alpha_d from commandbutton within tabpage_diseases
end type
type cb_down_d from commandbutton within tabpage_diseases
end type
type cb_up_d from commandbutton within tabpage_diseases
end type
type cb_new_disease from commandbutton within tabpage_diseases
end type
type dw_diseases from u_dw_pick_list within tabpage_diseases
end type
type tabpage_diseases from userobject within u_tab_vaccine_diseases
st_page st_page
pb_vacc_up pb_vacc_up
pb_vacc_down pb_vacc_down
st_dis_page st_dis_page
pb_dis_up pb_dis_up
pb_dis_down pb_dis_down
st_2 st_2
dw_disease_vaccines dw_disease_vaccines
cb_add_vaccine cb_add_vaccine
cb_edit_d cb_edit_d
cb_alpha_d cb_alpha_d
cb_down_d cb_down_d
cb_up_d cb_up_d
cb_new_disease cb_new_disease
dw_diseases dw_diseases
end type
type tabpage_schedule from userobject within u_tab_vaccine_diseases
end type
type cb_add_schedule_item from commandbutton within tabpage_schedule
end type
type dw_schedule from u_dw_pick_list within tabpage_schedule
end type
type st_4 from statictext within tabpage_schedule
end type
type st_show from statictext within tabpage_schedule
end type
type st_3 from statictext within tabpage_schedule
end type
type st_schedule_title from statictext within tabpage_schedule
end type
type tabpage_schedule from userobject within u_tab_vaccine_diseases
cb_add_schedule_item cb_add_schedule_item
dw_schedule dw_schedule
st_4 st_4
st_show st_show
st_3 st_3
st_schedule_title st_schedule_title
end type
end forward

global type u_tab_vaccine_diseases from tab
integer width = 2427
integer height = 1752
integer taborder = 1
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_vaccines tabpage_vaccines
tabpage_diseases tabpage_diseases
tabpage_schedule tabpage_schedule
end type
global u_tab_vaccine_diseases u_tab_vaccine_diseases

type variables
string vaccine_id
long disease_id

string display_flag
end variables

forward prototypes
public function integer load_schedule ()
end prototypes

public function integer load_schedule ();boolean lb_loop
integer li_schedule_sequence
integer li_warning_days
long ll_age_days
datetime ldt_age
long ll_row
date ld_age

 DECLARE lsp_get_immunization_schedule PROCEDURE FOR dbo.sp_get_immunization_schedule  
         @pl_disease_id = :disease_id  ;


EXECUTE lsp_get_immunization_schedule;
if not tf_check() then return -1

tabpage_schedule.dw_schedule.reset()

lb_loop = true

DO
	FETCH lsp_get_immunization_schedule INTO
		:li_schedule_sequence,
		:ldt_age,
		:ll_age_days,
		:li_warning_days;
	if not tf_check() then return -1

	if sqlca.sqlcode = 0 then
		ll_row = tabpage_schedule.dw_schedule.insertrow(0)
		ld_age = date(ldt_age)
		tabpage_schedule.dw_schedule.setitem(ll_row, "schedule_sequence", li_schedule_sequence)
		tabpage_schedule.dw_schedule.setitem(ll_row, "pretty_age", f_pretty_age(immunization_date_of_birth, ld_age))
		tabpage_schedule.dw_schedule.setitem(ll_row, "age", ld_age)
		tabpage_schedule.dw_schedule.setitem(ll_row, "warning_days", li_warning_days)
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lsp_get_immunization_schedule;

SELECT display_flag
INTO :display_flag
FROM c_Disease
WHERE disease_id = :disease_id;
if not tf_check() then return -1

if display_flag = "Y" then
	tabpage_schedule.st_show.backcolor = color_object_selected
	tabpage_schedule.st_show.text = "Yes"
else
	tabpage_schedule.st_show.backcolor = color_object
	tabpage_schedule.st_show.text = "No"
end if


return 1

end function

event selectionchanged;
if oldindex = -1 then
	tabpage_vaccines.dw_vaccines.retrieve()
	tabpage_vaccines.cb_add_disease.enabled = false
	tabpage_vaccines.cb_up.enabled = false
	tabpage_vaccines.cb_down.enabled = false
	tabpage_vaccines.cb_edit.enabled = false
	tabpage_vaccines.cb_makers.enabled = false
	tabpage_vaccines.cb_adminproc.enabled = false

	tabpage_diseases.dw_diseases.retrieve()
	tabpage_diseases.cb_add_vaccine.enabled = false
	tabpage_diseases.cb_up_d.enabled = false
	tabpage_diseases.cb_down_d.enabled = false
	tabpage_diseases.cb_edit_d.enabled = false
	
	setnull(disease_id)
	setnull(vaccine_id)
	
	// up & dn buttons - Vaccines
	tabpage_vaccines.dw_vaccines.last_page = 0
	tabpage_vaccines.dw_vaccines.set_page(1, tabpage_vaccines.st_vacc_page.text)
	If tabpage_vaccines.dw_vaccines.last_page < 2 then
		tabpage_vaccines.pb_down.visible = false
		tabpage_vaccines.pb_up.visible = false
	Else
		tabpage_vaccines.pb_down.visible = true
		tabpage_vaccines.pb_up.visible = true
		tabpage_vaccines.pb_up.enabled = false
		tabpage_vaccines.pb_down.enabled = true
	End if
	// Up & Dn - Diseases
	tabpage_diseases.dw_diseases.last_page = 0
	tabpage_diseases.dw_diseases.set_page(1,tabpage_diseases.st_dis_page.text)
	If tabpage_diseases.dw_diseases.last_page < 2 then
		tabpage_diseases.pb_dis_down.visible = false
		tabpage_diseases.pb_dis_up.visible = false
	Else
		tabpage_diseases.pb_dis_down.visible = true
		tabpage_diseases.pb_dis_up.visible = true
		tabpage_diseases.pb_dis_up.enabled = false
		tabpage_diseases.pb_dis_down.enabled = true
	End if
End If
end event

on u_tab_vaccine_diseases.create
this.tabpage_vaccines=create tabpage_vaccines
this.tabpage_diseases=create tabpage_diseases
this.tabpage_schedule=create tabpage_schedule
this.Control[]={this.tabpage_vaccines,&
this.tabpage_diseases,&
this.tabpage_schedule}
end on

on u_tab_vaccine_diseases.destroy
destroy(this.tabpage_vaccines)
destroy(this.tabpage_diseases)
destroy(this.tabpage_schedule)
end on

event selectionchanging;long ll_rowcount
long ll_row
string ls_find

if newindex = 3 then
	if isnull(disease_id) then
		openwithparm(w_pop_message, "Please Select a Disease.")
		selecttab(2)
		return 1
	else
		ll_rowcount = tabpage_diseases.dw_diseases.rowcount()
		ls_find = "disease_id=" + string(disease_id)
		ll_row = tabpage_diseases.dw_diseases.find(ls_find, 1, ll_rowcount)
		if ll_row > 0 then
			tabpage_schedule.st_schedule_title.text = tabpage_diseases.dw_diseases.object.description[ll_row] + " Schedule"
			load_schedule()
		else
			log.log(this, "u_tab_vaccine_diseases.selectionchanging.0018", "Disease_id not found (" + string(disease_id) + ")", 4)
			selecttab(oldindex)
			return 1
		end if
	end if
end if


end event

type tabpage_vaccines from userobject within u_tab_vaccine_diseases
integer x = 18
integer y = 112
integer width = 2391
integer height = 1624
long backcolor = 33538240
string text = "Vaccines"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
st_dise_page st_dise_page
pb_dise_down pb_dise_down
pb_dise_up pb_dise_up
st_vacc_page st_vacc_page
pb_up pb_up
pb_down pb_down
cb_adminproc cb_adminproc
cb_makers cb_makers
cb_alpha cb_alpha
st_1 st_1
cb_add_disease cb_add_disease
cb_new_vaccine cb_new_vaccine
cb_up cb_up
cb_down cb_down
cb_edit cb_edit
dw_vac_diseases dw_vac_diseases
dw_vaccines dw_vaccines
end type

on tabpage_vaccines.create
this.st_dise_page=create st_dise_page
this.pb_dise_down=create pb_dise_down
this.pb_dise_up=create pb_dise_up
this.st_vacc_page=create st_vacc_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_adminproc=create cb_adminproc
this.cb_makers=create cb_makers
this.cb_alpha=create cb_alpha
this.st_1=create st_1
this.cb_add_disease=create cb_add_disease
this.cb_new_vaccine=create cb_new_vaccine
this.cb_up=create cb_up
this.cb_down=create cb_down
this.cb_edit=create cb_edit
this.dw_vac_diseases=create dw_vac_diseases
this.dw_vaccines=create dw_vaccines
this.Control[]={this.st_dise_page,&
this.pb_dise_down,&
this.pb_dise_up,&
this.st_vacc_page,&
this.pb_up,&
this.pb_down,&
this.cb_adminproc,&
this.cb_makers,&
this.cb_alpha,&
this.st_1,&
this.cb_add_disease,&
this.cb_new_vaccine,&
this.cb_up,&
this.cb_down,&
this.cb_edit,&
this.dw_vac_diseases,&
this.dw_vaccines}
end on

on tabpage_vaccines.destroy
destroy(this.st_dise_page)
destroy(this.pb_dise_down)
destroy(this.pb_dise_up)
destroy(this.st_vacc_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_adminproc)
destroy(this.cb_makers)
destroy(this.cb_alpha)
destroy(this.st_1)
destroy(this.cb_add_disease)
destroy(this.cb_new_vaccine)
destroy(this.cb_up)
destroy(this.cb_down)
destroy(this.cb_edit)
destroy(this.dw_vac_diseases)
destroy(this.dw_vaccines)
end on

type st_dise_page from statictext within tabpage_vaccines
boolean visible = false
integer x = 1929
integer y = 1108
integer width = 306
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_dise_down from u_picture_button within tabpage_vaccines
boolean visible = false
integer x = 2103
integer y = 972
integer width = 137
integer height = 116
integer taborder = 24
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_vac_diseases.current_page
li_last_page = dw_vac_diseases.last_page

dw_vac_diseases.set_page(li_page + 1, st_dise_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_dise_up.enabled = true
end event

type pb_dise_up from u_picture_button within tabpage_vaccines
boolean visible = false
integer x = 1925
integer y = 972
integer width = 137
integer height = 116
integer taborder = 14
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_vac_diseases.current_page

dw_vac_diseases.set_page(li_page - 1, st_dise_page.text)

if li_page <= 2 then enabled = false
pb_dise_down.enabled = true

end event

type st_vacc_page from statictext within tabpage_vaccines
integer x = 864
integer y = 12
integer width = 315
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within tabpage_vaccines
boolean visible = false
integer x = 891
integer y = 92
integer width = 137
integer height = 116
integer taborder = 22
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_vaccines.current_page

dw_vaccines.set_page(li_page - 1, st_vacc_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within tabpage_vaccines
boolean visible = false
integer x = 1056
integer y = 92
integer width = 137
integer height = 116
integer taborder = 12
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_vaccines.current_page
li_last_page = dw_vaccines.last_page

dw_vaccines.set_page(li_page + 1, st_vacc_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type cb_adminproc from commandbutton within tabpage_vaccines
integer x = 914
integer y = 1060
integer width = 375
integer height = 108
integer taborder = 16
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Billing"
end type

event clicked;long ll_row
string ls_vaccine_id
string ls_description
str_popup popup

ll_row = dw_vaccines.get_selected_row()

if ll_row <= 1 then return

ls_vaccine_id = dw_vaccines.object.vaccine_id[ll_row]
ls_description = dw_vaccines.object.description[ll_row]

popup.data_row_count = 1
popup.items[1] = ls_vaccine_id
popup.title = ls_description
openwithparm(w_vaccine_procedures, popup)



end event

type cb_makers from commandbutton within tabpage_vaccines
integer x = 914
integer y = 1192
integer width = 375
integer height = 108
integer taborder = 16
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Makers"
end type

event clicked;long ll_row
string ls_vaccine_id
string ls_description
str_popup popup

ll_row = dw_vaccines.get_selected_row()

if ll_row <= 1 then return

ls_vaccine_id = dw_vaccines.object.vaccine_id[ll_row]
ls_description = dw_vaccines.object.description[ll_row]

popup.data_row_count = 2
popup.items[1] = "VACCINE"
popup.items[2] = ls_vaccine_id
popup.title = ls_description
openwithparm(w_maker_select, popup)



end event

type cb_alpha from commandbutton within tabpage_vaccines
integer x = 914
integer y = 796
integer width = 375
integer height = 108
integer taborder = 6
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Alphabetize"
end type

event clicked;long i
long ll_rowcount

dw_vaccines.setsort("description A")
dw_vaccines.sort()

ll_rowcount = dw_vaccines.rowcount()

for i = 1 to ll_rowcount
	dw_vaccines.setitem(i, "sort_sequence", i)
next

dw_vaccines.update()

dw_vaccines.setsort("sort_sequence A")

dw_vaccines.set_page(1, pb_up, pb_down, st_vacc_page)

end event

type st_1 from statictext within tabpage_vaccines
integer x = 1449
integer y = 80
integer width = 869
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Diseases Treated by Vaccine:"
boolean focusrectangle = false
end type

type cb_add_disease from commandbutton within tabpage_vaccines
event clicked pbm_bnclicked
integer x = 1454
integer y = 980
integer width = 393
integer height = 108
integer taborder = 4
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Disease"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_disease_id
long ll_row

popup.dataobject = "dw_diseases_to_attach"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = vaccine_id

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 0 then return

ll_disease_id = long(popup_return.items[1])

INSERT INTO c_Vaccine_Disease (
	vaccine_id,
	disease_id,
	units )
VALUES (
	:vaccine_id,
	:ll_disease_id,
	1);
if not tf_check() then return

ll_row = dw_vac_diseases.insertrow(0)
dw_vac_diseases.setitem(ll_row, "disease_id", ll_disease_id)
dw_vac_diseases.setitem(ll_row, "description", popup_return.descriptions[1])
dw_vac_diseases.setitem(ll_row, "sort_sequence", ll_row + 1000)
dw_vac_diseases.setitem(ll_row, "selected_flag", 0)
dw_vac_diseases.recalc_page(pb_dise_up,pb_dise_down,st_dise_page)
end event

type cb_new_vaccine from commandbutton within tabpage_vaccines
integer x = 914
integer y = 308
integer width = 375
integer height = 108
integer taborder = 6
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Vaccine"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_rowcount
long i
integer li_sort_sequence
string ls_vaccine_id
integer li_sts
long ll_row
string ls_exists
string ls_key


popup.item = "Enter Vaccine Description:"

openwithparm(w_pop_get_string, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 0 then return

ll_rowcount = dw_vaccines.rowcount()

for i = 1 to ll_rowcount
	dw_vaccines.setitem(i, "sort_sequence", i)
next

i = 0
ls_key = f_gen_key_string(popup_return.items[1], 20)
ls_vaccine_id = ls_key

// Make sure we have a unique vaccine id
DO
	SELECT vaccine_id
	INTO :ls_exists
	FROM c_Vaccine
	WHERE vaccine_id = :ls_vaccine_id;
	if not tf_check() then
		log.log(this, "u_tab_vaccine_diseases.cb_new_vaccine.clicked.0037", "Error checking for duplicate vaccine_id", 4)
		openwithparm(w_pop_message, "Error adding vaccine")
		return
	end if
	if sqlca.sqlcode = 100 then exit
	i += 1
	ls_vaccine_id = ls_key + string(i)
LOOP WHILE true

vaccine_id = ls_vaccine_id

dw_vaccines.clear_selected()
i = dw_vaccines.insertrow(0)
dw_vaccines.setitem(i, "vaccine_id", vaccine_id)
dw_vaccines.setitem(i, "description", popup_return.items[1])
dw_vaccines.setitem(i, "status", "OK")
dw_vaccines.setitem(i, "sort_sequence", i)
dw_vaccines.setitem(i, "selected_flag", 1)
dw_vaccines.scrolltorow(i)

li_sts = dw_vaccines.update()
if li_sts < 0 then
	log.log(this, "u_tab_vaccine_diseases.cb_new_vaccine.clicked.0037", "Error adding new vaccine", 4)
	openwithparm(w_pop_message, "Error adding vaccine")
	return
end if


dw_vac_diseases.retrieve(vaccine_id)
cb_add_disease.enabled = true
cb_up.enabled = true
cb_down.enabled = true
cb_edit.enabled = true
dw_vaccines.recalc_page(pb_up, pb_down, st_vacc_page)
dw_vaccines.set_page(dw_vaccines.last_page, pb_up, pb_down, st_vacc_page)


end event

type cb_up from commandbutton within tabpage_vaccines
integer x = 914
integer y = 532
integer width = 375
integer height = 108
integer taborder = 4
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Up"
end type

event clicked;integer li_sort_sequence
integer li_sort_sequence_x
long ll_row
long ll_lastrow

ll_row = dw_vaccines.get_selected_row()

if ll_row <= 1 then return

ll_lastrow = long(dw_vaccines.Object.DataWindow.LastRowOnPage)

li_sort_sequence = dw_vaccines.object.sort_sequence[ll_row]
li_sort_sequence_x = dw_vaccines.object.sort_sequence[ll_row - 1]

dw_vaccines.setitem(ll_row, "sort_sequence", li_sort_sequence_x)
dw_vaccines.setitem(ll_row - 1, "sort_sequence", li_sort_sequence)

dw_vaccines.setredraw(false)
dw_vaccines.update()
dw_vaccines.sort()
dw_vaccines.scrolltorow(ll_lastrow)
dw_vaccines.scrolltorow(ll_row - 1)
dw_vaccines.setredraw(true)



end event

type cb_down from commandbutton within tabpage_vaccines
integer x = 914
integer y = 664
integer width = 375
integer height = 108
integer taborder = 5
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Down"
end type

event clicked;integer li_sort_sequence
integer li_sort_sequence_x
long ll_row
long ll_lastrow

ll_row = dw_vaccines.get_selected_row()

if ll_row <= 0 then return
if ll_row >= dw_vaccines.rowcount() then return

ll_lastrow = long(dw_vaccines.Object.DataWindow.LastRowOnPage)

li_sort_sequence = dw_vaccines.object.sort_sequence[ll_row]
li_sort_sequence_x = dw_vaccines.object.sort_sequence[ll_row + 1]

dw_vaccines.setitem(ll_row, "sort_sequence", li_sort_sequence_x)
dw_vaccines.setitem(ll_row + 1, "sort_sequence", li_sort_sequence)

dw_vaccines.setredraw(false)
dw_vaccines.update()
dw_vaccines.sort()
dw_vaccines.scrolltorow(ll_lastrow)
dw_vaccines.scrolltorow(ll_row + 1)
dw_vaccines.setredraw(true)



end event

type cb_edit from commandbutton within tabpage_vaccines
integer x = 914
integer y = 1444
integer width = 375
integer height = 108
integer taborder = 3
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;string ls_description
str_popup_return popup_return
long ll_row

ll_row = dw_vaccines.get_selected_row()

if ll_row <= 0 then return

ls_description = dw_vaccines.object.description[ll_row]

openwithparm(w_pop_yes_no, "Are you sure you wish to delete " + ls_description + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

UPDATE c_Vaccine
SET status = 'NA'
WHERE vaccine_id = :vaccine_id;
if not tf_check() then return

dw_vaccines.deleterow(ll_row)
dw_vaccines.resetupdate()


dw_vac_diseases.reset()
dw_vac_diseases.settransobject(sqlca)
cb_add_disease.enabled = false
cb_up.enabled = false
cb_down.enabled = false
cb_edit.enabled = false


end event

type dw_vac_diseases from u_dw_pick_list within tabpage_vaccines
integer x = 1426
integer y = 184
integer width = 914
integer height = 732
integer taborder = 3
string dataobject = "dw_vaccine_disease_list"
end type

event constructor;call super::constructor;settransobject(sqlca)

end event

event post_click;call super::post_click;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_attachment_button, li_sts, li_service_count
window lw_pop_buttons
long ll_disease_id

ll_disease_id = object.disease_id[lastrow]

setnull(li_attachment_button)

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonxm.bmp"
	popup.button_helps[popup.button_count] = "Delete Disease From Vaccine"
	popup.button_titles[popup.button_count] = "Delete"
	buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	setitem(lastrow, "selected_flag", 0)
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	setitem(lastrow, "selected_flag", 0)
	button_pressed = 1
else
	setitem(lastrow, "selected_flag", 0)
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "DELETE"
		DELETE FROM c_Vaccine_Disease
		WHERE vaccine_id = :vaccine_id
		AND disease_id = :ll_disease_id;
		if not tf_check() then return
		deleterow(lastrow)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type dw_vaccines from u_dw_pick_list within tabpage_vaccines
integer y = 32
integer width = 827
integer height = 1576
integer taborder = 2
string dataobject = "dw_vaccine_list"
boolean border = false
boolean livescroll = false
end type

event constructor;call super::constructor;settransobject(sqlca)

end event

event post_click;call super::post_click;
if lastselected then
	vaccine_id = object.vaccine_id[lastrow]
	dw_vac_diseases.retrieve(vaccine_id)
	dw_vac_diseases.last_page = 0
	dw_vac_diseases.set_page(1,pb_dise_up,pb_dise_down,st_dise_page)
	cb_add_disease.enabled = true
	cb_up.enabled = true
	cb_down.enabled = true
	cb_edit.enabled = true
	cb_makers.enabled = true
	cb_adminproc.enabled = true
end if

end event

type tabpage_diseases from userobject within u_tab_vaccine_diseases
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2391
integer height = 1624
long backcolor = 33538240
string text = "Diseases"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
st_page st_page
pb_vacc_up pb_vacc_up
pb_vacc_down pb_vacc_down
st_dis_page st_dis_page
pb_dis_up pb_dis_up
pb_dis_down pb_dis_down
st_2 st_2
dw_disease_vaccines dw_disease_vaccines
cb_add_vaccine cb_add_vaccine
cb_edit_d cb_edit_d
cb_alpha_d cb_alpha_d
cb_down_d cb_down_d
cb_up_d cb_up_d
cb_new_disease cb_new_disease
dw_diseases dw_diseases
end type

on tabpage_diseases.create
this.st_page=create st_page
this.pb_vacc_up=create pb_vacc_up
this.pb_vacc_down=create pb_vacc_down
this.st_dis_page=create st_dis_page
this.pb_dis_up=create pb_dis_up
this.pb_dis_down=create pb_dis_down
this.st_2=create st_2
this.dw_disease_vaccines=create dw_disease_vaccines
this.cb_add_vaccine=create cb_add_vaccine
this.cb_edit_d=create cb_edit_d
this.cb_alpha_d=create cb_alpha_d
this.cb_down_d=create cb_down_d
this.cb_up_d=create cb_up_d
this.cb_new_disease=create cb_new_disease
this.dw_diseases=create dw_diseases
this.Control[]={this.st_page,&
this.pb_vacc_up,&
this.pb_vacc_down,&
this.st_dis_page,&
this.pb_dis_up,&
this.pb_dis_down,&
this.st_2,&
this.dw_disease_vaccines,&
this.cb_add_vaccine,&
this.cb_edit_d,&
this.cb_alpha_d,&
this.cb_down_d,&
this.cb_up_d,&
this.cb_new_disease,&
this.dw_diseases}
end on

on tabpage_diseases.destroy
destroy(this.st_page)
destroy(this.pb_vacc_up)
destroy(this.pb_vacc_down)
destroy(this.st_dis_page)
destroy(this.pb_dis_up)
destroy(this.pb_dis_down)
destroy(this.st_2)
destroy(this.dw_disease_vaccines)
destroy(this.cb_add_vaccine)
destroy(this.cb_edit_d)
destroy(this.cb_alpha_d)
destroy(this.cb_down_d)
destroy(this.cb_up_d)
destroy(this.cb_new_disease)
destroy(this.dw_diseases)
end on

type st_page from statictext within tabpage_diseases
boolean visible = false
integer x = 1998
integer y = 1112
integer width = 297
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_vacc_up from u_picture_button within tabpage_diseases
boolean visible = false
integer x = 1984
integer y = 976
integer width = 137
integer height = 116
integer taborder = 11
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_disease_vaccines.current_page

dw_disease_vaccines.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_vacc_down.enabled = true

end event

type pb_vacc_down from u_picture_button within tabpage_diseases
boolean visible = false
integer x = 2167
integer y = 980
integer width = 137
integer height = 116
integer taborder = 11
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_disease_vaccines.current_page
li_last_page = dw_disease_vaccines.last_page

dw_disease_vaccines.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_vacc_up.enabled = true
end event

type st_dis_page from statictext within tabpage_diseases
integer x = 850
integer y = 20
integer width = 347
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_dis_up from u_picture_button within tabpage_diseases
boolean visible = false
integer x = 864
integer y = 104
integer width = 137
integer height = 116
integer taborder = 11
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_diseases.current_page

dw_diseases.set_page(li_page - 1, st_dis_page.text)

if li_page <= 2 then enabled = false
pb_dis_down.enabled = true

end event

type pb_dis_down from u_picture_button within tabpage_diseases
boolean visible = false
integer x = 1038
integer y = 104
integer width = 137
integer height = 116
integer taborder = 11
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_diseases.current_page
li_last_page = dw_diseases.last_page

dw_diseases.set_page(li_page + 1, st_dis_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_dis_up.enabled = true
end event

type st_2 from statictext within tabpage_diseases
integer x = 1417
integer y = 80
integer width = 933
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Vaccines Which Treat Disease:"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_disease_vaccines from u_dw_pick_list within tabpage_diseases
integer x = 1426
integer y = 184
integer width = 914
integer height = 728
integer taborder = 2
string dataobject = "dw_disease_vaccine_list"
end type

event constructor;call super::constructor;settransobject(sqlca)

end event

type cb_add_vaccine from commandbutton within tabpage_diseases
event clicked pbm_bnclicked
integer x = 1477
integer y = 968
integer width = 393
integer height = 108
integer taborder = 5
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Vaccine"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_row

popup.dataobject = "dw_vaccines_to_attach"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = string(disease_id)
popup.numeric_argument = true

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 0 then return

INSERT INTO c_Vaccine_Disease (
	vaccine_id,
	disease_id,
	units )
VALUES (
	:popup_return.items[1],
	:disease_id,
	1);
if not tf_check() then return

ll_row = dw_disease_vaccines.insertrow(0)
dw_disease_vaccines.setitem(ll_row, "vaccine_id", popup_return.items[1])
dw_disease_vaccines.setitem(ll_row, "description", popup_return.descriptions[1])
dw_disease_vaccines.setitem(ll_row, "sort_sequence", ll_row + 1000)
dw_disease_vaccines.setitem(ll_row, "selected_flag", 0)
dw_disease_vaccines.recalc_page(pb_vacc_up,pb_vacc_down,st_page)


end event

type cb_edit_d from commandbutton within tabpage_diseases
event clicked pbm_bnclicked
integer x = 919
integer y = 1444
integer width = 375
integer height = 108
integer taborder = 4
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;string ls_description
str_popup_return popup_return
long ll_row

ll_row = dw_diseases.get_selected_row()

if ll_row <= 0 then return

ls_description = dw_diseases.object.description[ll_row]

openwithparm(w_pop_yes_no, "Are you sure you wish to delete " + ls_description + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

UPDATE c_Disease
SET status = 'NA'
WHERE disease_id = :disease_id;
if not tf_check() then return

dw_diseases.deleterow(ll_row)
dw_diseases.resetupdate()


dw_disease_vaccines.reset()
dw_disease_vaccines.settransobject(sqlca)
cb_add_vaccine.enabled = false
cb_up_d.enabled = false
cb_down_d.enabled = false
cb_edit_d.enabled = false


end event

type cb_alpha_d from commandbutton within tabpage_diseases
event clicked pbm_bnclicked
integer x = 923
integer y = 1244
integer width = 375
integer height = 108
integer taborder = 6
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Alphabetize"
end type

event clicked;long i
long ll_rowcount

dw_diseases.setsort("description A")
dw_diseases.sort()

ll_rowcount = dw_diseases.rowcount()

for i = 1 to ll_rowcount
	dw_diseases.setitem(i, "sort_sequence", i)
next

dw_diseases.update()

dw_diseases.setsort("sort_sequence A")

end event

type cb_down_d from commandbutton within tabpage_diseases
event clicked pbm_bnclicked
integer x = 923
integer y = 1108
integer width = 375
integer height = 108
integer taborder = 6
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Down"
end type

event clicked;integer li_sort_sequence
integer li_sort_sequence_x
long ll_row
long ll_lastrow

ll_row = dw_diseases.get_selected_row()

if ll_row <= 0 then return
if ll_row >= dw_diseases.rowcount() then return

ll_lastrow = long(dw_diseases.Object.DataWindow.LastRowOnPage)

li_sort_sequence = dw_diseases.object.sort_sequence[ll_row]
li_sort_sequence_x = dw_diseases.object.sort_sequence[ll_row + 1]

dw_diseases.setitem(ll_row, "sort_sequence", li_sort_sequence_x)
dw_diseases.setitem(ll_row + 1, "sort_sequence", li_sort_sequence)

dw_diseases.setredraw(false)
dw_diseases.update()
dw_diseases.sort()
dw_diseases.scrolltorow(ll_lastrow)
dw_diseases.scrolltorow(ll_row + 1)
dw_diseases.setredraw(true)



end event

type cb_up_d from commandbutton within tabpage_diseases
event clicked pbm_bnclicked
integer x = 919
integer y = 972
integer width = 375
integer height = 108
integer taborder = 5
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Up"
end type

event clicked;integer li_sort_sequence
integer li_sort_sequence_x
long ll_row
long ll_lastrow

ll_row = dw_diseases.get_selected_row()

if ll_row <= 1 then return

ll_lastrow = long(dw_diseases.Object.DataWindow.LastRowOnPage)

li_sort_sequence = dw_diseases.object.sort_sequence[ll_row]
li_sort_sequence_x = dw_diseases.object.sort_sequence[ll_row - 1]

dw_diseases.setitem(ll_row, "sort_sequence", li_sort_sequence_x)
dw_diseases.setitem(ll_row - 1, "sort_sequence", li_sort_sequence)

dw_diseases.setredraw(false)
dw_diseases.update()
dw_diseases.sort()
dw_diseases.scrolltorow(ll_lastrow)
dw_diseases.scrolltorow(ll_row - 1)
dw_diseases.setredraw(true)



end event

type cb_new_disease from commandbutton within tabpage_diseases
event clicked pbm_bnclicked
integer x = 919
integer y = 764
integer width = 375
integer height = 108
integer taborder = 7
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Disease"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_rowcount
long i
integer li_sort_sequence
long ll_disease_id
integer li_sts


popup.item = "Enter Disease Description:"

openwithparm(w_pop_get_string, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 0 then return

ll_rowcount = dw_diseases.rowcount()

for i = 1 to ll_rowcount
	dw_diseases.setitem(i, "sort_sequence", i)
next

SELECT max(disease_id)
INTO :ll_disease_id
FROM c_Disease;
if not tf_check() then return

if isnull(ll_disease_id) then
	ll_disease_id = 1
else
	ll_disease_id += 1
end if

disease_id = ll_disease_id

dw_diseases.clear_selected()
i = dw_diseases.insertrow(0)
dw_diseases.setitem(i, "disease_id", disease_id)
dw_diseases.setitem(i, "description", popup_return.items[1])
dw_diseases.setitem(i, "status", "OK")
dw_diseases.setitem(i, "sort_sequence", i)
dw_diseases.setitem(i, "selected_flag", 1)
dw_diseases.scrolltorow(i)

li_sts = dw_diseases.update()

dw_disease_vaccines.retrieve(disease_id)
cb_add_vaccine.enabled = true
cb_up_d.enabled = true
cb_down_d.enabled = true
cb_edit_d.enabled = true
dw_diseases.recalc_page(pb_dis_up,pb_dis_down,st_dis_page)
end event

type dw_diseases from u_dw_pick_list within tabpage_diseases
integer y = 32
integer width = 823
integer height = 1576
integer taborder = 2
string dataobject = "dw_disease_list"
boolean border = false
boolean livescroll = false
end type

event constructor;call super::constructor;settransobject(sqlca)

end event

event post_click;call super::post_click;
if lastselected then
	disease_id = object.disease_id[lastrow]
	dw_disease_vaccines.retrieve(disease_id)
	dw_disease_vaccines.last_page = 0
	dw_disease_vaccines.set_page(1,pb_vacc_up,pb_vacc_down,st_page)
	cb_add_vaccine.enabled = true
	cb_up_d.enabled = true
	cb_down_d.enabled = true
	cb_edit_d.enabled = true
end if

end event

type tabpage_schedule from userobject within u_tab_vaccine_diseases
integer x = 18
integer y = 112
integer width = 2391
integer height = 1624
long backcolor = 33538240
string text = "Schedule"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
cb_add_schedule_item cb_add_schedule_item
dw_schedule dw_schedule
st_4 st_4
st_show st_show
st_3 st_3
st_schedule_title st_schedule_title
end type

on tabpage_schedule.create
this.cb_add_schedule_item=create cb_add_schedule_item
this.dw_schedule=create dw_schedule
this.st_4=create st_4
this.st_show=create st_show
this.st_3=create st_3
this.st_schedule_title=create st_schedule_title
this.Control[]={this.cb_add_schedule_item,&
this.dw_schedule,&
this.st_4,&
this.st_show,&
this.st_3,&
this.st_schedule_title}
end on

on tabpage_schedule.destroy
destroy(this.cb_add_schedule_item)
destroy(this.dw_schedule)
destroy(this.st_4)
destroy(this.st_show)
destroy(this.st_3)
destroy(this.st_schedule_title)
end on

type cb_add_schedule_item from commandbutton within tabpage_schedule
integer x = 1298
integer y = 1396
integer width = 608
integer height = 108
integer taborder = 6
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Schedule Item"
end type

event clicked;str_popup popup
str_popup_return popup_return
date ld_age
string ls_pretty_age
integer li_warning_days
long ll_row
long ll_rowcount
integer li_schedule_sequence
integer li_temp

popup.data_row_count = 0
openwithparm(w_schedule_item_edit, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

ld_age = date(popup_return.items[1])
li_warning_days = integer(popup_return.items[2])

if not (ld_age >= immunization_date_of_birth) then
	log.log(this, "u_tab_vaccine_diseases.cb_new_vaccine.clicked.0037", "Age not valid", 3)
	return
end if

dw_schedule.setredraw(false)

ll_rowcount = dw_schedule.insertrow(0)
dw_schedule.setitem(ll_rowcount, "age", ld_age)
dw_schedule.setitem(ll_rowcount, "pretty_age", f_pretty_age(immunization_date_of_birth, ld_age))
dw_schedule.setitem(ll_rowcount, "warning_days", li_warning_days)

dw_schedule.sort()

DELETE c_Immunization_Schedule
WHERE disease_id = :disease_id;
if not tf_check() then return

for ll_row = 1 to ll_rowcount
	dw_schedule.setitem(ll_row, "schedule_sequence", ll_row)
	ld_age = dw_schedule.object.age[ll_row]
	li_warning_days = dw_schedule.object.warning_days[ll_row]
	INSERT INTO c_Immunization_Schedule (
		disease_id,
		schedule_sequence,
		age,
		warning_days )
	VALUES (
		:disease_id,
		:ll_row,
		:ld_age,
		:li_warning_days );
	if not tf_check() then return
next

dw_schedule.setredraw(true)

end event

type dw_schedule from u_dw_pick_list within tabpage_schedule
event edit_item pbm_custom02
integer x = 1134
integer y = 420
integer width = 1111
integer height = 952
integer taborder = 2
string dataobject = "dw_disease_schedule"
boolean border = false
end type

event edit_item;str_popup popup
str_popup_return popup_return
date ld_age
string ls_pretty_age
integer li_warning_days
long ll_row
long ll_rowcount
integer li_schedule_sequence

ld_age = dw_schedule.object.age[lastrow]
li_warning_days = dw_schedule.object.warning_days[lastrow]
li_schedule_sequence = dw_schedule.object.schedule_sequence[lastrow]

popup.data_row_count = 2
popup.items[1] = string(ld_age)
popup.items[2] = string(li_warning_days)

openwithparm(w_schedule_item_edit, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

ld_age = date(popup_return.items[1])
li_warning_days = integer(popup_return.items[2])

if not (ld_age >= immunization_date_of_birth) then
	log.log(this, "u_tab_vaccine_diseases.cb_new_vaccine.clicked.0037", "Age not valid", 3)
	return
end if

UPDATE c_Immunization_Schedule
SET age = :ld_age,
	 warning_days = :li_warning_days
WHERE disease_id = :disease_id
AND schedule_sequence = :li_schedule_sequence;
if not tf_check() then return

dw_schedule.setredraw(false)

dw_schedule.setitem(lastrow, "age", ld_age)
dw_schedule.setitem(lastrow, "pretty_age", f_pretty_age(immunization_date_of_birth, ld_age))
dw_schedule.setitem(lastrow, "warning_days", li_warning_days)

dw_schedule.sort()

for ll_row = 1 to ll_rowcount
	dw_schedule.setitem(ll_row, "display_sequence", ll_row)
next

dw_schedule.setredraw(true)



end event

event post_click;call super::post_click;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_attachment_button, li_sts, li_service_count
window lw_pop_buttons
integer li_schedule_sequence

li_schedule_sequence = object.schedule_sequence[lastrow]

setnull(li_attachment_button)

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Schedule Item"
	popup.button_titles[popup.button_count] = "Edit"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonxm.bmp"
	popup.button_helps[popup.button_count] = "Delete Schedule Item"
	popup.button_titles[popup.button_count] = "Delete"
	buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	setitem(lastrow, "selected_flag", 0)
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	setitem(lastrow, "selected_flag", 0)
	button_pressed = 1
else
	setitem(lastrow, "selected_flag", 0)
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDIT"
		postevent("edit_item")
	CASE "DELETE"
		DELETE FROM c_Immunization_Schedule
		WHERE disease_id = :disease_id
		AND schedule_sequence = :li_schedule_sequence;
		if not tf_check() then return
		deleterow(lastrow)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type st_4 from statictext within tabpage_schedule
integer x = 1166
integer y = 304
integer width = 850
integer height = 100
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Schedule"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_show from statictext within tabpage_schedule
integer x = 311
integer y = 484
integer width = 288
integer height = 112
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if display_flag = "Y" then
	display_flag = "N"
	backcolor = color_object
	text = "No"
else
	display_flag = "Y"
	backcolor = color_object_selected
	text = "Yes"
end if

UPDATE c_Disease
SET display_flag = :display_flag
WHERE disease_id = :disease_id;
if not tf_check() then return


end event

type st_3 from statictext within tabpage_schedule
integer x = 133
integer y = 312
integer width = 722
integer height = 148
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Show This Disease On Immunization Schedule"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_schedule_title from statictext within tabpage_schedule
integer width = 2359
integer height = 124
integer textsize = -18
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

