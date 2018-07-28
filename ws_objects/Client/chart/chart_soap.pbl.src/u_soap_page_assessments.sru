$PBExportHeader$u_soap_page_assessments.sru
$PBExportComments$show button bar for doing test from observation & treatment types..
forward
global type u_soap_page_assessments from u_soap_page_base
end type
type pb_down from picturebutton within u_soap_page_assessments
end type
type pb_up from picturebutton within u_soap_page_assessments
end type
type dw_soap_display from u_soap_display within u_soap_page_assessments
end type
type p_atat from picture within u_soap_page_assessments
end type
type p_aatt from picture within u_soap_page_assessments
end type
type p_aa from picture within u_soap_page_assessments
end type
type p_tt from picture within u_soap_page_assessments
end type
type st_new_data from statictext within u_soap_page_assessments
end type
type p_obj from picture within u_soap_page_assessments
end type
type st_page from statictext within u_soap_page_assessments
end type
type st_include_cancelled from statictext within u_soap_page_assessments
end type
end forward

global type u_soap_page_assessments from u_soap_page_base
pb_down pb_down
pb_up pb_up
dw_soap_display dw_soap_display
p_atat p_atat
p_aatt p_aatt
p_aa p_aa
p_tt p_tt
st_new_data st_new_data
p_obj p_obj
st_page st_page
st_include_cancelled st_include_cancelled
end type
global u_soap_page_assessments u_soap_page_assessments

type variables
string display_mode
boolean new_data

end variables

forward prototypes
public subroutine xx_refresh ()
public subroutine xx_initialize ()
end prototypes

public subroutine xx_refresh ();integer li_sts
string ls_text
long ll_page

setredraw(false)

ll_page = dw_soap_display.current_page
if ll_page <= 0 then ll_page = 1

li_sts = dw_soap_display.load_encounter(display_mode, new_data)
if li_sts <= 0 then return

dw_soap_display.last_page = 0
dw_soap_display.set_page(ll_page, pb_up, pb_down, st_page)
st_page.visible = false

setredraw(true)


end subroutine

public subroutine xx_initialize ();string ls_temp

if st_encounter.visible then
	dw_soap_display.visible = true
	p_atat.visible = true
	p_aatt.visible = true
	p_aa.visible = true
	
	pb_up.x = button_x - pb_up.width - 16
	pb_down.x = pb_up.x
	p_atat.x = pb_up.x
	p_aatt.x = pb_up.x
	p_aa.x = pb_up.x
	p_tt.x = pb_up.x
	p_obj.x = pb_up.x
	
	st_new_data.x = pb_up.x
	st_include_cancelled.x = st_new_data.x
	
	dw_soap_display.width = pb_up.x - dw_soap_display.x - 16
	
	dw_soap_display.height = height - dw_soap_display.y
else
	dw_soap_display.visible = false
	p_atat.visible = false
	p_aatt.visible = false
	p_aa.visible = false
end if

pb_up.visible = false
pb_down.visible = false

display_mode = upper(this_section.get_attribute(this_section.page[this_page].page_id, "display_mode"))
if isnull(display_mode) then display_mode = "ATAT"

CHOOSE CASE display_mode
	CASE "AATT"
		p_aatt.BorderStyle = StyleLowered!
	CASE "AA"
		p_aa.BorderStyle = StyleLowered!
	CASE "TT"
		p_tt.BorderStyle = StyleLowered!
	CASE "OBJ"
		p_obj.BorderStyle = StyleLowered!
	CASE ELSE
		display_mode = "ATAT"
		p_atat.BorderStyle = StyleLowered!
END CHOOSE

dw_soap_display.assessment_service = this_section.get_attribute(this_section.page[this_page].page_id, "assessment_service")
if isnull(dw_soap_display.assessment_service) then dw_soap_display.assessment_service = "ASSESSMENT_REVIEW"

dw_soap_display.treatment_service = this_section.get_attribute(this_section.page[this_page].page_id, "treatment_service")
if isnull(dw_soap_display.treatment_service) then dw_soap_display.treatment_service = "TREATMENT_REVIEW"

dw_soap_display.sincelast_display_script_id = long(this_section.get_attribute(this_section.page[this_page].page_id, "sincelast_display_script_id"))

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "text_color_new")
if isnull(ls_temp) then
	dw_soap_display.text_color_new = rgb(0,0,255)
else
	dw_soap_display.text_color_new = long(ls_temp)
end if

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "back_color_services")
if isnull(ls_temp) then
	dw_soap_display.back_color_services = rgb(192,255,255)
else
	dw_soap_display.back_color_services = long(ls_temp)
end if

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "back_color_deleted")
if isnull(ls_temp) then
	dw_soap_display.back_color_deleted = rgb(255,196, 196)
else
	dw_soap_display.back_color_deleted = long(ls_temp)
end if

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "new_data")
if isnull(ls_temp) then ls_temp = "False"
new_data = f_string_to_boolean(ls_temp)

if new_data then
	st_new_data.BorderStyle = StyleLowered!
else
	st_new_data.BorderStyle = StyleRaised!
end if

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "show_deleted")
if isnull(ls_temp) then ls_temp = "False"
dw_soap_display.show_deleted = f_string_to_boolean(ls_temp)

if dw_soap_display.show_deleted then
	st_include_cancelled.BorderStyle = StyleLowered!
else
	st_include_cancelled.BorderStyle = StyleRaised!
end if

dw_soap_display.initialize()


end subroutine

on u_soap_page_assessments.create
int iCurrent
call super::create
this.pb_down=create pb_down
this.pb_up=create pb_up
this.dw_soap_display=create dw_soap_display
this.p_atat=create p_atat
this.p_aatt=create p_aatt
this.p_aa=create p_aa
this.p_tt=create p_tt
this.st_new_data=create st_new_data
this.p_obj=create p_obj
this.st_page=create st_page
this.st_include_cancelled=create st_include_cancelled
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_down
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.dw_soap_display
this.Control[iCurrent+4]=this.p_atat
this.Control[iCurrent+5]=this.p_aatt
this.Control[iCurrent+6]=this.p_aa
this.Control[iCurrent+7]=this.p_tt
this.Control[iCurrent+8]=this.st_new_data
this.Control[iCurrent+9]=this.p_obj
this.Control[iCurrent+10]=this.st_page
this.Control[iCurrent+11]=this.st_include_cancelled
end on

on u_soap_page_assessments.destroy
call super::destroy
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.dw_soap_display)
destroy(this.p_atat)
destroy(this.p_aatt)
destroy(this.p_aa)
destroy(this.p_tt)
destroy(this.st_new_data)
destroy(this.p_obj)
destroy(this.st_page)
destroy(this.st_include_cancelled)
end on

type st_encounter_id from u_soap_page_base`st_encounter_id within u_soap_page_assessments
end type

type cb_coding from u_soap_page_base`cb_coding within u_soap_page_assessments
end type

type st_no_encounters from u_soap_page_base`st_no_encounters within u_soap_page_assessments
end type

type pb_4 from u_soap_page_base`pb_4 within u_soap_page_assessments
end type

type cb_current from u_soap_page_base`cb_current within u_soap_page_assessments
end type

type cb_prev from u_soap_page_base`cb_prev within u_soap_page_assessments
end type

type cb_next from u_soap_page_base`cb_next within u_soap_page_assessments
end type

type pb_1 from u_soap_page_base`pb_1 within u_soap_page_assessments
end type

type pb_5 from u_soap_page_base`pb_5 within u_soap_page_assessments
end type

type pb_2 from u_soap_page_base`pb_2 within u_soap_page_assessments
end type

type pb_3 from u_soap_page_base`pb_3 within u_soap_page_assessments
end type

type pb_6 from u_soap_page_base`pb_6 within u_soap_page_assessments
end type

type pb_summary from u_soap_page_base`pb_summary within u_soap_page_assessments
end type

type st_button_1 from u_soap_page_base`st_button_1 within u_soap_page_assessments
end type

type st_button_2 from u_soap_page_base`st_button_2 within u_soap_page_assessments
end type

type st_button_3 from u_soap_page_base`st_button_3 within u_soap_page_assessments
end type

type st_button_4 from u_soap_page_base`st_button_4 within u_soap_page_assessments
end type

type st_button_5 from u_soap_page_base`st_button_5 within u_soap_page_assessments
end type

type st_button_6 from u_soap_page_base`st_button_6 within u_soap_page_assessments
end type

type st_encounter from u_soap_page_base`st_encounter within u_soap_page_assessments
end type

type st_encounter_background from u_soap_page_base`st_encounter_background within u_soap_page_assessments
end type

type st_config_mode_menu from u_soap_page_base`st_config_mode_menu within u_soap_page_assessments
end type

type st_encounter_status from u_soap_page_base`st_encounter_status within u_soap_page_assessments
end type

type st_encounter_count from u_soap_page_base`st_encounter_count within u_soap_page_assessments
end type

type pb_down from picturebutton within u_soap_page_assessments
integer x = 2071
integer y = 256
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
alignment htextalign = left!
end type

event clicked;string ls_text
dw_soap_display.set_page(dw_soap_display.current_page + 1, ls_text)
pb_up.enabled = true

if dw_soap_display.current_page >= dw_soap_display.last_page then
	enabled = false
else
	enabled = true
end if

end event

type pb_up from picturebutton within u_soap_page_assessments
integer x = 2071
integer y = 128
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
alignment htextalign = left!
end type

event clicked;string ls_text
dw_soap_display.set_page(dw_soap_display.current_page - 1, ls_text)
pb_down.enabled = true

if dw_soap_display.current_page <= 1 then
	enabled = false
else
	enabled = true
end if

end event

type dw_soap_display from u_soap_display within u_soap_page_assessments
integer x = 14
integer y = 148
integer width = 1874
integer height = 1024
integer taborder = 10
boolean bringtotop = true
end type

event selected;call super::selected;refresh()
parent.postevent("refresh")
end event

event computed_clicked;call super::computed_clicked;refresh()
parent.postevent("refresh")
end event

type p_atat from picture within u_soap_page_assessments
integer x = 2071
integer y = 392
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_assessments1.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_aatt.BorderStyle = StyleRaised!
p_aa.BorderStyle = StyleRaised!
p_tt.BorderStyle = StyleRaised!
p_obj.BorderStyle = StyleRaised!

display_mode = "ATAT"
refresh()

end event

type p_aatt from picture within u_soap_page_assessments
integer x = 2071
integer y = 512
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_assessments2.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_atat.BorderStyle = StyleRaised!
p_aa.BorderStyle = StyleRaised!
p_tt.BorderStyle = StyleRaised!
p_obj.BorderStyle = StyleRaised!

display_mode = "AATT"
refresh()

end event

type p_aa from picture within u_soap_page_assessments
integer x = 2071
integer y = 632
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_assessments3.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_atat.BorderStyle = StyleRaised!
p_aatt.BorderStyle = StyleRaised!
p_tt.BorderStyle = StyleRaised!
p_obj.BorderStyle = StyleRaised!

display_mode = "AA"
refresh()

end event

type p_tt from picture within u_soap_page_assessments
integer x = 2071
integer y = 752
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_assessments4.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_atat.BorderStyle = StyleRaised!
p_aatt.BorderStyle = StyleRaised!
p_aa.BorderStyle = StyleRaised!
p_obj.BorderStyle = StyleRaised!

display_mode = "TT"
refresh()

end event

type st_new_data from statictext within u_soap_page_assessments
integer x = 2071
integer y = 1008
integer width = 137
integer height = 112
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "New Only"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if new_data then
	new_data = false
	BorderStyle = StyleRaised!
else
	new_data = true
	BorderStyle = StyleLowered!
end if

refresh()

end event

type p_obj from picture within u_soap_page_assessments
integer x = 2071
integer y = 872
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_encounter_objects.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_atat.BorderStyle = StyleRaised!
p_aatt.BorderStyle = StyleRaised!
p_aa.BorderStyle = StyleRaised!
p_tt.BorderStyle = StyleRaised!

display_mode = "OBJ"
refresh()

end event

type st_page from statictext within u_soap_page_assessments
boolean visible = false
integer x = 2066
integer y = 1128
integer width = 256
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean focusrectangle = false
end type

type st_include_cancelled from statictext within u_soap_page_assessments
integer x = 2071
integer y = 1132
integer width = 137
integer height = 112
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Incl Cncld"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_soap_display.show_deleted then
	dw_soap_display.show_deleted = false
	BorderStyle = StyleRaised!
else
	dw_soap_display.show_deleted = true
	BorderStyle = StyleLowered!
end if

refresh()

end event

