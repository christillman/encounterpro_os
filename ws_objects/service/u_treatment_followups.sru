HA$PBExportHeader$u_treatment_followups.sru
forward
global type u_treatment_followups from u_tabpage
end type
type pb_down from u_picture_button within u_treatment_followups
end type
type pb_up from u_picture_button within u_treatment_followups
end type
type dw_workplans from u_dw_treatment_workplans within u_treatment_followups
end type
end forward

global type u_treatment_followups from u_tabpage
integer width = 2802
integer height = 1012
string text = "Followups"
pb_down pb_down
pb_up pb_up
dw_workplans dw_workplans
end type
global u_treatment_followups u_treatment_followups

type variables
boolean initialized = false
u_component_treatment treatment

end variables

forward prototypes
public function integer initialize (u_component_treatment puo_treatment)
public function integer display_followups ()
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize (u_component_treatment puo_treatment);
treatment = puo_treatment

dw_workplans.x = 0
dw_workplans.y = 0
dw_workplans.width = width
dw_workplans.height = height
pb_up.x = width - pb_up.width
pb_up.y = 0
pb_down.x = pb_up.x
pb_down.y = height - pb_down.height


return 1

end function

public function integer display_followups ();integer li_sts
string ls_temp

li_sts = dw_workplans.display_workplans(treatment.treatment_id, "Followup")
if li_sts < 0 then return -1

if li_sts = 0 then
	pb_up.visible = false
	pb_down.visible = false
	return 0
end if

dw_workplans.last_page = 0
dw_workplans.set_page(1, ls_temp)
if dw_workplans.last_page < 2 then
	pb_up.visible = false
	pb_down.visible = false
else
	pb_up.visible = true
	pb_down.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
end if

return li_sts

end function

public function integer initialize ();
treatment = parent_tab.service.treatment

dw_workplans.x = 0
dw_workplans.y = 0
dw_workplans.width = width
dw_workplans.height = height
pb_up.x = width - pb_up.width
pb_up.y = 0
pb_down.x = pb_up.x
pb_down.y = height - pb_down.height


return 1

end function

public subroutine refresh ();
display_followups()

end subroutine

on u_treatment_followups.create
int iCurrent
call super::create
this.pb_down=create pb_down
this.pb_up=create pb_up
this.dw_workplans=create dw_workplans
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_down
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.dw_workplans
end on

on u_treatment_followups.destroy
call super::destroy
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.dw_workplans)
end on

type pb_down from u_picture_button within u_treatment_followups
integer x = 2258
integer y = 744
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;string ls_temp
integer li_page
integer li_last_page

li_page = dw_workplans.current_page
li_last_page = dw_workplans.last_page

dw_workplans.set_page(li_page + 1, ls_temp)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within u_treatment_followups
integer x = 2263
integer y = 116
integer width = 137
integer height = 116
integer taborder = 20
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;string ls_temp
integer li_page

li_page = dw_workplans.current_page

dw_workplans.set_page(li_page - 1, ls_temp)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type dw_workplans from u_dw_treatment_workplans within u_treatment_followups
integer y = 28
integer height = 876
integer taborder = 10
end type

