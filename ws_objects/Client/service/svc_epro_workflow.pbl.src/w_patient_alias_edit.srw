$PBExportHeader$w_patient_alias_edit.srw
forward
global type w_patient_alias_edit from window
end type
type cb_delete from commandbutton within w_patient_alias_edit
end type
type st_alias_type from statictext within w_patient_alias_edit
end type
type st_degree_title from statictext within w_patient_alias_edit
end type
type sle_degree from singlelineedit within w_patient_alias_edit
end type
type st_name_suffix_title from statictext within w_patient_alias_edit
end type
type sle_name_suffix from singlelineedit within w_patient_alias_edit
end type
type st_name_prefix_title from statictext within w_patient_alias_edit
end type
type sle_name_prefix from singlelineedit within w_patient_alias_edit
end type
type sle_middle_name from singlelineedit within w_patient_alias_edit
end type
type st_middle_name_title from statictext within w_patient_alias_edit
end type
type sle_first_name from singlelineedit within w_patient_alias_edit
end type
type st_first_name_title from statictext within w_patient_alias_edit
end type
type st_last_name_title from statictext within w_patient_alias_edit
end type
type st_1 from statictext within w_patient_alias_edit
end type
type cb_cancel from commandbutton within w_patient_alias_edit
end type
type cb_finished from commandbutton within w_patient_alias_edit
end type
type sle_last_name from singlelineedit within w_patient_alias_edit
end type
end forward

global type w_patient_alias_edit from window
integer x = 649
integer y = 252
integer width = 1614
integer height = 1352
boolean titlebar = true
windowtype windowtype = response!
long backcolor = 7191717
event postopen ( )
cb_delete cb_delete
st_alias_type st_alias_type
st_degree_title st_degree_title
sle_degree sle_degree
st_name_suffix_title st_name_suffix_title
sle_name_suffix sle_name_suffix
st_name_prefix_title st_name_prefix_title
sle_name_prefix sle_name_prefix
sle_middle_name sle_middle_name
st_middle_name_title st_middle_name_title
sle_first_name sle_first_name
st_first_name_title st_first_name_title
st_last_name_title st_last_name_title
st_1 st_1
cb_cancel cb_cancel
cb_finished cb_finished
sle_last_name sle_last_name
end type
global w_patient_alias_edit w_patient_alias_edit

type variables
str_patient_alias patient_alias

boolean changed = false

end variables

on w_patient_alias_edit.create
this.cb_delete=create cb_delete
this.st_alias_type=create st_alias_type
this.st_degree_title=create st_degree_title
this.sle_degree=create sle_degree
this.st_name_suffix_title=create st_name_suffix_title
this.sle_name_suffix=create sle_name_suffix
this.st_name_prefix_title=create st_name_prefix_title
this.sle_name_prefix=create sle_name_prefix
this.sle_middle_name=create sle_middle_name
this.st_middle_name_title=create st_middle_name_title
this.sle_first_name=create sle_first_name
this.st_first_name_title=create st_first_name_title
this.st_last_name_title=create st_last_name_title
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_finished=create cb_finished
this.sle_last_name=create sle_last_name
this.Control[]={this.cb_delete,&
this.st_alias_type,&
this.st_degree_title,&
this.sle_degree,&
this.st_name_suffix_title,&
this.sle_name_suffix,&
this.st_name_prefix_title,&
this.sle_name_prefix,&
this.sle_middle_name,&
this.st_middle_name_title,&
this.sle_first_name,&
this.st_first_name_title,&
this.st_last_name_title,&
this.st_1,&
this.cb_cancel,&
this.cb_finished,&
this.sle_last_name}
end on

on w_patient_alias_edit.destroy
destroy(this.cb_delete)
destroy(this.st_alias_type)
destroy(this.st_degree_title)
destroy(this.sle_degree)
destroy(this.st_name_suffix_title)
destroy(this.sle_name_suffix)
destroy(this.st_name_prefix_title)
destroy(this.sle_name_prefix)
destroy(this.sle_middle_name)
destroy(this.st_middle_name_title)
destroy(this.sle_first_name)
destroy(this.st_first_name_title)
destroy(this.st_last_name_title)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_finished)
destroy(this.sle_last_name)
end on

event open;
patient_alias = message.powerobjectparm

st_alias_type.text = wordcap(patient_alias.alias_type)

SELECT last_name,
		first_name,
		middle_name,
		name_prefix,
		name_suffix,
		degree
INTO :sle_last_name.text,
		:sle_first_name.text,
		:sle_middle_name.text,
		:sle_name_prefix.text,
		:sle_name_suffix.text,
		:sle_degree.text
FROM p_Patient_Alias
WHERE cpr_id = :patient_alias.cpr_id
AND alias_type = :patient_alias.alias_type
AND current_flag = 'Y';
if not tf_check() then
	close(this)
	return
end if

if wordcap(patient_alias.alias_type) = 'Primary' then
	cb_delete.visible = false
else
	cb_delete.visible = true
end if

end event

type cb_delete from commandbutton within w_patient_alias_edit
integer x = 581
integer y = 1108
integer width = 325
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you wish to delete this alias?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

UPDATE p_Patient_Alias
SET current_flag = 'N'
WHERE cpr_id = :patient_alias.cpr_id
AND alias_type = :patient_alias.alias_type
AND current_flag = 'Y';
if not tf_check() then return

close(parent)

end event

type st_alias_type from statictext within w_patient_alias_edit
integer x = 416
integer y = 136
integer width = 786
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_degree_title from statictext within w_patient_alias_edit
integer x = 78
integer y = 940
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Degree:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_degree from singlelineedit within w_patient_alias_edit
integer x = 507
integer y = 924
integer width = 1001
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true
text = Upper(text)
if (text = 'PHD') then text = 'PhD'

end event

type st_name_suffix_title from statictext within w_patient_alias_edit
integer x = 78
integer y = 812
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Name Suffix:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_name_suffix from singlelineedit within w_patient_alias_edit
integer x = 507
integer y = 796
integer width = 1001
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true
if common_thread.name_cap = 'Y' then text = wordcap(text)
end event

type st_name_prefix_title from statictext within w_patient_alias_edit
integer x = 78
integer y = 684
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Name Prefix:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_name_prefix from singlelineedit within w_patient_alias_edit
integer x = 507
integer y = 668
integer width = 1001
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true
text = wordcap(text)

end event

type sle_middle_name from singlelineedit within w_patient_alias_edit
integer x = 507
integer y = 540
integer width = 1001
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true
if common_thread.name_cap = 'Y' then text = wordcap(text)

end event

type st_middle_name_title from statictext within w_patient_alias_edit
integer x = 69
integer y = 556
integer width = 416
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Middle Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_first_name from singlelineedit within w_patient_alias_edit
integer x = 507
integer y = 412
integer width = 1001
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true
if common_thread.name_cap = 'Y' then text = wordcap(text)

end event

type st_first_name_title from statictext within w_patient_alias_edit
integer x = 78
integer y = 428
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "First Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_last_name_title from statictext within w_patient_alias_edit
integer x = 78
integer y = 300
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Last Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_patient_alias_edit
integer width = 1618
integer height = 120
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Patient Alias"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_patient_alias_edit
integer x = 64
integer y = 1108
integer width = 402
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;close(parent)

end event

type cb_finished from commandbutton within w_patient_alias_edit
integer x = 1019
integer y = 1108
integer width = 517
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;string ls_last_name
string ls_first_name
string ls_middle_name
string ls_name_prefix
string ls_name_suffix
string ls_degree


if len(trim(sle_last_name.text)) > 0 then
	ls_last_name = trim(sle_last_name.text)
else
	setnull(ls_last_name)
end if
	
if len(trim(sle_first_name.text)) > 0 then
	ls_first_name = trim(sle_first_name.text)
else
	setnull(ls_first_name)
end if
	
if len(trim(sle_middle_name.text)) > 0 then
	ls_middle_name = trim(sle_middle_name.text)
else
	setnull(ls_middle_name)
end if
	
if len(trim(sle_name_prefix.text)) > 0 then
	ls_name_prefix = trim(sle_name_prefix.text)
else
	setnull(ls_name_prefix)
end if
	
if len(trim(sle_name_suffix.text)) > 0 then
	ls_name_suffix = trim(sle_name_suffix.text)
else
	setnull(ls_name_suffix)
end if
	
if len(trim(sle_degree.text)) > 0 then
	ls_degree = trim(sle_degree.text)
else
	setnull(ls_degree)
end if
	


if changed then
	INSERT INTO p_Patient_Alias (
		cpr_id ,
		alias_type ,
		last_name ,
		first_name ,
		middle_name ,
		name_prefix ,
		name_suffix ,
		degree ,
		created_by )
	VALUES (
		:patient_alias.cpr_id,
		:patient_alias.alias_type,
		:ls_last_name,
		:ls_first_name,
		:ls_middle_name,
		:ls_name_prefix,
		:ls_name_suffix,
		:ls_degree,
		:current_scribe.user_id);
	if not tf_check() then return -1
end if

close(parent)

end event

type sle_last_name from singlelineedit within w_patient_alias_edit
integer x = 507
integer y = 284
integer width = 1001
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true
if common_thread.name_cap = 'Y' then text = wordcap(text)

end event

