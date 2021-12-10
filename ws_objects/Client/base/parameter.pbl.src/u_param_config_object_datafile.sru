$PBExportHeader$u_param_config_object_datafile.sru
forward
global type u_param_config_object_datafile from u_param_config_object_base
end type
type rb_machine from radiobutton within u_param_config_object_datafile
end type
type rb_human from radiobutton within u_param_config_object_datafile
end type
end forward

global type u_param_config_object_datafile from u_param_config_object_base
string config_object_type = "Report"
rb_machine rb_machine
rb_human rb_human
end type
global u_param_config_object_datafile u_param_config_object_datafile

type variables


end variables

on u_param_config_object_datafile.create
int iCurrent
call super::create
this.rb_machine=create rb_machine
this.rb_human=create rb_human
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_machine
this.Control[iCurrent+2]=this.rb_human
end on

on u_param_config_object_datafile.destroy
call super::destroy
destroy(this.rb_machine)
destroy(this.rb_human)
end on

event constructor;call super::constructor;config_object_type = "Datafile"
rb_machine.checked = true

end event

type cb_clear from u_param_config_object_base`cb_clear within u_param_config_object_datafile
end type

type st_required from u_param_config_object_base`st_required within u_param_config_object_datafile
end type

type st_helptext from u_param_config_object_base`st_helptext within u_param_config_object_datafile
end type

type st_title from u_param_config_object_base`st_title within u_param_config_object_datafile
end type

type st_popup_values from u_param_config_object_base`st_popup_values within u_param_config_object_datafile
end type

type cb_configure from u_param_config_object_base`cb_configure within u_param_config_object_datafile
end type

type rb_machine from radiobutton within u_param_config_object_datafile
integer x = 18
integer y = 932
integer width = 818
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Machine Readable Datafile"
boolean checked = true
end type

event clicked;if checked then
	config_object_type = "Datafile"
end if

end event

type rb_human from radiobutton within u_param_config_object_datafile
integer x = 18
integer y = 1016
integer width = 818
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Human Readable Report"
end type

event clicked;if checked then
	config_object_type = "Report"
end if

end event

