$PBExportHeader$u_soap_page_results.sru
$PBExportComments$show button bar for doing test from observation & treatment types..
forward
global type u_soap_page_results from u_soap_page_base
end type
type pb_down from picturebutton within u_soap_page_results
end type
type pb_up from picturebutton within u_soap_page_results
end type
type st_new_data from statictext within u_soap_page_results
end type
type st_page from statictext within u_soap_page_results
end type
type uo_attachments from u_letter_attachments within u_soap_page_results
end type
type st_attachments_title from statictext within u_soap_page_results
end type
end forward

global type u_soap_page_results from u_soap_page_base
pb_down pb_down
pb_up pb_up
st_new_data st_new_data
st_page st_page
uo_attachments uo_attachments
st_attachments_title st_attachments_title
end type
global u_soap_page_results u_soap_page_results

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

ll_page = uo_attachments.dw_attachments.current_page
if ll_page <= 0 then ll_page = 1

//li_sts = uo_attachments.load_encounter(display_mode, new_data)
if li_sts <= 0 then return

uo_attachments.dw_attachments.last_page = 0
uo_attachments.dw_attachments.set_page(ll_page, pb_up, pb_down, st_page)
st_page.visible = false

uo_attachments.refresh("Lab Results")

setredraw(true)


end subroutine

public subroutine xx_initialize ();string ls_temp

long ll_null

setnull(ll_null)

if st_encounter.visible then
	uo_attachments.visible = true
	
	pb_up.x = button_x - pb_up.width - 16
	pb_down.x = pb_up.x
	
	st_new_data.x = pb_up.x
	

	//uo_attachments.width = width - uo_attachments.x
	uo_attachments.width = pb_up.x - uo_attachments.x - 16	
	uo_attachments.height = height - uo_attachments.y
	
	st_attachments_title.width = uo_attachments.width - 120
	st_attachments_title.height = height - st_attachments_title.y
else
	uo_attachments.visible = false
end if

pb_up.visible = false
pb_down.visible = false

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

// Initially pull out all the patient results
uo_attachments.initialize("Patient", "Tag", ll_null, "Lab Results")


end subroutine

on u_soap_page_results.create
int iCurrent
call super::create
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_new_data=create st_new_data
this.st_page=create st_page
this.uo_attachments=create uo_attachments
this.st_attachments_title=create st_attachments_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_down
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.st_new_data
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.uo_attachments
this.Control[iCurrent+6]=this.st_attachments_title
end on

on u_soap_page_results.destroy
call super::destroy
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_new_data)
destroy(this.st_page)
destroy(this.uo_attachments)
destroy(this.st_attachments_title)
end on

type cb_configure_tab from u_soap_page_base`cb_configure_tab within u_soap_page_results
end type

type st_encounter_id from u_soap_page_base`st_encounter_id within u_soap_page_results
end type

type cb_coding from u_soap_page_base`cb_coding within u_soap_page_results
end type

type st_no_encounters from u_soap_page_base`st_no_encounters within u_soap_page_results
integer x = 18
integer width = 1504
end type

type pb_4 from u_soap_page_base`pb_4 within u_soap_page_results
end type

type cb_current from u_soap_page_base`cb_current within u_soap_page_results
end type

type cb_prev from u_soap_page_base`cb_prev within u_soap_page_results
end type

type cb_next from u_soap_page_base`cb_next within u_soap_page_results
end type

type pb_1 from u_soap_page_base`pb_1 within u_soap_page_results
end type

type pb_5 from u_soap_page_base`pb_5 within u_soap_page_results
end type

type pb_2 from u_soap_page_base`pb_2 within u_soap_page_results
end type

type pb_3 from u_soap_page_base`pb_3 within u_soap_page_results
end type

type pb_6 from u_soap_page_base`pb_6 within u_soap_page_results
end type

type pb_summary from u_soap_page_base`pb_summary within u_soap_page_results
end type

type st_button_1 from u_soap_page_base`st_button_1 within u_soap_page_results
end type

type st_button_2 from u_soap_page_base`st_button_2 within u_soap_page_results
end type

type st_button_3 from u_soap_page_base`st_button_3 within u_soap_page_results
end type

type st_button_4 from u_soap_page_base`st_button_4 within u_soap_page_results
end type

type st_button_5 from u_soap_page_base`st_button_5 within u_soap_page_results
end type

type st_button_6 from u_soap_page_base`st_button_6 within u_soap_page_results
end type

type st_encounter from u_soap_page_base`st_encounter within u_soap_page_results
end type

type st_encounter_background from u_soap_page_base`st_encounter_background within u_soap_page_results
end type

type st_config_mode_menu from u_soap_page_base`st_config_mode_menu within u_soap_page_results
end type

type st_encounter_status from u_soap_page_base`st_encounter_status within u_soap_page_results
end type

type st_encounter_count from u_soap_page_base`st_encounter_count within u_soap_page_results
end type

type pb_down from picturebutton within u_soap_page_results
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
//uo_attachments.set_page(uo_attachments.current_page + 1, ls_text)
//pb_up.enabled = true
//
//if uo_attachments.current_page >= uo_attachments.last_page then
//	enabled = false
//else
//	enabled = true
//end if

end event

type pb_up from picturebutton within u_soap_page_results
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
//uo_attachments.set_page(uo_attachments.current_page - 1, ls_text)
//pb_down.enabled = true
//
//if uo_attachments.current_page <= 1 then
//	enabled = false
//else
//	enabled = true
//end if

end event

type st_new_data from statictext within u_soap_page_results
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

type st_page from statictext within u_soap_page_results
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

type uo_attachments from u_letter_attachments within u_soap_page_results
event destroy ( )
integer x = 530
integer y = 324
integer width = 1943
integer height = 824
integer taborder = 30
boolean bringtotop = true
end type

on uo_attachments.destroy
call u_letter_attachments::destroy
end on

event ue_attachment_clicked;call super::ue_attachment_clicked;current_patient.attachments.menu(pl_attachment_id, context_object, object_key)
parent.refresh()

end event

type st_attachments_title from statictext within u_soap_page_results
integer x = 873
integer width = 1883
integer height = 96
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Attachments"
alignment alignment = center!
boolean focusrectangle = false
end type

