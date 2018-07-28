HA$PBExportHeader$u_tabpage_treatment_type_default_modes.sru
forward
global type u_tabpage_treatment_type_default_modes from u_tabpage
end type
type dw_offices from u_dw_pick_list within u_tabpage_treatment_type_default_modes
end type
type st_workplan_description_title from statictext within u_tabpage_treatment_type_default_modes
end type
type st_1 from statictext within u_tabpage_treatment_type_default_modes
end type
end forward

global type u_tabpage_treatment_type_default_modes from u_tabpage
integer width = 2802
integer height = 1000
dw_offices dw_offices
st_workplan_description_title st_workplan_description_title
st_1 st_1
end type
global u_tabpage_treatment_type_default_modes u_tabpage_treatment_type_default_modes

type variables
string treatment_type

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize (string ps_key)
end prototypes

public subroutine refresh ();dw_offices.settransobject(sqlca)
dw_offices.retrieve(treatment_type)


end subroutine

public function integer initialize (string ps_key);treatment_type = ps_key

this.event trigger resize_tabpage()

return 1

end function

on u_tabpage_treatment_type_default_modes.create
int iCurrent
call super::create
this.dw_offices=create dw_offices
this.st_workplan_description_title=create st_workplan_description_title
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_offices
this.Control[iCurrent+2]=this.st_workplan_description_title
this.Control[iCurrent+3]=this.st_1
end on

on u_tabpage_treatment_type_default_modes.destroy
call super::destroy
destroy(this.dw_offices)
destroy(this.st_workplan_description_title)
destroy(this.st_1)
end on

event resize_tabpage;call super::resize_tabpage;long ll_width

ll_width = (dw_offices.width - 169)

dw_offices.object.office_description.width = int(ll_width / 2)
dw_offices.object.compute_treatment_mode.width = int(ll_width / 2)



end event

type dw_offices from u_dw_pick_list within u_tabpage_treatment_type_default_modes
integer x = 119
integer y = 96
integer width = 2565
integer height = 852
integer taborder = 10
string dataobject = "dw_jmj_treatment_type_default_modes"
boolean border = false
end type

event selected;call super::selected;string ls_clicked_office_id
str_popup popup
str_popup_return popup_return
string ls_treatment_mode
string ls_current_treatment_mode
string ls_office_id
boolean lb_no_default
long i

ls_clicked_office_id = object.office_id[selected_row]

popup.dataobject = "dw_treatment_mode_pick"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = treatment_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_treatment_mode = popup_return.items[1]

sqlca.jmj_treatment_type_set_default_mode(ls_clicked_office_id, treatment_type, ls_treatment_mode, current_scribe.user_id)
if not tf_check() then return

object.treatment_mode[selected_row] = ls_treatment_mode

// See if the user wants to apply this to all offices
if rowcount() > 1 then
	openwithparm(w_pop_yes_no, "Do you wish to set the default treatment mode for all offices to ~"" + ls_treatment_mode + "~"?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		for i = 1 to rowcount()
			ls_office_id = object.office_id[i]
			if ls_clicked_office_id <> ls_office_id then
				sqlca.jmj_treatment_type_set_default_mode(ls_office_id, treatment_type, ls_treatment_mode, current_scribe.user_id)
				if not tf_check() then return
				object.treatment_mode[i] = ls_treatment_mode
			end if
		next
	end if
end if

clear_selected()


end event

type st_workplan_description_title from statictext within u_tabpage_treatment_type_default_modes
integer x = 1339
integer y = 4
integer width = 1225
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Default Treatment Mode"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within u_tabpage_treatment_type_default_modes
integer x = 151
integer y = 4
integer width = 1189
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Office"
boolean focusrectangle = false
end type

