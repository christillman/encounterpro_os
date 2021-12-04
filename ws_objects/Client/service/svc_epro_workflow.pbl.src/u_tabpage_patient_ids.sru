$PBExportHeader$u_tabpage_patient_ids.sru
forward
global type u_tabpage_patient_ids from u_tabpage
end type
type cb_new_id from commandbutton within u_tabpage_patient_ids
end type
type st_idvalue_title from statictext within u_tabpage_patient_ids
end type
type st_iddomain_title from statictext within u_tabpage_patient_ids
end type
type st_owner_title from statictext within u_tabpage_patient_ids
end type
type dw_patient_ids from u_dw_pick_list within u_tabpage_patient_ids
end type
type st_cpr_id from statictext within u_tabpage_patient_ids
end type
end forward

global type u_tabpage_patient_ids from u_tabpage
integer width = 2875
integer height = 1268
string text = "none"
cb_new_id cb_new_id
st_idvalue_title st_idvalue_title
st_iddomain_title st_iddomain_title
st_owner_title st_owner_title
dw_patient_ids dw_patient_ids
st_cpr_id st_cpr_id
end type
global u_tabpage_patient_ids u_tabpage_patient_ids

type variables

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();integer li_sts
string ls_temp

if isnull(current_patient) then
	log.log(this, "u_tabpage_patient_ids.initialize:0005", "No current patient", 4)
	return -1
else
	st_cpr_id.text = current_patient.cpr_id
end if

return 1

end function

public subroutine refresh ();long i
string ls_null
long ll_null
u_ds_data luo_data
long ll_count
string ls_temp
long ll_owner_id
long ll_row
string ls_iddomain
string ls_idvalue
string ls_progress_key
string ls_owner_name

setnull(ls_null)
setnull(ll_null)

dw_patient_ids.reset()
dw_patient_ids.object.iddomain.x = st_iddomain_title.x - dw_patient_ids.x
dw_patient_ids.object.idvalue.x = st_idvalue_title.x - dw_patient_ids.x
dw_patient_ids.object.idvalue.width = st_idvalue_title.width


luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_domain_translate_list")
ll_count = luo_data.retrieve("Patient ID")

for i = 1 to ll_count
	ls_temp = luo_data.object.domain_item[i]
	if isnumber(ls_temp) then
		// Convert the owner id to a long
		ll_owner_id = long(ls_temp)
		
		// Look up the owner name		
		SELECT owner
		INTO :ls_owner_name
		FROM c_Owner
		WHERE owner_id = :ll_owner_id;
		if not tf_check() then return
		if sqlca.sqlcode = 100 then
			ls_owner_name = "Owner " + string(ll_owner_id)
		end if
	
		// Get the ID Domain
		ls_iddomain = luo_data.object.domain_item_description[i]
		
		// Look up the current value for this ID Domain and owner
		ls_progress_key = string(ll_owner_id) + "^" + ls_iddomain
		ls_idvalue = f_get_progress_value(current_patient.cpr_id, &
									"Patient", &
									ll_null, &
									"ID", &
									ls_progress_key)

		// Now display the record
		ll_row = dw_patient_ids.insertrow(0)
		dw_patient_ids.object.owner_id[ll_row] = ll_owner_id
		dw_patient_ids.object.owner_name[ll_row] = ls_owner_name
		dw_patient_ids.object.iddomain[ll_row] = ls_iddomain
		dw_patient_ids.object.idvalue[ll_row] = ls_idvalue
	end if
next


DESTROY luo_data

end subroutine

on u_tabpage_patient_ids.create
int iCurrent
call super::create
this.cb_new_id=create cb_new_id
this.st_idvalue_title=create st_idvalue_title
this.st_iddomain_title=create st_iddomain_title
this.st_owner_title=create st_owner_title
this.dw_patient_ids=create dw_patient_ids
this.st_cpr_id=create st_cpr_id
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_new_id
this.Control[iCurrent+2]=this.st_idvalue_title
this.Control[iCurrent+3]=this.st_iddomain_title
this.Control[iCurrent+4]=this.st_owner_title
this.Control[iCurrent+5]=this.dw_patient_ids
this.Control[iCurrent+6]=this.st_cpr_id
end on

on u_tabpage_patient_ids.destroy
call super::destroy
destroy(this.cb_new_id)
destroy(this.st_idvalue_title)
destroy(this.st_iddomain_title)
destroy(this.st_owner_title)
destroy(this.dw_patient_ids)
destroy(this.st_cpr_id)
end on

type cb_new_id from commandbutton within u_tabpage_patient_ids
integer x = 1225
integer y = 936
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New ID"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_owner_id
string ls_owner_id
string ls_IDDomain
long ll_count

popup.title = "Enter Owner ID for New External ID"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return
ls_owner_id = popup_return.items[1]
if not isnumber(ls_owner_id) then
	openwithparm(w_pop_message, "The Owner ID must be a number")
	return
end if

ll_owner_id = long(popup_return.items[1])

popup.title = "Enter the Domain Name for the New External ID"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return
ls_IDDomain = popup_return.items[1]


SELECT count(*)
INTO :ll_count
FROM c_Domain
WHERE domain_id = 'Patient ID'
AND domain_item = :ls_owner_id
AND domain_item_description = :ls_IDDomain;
if not tf_check() then return

if ll_count > 0 then
	openwithparm(w_pop_message, "That Owner/Domain already exists")
	return
end if

SELECT max(domain_sequence) + 1
INTO :ll_count
FROM c_Domain
WHERE domain_id = 'Patient ID';
if not tf_check() then return

IF isnull(ll_count) then ll_count = 1

INSERT INTO c_Domain (
	domain_id,
	domain_sequence,
	domain_item,
	domain_item_description)
VALUES (
	'Patient ID',
	:ll_count,
	:ls_owner_id,
	:ls_IDDomain);
if not tf_check() then return

refresh()

end event

type st_idvalue_title from statictext within u_tabpage_patient_ids
integer x = 2053
integer y = 92
integer width = 512
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "ID Value"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_iddomain_title from statictext within u_tabpage_patient_ids
integer x = 1266
integer y = 92
integer width = 361
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "ID Name"
boolean focusrectangle = false
end type

type st_owner_title from statictext within u_tabpage_patient_ids
integer x = 247
integer y = 92
integer width = 411
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "ID Owner"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_patient_ids from u_dw_pick_list within u_tabpage_patient_ids
integer x = 215
integer y = 168
integer width = 2455
integer height = 704
integer taborder = 10
string dataobject = "dw_patient_ids"
boolean vscrollbar = true
end type

event selected;call super::selected;str_popup popup
str_popup_return popup_return
string ls_IDValue
long ll_null
integer li_sts
string ls_progress_key
string ls_other_cpr_id
string ls_billing_id
string ls_last_name
string ls_first_name
string ls_message

setnull(ll_null)

openwithparm(w_pop_yes_no, "Do you wish to change this ID Value for this patient?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


popup.title = "Enter New Value for this External ID"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return
ls_IDValue = popup_return.items[1]

ls_progress_key = string(long(object.owner_id[selected_row])) + "^" + string(object.iddomain[selected_row])

SELECT min(cpr_id)
INTO :ls_other_cpr_id
FROM p_Patient_Progress
WHERE progress_type = 'ID'
AND progress_key = :ls_progress_key
AND progress_value = :ls_IDValue
AND current_flag = 'Y'
AND cpr_id <> :current_patient.cpr_id;
if not tf_check() then return

if len(ls_other_cpr_id) > 0 then
	SELECT billing_id, last_name, first_name
	INTO :ls_billing_id, :ls_last_name, :ls_first_name
	FROM p_Patient
	WHERE cpr_id = :ls_other_cpr_id;
	if not tf_check() then return
	
	ls_message = "The ID value you have entered is already assigned to another patient ("
	if len(ls_billing_id) > 0 then
		ls_message += ls_billing_id + ", "
	end if

	if len(ls_first_name) > 0 then
		ls_message += ls_first_name + " "
	end if

	if len(ls_last_name) > 0 then
		ls_message += ls_last_name
	end if

	ls_message += ").  You must change the id for the other patient before you can assign the id to this patient."

	openwithparm(w_pop_message, ls_message)
	return
end if


li_sts = f_Set_Progress(current_patient.cpr_id, &
								"Patient", &
								ll_null, &
								"ID", &
								ls_progress_key, &
								ls_IDValue, &
								datetime(today(), now()), &
								ll_null, &
								ll_null, &
								ll_null )


refresh()

end event

type st_cpr_id from statictext within u_tabpage_patient_ids
integer x = 27
integer y = 24
integer width = 375
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

