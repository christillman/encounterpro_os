$PBExportHeader$w_contraindication_display.srw
forward
global type w_contraindication_display from w_window_base
end type
type cb_finished from commandbutton within w_contraindication_display
end type
type st_title from statictext within w_contraindication_display
end type
type dw_contraindications from u_dw_pick_list within w_contraindication_display
end type
type st_assessment_title from statictext within w_contraindication_display
end type
type st_treatment_title from statictext within w_contraindication_display
end type
type st_assessment from statictext within w_contraindication_display
end type
type st_treatment from statictext within w_contraindication_display
end type
type ole_long_description from u_ie_browser within w_contraindication_display
end type
type cb_do_not_prescribe from commandbutton within w_contraindication_display
end type
type cb_prescribe from commandbutton within w_contraindication_display
end type
end forward

global type w_contraindication_display from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
integer max_buttons = 5
cb_finished cb_finished
st_title st_title
dw_contraindications dw_contraindications
st_assessment_title st_assessment_title
st_treatment_title st_treatment_title
st_assessment st_assessment
st_treatment st_treatment
ole_long_description ole_long_description
cb_do_not_prescribe cb_do_not_prescribe
cb_prescribe cb_prescribe
end type
global w_contraindication_display w_contraindication_display

type variables
str_contraindications contraindications


end variables

on w_contraindication_display.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.st_title=create st_title
this.dw_contraindications=create dw_contraindications
this.st_assessment_title=create st_assessment_title
this.st_treatment_title=create st_treatment_title
this.st_assessment=create st_assessment
this.st_treatment=create st_treatment
this.ole_long_description=create ole_long_description
this.cb_do_not_prescribe=create cb_do_not_prescribe
this.cb_prescribe=create cb_prescribe
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.dw_contraindications
this.Control[iCurrent+4]=this.st_assessment_title
this.Control[iCurrent+5]=this.st_treatment_title
this.Control[iCurrent+6]=this.st_assessment
this.Control[iCurrent+7]=this.st_treatment
this.Control[iCurrent+8]=this.ole_long_description
this.Control[iCurrent+9]=this.cb_do_not_prescribe
this.Control[iCurrent+10]=this.cb_prescribe
end on

on w_contraindication_display.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.st_title)
destroy(this.dw_contraindications)
destroy(this.st_assessment_title)
destroy(this.st_treatment_title)
destroy(this.st_assessment)
destroy(this.st_treatment)
destroy(this.ole_long_description)
destroy(this.cb_do_not_prescribe)
destroy(this.cb_prescribe)
end on

event open;call super::open;integer i
long ll_definition_id
long ll_row
string ls_verb1
string ls_verb2
string ls_treatment_type_description

contraindications = message.powerobjectparm

if contraindications.contraindication_count <= 0 then
	close(this)
	return
end if

ls_treatment_type_description = datalist.treatment_type_description(contraindications.treatment_type)
if isnull(ls_treatment_type_description) then ls_treatment_type_description = "Treatment"

CHOOSE CASE upper(datalist.treatment_type_component(contraindications.treatment_type))
	CASE "TREAT_MEDICATION"
		ls_verb1 = "Prescribe"
		ls_verb2 = "Prescribing"
	CASE ELSE
		ls_verb1 = "Order"
		ls_verb2 = "Ordering"
END CHOOSE

if contraindications.show_choice then
	cb_finished.visible = false
	cb_do_not_prescribe.text = "Do NOT " + ls_verb1 + " This " + ls_treatment_type_description
	cb_prescribe.text = "Continue " + ls_verb2 + " This " + ls_treatment_type_description
else
	cb_do_not_prescribe.visible = false
	cb_prescribe.visible = false
end if

// Set the title and sizes
If isvalid(current_patient) and not isnull(current_patient) Then
	title = current_patient.id_line()
End If

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

if len(contraindications.assessment_id) > 0 then
	st_assessment.text = datalist.assessment_description(contraindications.assessment_id)
else
	st_assessment.text = "<No Assessment Context>"
end if

st_treatment.text = contraindications.treatment_description

dw_contraindications.object.short_description.width = dw_contraindications.width - 667

for i = 1 to contraindications.contraindication_count
	ll_row = dw_contraindications.insertrow(0)
	if i = 1 then dw_contraindications.object.selected_flag[ll_row] = 1
	dw_contraindications.object.icon[ll_row] = contraindications.contraindication[i].icon
	dw_contraindications.object.short_description[ll_row] = contraindications.contraindication[i].shortdescription
	dw_contraindications.object.severity[ll_row] = contraindications.contraindication[i].severity
	if len(contraindications.contraindication[ll_row].references) > 0 then
		dw_contraindications.object.references_flag[ll_row] = 1
	end if
next

dw_contraindications.event post selected(1)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_contraindication_display
integer x = 2857
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_contraindication_display
integer y = 1436
end type

type cb_finished from commandbutton within w_contraindication_display
integer x = 2432
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;closewithreturn(parent, "OK")

end event

type st_title from statictext within w_contraindication_display
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Contraindications"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_contraindications from u_dw_pick_list within w_contraindication_display
integer x = 14
integer y = 340
integer width = 2880
integer height = 376
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_contraindication_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;string ls_temp
blob lb_longdescription

ls_temp = f_temp_file("htm")

if isnull(contraindications.contraindication[selected_row].longdescription) then
	lb_longdescription = blob(contraindications.contraindication[selected_row].warning)
else
	lb_longdescription = blob(contraindications.contraindication[selected_row].longdescription)
end if

if isnull(lb_longdescription) then
	ole_long_description.visible = false
else
	ole_long_description.visible = true
	log.file_write(lb_longdescription, ls_temp)
	ole_long_description.object.navigate(ls_temp)
end if

end event

event buttonclicked;call super::buttonclicked;string ls_temp
blob lb_references

ls_temp = f_temp_file("htm")

lb_references = blob(contraindications.contraindication[row].references)

log.file_write(lb_references, ls_temp)

f_open_file(ls_temp, false)

end event

type st_assessment_title from statictext within w_contraindication_display
integer x = 27
integer y = 132
integer width = 507
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Assessment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_treatment_title from statictext within w_contraindication_display
integer x = 27
integer y = 224
integer width = 507
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Treatment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_assessment from statictext within w_contraindication_display
integer x = 544
integer y = 136
integer width = 2208
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_treatment from statictext within w_contraindication_display
integer x = 544
integer y = 228
integer width = 2208
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type ole_long_description from u_ie_browser within w_contraindication_display
integer x = 23
integer y = 728
integer width = 2880
integer height = 844
integer taborder = 21
boolean bringtotop = true
string binarykey = "w_contraindication_display.win"
end type

type cb_do_not_prescribe from commandbutton within w_contraindication_display
integer x = 311
integer y = 1612
integer width = 1111
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Do Not Prescribe This Treatment "
end type

event clicked;closewithreturn(parent, "CANCEL")

end event

type cb_prescribe from commandbutton within w_contraindication_display
integer x = 1518
integer y = 1612
integer width = 1111
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Continue Prescribing This Treatment"
end type

event clicked;closewithreturn(parent, "OK")

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Bw_contraindication_display.bin 
2000000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000002282776001c8606800000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f000000002282776001c860682282776001c86068000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000009c000000000000000100000002fffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
25ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c0000411d000015cf0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c046000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000006c0074006e006900000067006f0046007400720000006500720046006e0061006c006b0000004c0000411d000015cf0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c04600000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000650048007600610000007900720046006e0061006c006b006e0069004700200074006f00690068002000630065004d00690064006d007500430020006e006f00000064006900470069006700470000006c00690020006c006100530073006e004d00200000005400690047006c006c00530020006e0061002000730054004d00430020006e006f006500640073006e0064006500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Bw_contraindication_display.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
