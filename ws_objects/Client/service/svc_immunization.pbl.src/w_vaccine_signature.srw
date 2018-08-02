$PBExportHeader$w_vaccine_signature.srw
forward
global type w_vaccine_signature from w_window_base
end type
type dw_vaccine_list from u_dw_pick_list within w_vaccine_signature
end type
type st_1 from statictext within w_vaccine_signature
end type
type cb_sign from commandbutton within w_vaccine_signature
end type
type cb_accept_no_sig from commandbutton within w_vaccine_signature
end type
type st_the_following from statictext within w_vaccine_signature
end type
type mle_statement from multilineedit within w_vaccine_signature
end type
type cb_cancel from commandbutton within w_vaccine_signature
end type
end forward

global type w_vaccine_signature from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_vaccine_list dw_vaccine_list
st_1 st_1
cb_sign cb_sign
cb_accept_no_sig cb_accept_no_sig
st_the_following st_the_following
mle_statement mle_statement
cb_cancel cb_cancel
end type
global w_vaccine_signature w_vaccine_signature

type variables
str_treatment_description vaccines[]
integer vaccine_count
boolean approve_warning

end variables

forward prototypes
public subroutine set_vaccine_signature (long pl_attachment_id)
public function integer load_new_vaccine_list ()
end prototypes

public subroutine set_vaccine_signature (long pl_attachment_id);// a stored procedure to update the signature for all vaccines
Integer i
Long    ll_rows,ll_treatment_id

DECLARE lsp_set_treatment_signature PROCEDURE FOR dbo.sp_set_treatment_signature
	@pl_treatment_id = :ll_treatment_id,
	@pl_attachment_id = :pl_attachment_id;

ll_rows = dw_vaccine_list.rowcount()
For i = 2 to ll_rows
	ll_treatment_id = dw_vaccine_list.object.treatment_id[i]
	EXECUTE lsp_set_treatment_signature;
Next
Return
end subroutine

public function integer load_new_vaccine_list ();Integer i
Long ll_row,ll_treatment_id
str_progress_list lstr_attachments
dw_vaccine_list.setredraw(False)
dw_vaccine_list.reset()
string ls_find
date ld_encounter_date

ld_encounter_date = date(current_patient.open_encounter_date)
if isnull(ld_encounter_date) then ld_encounter_date = today()

ls_find = "treatment_type='IMMUNIZATION' and open_encounter_id=" &
			+ string(current_patient.open_encounter.encounter_id) &
			+ " and (isnull(treatment_status) or treatment_status <> 'CANCELLED')"

vaccine_count = current_patient.treatments.get_treatments(ls_find, vaccines)

For i = 1 To vaccine_count
	// don't sign if the vaccine was given on a different date from the encounter date
	if date(vaccines[i].begin_date) <>  ld_encounter_date then continue
	
	// If the vaccine is already signed then continue
	ll_treatment_id = vaccines[i].treatment_id

	lstr_attachments = current_patient.attachments.get_attachments( "Treatment", ll_treatment_id, "Attachment", "Signature")
	
	// If the treatment already has a signature attachment then skip it
	If lstr_attachments.progress_count > 0 Then continue

	ll_row = dw_vaccine_list.insertrow(0)
	dw_vaccine_list.object.vaccine[ll_row] = vaccines[i].treatment_description
	dw_vaccine_list.object.treatment_id[ll_row] = vaccines[i].treatment_id
Next

dw_vaccine_list.setredraw(True)

Return 1

end function

on w_vaccine_signature.create
int iCurrent
call super::create
this.dw_vaccine_list=create dw_vaccine_list
this.st_1=create st_1
this.cb_sign=create cb_sign
this.cb_accept_no_sig=create cb_accept_no_sig
this.st_the_following=create st_the_following
this.mle_statement=create mle_statement
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_vaccine_list
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_sign
this.Control[iCurrent+4]=this.cb_accept_no_sig
this.Control[iCurrent+5]=this.st_the_following
this.Control[iCurrent+6]=this.mle_statement
this.Control[iCurrent+7]=this.cb_cancel
end on

on w_vaccine_signature.destroy
call super::destroy
destroy(this.dw_vaccine_list)
destroy(this.st_1)
destroy(this.cb_sign)
destroy(this.cb_accept_no_sig)
destroy(this.st_the_following)
destroy(this.mle_statement)
destroy(this.cb_cancel)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts
string ls_statement

if isnull(current_patient.open_encounter) then
	log.log(this, "w_vaccine_signature.open.0006", "No open encounter", 4)
	popup_return.item_count = 1
	popup_return.items[1] = "ERROR"
	closewithreturn(this, popup_return)
end if

li_sts = load_new_vaccine_list()
if li_sts <= 0 then
	popup_return.item_count = 1
	popup_return.items[1] = "NORX"
	closewithreturn(this, popup_return)
end if

st_the_following.text = "The following vaccines will be administered for " + current_patient.name() + ":"

ls_statement = current_service.get_attribute("Vaccine Consent Statement")
if isnull(ls_statement) then
	ls_statement = datalist.get_preference( "PREFERENCES", "Vaccine Consent Statement")
end if

if len(ls_statement) > 0 then
	mle_statement.text = ls_statement
end if

if isnull(current_service) then
	approve_warning = false
else
	current_service.get_attribute("Approve Nosig Warning", approve_warning, false)
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_vaccine_signature
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_vaccine_signature
integer x = 370
integer y = 1712
end type

type dw_vaccine_list from u_dw_pick_list within w_vaccine_signature
integer x = 850
integer y = 368
integer width = 1225
integer height = 756
integer taborder = 30
string dataobject = "dw_vaccine_approval_list"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_vaccine_signature
integer width = 2926
integer height = 160
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Immunization Approval"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_sign from commandbutton within w_vaccine_signature
integer x = 2107
integer y = 1648
integer width = 736
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sign"
end type

event clicked;String 	ls_claimedid,ls_service,ls_find
Long		ll_encounter_id,ll_treatment_id,ll_attachment_id
integer  li_sts
str_popup popup
str_popup_return popup_return
str_attributes lstra_attributes
str_attachment lstr_attachment
str_progress_list lstr_attachments

ls_claimedid = "Parent or Legal Guardian of " + current_patient.name()

ls_service = "EXTERNAL_SOURCE"
ll_encounter_id = current_patient.open_encounter.encounter_id
Setnull(ll_treatment_id)
If dw_vaccine_list.rowcount() > 0 Then
	// get the signature ( we need atleast one vaccine reference )
	// now use the same signature for all the other vaccines in this list
	ll_treatment_id = dw_vaccine_list.object.treatment_id[1]
End If

f_attribute_add_attribute(lstra_attributes, "encounter_id", String(ll_encounter_id))
f_attribute_add_attribute(lstra_attributes, "external_source_type", "Signature")
f_attribute_add_attribute(lstra_attributes, "treatment_id", String(ll_treatment_id))
f_attribute_add_attribute(lstra_attributes, "attachment_context_object", "Treatment")
f_attribute_add_attribute(lstra_attributes, "attachment_object_key", String(ll_treatment_id))
f_attribute_add_attribute(lstra_attributes, "progress_type", "Attachment")
f_attribute_add_attribute(lstra_attributes, "progress_key", "Signature")
f_attribute_add_attribute(lstra_attributes, "claimed_id", ls_claimedid)

li_sts = service_list.do_service(ls_service,lstra_attributes)
If li_sts <> 1 Then
	popup.title = "No signature was captured.  Do you wish to:"
	popup.data_row_count = 3
	popup.items[1] = "Try Again"
	popup.items[2] = "Accept Without Signing"
	popup.items[3] = "Sign Later"
	openwithparm(w_pop_choices_3, popup)
	li_sts = message.doubleparm
	if li_sts = 1 then
		return
	elseif li_sts = 2 then
		popup_return.item_count = 1
		popup_return.items[1] = "ACCEPT"
	else
		popup_return.item_count = 0
	end if
	closewithreturn(parent, popup_return)
	return
End If

lstr_attachments = current_patient.attachments.get_attachments( "Treatment", ll_treatment_id, "Attachment", "Signature")

If lstr_attachments.progress_count > 0 Then
	ll_attachment_id = lstr_attachments.progress[lstr_attachments.progress_count].attachment_id
	if ll_attachment_id > 0 Then set_vaccine_signature(ll_attachment_id)
End If

popup_return.item_count = 1
popup_return.items[1] = "ACCEPT"

closewithreturn(parent, popup_return)


end event

type cb_accept_no_sig from commandbutton within w_vaccine_signature
integer x = 1097
integer y = 1648
integer width = 736
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Accept w/o Signature"
end type

event clicked;str_popup_return popup_return

if approve_warning then
	openwithparm(w_pop_yes_no, "Are you sure you want to approve these vaccinations without capturing a signature?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if


popup_return.item_count = 1
popup_return.items[1] = "ACCEPTNOSIG"

closewithreturn(parent, popup_return)


end event

type st_the_following from statictext within w_vaccine_signature
integer x = 23
integer y = 256
integer width = 2885
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "The following vaccines will be administered for"
alignment alignment = center!
boolean focusrectangle = false
end type

type mle_statement from multilineedit within w_vaccine_signature
integer x = 59
integer y = 1212
integer width = 2779
integer height = 364
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "I received a copy of the Vaccine Information Statement for each vaccine.  I know the risks of the disease each vaccine prevents.  I know the benefits and the risks of each vaccine.  I have had a chance to ask questions about the disease, the vaccines and"
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_vaccine_signature
integer x = 64
integer y = 1648
integer width = 416
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

closewithreturn(parent, popup_return)


end event

