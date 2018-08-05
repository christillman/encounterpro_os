$PBExportHeader$w_vial_instance_details.srw
forward
global type w_vial_instance_details from w_window_base
end type
type st_exp_t from statictext within w_vial_instance_details
end type
type st_comments from statictext within w_vial_instance_details
end type
type st_maker from statictext within w_vial_instance_details
end type
type st_title from statictext within w_vial_instance_details
end type
type st_3 from statictext within w_vial_instance_details
end type
type sle_lot_number from singlelineedit within w_vial_instance_details
end type
type st_2 from statictext within w_vial_instance_details
end type
type st_expiration_date from statictext within w_vial_instance_details
end type
type mle_edit from multilineedit within w_vial_instance_details
end type
type cb_comments from commandbutton within w_vial_instance_details
end type
type cb_not_in_vial from commandbutton within w_vial_instance_details
end type
type cb_in_vial from commandbutton within w_vial_instance_details
end type
end forward

global type w_vial_instance_details from w_window_base
windowtype windowtype = response!
event post_open pbm_custom01
st_exp_t st_exp_t
st_comments st_comments
st_maker st_maker
st_title st_title
st_3 st_3
sle_lot_number sle_lot_number
st_2 st_2
st_expiration_date st_expiration_date
mle_edit mle_edit
cb_comments cb_comments
cb_not_in_vial cb_not_in_vial
cb_in_vial cb_in_vial
end type
global w_vial_instance_details w_vial_instance_details

type variables
String	drug_id
String 	maker_id
String 	lot_number
String	prev_maker_id,prev_lot_number,prev_treatment_status
date 		expiration_date
date		prev_exp_date
long 		treatment_id
end variables

forward prototypes
public function integer save_changes ()
public function string get_comments ()
public subroutine update ()
end prototypes

event post_open;call super::post_open;string		ls_temp


mle_edit.text = get_comments()

// set the default maker,lot,exp date
if isnull(maker_id) then
	maker_id = f_get_global_preference("ALLERGEN", "MAKER_"+drug_id)
end if

If isnull(maker_id) Then
	st_maker.text = "N/A"
Else
	SELECT maker_name
	INTO :st_maker.text
	FROM c_Drug_Maker
	WHERE maker_id = :maker_id;
	If Not tf_check() Then
		log.log(This, "w_vial_instance_details:post", "Error getting maker information", 4)
		close(This)
		return
	End If
	If sqlca.sqlcode = 100 Then
		st_maker.text = "N/A"
		setnull(maker_id)
	End if
End if

if isnull(lot_number) then
	lot_number = f_get_global_preference("ALLERGEN", "LOT_" + maker_id + "_" + drug_id)
end if
sle_lot_number.text = lot_number

If isnull(expiration_date) Then
	ls_temp = f_get_global_preference("ALLERGEN", "EXP_" + maker_id + "_" + drug_id)
Else
	ls_temp = string(date(expiration_date))
end if

if isnull(ls_temp) then
	st_expiration_date.text = "N/A"
elseif isdate(ls_temp) then
	st_expiration_date.text = ls_temp
	expiration_date = date(ls_temp)
else
	st_expiration_date.text = "N/A"
end if
end event

public function integer save_changes ();long			ll_null
datetime		ldt_progress_date_time


setnull(ll_null)
setnull(ldt_progress_date_time)

if prev_maker_id <> maker_id then
	// update maker
	f_set_progress(current_patient.cpr_id, &
					"Treatment", &
					treatment_id, &
					'Modify', &
					'maker_id', &
					maker_id, &
					ldt_progress_date_time, &
					ll_null, &
					ll_null, &
					ll_null)	

	f_set_global_preference("ALLERGEN", "MAKER_" + drug_id, maker_id)
end if

// lot number
if prev_lot_number <> sle_lot_number.text then

	lot_number = sle_lot_number.text
	f_set_progress(current_patient.cpr_id, &
					"Treatment", &
					treatment_id, &
					'Modify', &
					'lot_number', &
					sle_lot_number.text, &
					ldt_progress_date_time, &
					ll_null, &
					ll_null, &
					ll_null)	
	
	f_set_global_preference("ALLERGEN", "LOT_" + maker_id + "_" + drug_id, sle_lot_number.text)
end if

// expiration_date
if isnull(prev_exp_date) or prev_exp_date <> expiration_date then

	f_set_progress(current_patient.cpr_id, &
					"Treatment", &
					treatment_id, &
					'Modify', &
					'expiration_date', &
					string(expiration_date), &
					ldt_progress_date_time, &
					ll_null, &
					ll_null, &
					ll_null)	
end if
if not isnull(expiration_date) then
	f_set_global_preference("ALLERGEN", "EXP_" + maker_id + "_" + drug_id, string(expiration_date, date_format_string))
end if


return 1
end function

public function string get_comments ();string ls_comment
integer i

str_progress_list lstr_progress

lstr_progress = f_get_progress(current_patient.cpr_id, &
                 			     "Treatment", &
		                        treatment_id, &
        			               'Comment', &
                 			      'Comment')
// get the comments
For i = 1 to lstr_progress.progress_count
	if lstr_progress.progress[i].progress_type = 'Comment' then
		if not isnull(lstr_progress.progress[i].progress) then
			ls_comment += lstr_progress.progress[i].progress + "~r~n"
		end if
	end if
next

return ls_comment
end function

public subroutine update ();
end subroutine

event open;call super::open;string ls_description,ls_maker
string ls_treatment_status

treatment_id = message.doubleparm

// Set the title and sizes
title = current_patient.id_line()

SELECT treatment_description,
		maker_id,
		lot_number,
		expiration_date,
		treatment_status,
		drug_id
INTO :ls_description,
		:maker_id,
		:lot_number,
		:expiration_date,
		:prev_treatment_status,
		:drug_id
FROM p_Treatment_Item
WHERE treatment_id = :treatment_id
using sqlca;

st_title.text = "Allergen details for ~"" + ls_description + "~""

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -10
		else
			st_title.textsize = -12
		end if
	else
		st_title.textsize = -14
	end if
else
	st_title.textsize = -18
end if

SELECT maker_name
INTO :ls_maker
FROM c_drug_maker
WHERE maker_id = :maker_id;

st_maker.text = ls_maker
sle_lot_number.text = lot_number
st_expiration_date.text = string(expiration_date)

prev_maker_id = maker_id
prev_lot_number = lot_number
prev_exp_date = expiration_date

if isnull(prev_maker_id) then prev_maker_id = ""
if isnull(prev_lot_number) then prev_lot_number = ""
	
postevent("post_open")
end event

on w_vial_instance_details.create
int iCurrent
call super::create
this.st_exp_t=create st_exp_t
this.st_comments=create st_comments
this.st_maker=create st_maker
this.st_title=create st_title
this.st_3=create st_3
this.sle_lot_number=create sle_lot_number
this.st_2=create st_2
this.st_expiration_date=create st_expiration_date
this.mle_edit=create mle_edit
this.cb_comments=create cb_comments
this.cb_not_in_vial=create cb_not_in_vial
this.cb_in_vial=create cb_in_vial
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_exp_t
this.Control[iCurrent+2]=this.st_comments
this.Control[iCurrent+3]=this.st_maker
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_lot_number
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_expiration_date
this.Control[iCurrent+9]=this.mle_edit
this.Control[iCurrent+10]=this.cb_comments
this.Control[iCurrent+11]=this.cb_not_in_vial
this.Control[iCurrent+12]=this.cb_in_vial
end on

on w_vial_instance_details.destroy
call super::destroy
destroy(this.st_exp_t)
destroy(this.st_comments)
destroy(this.st_maker)
destroy(this.st_title)
destroy(this.st_3)
destroy(this.sle_lot_number)
destroy(this.st_2)
destroy(this.st_expiration_date)
destroy(this.mle_edit)
destroy(this.cb_comments)
destroy(this.cb_not_in_vial)
destroy(this.cb_in_vial)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_vial_instance_details
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_vial_instance_details
end type

type st_exp_t from statictext within w_vial_instance_details
integer x = 183
integer y = 612
integer width = 581
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Expiration Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_comments from statictext within w_vial_instance_details
integer x = 201
integer y = 896
integer width = 558
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Comments:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_maker from statictext within w_vial_instance_details
integer x = 805
integer y = 276
integer width = 1193
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "N/A"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_maker_id

str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_maker_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "N/A"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

if popup_return.items[1] = "" then
	setnull(maker_id)
else
	maker_id = popup_return.items[1]
end if

text = popup_return.descriptions[1]
sle_lot_number.setfocus()

end event

type st_title from statictext within w_vial_instance_details
integer width = 2926
integer height = 144
integer textsize = -22
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_vial_instance_details
integer x = 210
integer y = 444
integer width = 553
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Lot Number:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_lot_number from singlelineedit within w_vial_instance_details
integer x = 805
integer y = 424
integer width = 1193
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_vial_instance_details
integer x = 210
integer y = 296
integer width = 553
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Allergen Maker:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_expiration_date from statictext within w_vial_instance_details
integer x = 805
integer y = 592
integer width = 1193
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
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

event clicked;date ld_expiration_date
string ls_text

ld_expiration_date = expiration_date
if isnull(ld_expiration_date) then ld_expiration_date = today()

ls_text = f_select_date(ld_expiration_date, "Expiration Date")
if isnull(ls_text) then return

if ld_expiration_date < today() then
	openwithparm(w_pop_message,"Enter a valid expiration date")
	setfocus()
	return
end if
expiration_date = ld_expiration_date
text = ls_text
end event

type mle_edit from multilineedit within w_vial_instance_details
integer x = 800
integer y = 736
integer width = 1710
integer height = 468
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type cb_comments from commandbutton within w_vial_instance_details
integer x = 2546
integer y = 1100
integer width = 169
integer height = 104
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
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
popup.items[1] = "VIAL_ALLERGEN_"+string(treatment_id)
popup.items[2] = "VIAL_ALLERGEN"
popup.items[3] = ls_comment

Openwithparm(w_progress_note_edit,popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

ls_comment = popup_return.items[1]
If not isnull(ls_comment) and len(ls_comment) > 0 Then

	f_set_progress(current_patient.cpr_id, &
                        "Treatment", &
                        treatment_id, &
                        'Comment', &
                        'Comment', &
                        ls_comment, &
                        ldt_null, &
                        ll_null, &
                        ll_null, &
                        ll_null)

	mle_edit.text = get_comments()
End If
end event

type cb_not_in_vial from commandbutton within w_vial_instance_details
integer x = 1312
integer y = 1444
integer width = 654
integer height = 140
integer taborder = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Not In Vial"
end type

event clicked;long ll_null
string ls_null
datetime ldt_progress_date_time

// save the changes
save_changes()

setnull(ll_null)
setnull(ls_null)
setnull(ldt_progress_date_time)

if prev_treatment_status <> 'OPEN' THEN
	// set the treatment status 
	f_set_progress(current_patient.cpr_id, &
					"Treatment", &
					treatment_id, &
					'Modify', &
					'treatment_status', &
					'OPEN', &
					ldt_progress_date_time, &
					ll_null, &
					ll_null, &
					ll_null)	
end if
Close(Parent)
end event

type cb_in_vial from commandbutton within w_vial_instance_details
integer x = 2053
integer y = 1444
integer width = 654
integer height = 140
integer taborder = 90
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "In Vial"
end type

event clicked;long ll_null
string ls_null
datetime ldt_progress_date_time

setnull(ll_null)
setnull(ls_null)
setnull(ldt_progress_date_time)

// save the changes
save_changes()

if prev_treatment_status = 'OPEN' Then
	f_set_progress(current_patient.cpr_id, &
					"Treatment", &
					treatment_id, &
					'CLOSED', &
					ls_null, &
					'added in vial', &
					ldt_progress_date_time, &
					ll_null, &
					ll_null, &
					ll_null)
end if
Close(Parent)
end event

