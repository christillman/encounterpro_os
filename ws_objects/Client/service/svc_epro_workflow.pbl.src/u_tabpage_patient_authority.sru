$PBExportHeader$u_tabpage_patient_authority.sru
forward
global type u_tabpage_patient_authority from u_tabpage
end type
type st_tertiary_title from statictext within u_tabpage_patient_authority
end type
type st_tertiary_authority from statictext within u_tabpage_patient_authority
end type
type st_secondary_title from statictext within u_tabpage_patient_authority
end type
type st_secondary_authority from statictext within u_tabpage_patient_authority
end type
type st_primary_authority from statictext within u_tabpage_patient_authority
end type
type st_primary_title from statictext within u_tabpage_patient_authority
end type
type st_cpr_id from statictext within u_tabpage_patient_authority
end type
end forward

global type u_tabpage_patient_authority from u_tabpage
integer width = 2875
integer height = 1268
string text = "none"
st_tertiary_title st_tertiary_title
st_tertiary_authority st_tertiary_authority
st_secondary_title st_secondary_title
st_secondary_authority st_secondary_authority
st_primary_authority st_primary_authority
st_primary_title st_primary_title
st_cpr_id st_cpr_id
end type
global u_tabpage_patient_authority u_tabpage_patient_authority

type variables

end variables

forward prototypes
public function integer initialize ()
public function integer show_patient (string ps_cpr_id)
public subroutine refresh ()
public function integer update_authority (string ps_authority_id, string ps_authority_type, integer pi_authority_sequence)
end prototypes

public function integer initialize ();integer li_sts
string ls_temp

if isnull(current_patient) then
	log.log(this, "u_tabpage_patient_authority.initialize.0005", "No current patient", 4)
	return -1
else
	st_cpr_id.text = current_patient.cpr_id
end if

return 1

end function

public function integer show_patient (string ps_cpr_id);long ll_authority_sequence,ll_row
integer li_sts,i
str_patient_authorities lstr_patient_authorities


st_primary_authority.text = ""
st_secondary_authority.text = ""
st_tertiary_authority.text = ""

lstr_patient_authorities = current_patient.get_authorities()

for i = 1 to lstr_patient_authorities.authority_count
	if upper(lstr_patient_authorities.authority[i].authority_type) = "PAYOR" then
		CHOOSE CASE lstr_patient_authorities.authority[i].authority_sequence
			CASE 1
				st_primary_authority.text = lstr_patient_authorities.authority[i].authority_name
			CASE 2
				st_secondary_authority.text = lstr_patient_authorities.authority[i].authority_name
			CASE 3
				st_tertiary_authority.text = lstr_patient_authorities.authority[i].authority_name
		END CHOOSE
	end if
next


Return 1


end function

public subroutine refresh ();show_patient(current_patient.cpr_id)

end subroutine

public function integer update_authority (string ps_authority_id, string ps_authority_type, integer pi_authority_sequence);datetime ldt_now

ldt_now = datetime(today(), now())

if isnull(ps_authority_id) or trim(ps_authority_id) = "" then return 0
if isnull(ps_authority_type) or trim(ps_authority_type) = "" then
	SELECT authority_type
	INTO :ps_authority_type
	FROM c_Authority
	WHERE authority_id = :ps_authority_id;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		log.log(this, "u_tabpage_patient_authority.update_authority.0013", "Authority not found (" + ps_authority_id + ")", 4)
		return -1
	end if
end if

DELETE FROM p_Patient_Authority
WHERE cpr_id = :current_patient.cpr_id
AND authority_type = :ps_authority_type
AND authority_sequence = :pi_authority_sequence;
if not tf_check() then return -1

INSERT INTO p_Patient_Authority (
	cpr_id,
	authority_type,
	Authority_sequence,
	Authority_id,
	created,
	created_by,
	modified_by)
VALUES (
	:current_patient.cpr_id,
	:ps_authority_type,
	:pi_authority_sequence,
	:ps_authority_id,
	:ldt_now,
	:current_scribe.user_id,
	:current_scribe.user_id);
if not tf_check() then return -1

return 1

end function

on u_tabpage_patient_authority.create
int iCurrent
call super::create
this.st_tertiary_title=create st_tertiary_title
this.st_tertiary_authority=create st_tertiary_authority
this.st_secondary_title=create st_secondary_title
this.st_secondary_authority=create st_secondary_authority
this.st_primary_authority=create st_primary_authority
this.st_primary_title=create st_primary_title
this.st_cpr_id=create st_cpr_id
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_tertiary_title
this.Control[iCurrent+2]=this.st_tertiary_authority
this.Control[iCurrent+3]=this.st_secondary_title
this.Control[iCurrent+4]=this.st_secondary_authority
this.Control[iCurrent+5]=this.st_primary_authority
this.Control[iCurrent+6]=this.st_primary_title
this.Control[iCurrent+7]=this.st_cpr_id
end on

on u_tabpage_patient_authority.destroy
call super::destroy
destroy(this.st_tertiary_title)
destroy(this.st_tertiary_authority)
destroy(this.st_secondary_title)
destroy(this.st_secondary_authority)
destroy(this.st_primary_authority)
destroy(this.st_primary_title)
destroy(this.st_cpr_id)
end on

type st_tertiary_title from statictext within u_tabpage_patient_authority
integer x = 279
integer y = 620
integer width = 617
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Tertiary Payer"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_tertiary_authority from statictext within u_tabpage_patient_authority
integer x = 937
integer y = 604
integer width = 1344
integer height = 108
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer li_sts
str_popup_return popup_return
string ls_authority_id
string ls_authority_type

open(w_carrier_select)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_authority_id = popup_return.items[1]
ls_authority_type = popup_return.items[2]
text = popup_return.descriptions[1]
li_sts = update_authority(ls_authority_id, ls_authority_type, 3)



end event

type st_secondary_title from statictext within u_tabpage_patient_authority
integer x = 279
integer y = 364
integer width = 617
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Secondary Payer"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_secondary_authority from statictext within u_tabpage_patient_authority
integer x = 937
integer y = 348
integer width = 1344
integer height = 108
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer li_sts
str_popup_return popup_return
string ls_authority_id
string ls_authority_type

open(w_carrier_select)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_authority_id = popup_return.items[1]
ls_authority_type = popup_return.items[2]
text = popup_return.descriptions[1]
li_sts = update_authority(ls_authority_id, ls_authority_type, 2)



end event

type st_primary_authority from statictext within u_tabpage_patient_authority
integer x = 937
integer y = 92
integer width = 1344
integer height = 108
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer li_sts
str_popup_return popup_return
string ls_authority_id
string ls_authority_type

open(w_carrier_select)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_authority_id = popup_return.items[1]
ls_authority_type = popup_return.items[2]
text = popup_return.descriptions[1]
li_sts = update_authority(ls_authority_id, ls_authority_type, 1)



end event

type st_primary_title from statictext within u_tabpage_patient_authority
integer x = 279
integer y = 108
integer width = 617
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Primary Payer"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_cpr_id from statictext within u_tabpage_patient_authority
integer x = 27
integer y = 24
integer width = 375
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

