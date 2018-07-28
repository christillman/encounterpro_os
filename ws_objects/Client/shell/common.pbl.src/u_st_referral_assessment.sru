$PBExportHeader$u_st_referral_assessment.sru
forward
global type u_st_referral_assessment from statictext
end type
end forward

global type u_st_referral_assessment from statictext
integer width = 1056
integer height = 88
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type
global u_st_referral_assessment u_st_referral_assessment

type variables
string assessment_id
string description
end variables

forward prototypes
public subroutine set_assessment (string ps_assessment_id, string ps_description)
public subroutine pretty_text ()
end prototypes

public subroutine set_assessment (string ps_assessment_id, string ps_description);if not isnull(ps_assessment_id) then
	assessment_id = ps_assessment_id
	description = ps_description
	pretty_text()
end if
end subroutine

public subroutine pretty_text ();integer li_sts
string ls_description, ls_auto_close, ls_icd_9_code
decimal lcd_charge

if not isnull(assessment_id) then
	if isnull(description) Or Len(description) = 0 then
		li_sts = tf_get_assessment(assessment_id, ls_description, ls_icd_9_code, ls_auto_close)
		if li_sts > 0 then
			text = ls_description
		else
			text = ""
		end if
	else
		text = description
	end if
else
	text = ""
end if
		

end subroutine

on constructor;setnull(assessment_id)
end on

on u_st_referral_assessment.create
end on

on u_st_referral_assessment.destroy
end on

