$PBExportHeader$w_authority_consultant.srw
forward
global type w_authority_consultant from w_window_base
end type
type dw_authorities from u_dw_pick_list within w_authority_consultant
end type
type st_title from statictext within w_authority_consultant
end type
type cb_ok from commandbutton within w_authority_consultant
end type
type cb_cancel from commandbutton within w_authority_consultant
end type
type st_help from statictext within w_authority_consultant
end type
end forward

global type w_authority_consultant from w_window_base
integer width = 2898
integer height = 1808
string title = "Authority Management"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_authorities dw_authorities
st_title st_title
cb_ok cb_ok
cb_cancel cb_cancel
st_help st_help
end type
global w_authority_consultant w_authority_consultant

type variables
string 			user_id
string authority_type
u_ds_data      preferred_providers
end variables

forward prototypes
public subroutine refresh_authorities ()
end prototypes

public subroutine refresh_authorities ();
end subroutine

on w_authority_consultant.create
int iCurrent
call super::create
this.dw_authorities=create dw_authorities
this.st_title=create st_title
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_help=create st_help
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_authorities
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.st_help
end on

on w_authority_consultant.destroy
call super::destroy
destroy(this.dw_authorities)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_help)
end on

event open;call super::open;str_popup		popup
string ls_name
string ls_type_desc

popup = Message.powerobjectparm
If popup.data_row_count < 1 Then
	log.log(this,"w_authority_consultant:open","Invalid Parameters",4)
	Close(this)
	Return
End If


user_id = popup.items[1]
if popup.data_row_count < 2 Then
	authority_type = "PAYOR"
else
	authority_type =  popup.items[2]
end if

ls_type_desc = datalist.authority_type_description(authority_type)

preferred_providers = Create u_ds_data
preferred_providers.set_dataobject("dw_pref_prov_by_consultant")

ls_name = user_list.user_full_name(user_id)
st_title.text = "Valid " + wordcap(ls_type_desc) + "s for " + ls_name
st_help.text = "Click to highlight the valid " + lower(ls_type_desc) + "s for "
st_help.text += ls_name
st_help.text += ".  Click again to un-highlight a " + ls_type_desc + "."

dw_authorities.object.name.width = dw_authorities.width - 189

dw_authorities.retrieve(authority_type,'%','OK')
postevent("post_open")

end event

event post_open;call super::post_open;Long ll_rowcount,ll_find,ll_provider_count
String ls_authority_id,ls_find
Integer i

preferred_providers.retrieve(user_id)

ll_provider_count = preferred_providers.rowcount()
// select the authorities for this consultant
ll_rowcount = dw_authorities.rowcount()
For i = 1 to preferred_providers.rowcount()
	ls_authority_id = preferred_providers.object.authority_id[i]
	ls_find = "authority_id='"+ls_authority_id+"'"
	ll_find = dw_authorities.find(ls_find,1,ll_rowcount)
	If ll_find <= 0 Then Continue
	dw_authorities.object.selected_flag[ll_find] = 1
Next

end event

type pb_epro_help from w_window_base`pb_epro_help within w_authority_consultant
integer x = 2802
integer y = 340
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_authority_consultant
end type

type dw_authorities from u_dw_pick_list within w_authority_consultant
integer x = 526
integer y = 252
integer width = 1778
integer height = 1204
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_insurance_display_list"
boolean vscrollbar = true
end type

event constructor;call super::constructor;settransobject(sqlca)
multiselect = true
end event

event selected;call super::selected;string ls_authority_id,ls_find
long ll_find,ll_row

ls_authority_id = object.authority_id[selected_row]
ls_find = "authority_id='"+ls_authority_id+"'"
ll_find = preferred_providers.find(ls_find,1,preferred_providers.rowcount())
If ll_find <= 0 Then
	ll_row = preferred_providers.insertrow(0)
	preferred_providers.object.consultant_id[ll_row] = user_id
	preferred_providers.object.authority_id[ll_row] = ls_authority_id
End If

end event

event unselected(long unselected_row);call super::unselected;string ls_authority_id,ls_find
long ll_find,ll_row

ls_authority_id = object.authority_id[unselected_row]
ls_find = "authority_id='"+ls_authority_id+"'"
ll_find = preferred_providers.find(ls_find,1,preferred_providers.rowcount())
If ll_find > 0 Then
	preferred_providers.deleterow(ll_find)
End If
end event

type st_title from statictext within w_authority_consultant
integer width = 2885
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Valid Payers for xxxx"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_authority_consultant
integer x = 2464
integer y = 1584
integer width = 402
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;preferred_providers.update()
Close(parent)
end event

type cb_cancel from commandbutton within w_authority_consultant
integer x = 55
integer y = 1592
integer width = 402
integer height = 112
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type st_help from statictext within w_authority_consultant
integer y = 112
integer width = 2885
integer height = 128
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Click to highlight the valid payers for xxxx.  Click again to un-highlight a payer."
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_done from w_window_full_response`pb_done within w_authority_consultant
end type

event pb_done::clicked;call super::clicked;preferred_providers.update()
Close(parent)
end event

type pb_cancel from w_window_full_response`pb_cancel within w_authority_consultant
integer x = 87
integer y = 904
string text = "Clos"
end type

event pb_cancel::clicked;call super::clicked;Close(Parent)
end event

