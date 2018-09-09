$PBExportHeader$w_user_privilege.srw
forward
global type w_user_privilege from w_window_base
end type
type pb_done from u_picture_button within w_user_privilege
end type
type st_name from statictext within w_user_privilege
end type
type dw_privs_available from u_dw_pick_list within w_user_privilege
end type
type dw_privs from u_dw_pick_list within w_user_privilege
end type
type st_1 from statictext within w_user_privilege
end type
type st_2 from statictext within w_user_privilege
end type
type cb_assign from commandbutton within w_user_privilege
end type
type cb_delete from commandbutton within w_user_privilege
end type
end forward

global type w_user_privilege from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
st_name st_name
dw_privs_available dw_privs_available
dw_privs dw_privs
st_1 st_1
st_2 st_2
cb_assign cb_assign
cb_delete cb_delete
end type
global w_user_privilege w_user_privilege

type variables
string user_id
end variables

forward prototypes
public function integer load_privs ()
end prototypes

public function integer load_privs ();long ll_rowcount
long i
string ls_user_id

dw_privs_available.setredraw(false)
dw_privs.setredraw(false)

dw_privs_available.settransobject(sqlca)
dw_privs_available.retrieve(user_id,office_id)

ll_rowcount = dw_privs_available.rowcount()
if ll_rowcount <= 0 then return ll_rowcount

for i = ll_rowcount to 1 step -1
	ls_user_id = dw_privs_available.object.user_id[i]
	if not isnull(ls_user_id) then
		dw_privs_available.RowsMove ( i, i, Primary!, dw_privs, 1000, Primary!)
	end if
next

dw_privs.sort()

dw_privs_available.setredraw(true)
dw_privs.setredraw(true)

return 1

end function

on w_user_privilege.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.st_name=create st_name
this.dw_privs_available=create dw_privs_available
this.dw_privs=create dw_privs
this.st_1=create st_1
this.st_2=create st_2
this.cb_assign=create cb_assign
this.cb_delete=create cb_delete
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.st_name
this.Control[iCurrent+3]=this.dw_privs_available
this.Control[iCurrent+4]=this.dw_privs
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cb_assign
this.Control[iCurrent+8]=this.cb_delete
end on

on w_user_privilege.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.st_name)
destroy(this.dw_privs_available)
destroy(this.dw_privs)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_assign)
destroy(this.cb_delete)
end on

event open;call super::open;str_popup popup
integer li_sts

popup = message.powerobjectparm
if popup.data_row_count <> 2 then
	log.log(this, "w_user_privilege:open", "Invalid parameters", 4)
	close(this)
end if

user_id = popup.items[1]
st_name.text = popup.items[2]

li_sts = load_privs()
if li_sts <= 0 then
	log.log(this, "w_user_privilege:open", "Unable to load privileges", 4)
	close(this)
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_user_privilege
boolean visible = true
integer x = 2674
integer y = 16
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_user_privilege
end type

type pb_done from u_picture_button within w_user_privilege
integer x = 2569
integer y = 1552
integer taborder = 50
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type st_name from statictext within w_user_privilege
integer x = 215
integer y = 20
integer width = 2446
integer height = 172
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_privs_available from u_dw_pick_list within w_user_privilege
integer x = 174
integer y = 312
integer width = 1038
integer height = 1368
integer taborder = 40
string dataobject = "dw_privileges"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;dw_privs.clear_selected()

end event

type dw_privs from u_dw_pick_list within w_user_privilege
integer x = 1687
integer y = 312
integer width = 1038
integer height = 1156
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_privileges"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;dw_privs_available.clear_selected()
end event

type st_1 from statictext within w_user_privilege
integer x = 251
integer y = 208
integer width = 795
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Available Privileges"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_user_privilege
integer x = 1765
integer y = 208
integer width = 795
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Assigned Privileges"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_assign from commandbutton within w_user_privilege
integer x = 1321
integer y = 552
integer width = 247
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

event clicked;string ls_privilege_id
long ll_row

ll_row = dw_privs_available.get_selected_row()
if ll_row <= 0 then return

ls_privilege_id = dw_privs_available.object.privilege_id[ll_row]

INSERT INTO o_User_Privilege (office_id,user_id, privilege_id,access_flag,created_by)
VALUES (:office_id,:user_id, :ls_privilege_id,'G',:current_scribe.user_id);
if not tf_check() then return


dw_privs.setredraw(false)

dw_privs_available.rowsmove(ll_row, ll_row, Primary!, dw_privs, 1000, Primary!)

dw_privs.sort()

dw_privs.setredraw(true)

end event

type cb_delete from commandbutton within w_user_privilege
integer x = 1321
integer y = 800
integer width = 247
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<<"
end type

event clicked;string ls_privilege_id
long ll_row

ll_row = dw_privs.get_selected_row()
if ll_row <= 0 then return

ls_privilege_id = dw_privs.object.privilege_id[ll_row]

DELETE o_User_Privilege
WHERE user_id = :user_id
AND privilege_id = :ls_privilege_id
and office_id = :office_id;
if not tf_check() then return


dw_privs_available.setredraw(false)

dw_privs.rowsmove(ll_row, ll_row, Primary!, dw_privs_available, 1000, Primary!)

dw_privs_available.sort()

dw_privs_available.setredraw(true)

end event

