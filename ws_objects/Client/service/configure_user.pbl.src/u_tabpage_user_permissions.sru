$PBExportHeader$u_tabpage_user_permissions.sru
forward
global type u_tabpage_user_permissions from u_tabpage_user_base
end type
type st_office from statictext within u_tabpage_user_permissions
end type
type st_4 from statictext within u_tabpage_user_permissions
end type
type st_3 from statictext within u_tabpage_user_permissions
end type
type st_access_clinical_data from statictext within u_tabpage_user_permissions
end type
type st_certified from statictext within u_tabpage_user_permissions
end type
type st_rx from statictext within u_tabpage_user_permissions
end type
type dw_privileges from u_dw_pick_list within u_tabpage_user_permissions
end type
type st_1 from statictext within u_tabpage_user_permissions
end type
end forward

global type u_tabpage_user_permissions from u_tabpage_user_base
string tag = "User"
integer width = 2743
integer height = 1400
st_office st_office
st_4 st_4
st_3 st_3
st_access_clinical_data st_access_clinical_data
st_certified st_certified
st_rx st_rx
dw_privileges dw_privileges
st_1 st_1
end type
global u_tabpage_user_permissions u_tabpage_user_permissions

type variables
string privilege_office_id

boolean rx_certified


end variables

forward prototypes
public subroutine refresh ()
public function integer initialize ()
end prototypes

public subroutine refresh ();u_ds_data luo_data
long ll_count
long ll_priv_count
long i
string ls_privilege_id
string ls_find
long ll_row
string ls_access_flag

if user.clinical_access_flag then
	st_access_clinical_data.text = "Yes"
else
	st_access_clinical_data.text = "No"
end if

rx_certified = user_list.user_certified(user.user_id)
if rx_certified then
	st_certified.text = "Yes"
else
	st_certified.text = "No"
end if

st_office.text = datalist.office_description(privilege_office_id)

dw_privileges.setredraw(false)

ll_priv_count = dw_privileges.retrieve()

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_user_privileges_for_office")
ll_count = luo_data.retrieve(user.user_id, privilege_office_id)
for i = 1 to ll_count
	ls_privilege_id = luo_data.object.privilege_id[i]
	ls_access_flag = luo_data.object.access_flag[i]
	ls_find = "privilege_id='" + ls_privilege_id + "'"
	ll_row = dw_privileges.find(ls_find, 1, ll_priv_count)
	if ll_row > 0 then
		dw_privileges.object.access_flag[ll_row] = ls_access_flag
	end if
next

dw_privileges.setredraw(true)

end subroutine

public function integer initialize ();long ll_count

privilege_office_id = gnv_app.office_id


dw_privileges.settransobject(sqlca)
dw_privileges.object.description.width = dw_privileges.width - 380


return 1


end function

on u_tabpage_user_permissions.create
int iCurrent
call super::create
this.st_office=create st_office
this.st_4=create st_4
this.st_3=create st_3
this.st_access_clinical_data=create st_access_clinical_data
this.st_certified=create st_certified
this.st_rx=create st_rx
this.dw_privileges=create dw_privileges
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_office
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_access_clinical_data
this.Control[iCurrent+5]=this.st_certified
this.Control[iCurrent+6]=this.st_rx
this.Control[iCurrent+7]=this.dw_privileges
this.Control[iCurrent+8]=this.st_1
end on

on u_tabpage_user_permissions.destroy
call super::destroy
destroy(this.st_office)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_access_clinical_data)
destroy(this.st_certified)
destroy(this.st_rx)
destroy(this.dw_privileges)
destroy(this.st_1)
end on

type st_office from statictext within u_tabpage_user_permissions
integer x = 1426
integer y = 96
integer width = 1257
integer height = 104
integer taborder = 150
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

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

privilege_office_id = popup_return.items[1]

refresh()

end event

type st_4 from statictext within u_tabpage_user_permissions
integer x = 402
integer y = 464
integer width = 649
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Special Privileges"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within u_tabpage_user_permissions
integer x = 37
integer y = 620
integer width = 992
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "User May Access Clinical Data:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_access_clinical_data from statictext within u_tabpage_user_permissions
integer x = 1047
integer y = 608
integer width = 261
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_progress
integer li_sts

if user.clinical_access_flag then
	ls_progress = "N"
else
	ls_progress = "Y"
end if

li_sts = user_list.set_user_progress( user.user_id, &
												"Modify", &
												"clinical_access_flag", &
												ls_progress)
if li_sts <= 0 then return

if ls_progress = "Y" then
	user.clinical_access_flag = true
	text = "Yes"
	f_log_security_event("Grant Clinical Access", "Success", user.user_id)
else
	user.clinical_access_flag = false
	text = "No"
	f_log_security_event("Revoke Clinical Access", "Success", user.user_id)
end if




end event

type st_certified from statictext within u_tabpage_user_permissions
integer x = 1047
integer y = 748
integer width = 261
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;datetime ldt_now
string ls_progress_type
string ls_certified
integer li_sts

if rx_certified then
	ls_certified = "N"
else
	ls_certified = "Y"
end if

ldt_now = datetime(today(), now())

li_sts = user_list.set_user_progress( user.user_id, &
												"Modify", &
												"certified", &
												ls_certified)
if li_sts <= 0 then return


if ls_certified = "Y" then
	rx_certified = true
	text = "Yes"
	user.certified = "Y"
	f_log_security_event("Grant Rx Certified", "Success", user.user_id)
else
	rx_certified = false
	text = "No"
	user.certified = "N"
	f_log_security_event("Revoke Rx Certified", "Success", user.user_id)
end if

end event

type st_rx from statictext within u_tabpage_user_permissions
integer x = 37
integer y = 764
integer width = 992
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "User May Prescribe Medications:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_privileges from u_dw_pick_list within u_tabpage_user_permissions
integer x = 1426
integer y = 208
integer width = 1257
integer height = 1140
integer taborder = 10
string dataobject = "dw_privilege_list"
boolean vscrollbar = true
boolean multiselect = true
end type

event clicked;call super::clicked;string ls_privilege_id
integer li_sts
string ls_access_flag
string ls_secure_flag

ls_privilege_id = object.privilege_id[row]
ls_access_flag = object.access_flag[row]
ls_secure_flag = object.secure_flag[row]


if lastcolumnname = "compute_yesno" then
	if lower(ls_privilege_id) = "super user" then
		if not user_list.is_superuser(current_scribe.user_id) then
			openwithparm(w_pop_message, "Only a Super User may set the Super User privilege")
			return
		end if
	end if
	if isnull(ls_access_flag) then
		if ls_secure_flag = "Y" then
			li_sts = user_list.set_user_progress( user.user_id, &
															"Grant Privilege", &
															privilege_office_id, &
															ls_privilege_id)
			if li_sts <= 0 then return
			f_log_security_event(left("Grant " + ls_privilege_id, 24), "Success", user.user_id)
		else
			li_sts = user_list.set_user_progress( user.user_id, &
															"Revoke Privilege", &
															privilege_office_id, &
															ls_privilege_id)
			if li_sts <= 0 then return
			f_log_security_event(left("Revoke " + ls_privilege_id, 24), "Success", user.user_id)
		end if
	elseif ls_access_flag = "G" then
		li_sts = user_list.set_user_progress( user.user_id, &
														"Revoke Privilege", &
														privilege_office_id, &
														ls_privilege_id)
		if li_sts <= 0 then return
		f_log_security_event(left("Revoke " + ls_privilege_id, 24), "Success", user.user_id)
	else
		li_sts = user_list.set_user_progress( user.user_id, &
														"Grant Privilege", &
														privilege_office_id, &
														ls_privilege_id)
		if li_sts <= 0 then return
		f_log_security_event(left("Grant " + ls_privilege_id, 24), "Success", user.user_id)
	end if
end if

refresh()


end event

type st_1 from statictext within u_tabpage_user_permissions
integer x = 1426
integer width = 1257
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Office Privileges"
alignment alignment = center!
boolean focusrectangle = false
end type

