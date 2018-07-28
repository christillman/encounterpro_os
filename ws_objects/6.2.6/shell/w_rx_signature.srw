HA$PBExportHeader$w_rx_signature.srw
forward
global type w_rx_signature from w_window_base
end type
type pb_cancel from u_picture_button within w_rx_signature
end type
type dw_new_rx from u_dw_pick_list within w_rx_signature
end type
type st_1 from statictext within w_rx_signature
end type
type cb_sign from commandbutton within w_rx_signature
end type
type cb_accept_no_sig from commandbutton within w_rx_signature
end type
end forward

global type w_rx_signature from w_window_base
integer width = 0
integer height = 0
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 0
string button_type = ""
boolean show_more_buttons = false
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
real x_factor = 0
real y_factor = 0
pb_cancel pb_cancel
dw_new_rx dw_new_rx
st_1 st_1
cb_sign cb_sign
cb_accept_no_sig cb_accept_no_sig
end type
global w_rx_signature w_rx_signature

forward prototypes
public subroutine load_new_rx_list ()
public subroutine set_rx_signed (long pl_attachment_id)
end prototypes

public subroutine load_new_rx_list ();integer i, j
long ll_row
long ll_rowcount
long ll_treatment_id
string ls_temp,ls_find
integer li_sts
str_encounter_description lstr_encounter
str_treatment_description 		lstr_treatment
str_progress_list lstr_attachments
string ls_signed_by

dw_new_rx.setredraw(false)
dw_new_rx.reset()

current_patient.encounters.encounter(lstr_encounter, current_patient.open_encounter.encounter_id)

temp_datastore.set_dataobject("dw_rx_list")
temp_datastore.retrieve(current_patient.cpr_id, current_patient.open_encounter.encounter_id)
ll_rowcount = temp_datastore.rowcount()


for i = 1 to ll_rowcount
	ll_treatment_id = temp_datastore.object.treatment_id[i]
	ll_row = dw_new_rx.insertrow(0)
	dw_new_rx.setitem(ll_row, "treatment_id", ll_treatment_id)
	lstr_treatment.treatment_id = ll_treatment_id
	lstr_treatment.begin_date = temp_datastore.object.begin_date[i]
	lstr_treatment.end_date = temp_datastore.object.end_date[i]
	lstr_treatment.close_encounter_id = temp_datastore.object.close_encounter_id[i]
	lstr_treatment.treatment_description = temp_datastore.object.treatment_description[i]
	lstr_treatment.treatment_status = temp_datastore.object.treatment_status[i]
	lstr_treatment.open_encounter_id = temp_datastore.object.open_encounter_id[i]
	
	ls_temp = f_treatment_full_description(lstr_treatment, lstr_encounter)
	
	lstr_attachments = current_patient.attachments.get_attachments( "Treatment", ll_treatment_id, "Attachment", "Signature")
	
	// If the treatment already has a signature then show who signed it
	If lstr_attachments.progress_count > 0 Then
		ls_signed_by = user_list.user_full_name(lstr_attachments.progress[lstr_attachments.progress_count].user_id)
		ls_temp += " (Signed by " + ls_signed_by + ")"
		dw_new_rx.setitem(ll_row,"signed",1)
	end if
	dw_new_rx.setitem(ll_row, "rx_sig", ls_temp)
next

dw_new_rx.setredraw(true)

return

end subroutine

public subroutine set_rx_signed (long pl_attachment_id);// Loop thru all the rx and update the signature for the one's not signed

Integer i
Long    ll_rows,ll_treatment_id

DECLARE lsp_set_treatment_signature PROCEDURE FOR dbo.sp_set_treatment_signature
	@pl_treatment_id = :ll_treatment_id,
	@pl_attachment_id = :pl_attachment_id;

ll_rows = dw_new_rx.rowcount()
For i = 1 to ll_rows
	If dw_new_rx.object.signed[i] = 1 Then Continue
	ll_treatment_id = dw_new_rx.object.treatment_id[i]
	EXECUTE lsp_set_treatment_signature;
Next
Return
end subroutine

on w_rx_signature.create
int iCurrent
call super::create
this.pb_cancel=create pb_cancel
this.dw_new_rx=create dw_new_rx
this.st_1=create st_1
this.cb_sign=create cb_sign
this.cb_accept_no_sig=create cb_accept_no_sig
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_cancel
this.Control[iCurrent+2]=this.dw_new_rx
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_sign
this.Control[iCurrent+5]=this.cb_accept_no_sig
end on

on w_rx_signature.destroy
call super::destroy
destroy(this.pb_cancel)
destroy(this.dw_new_rx)
destroy(this.st_1)
destroy(this.cb_sign)
destroy(this.cb_accept_no_sig)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts

if isnull(current_patient.open_encounter) then
	log.log(this, "open", "No open encounter", 4)
	popup_return.item_count = 1
	popup_return.items[1] = "ERROR"
	closewithreturn(this, popup_return)
	return
end if

load_new_rx_list()
if dw_new_rx.rowcount() = 0 then
	popup_return.item_count = 1
	popup_return.items[1] = "NORX"
	closewithreturn(this, popup_return)
	return
end if

if f_is_external_source_available("Signature") then
	cb_sign.text = "Sign"
else
	cb_sign.text = "Sign Later"
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_rx_signature
integer x = 0
integer y = 0
integer width = 0
integer height = 0
integer taborder = 0
integer textsize = 0
integer weight = 0
fontpitch fontpitch = default!
fontfamily fontfamily = anyfont!
string facename = ""
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_rx_signature
integer x = 0
integer y = 0
integer width = 0
integer height = 0
integer textsize = 0
integer weight = 0
fontpitch fontpitch = default!
fontfamily fontfamily = anyfont!
string facename = ""
long textcolor = 0
long backcolor = 0
end type

type pb_cancel from u_picture_button within w_rx_signature
integer x = 82
integer y = 1552
integer width = 0
integer height = 0
integer taborder = 40
boolean bringtotop = true
integer textsize = 0
integer weight = 0
fontpitch fontpitch = default!
fontfamily fontfamily = anyfont!
string facename = ""
boolean cancel = true
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

closewithreturn(parent, popup_return)


end event

type dw_new_rx from u_dw_pick_list within w_rx_signature
integer x = 101
integer y = 220
integer width = 2670
integer height = 756
integer taborder = 30
string dataobject = "dw_new_rx_list"
boolean livescroll = false
borderstyle borderstyle = stylelowered!
boolean select_computed = false
end type

type st_1 from statictext within w_rx_signature
integer width = 2885
integer height = 160
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "New Prescription Medications"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_sign from commandbutton within w_rx_signature
integer x = 1545
integer y = 1172
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

event clicked;integer li_log_id
String 	ls_claimedid,ls_service,ls_find
Long		ll_encounter_id,ll_treatment_id,ll_attachment_id
integer  li_sts
str_progress_list lstr_attachments

str_popup_return popup_return
str_attributes lstra_attributes
str_attachment lstr_attachment

if f_is_external_source_available("Signature") then
	ls_service = "EXTERNAL_SOURCE"
	ll_encounter_id = current_patient.open_encounter.encounter_id
	Setnull(ll_treatment_id)
	If dw_new_rx.rowcount() > 0 Then
		// get the signature ( we need atleast one vaccine reference )
		// now use the same signature for all the other vaccines in this list
		ll_treatment_id = dw_new_rx.object.treatment_id[1]
	End If

	f_attribute_add_attribute(lstra_attributes, "encounter_id", String(ll_encounter_id))
	f_attribute_add_attribute(lstra_attributes, "external_source_type", "Signature")
	f_attribute_add_attribute(lstra_attributes, "treatment_id", String(ll_treatment_id))
	f_attribute_add_attribute(lstra_attributes, "attachment_context_object", "Treatment")
	f_attribute_add_attribute(lstra_attributes, "attachment_object_key", String(ll_treatment_id))
	f_attribute_add_attribute(lstra_attributes, "progress_type", "Attachment")
	f_attribute_add_attribute(lstra_attributes, "progress_key", "Signature")

	li_sts = service_list.do_service(ls_service,lstra_attributes)
	If li_sts <= 0 Then
		log.log(this,"clicked()","Failed to get encounter signature",4)
		pb_cancel.event clicked()
		Return
	End If

	lstr_attachments = current_patient.attachments.get_attachments( "Treatment", ll_treatment_id, "Attachment", "Signature")

	If lstr_attachments.progress_count > 0 Then
		ll_attachment_id = lstr_attachments.progress[lstr_attachments.progress_count].attachment_id
		// Use the same signature for all other unsigned Rx's
		If ll_attachment_id > 0 Then set_rx_signed(ll_attachment_id)
	End If

	popup_return.item_count = 1
	popup_return.items[1] = "ACCEPT"

Else
//	li_log_id = current_patient.open_encounter.find_service("RX_SIGNATURE")
//	if li_log_id = 0 then
//		li_log_id = current_patient.open_encounter.order_service("RX_SIGNATURE", "Signature for Prescriptions", current_user.user_id)
//	end if
	popup_return.item_count = 1
	popup_return.items[1] = "ACCEPTLATER"
End if

Closewithreturn(parent, popup_return)

end event

type cb_accept_no_sig from commandbutton within w_rx_signature
integer x = 594
integer y = 1172
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

popup_return.item_count = 1
popup_return.items[1] = "ACCEPTNOSIG"

closewithreturn(parent, popup_return)


end event

