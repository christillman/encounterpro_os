$PBExportHeader$w_drug_alert.srw
forward
global type w_drug_alert from window
end type
type cb_allergies from commandbutton within w_drug_alert
end type
type st_1 from statictext within w_drug_alert
end type
type dw_message from datawindow within w_drug_alert
end type
type cb_no from commandbutton within w_drug_alert
end type
type cb_yes from commandbutton within w_drug_alert
end type
end forward

global type w_drug_alert from window
integer x = 430
integer y = 484
integer width = 2066
integer height = 952
windowtype windowtype = response!
long backcolor = 33538240
cb_allergies cb_allergies
st_1 st_1
dw_message dw_message
cb_no cb_no
cb_yes cb_yes
end type
global w_drug_alert w_drug_alert

on open;string ls_temp

dw_message.reset()
dw_message.insertrow(0)
dw_message.setitem(1,1,message.stringparm)

end on

on w_drug_alert.create
this.cb_allergies=create cb_allergies
this.st_1=create st_1
this.dw_message=create dw_message
this.cb_no=create cb_no
this.cb_yes=create cb_yes
this.Control[]={this.cb_allergies,&
this.st_1,&
this.dw_message,&
this.cb_no,&
this.cb_yes}
end on

on w_drug_alert.destroy
destroy(this.cb_allergies)
destroy(this.st_1)
destroy(this.dw_message)
destroy(this.cb_no)
destroy(this.cb_yes)
end on

type cb_allergies from commandbutton within w_drug_alert
integer x = 791
integer y = 760
integer width = 462
integer height = 108
integer taborder = 30
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Allergy List"
end type

event clicked;str_attributes lstr_attributes
string ls_service

ls_service = "ASSESSMENT_LIST"

service_list.do_service(current_patient.cpr_id, &
								current_patient.open_encounter_id, &
								ls_service, &
								lstr_attributes)



end event

type st_1 from statictext within w_drug_alert
integer x = 242
integer y = 56
integer width = 1600
integer height = 172
integer textsize = -26
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "! Drug Alert  !"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_message from datawindow within w_drug_alert
integer x = 73
integer y = 296
integer width = 1906
integer height = 368
integer taborder = 10
boolean enabled = false
string dataobject = "dw_ok"
boolean border = false
end type

type cb_no from commandbutton within w_drug_alert
integer x = 197
integer y = 760
integer width = 315
integer height = 108
integer taborder = 20
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "No"
end type

on clicked;closewithreturn(parent, 0)
end on

type cb_yes from commandbutton within w_drug_alert
integer x = 1531
integer y = 760
integer width = 315
integer height = 108
integer taborder = 40
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Yes"
end type

on clicked;closewithreturn(parent, 1)
end on

