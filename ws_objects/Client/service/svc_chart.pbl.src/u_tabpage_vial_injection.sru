$PBExportHeader$u_tabpage_vial_injection.sru
forward
global type u_tabpage_vial_injection from u_tabpage
end type
type st_unit from statictext within u_tabpage_vial_injection
end type
type st_6 from statictext within u_tabpage_vial_injection
end type
type cb_new from commandbutton within u_tabpage_vial_injection
end type
type cb_close from commandbutton within u_tabpage_vial_injection
end type
type uo_picture from u_picture_display within u_tabpage_vial_injection
end type
type st_3 from statictext within u_tabpage_vial_injection
end type
type st_vials from statictext within u_tabpage_vial_injection
end type
type pb_down from u_picture_button within u_tabpage_vial_injection
end type
type pb_up from u_picture_button within u_tabpage_vial_injection
end type
type st_page from statictext within u_tabpage_vial_injection
end type
type st_5 from statictext within u_tabpage_vial_injection
end type
type dw_vials from u_dw_pick_list within u_tabpage_vial_injection
end type
type st_title from statictext within u_tabpage_vial_injection
end type
type rte_history from u_rich_text_edit within u_tabpage_vial_injection
end type
type cb_shot from commandbutton within u_tabpage_vial_injection
end type
type st_1 from statictext within u_tabpage_vial_injection
end type
type st_4 from statictext within u_tabpage_vial_injection
end type
type st_amount_text from statictext within u_tabpage_vial_injection
end type
type st_amount from statictext within u_tabpage_vial_injection
end type
type mle_comments from multilineedit within u_tabpage_vial_injection
end type
type st_2 from statictext within u_tabpage_vial_injection
end type
type cb_location from commandbutton within u_tabpage_vial_injection
end type
type st_comment from statictext within u_tabpage_vial_injection
end type
type st_location_domain_edit from statictext within u_tabpage_vial_injection
end type
type gb_1 from groupbox within u_tabpage_vial_injection
end type
type st_portrait from statictext within u_tabpage_vial_injection
end type
end forward

global type u_tabpage_vial_injection from u_tabpage
integer width = 2729
integer height = 1376
st_unit st_unit
st_6 st_6
cb_new cb_new
cb_close cb_close
uo_picture uo_picture
st_3 st_3
st_vials st_vials
pb_down pb_down
pb_up pb_up
st_page st_page
st_5 st_5
dw_vials dw_vials
st_title st_title
rte_history rte_history
cb_shot cb_shot
st_1 st_1
st_4 st_4
st_amount_text st_amount_text
st_amount st_amount
mle_comments mle_comments
st_2 st_2
cb_location cb_location
st_comment st_comment
st_location_domain_edit st_location_domain_edit
gb_1 gb_1
st_portrait st_portrait
end type
global u_tabpage_vial_injection u_tabpage_vial_injection

type variables
real							dose_amount
string						dose_unit
string						location
string						location_domain
string						preference_id
string						vial_desc
string						allergy_treatment_desc
string						vial_ins_treatment_type = 'Allergyvialinstance'
long							vial_treatment_id
long							allergy_root_treatment_id
long							shot_display_script_id
long							selected_tab

u_component_service		service
end variables

forward prototypes
public subroutine display_portrait ()
public subroutine change_title (string ps_desc)
public subroutine show_history ()
public subroutine initialize (u_component_service puo_service, string ps_tapage_text)
public function integer show_vials ()
public subroutine refresh ()
end prototypes

public subroutine display_portrait ();string ls_file
string ls_find
integer li_sts
u_component_attachment luo_image
str_progress_list lstr_attachments
long ll_null

setnull(ll_null)

lstr_attachments = current_patient.attachments.get_attachments( "Patient", ll_null, "Attachment", "Portrait")

If lstr_attachments.progress_count > 0 Then
	ls_file = current_patient.attachments.get_attachment(lstr_attachments.progress[lstr_attachments.progress_count].attachment_id)
	uo_picture.display_picture(ls_file)
	st_portrait.visible = false
	uo_picture.visible = true
	filedelete(ls_file)
else
	st_portrait.visible = true
	uo_picture.visible = false
end if
end subroutine

public subroutine change_title (string ps_desc);if isnull(ps_desc) or len(ps_desc) = 0 then 
	st_title.text = "Admin "+allergy_treatment_desc+" - Vial ???"
	return
end if

st_title.text = "Admin "+allergy_treatment_desc+" - "+ ps_desc

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -8
		else
			st_title.textsize = -10
		end if
	else
		st_title.textsize = -10
	end if
else
	st_title.textsize = -12
end if
end subroutine

public subroutine show_history ();current_service.treatment_id = allergy_root_treatment_id
rte_history.clear_rtf()
rte_history.display_script(shot_display_script_id)
current_service.treatment_id = 0
end subroutine

public subroutine initialize (u_component_service puo_service, string ps_tapage_text);string ls_dose_amount

service = puo_service

text = ps_tapage_text

ls_dose_amount = f_get_global_preference("ALLERGY_ADMIN", "LAST_DOSE_" + string(allergy_root_treatment_id))
dose_amount = real(ls_dose_amount)
st_amount_text.text = ls_dose_amount

if not isnull(service) then
	shot_display_script_id = long(service.get_attribute("allergy_admin_display_script_id"))
end if

// dose unit
dose_unit = service.get_attribute("dose_unit")
if isnull(dose_unit) or len(dose_unit) = 0 then
	dose_unit = "ML"
end if
st_unit.text = dose_unit

location_domain = service.get_attribute("location_domain")
if isnull(location_domain) or len(location_domain) = 0 then
	preference_id = "!AllergyAdmin_location_domain"
	location_domain = datalist.get_preference("PREFERENCES", preference_id)

	if isnull(location_domain) then location_domain = '!AllergyAdmi'
end if

uo_picture.initialize()

change_title(vial_desc)

Return
end subroutine

public function integer show_vials ();long 			ll_rowcount
long			ll_tab

dw_vials.setredraw(false)
dw_vials.reset()
dw_vials.retrieve(allergy_root_treatment_id,vial_ins_treatment_type)
ll_rowcount = dw_vials.rowcount()

st_vials.text = string(dw_vials.rowcount())
dw_vials.set_page(1,pb_up,pb_down,st_page)
dw_vials.setredraw(true)

Return 1
end function

public subroutine refresh ();show_vials()
show_history()
display_portrait()
change_title(vial_desc)
end subroutine

on u_tabpage_vial_injection.create
int iCurrent
call super::create
this.st_unit=create st_unit
this.st_6=create st_6
this.cb_new=create cb_new
this.cb_close=create cb_close
this.uo_picture=create uo_picture
this.st_3=create st_3
this.st_vials=create st_vials
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.st_5=create st_5
this.dw_vials=create dw_vials
this.st_title=create st_title
this.rte_history=create rte_history
this.cb_shot=create cb_shot
this.st_1=create st_1
this.st_4=create st_4
this.st_amount_text=create st_amount_text
this.st_amount=create st_amount
this.mle_comments=create mle_comments
this.st_2=create st_2
this.cb_location=create cb_location
this.st_comment=create st_comment
this.st_location_domain_edit=create st_location_domain_edit
this.gb_1=create gb_1
this.st_portrait=create st_portrait
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_unit
this.Control[iCurrent+2]=this.st_6
this.Control[iCurrent+3]=this.cb_new
this.Control[iCurrent+4]=this.cb_close
this.Control[iCurrent+5]=this.uo_picture
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_vials
this.Control[iCurrent+8]=this.pb_down
this.Control[iCurrent+9]=this.pb_up
this.Control[iCurrent+10]=this.st_page
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.dw_vials
this.Control[iCurrent+13]=this.st_title
this.Control[iCurrent+14]=this.rte_history
this.Control[iCurrent+15]=this.cb_shot
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.st_4
this.Control[iCurrent+18]=this.st_amount_text
this.Control[iCurrent+19]=this.st_amount
this.Control[iCurrent+20]=this.mle_comments
this.Control[iCurrent+21]=this.st_2
this.Control[iCurrent+22]=this.cb_location
this.Control[iCurrent+23]=this.st_comment
this.Control[iCurrent+24]=this.st_location_domain_edit
this.Control[iCurrent+25]=this.gb_1
this.Control[iCurrent+26]=this.st_portrait
end on

on u_tabpage_vial_injection.destroy
call super::destroy
destroy(this.st_unit)
destroy(this.st_6)
destroy(this.cb_new)
destroy(this.cb_close)
destroy(this.uo_picture)
destroy(this.st_3)
destroy(this.st_vials)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.st_5)
destroy(this.dw_vials)
destroy(this.st_title)
destroy(this.rte_history)
destroy(this.cb_shot)
destroy(this.st_1)
destroy(this.st_4)
destroy(this.st_amount_text)
destroy(this.st_amount)
destroy(this.mle_comments)
destroy(this.st_2)
destroy(this.cb_location)
destroy(this.st_comment)
destroy(this.st_location_domain_edit)
destroy(this.gb_1)
destroy(this.st_portrait)
end on

type st_unit from statictext within u_tabpage_vial_injection
integer x = 1554
integer y = 244
integer width = 128
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_6 from statictext within u_tabpage_vial_injection
integer x = 1413
integer y = 260
integer width = 142
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Unit:"
boolean focusrectangle = false
end type

type cb_new from commandbutton within u_tabpage_vial_injection
integer x = 1275
integer y = 644
integer width = 416
integer height = 120
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Vial"
end type

event clicked;string		ls_cpr_id
string		ls_service
long			ll_encounter_id

u_component_treatment		luo_treatment


ls_cpr_id = current_patient.cpr_id
ll_encounter_id = current_patient.open_encounter_id

luo_treatment = create u_component_treatment
luo_treatment.treatment_id = allergy_root_treatment_id
luo_treatment.treatment_description = allergy_treatment_desc


// call vial creation service
ls_service = service.get_attribute("new_vial_service")
if isnull(ls_service) then ls_service = "NEWVIAL"

service_list.do_service(ls_cpr_id,ll_encounter_id,ls_service,luo_treatment)

refresh()

Destroy luo_treatment

end event

type cb_close from commandbutton within u_tabpage_vial_injection
integer x = 1760
integer y = 644
integer width = 389
integer height = 120
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close Vial"
end type

event clicked;integer					li_sts
string					ls_progress,ls_null
long						ll_null
datetime 				ldt_progress_date_time

str_popup				popup
str_popup_return 		popup_return


setnull(ls_null)
setnull(ll_null)
setnull(ldt_progress_date_time)

if isnull(vial_treatment_id) then
	OpenwithParm(w_pop_message,"Select a vial to administer")
	cb_shot.enabled = false
	cb_close.enabled = false
	Return
end if

// enter the reason for closing
popup.argument_count = 1
popup.argument[1] = "CLOSE_VIAL"
popup.title = "Enter the reason:"
Openwithparm(w_pop_prompt_string, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count = 1 then
	ls_progress = popup_return.items[1]
else
	return
End if

// set the reason for closing a vial
li_sts = f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								vial_treatment_id, &
								'PROPERTY', &
								'Closed', &
								ls_progress, &
								ldt_progress_date_time, &
								ll_null, &
								ll_null, &
								ll_null)
// close the vial								
li_sts = f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								vial_treatment_id, &
								'CLOSED', &
								ls_null, &
								ls_progress, &
								ldt_progress_date_time, &
								ll_null, &
								ll_null, &
								ll_null)

if show_vials() <= 0 then
	return
end if
change_title(ls_null)

setnull(vial_treatment_id)
setnull(vial_desc)

enabled = false
cb_shot.enabled = false
end event

type uo_picture from u_picture_display within u_tabpage_vial_injection
event destroy ( )
integer x = 123
integer y = 192
integer width = 581
integer height = 456
integer taborder = 90
end type

on uo_picture.destroy
call u_picture_display::destroy
end on

type st_3 from statictext within u_tabpage_vial_injection
integer x = 32
integer y = 720
integer width = 178
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Vials:"
boolean focusrectangle = false
end type

type st_vials from statictext within u_tabpage_vial_injection
integer x = 247
integer y = 720
integer width = 146
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within u_tabpage_vial_injection
integer x = 448
integer y = 700
integer width = 137
integer height = 100
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

type pb_up from u_picture_button within u_tabpage_vial_injection
integer x = 631
integer y = 704
integer width = 137
integer height = 96
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

type st_page from statictext within u_tabpage_vial_injection
boolean visible = false
integer x = 535
integer y = 636
integer width = 87
integer height = 36
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within u_tabpage_vial_injection
integer x = 855
integer y = 672
integer width = 251
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "History"
boolean focusrectangle = false
end type

type dw_vials from u_dw_pick_list within u_tabpage_vial_injection
integer x = 9
integer y = 812
integer width = 777
integer height = 544
integer taborder = 20
string dataobject = "dw_allergy_open_vial_list"
end type

event selected;call super::selected;string ls_desc


cb_shot.enabled = true
cb_close.enabled = true
vial_treatment_id = object.treatment_id[selected_row]
vial_desc = object.treatment_description[selected_row]
ls_desc = object.treatment_description[selected_row]

change_title(ls_desc)
setnull(dose_amount)
st_amount_text.text = ""
cb_location.text = ""
mle_comments.text = ""
end event

event unselected;call super::unselected;cb_shot.enabled = false
cb_close.enabled = false
setnull(vial_treatment_id)
setnull(vial_desc)
st_title.text = "Admin ???"
end event

event constructor;call super::constructor;dw_vials.settransobject(sqlca)
end event

type st_title from statictext within u_tabpage_vial_injection
integer x = 32
integer y = 12
integer width = 2683
integer height = 148
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type rte_history from u_rich_text_edit within u_tabpage_vial_injection
integer x = 800
integer y = 780
integer width = 1902
integer height = 572
integer taborder = 30
boolean bringtotop = true
end type

type cb_shot from commandbutton within u_tabpage_vial_injection
integer x = 2208
integer y = 644
integer width = 389
integer height = 120
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Shot Given"
end type

event clicked;// Create Allergy injection Record
string ls_comment
string ls_location
string ls_description
long	ll_treatment_id,ll_null
datetime ldt_null

DECLARE lsp_create_allergy_injection PROCEDURE FOR dbo.sp_create_allergy_injection
			@ps_cpr_id = :current_patient.cpr_id,
			@pl_encounter_id = :current_patient.open_encounter.encounter_id,
			@pl_parent_treatment_id = :vial_treatment_id,
			@ps_ordered_by = :current_user.user_id,
			@ps_created_by = :current_scribe.user_id,
			@ps_description = :ls_description,
			@pl_treatment_id = :ll_treatment_id OUT;


setnull(ldt_null)
setnull(ll_null)

if isnull(vial_treatment_id) then
	OpenwithParm(w_pop_message,"Select a vial to administer")
	cb_shot.enabled = false
	cb_close.enabled = false
	Return
end if

// Check the amount
IF isnull(dose_amount) or dose_amount = 0 then
	OpenwithParm(w_pop_message,"Enter a valid amount")
	Return
END IF

// set the allergy treatment desc with vial desc
ls_description = allergy_treatment_desc + ' Vial: '+vial_desc

// create a new injection
EXECUTE lsp_create_allergy_injection;
if not tf_check() then return -1
	
// injection treatment id
FETCH lsp_create_allergy_injection INTO :ll_treatment_id;
if not tf_check() then return -1
	
CLOSE lsp_create_allergy_injection;

// set the comments
ls_comment = mle_comments.text

// if an allergy injection treatment is created then
if not isnull(ll_treatment_id) and ll_treatment_id > 0 Then
	
	// update the dose amount
	if not isnull(location) Then
		f_set_progress(current_patient.cpr_id, &
              "Treatment", &
               ll_treatment_id, &
               'Modify', &
               'dose_amount', &
               string(dose_amount), &
               ldt_null, &
               ll_null, &
               ll_null, &
               ll_null)
	end if

	// update the dose unit
	if not isnull(location) Then
		f_set_progress(current_patient.cpr_id, &
              "Treatment", &
               ll_treatment_id, &
               'Modify', &
               'dose_unit', &
               dose_unit, &
               ldt_null, &
               ll_null, &
               ll_null, &
               ll_null)
	end if

	// update the location
	if not isnull(location) Then
		f_set_progress(current_patient.cpr_id, &
              "Treatment", &
               ll_treatment_id, &
               'Modify', &
               'location', &
               location, &
               ldt_null, &
               ll_null, &
               ll_null, &
               ll_null)
	end if

	// update the comments
	if not isnull(ls_comment) Then
		f_set_progress(current_patient.cpr_id, &
              "Treatment", &
               ll_treatment_id, &
               'Comment', &
               'Comment', &
               ls_comment, &
               ldt_null, &
               ll_null, &
               ll_null, &
               ll_null)
	end if
	
	// assume the user completing the vial is the owner for the vial
	f_set_progress(current_patient.cpr_id, &
					"Treatment", &
					ll_treatment_id, &
					'PROPERTY', &
					'Injected By', &
					current_user.user_full_name, &
					ldt_null, &
					ll_null, &
					ll_null, &
					ll_null)
end if
enabled = false
f_set_global_preference("ALLERGY_ADMIN", "LAST_DOSE_" + string(allergy_root_treatment_id),st_amount_text.text)
// re-load patient treatments
current_patient.load_treatments()
show_history()
end event

type st_1 from statictext within u_tabpage_vial_injection
integer x = 768
integer y = 256
integer width = 274
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Amount:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within u_tabpage_vial_injection
integer x = 823
integer y = 416
integer width = 329
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Comments:"
boolean focusrectangle = false
end type

type st_amount_text from statictext within u_tabpage_vial_injection
integer x = 1061
integer y = 240
integer width = 219
integer height = 104
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_amount from statictext within u_tabpage_vial_injection
integer x = 1294
integer y = 248
integer width = 101
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "..."
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string 	ls_dose
real 		lr_dose
decimal {3} ld_dose
str_popup popup
str_popup_return popup_return

lr_dose = dose_amount
if isnull(lr_dose) then lr_dose = 0.00

popup.realitem = lr_dose
Openwithparm(w_number, popup)
popup_return = message.powerobjectparm

if popup_return.item <> "OK" then 
	return
end if

dose_amount = popup_return.realitem
ld_dose = dec(dose_amount)
st_amount_text.text = string(ld_dose)
end event

type mle_comments from multilineedit within u_tabpage_vial_injection
integer x = 1166
integer y = 368
integer width = 1371
integer height = 224
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autovscroll = true
end type

type st_2 from statictext within u_tabpage_vial_injection
integer x = 1705
integer y = 260
integer width = 270
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Location:"
boolean focusrectangle = false
end type

type cb_location from commandbutton within u_tabpage_vial_injection
integer x = 1993
integer y = 240
integer width = 544
integer height = 104
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;str_popup popup
str_popup_return popup_return


popup.dataobject = "dw_location_pick"
popup.argument_count = 1
popup.argument[1] = '!AllergyAdmi'
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "N/A"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

if popup_return.items[1] = "" then
	setnull(location)
else
	location = popup_return.items[1]
end if

text = popup_return.descriptions[1]

end event

type st_comment from statictext within u_tabpage_vial_injection
integer x = 2560
integer y = 472
integer width = 110
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "..."
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string 			ls_comment
long   			ll_null
datetime 		ldt_null

str_popup			popup
str_popup_return  popup_return

setnull(ldt_null)
setnull(ll_null)


// Call progress note edit to get the comments
popup.data_row_count = 3
popup.items[1] = "ADMIN_VIAL_"+string(vial_treatment_id)
popup.items[2] = "ADMIN_VIAL"
popup.items[3] = ls_comment

Openwithparm(w_progress_note_edit,popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

ls_comment = popup_return.items[1]
mle_comments.text = ls_comment
end event

type st_location_domain_edit from statictext within u_tabpage_vial_injection
integer x = 2560
integer y = 240
integer width = 105
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "..."
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
string ls_assessment_id
integer li_update_flag

if not isnull(location_domain) and location_domain <> "NA" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Locations in this Domain"
	popup.button_titles[popup.button_count] = "Edit Domain"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Change Location Domain"
	popup.button_titles[popup.button_count] = "Change Domain"
	buttons[popup.button_count] = "CHANGE"
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
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDIT"
		popup.data_row_count = 1
		popup.items[1] = location_domain
		openwithparm(w_location_domain_edit, popup)
		cb_location.postevent("clicked")
	CASE "CHANGE"
		open(w_pick_location_domain)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		if popup_return.items[1] <> location_domain then
			if not isnull(preference_id) then
				li_sts = datalist.update_preference("PREFERENCES", "Global", "Global", preference_id, location_domain)
				if li_sts <= 0 then log.log(this, "u_tabpage_vial_injection.st_location_domain_edit.clicked:0060", "Error updating location domain preference", 3)
			end if
			location_domain = popup_return.items[1]
			cb_location.postevent("clicked")
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type gb_1 from groupbox within u_tabpage_vial_injection
integer x = 741
integer y = 168
integer width = 1952
integer height = 452
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16776960
long backcolor = 33538240
string text = "[ Injection ]"
borderstyle borderstyle = stylebox!
end type

type st_portrait from statictext within u_tabpage_vial_injection
integer x = 123
integer y = 196
integer width = 581
integer height = 444
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Portrait"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;string ls_service

ls_service = datalist.get_preference("PREFERENCES", "portrait_service")
if isnull(ls_service) then ls_service = "PORTRAIT"

service_list.do_service(current_patient.cpr_id,current_patient.open_encounter_id,ls_service)

display_portrait()
end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Cu_tabpage_vial_injection.bin 
2E00001600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000008fffffffe0000000400000005000000060000000700000009fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000753ca2a001ca361d0000000300000bc00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000001000007d900000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004ab949ac111d9ec9740002b9ed2aba90500000000753ca2a001ca361d753ca2a001ca361d000000000000000000000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f00000020fffffffe00000022000000230000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002efffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
20ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff005000540039002d00340034003200370038003400390035000000340000000000000000000000000000000000000000000000000000000000000000000000000000fffe00020205ab949ac111d9ec9740002b9ed2aba90500000001fb8f0821101b01640008ed8413c72e2b00000030000007a90000003600000100000001b800000101000001c000000102000001c800000103000001d000000104000001d800000105000001e000000106000001e800000107000001f000000108000001f800000109000002000000010a000002080000010b000002100000010c000002180000010d000002200000010e000002280000010f000002300000011000000238000001110000024000000112000002480000011300000250000001140000028c0000011500000294000001160000029c00000117000002a400000118000002ac00000119000002b40000011a000002bc0000011b000002c40000011c000002cc0000011d000002d40000011e000002dc0000011f000002ec00000120000002f400000121000002fc0000012200000304000001230000030c0000012400000314000001250000031c0000012600000324000001270000032c0000012800000334000001290000033c0000012a000003440000012b0000034c0000012c000003540000012d0000035c0000012e000003640000012f0000036c0000013000000374000001310000037c00000132000003880000013300000390000001340000039800000000000003a000000003000100070000000300002aff0000000300000ec800000003000000490000000200000001000000020000000100000002000000010000000b0000000000000002000000000000000b0000ffff0000000b0000ffff0000000200000000000000020000006400000002000000030000000b000000000000000b0000ffff00000002000000000000000b0000ffff0000000b000000000000000800000031505c3a4352474f525c317e4149454854317e414d5458545c7e5458455c302e335c6e694252454d414e4143494454562e0000000000000002000000030000000300002fd00000000300003de000000003000005a000000003000005a000000003000005a000000003000005a000000002000000640000000b000000000000000b0000ffff0000000800000006616972410000006c000000020000000c0000000b000000000000000b000000000000000b000000000000000b0000000000000002000000000000000300ffffff0000000200000000000000020000006400000002000000000000000200000020000000020000000000000002000000140000000200000000000000020000000000000002000000000000000200000000000000020000000000000008000000010000000000000002000000010000000b0000ffff0000000b0000ffff0000003600000000000000010001330000000a006c6c61006e75776f32006f640d000001770000007764726f6d7061720065646f00000112000000106d726f66657374617463656c006e6f69000001090000000e65646968656c65736f6974630108006e00090000646500006f6d7469280065640d0000016c00000073656e69696361700074676e000001190000000c656761706772616d00726e69000001070000000d746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009006e6f66006d616e74011a0065000c000061700000616d65676e696772010e0062000d00006c6300006863706972646c6930006e6508000001690000006e65646e180062740c000001700000006d656761696772611500746e0a00000170000000776567616874646900010b0000000d00756f6d006f70657365746e6901060072000a00006162000074736b6300656c790000013400000015747865746d61726672616d656c72656b73656e6900012f0000000800646e690074746e650001270000000c006e696c0061707365676e696300010c0000000b006f6f7a006361666d00726f740000010a0000000e65736e696f697472646f6d6e012a0065000e00007266000064656d61617473690065636e000001130000001270737476646c6c656974636972616e6f01030079000c0000735f00006b636f74706f727001210073000b00006f6600007469746e63696c6100011000000009007a697300646f6d6501050065000c00006f620000726564726c79747301260065000a00006c6100006d6e676900746e65000001240000000965736162656e696c0001160000000b00676170006965686500746867000001250000000c747865746f636b6200726f6c000001230000000e746e6f6665646e756e696c7201220065000f00006f6600007473746e656b69727572687400011f00000009006e6f66007a69737401110065000700006174000079656b6200012b0000000f0061726600696c656d6977656e00687464000001290000000b6d617266797473650100656c090000015f000000657478650078746e0000012000000009746e6f66646c6f62000102000000090078655f00746e6574011d0079000c00007270000063746e69726f6c6f01170073000c000061700000616d65676e696772010d006c00090000697600006f6d77652c00656408000001690000006e65646e2e006c740900000169000000
2C6e65646e006c667400000131000000057478657400011c0000000c0069727000666f746e7465736600011b0000000a00697270006f7a746e14006d6f0b000001730000006c6f72637261626c0104007300090000616c00006175676e00006567090000015f00000073726576006e6f690000010f0000000d70696c636c62697373676e69000000000000000000000000000000000000000000000000000000000000000000000000000000000001000700002aff00000ec8000000490000000000ffffff0100010100000100010100000064000001000003000100005c3a4330474f5250317e41524548545c7e414d4958545c3154584554302e337e6e69425c454d415c4143495254562e4e03000044002fd000003de0000005a0000005a0000005a0000005a00000006400724105010c6c616900000000ff0000000000ffff00006400000020000000140000000000000000000100000001010001000002ba000104b10000000e00000000000000000000000200000144000100010001000100000000000000000001001f00000001000000000000000000000000ff10500000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000001000100000001000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e0401390000000000000000000000000000000000720041006100690000006c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000210000036e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004e400010001010002092e000000ffffb70000000000000000000000000000000000000000010000000000000000000000000001000000000000000000000000000000000000000000000000015400000030000000000000000005a0000005a0000000ffffff0000000000000000000000010000000000000000000000000000012400000001ff10000000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000000000000000000000000000000000000720041006100690000006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000005000000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e04013900010001010002092e000000ffffb7000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000005b0000006f004e006d0072006c00610000005d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Cu_tabpage_vial_injection.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
