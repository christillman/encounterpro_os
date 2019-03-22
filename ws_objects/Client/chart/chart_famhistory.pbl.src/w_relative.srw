$PBExportHeader$w_relative.srw
forward
global type w_relative from w_window_base
end type
type sle_name from singlelineedit within w_relative
end type
type st_relation from statictext within w_relative
end type
type st_2 from statictext within w_relative
end type
type st_3 from statictext within w_relative
end type
type st_4 from statictext within w_relative
end type
type st_5 from statictext within w_relative
end type
type st_6 from statictext within w_relative
end type
type st_1 from statictext within w_relative
end type
type em_birth_year from editmask within w_relative
end type
type em_age_at_death from editmask within w_relative
end type
type sle_cause_of_death from singlelineedit within w_relative
end type
type pb_done from u_picture_button within w_relative
end type
type pb_cancel from u_picture_button within w_relative
end type
end forward

global type w_relative from w_window_base
int X=380
int Y=237
int Width=2113
int Height=1305
WindowType WindowType=response!
boolean TitleBar=false
long BackColor=33538240
boolean ControlMenu=false
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
sle_name sle_name
st_relation st_relation
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_1 st_1
em_birth_year em_birth_year
em_age_at_death em_age_at_death
sle_cause_of_death sle_cause_of_death
pb_done pb_done
pb_cancel pb_cancel
end type
global w_relative w_relative

type variables
long family_history_sequence

end variables

forward prototypes
public function integer load_relative (long pl_family_history_sequence)
end prototypes

public function integer load_relative (long pl_family_history_sequence);string ls_relation
string ls_name
integer li_birth_year
integer li_age_at_death
string ls_cause_of_death

SELECT p_Family_History.relation,   
       p_Family_History.name,   
       p_Family_History.birth_year,   
       p_Family_History.age_at_death,   
       p_Family_History.cause_of_death  
INTO :ls_relation,
     :ls_name,   
     :li_birth_year,   
     :li_age_at_death,   
     :ls_cause_of_death  
FROM p_Family_History  
WHERE p_Family_History.cpr_id = :current_patient.cpr_id
AND p_Family_History.family_history_sequence = :pl_family_history_sequence;
if not tf_check() then close(this)

if sqlca.sqlcode = 100 then
	log.log(this, "w_relative.load_relative:0023", "Invalid family_history_sequence (" &
		+ current_patient.cpr_id + ", "  &
		+ string(pl_family_history_sequence) + ")", 4)
	return 0
end if

st_relation.text = ls_relation
sle_name.text = ls_name
em_birth_year.text = string(li_birth_year)
em_age_at_death.text = string(li_age_at_death)
sle_cause_of_death.text = ls_cause_of_death

return 1

end function

on w_relative.create
int iCurrent
call w_window_base::create
this.sle_name=create sle_name
this.st_relation=create st_relation
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_1=create st_1
this.em_birth_year=create em_birth_year
this.em_age_at_death=create em_age_at_death
this.sle_cause_of_death=create sle_cause_of_death
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=sle_name
this.Control[iCurrent+2]=st_relation
this.Control[iCurrent+3]=st_2
this.Control[iCurrent+4]=st_3
this.Control[iCurrent+5]=st_4
this.Control[iCurrent+6]=st_5
this.Control[iCurrent+7]=st_6
this.Control[iCurrent+8]=st_1
this.Control[iCurrent+9]=em_birth_year
this.Control[iCurrent+10]=em_age_at_death
this.Control[iCurrent+11]=sle_cause_of_death
this.Control[iCurrent+12]=pb_done
this.Control[iCurrent+13]=pb_cancel
end on

on w_relative.destroy
call w_window_base::destroy
destroy(this.sle_name)
destroy(this.st_relation)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_1)
destroy(this.em_birth_year)
destroy(this.em_age_at_death)
destroy(this.sle_cause_of_death)
destroy(this.pb_done)
destroy(this.pb_cancel)
end on

event open;call super::open;str_popup popup
long ll_family_history_sequence
integer li_sts

popup = message.powerobjectparm

if isnull(popup.item) then
	setnull(family_history_sequence)
	st_relation.text = ""
	sle_name.text = ""
	em_birth_year.text = ""
	em_age_at_death.text = ""
	sle_cause_of_death.text = ""
else
	ll_family_history_sequence = long(popup.item)
	if ll_family_history_sequence <= 0 then
		log.log(this, "w_relative:open", "Negative or Zero family_history_sequence (" &
			+ current_patient.cpr_id + ", "  &
			+ string(ll_family_history_sequence) + ")", 4)
		close(this)
	end if

	li_sts = load_relative(ll_family_history_sequence)
	if li_sts <= 0 then close(this)
end if

end event

type sle_name from singlelineedit within w_relative
int X=778
int Y=421
int Width=1153
int Height=101
int TabOrder=10
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_relation from statictext within w_relative
int X=782
int Y=281
int Width=586
int Height=101
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_domain_item_nodesc_list"
popup.datacolumn = 3
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "RELATION"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 1 then
	text = popup_return.items[1]
end if

end event

type st_2 from statictext within w_relative
int X=453
int Y=293
int Width=275
int Height=77
boolean Enabled=false
boolean BringToTop=true
string Text="Relation:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_3 from statictext within w_relative
int X=453
int Y=433
int Width=275
int Height=77
boolean Enabled=false
boolean BringToTop=true
string Text="Name:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_4 from statictext within w_relative
int X=407
int Y=573
int Width=321
int Height=77
boolean Enabled=false
boolean BringToTop=true
string Text="Birth Year:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_5 from statictext within w_relative
int X=325
int Y=713
int Width=403
int Height=77
boolean Enabled=false
boolean BringToTop=true
string Text="Age at death:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_6 from statictext within w_relative
int X=261
int Y=853
int Width=467
int Height=77
boolean Enabled=false
boolean BringToTop=true
string Text="Cause of death:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_relative
int Width=2113
int Height=161
boolean Enabled=false
boolean BringToTop=true
string Text="Blood Relation"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=33538240
int TextSize=-24
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_birth_year from editmask within w_relative
int X=782
int Y=561
int Width=247
int Height=101
int TabOrder=20
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
string Mask="####"
string DisplayData=""
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_age_at_death from editmask within w_relative
int X=782
int Y=701
int Width=247
int Height=101
int TabOrder=30
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
string Mask="###"
string DisplayData=""
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_cause_of_death from singlelineedit within w_relative
int X=778
int Y=841
int Width=1153
int Height=101
int TabOrder=40
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type pb_done from u_picture_button within w_relative
int X=1797
int Y=1041
int TabOrder=0
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
boolean Default=true
end type

event clicked;call super::clicked;str_popup_return popup_return

if st_relation.text = "" or isnull(st_relation.text) then
	openwithparm(w_pop_message, "You must specify a relation")
	return
end if

popup_return.item_count = 5
popup_return.items[1] = st_relation.text

if sle_name.text = "" then
	setnull(popup_return.items[2])
else
	popup_return.items[2] = sle_name.text
end if

if em_birth_year.text = "" then
	setnull(popup_return.items[3])
else
	popup_return.items[3] = em_birth_year.text
end if

if em_age_at_death.text = "" then
	setnull(popup_return.items[4])
else
	popup_return.items[4] = em_age_at_death.text
end if

if sle_cause_of_death.text = "" then
	setnull(popup_return.items[5])
else
	popup_return.items[5] = sle_cause_of_death.text
end if

closewithreturn(parent, popup_return)

end event

type pb_cancel from u_picture_button within w_relative
int X=74
int Y=1041
int TabOrder=0
boolean BringToTop=true
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

