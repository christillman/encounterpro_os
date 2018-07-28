HA$PBExportHeader$w_svc_assessment_move.srw
forward
global type w_svc_assessment_move from w_svc_generic
end type
type pb_up from u_picture_button within w_svc_assessment_move
end type
type pb_down from u_picture_button within w_svc_assessment_move
end type
type pb_bottom from u_picture_button within w_svc_assessment_move
end type
type pb_top from u_picture_button within w_svc_assessment_move
end type
type dw_assessment_sort from u_dw_pick_list within w_svc_assessment_move
end type
end forward

global type w_svc_assessment_move from w_svc_generic
pb_up pb_up
pb_down pb_down
pb_bottom pb_bottom
pb_top pb_top
dw_assessment_sort dw_assessment_sort
end type
global w_svc_assessment_move w_svc_assessment_move

on w_svc_assessment_move.create
int iCurrent
call super::create
this.pb_up=create pb_up
this.pb_down=create pb_down
this.pb_bottom=create pb_bottom
this.pb_top=create pb_top
this.dw_assessment_sort=create dw_assessment_sort
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_up
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.pb_bottom
this.Control[iCurrent+4]=this.pb_top
this.Control[iCurrent+5]=this.dw_assessment_sort
end on

on w_svc_assessment_move.destroy
call super::destroy
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.pb_bottom)
destroy(this.pb_top)
destroy(this.dw_assessment_sort)
end on

event open;call super::open;long ll_count
string ls_find
long ll_row
long ll_LastRowOnPage
long i
integer li_sts

dw_assessment_sort.settransobject(sqlca)

ll_count = dw_assessment_sort.retrieve(current_patient.cpr_id)

for i = 1 to ll_count
	dw_assessment_sort.object.sort_sequence[i] = i
next

li_sts = dw_assessment_sort.update()

if service.problem_id > 0 then
	ls_find = "problem_id=" + string(service.problem_id)
	ll_row = dw_assessment_sort.find(ls_find, 1, dw_assessment_sort.rowcount())
	if ll_row > 0 then
		dw_assessment_sort.object.selected_flag[ll_row] = 1
		
		ll_LastRowOnPage = long(dw_assessment_sort.Object.DataWindow.LastRowOnPage)
		if ll_row > ll_LastRowOnPage then
			dw_assessment_sort.scrolltorow(ll_row)
		end if
	end if
end if



end event

type pb_epro_help from w_svc_generic`pb_epro_help within w_svc_assessment_move
end type

type st_config_mode_menu from w_svc_generic`st_config_mode_menu within w_svc_assessment_move
end type

type cb_finished from w_svc_generic`cb_finished within w_svc_assessment_move
end type

type cb_be_back from w_svc_generic`cb_be_back within w_svc_assessment_move
end type

type cb_cancel from w_svc_generic`cb_cancel within w_svc_assessment_move
end type

type st_title from w_svc_generic`st_title within w_svc_assessment_move
integer width = 2638
string text = "Assessment Sort Order"
end type

type pb_up from u_picture_button within w_svc_assessment_move
integer x = 2606
integer y = 576
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "buttonup.bmp"
string disabledname = "buttonupx.bmp"
end type

event clicked;long ll_row
integer li_temp
string ls_text

ll_row = dw_assessment_sort.get_selected_row()
if ll_row <= 1 then
	pb_top.enabled = false
	return
end if
pb_top.enabled = true
dw_assessment_sort.setredraw(false)

li_temp = dw_assessment_sort.object.sort_sequence[ll_row - 1]

dw_assessment_sort.object.sort_sequence[ll_row - 1] = dw_assessment_sort.object.sort_sequence[ll_row]

dw_assessment_sort.object.sort_sequence[ll_row] = li_temp

dw_assessment_sort.sort()

ll_row = dw_assessment_sort.get_selected_row()

dw_assessment_sort.scrolltorow(ll_row)

dw_assessment_sort.recalc_page(ls_text)

dw_assessment_sort.update()

dw_assessment_sort.setredraw(true)

pb_down.enabled = true
pb_bottom.enabled = true

if ll_row > 1 then
	pb_up.enabled = true
	pb_top.enabled = true
else
	pb_up.enabled = false
	pb_top.enabled = false
end if

end event

type pb_down from u_picture_button within w_svc_assessment_move
integer x = 2606
integer y = 808
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "buttondn.bmp"
string disabledname = "buttondnx.bmp"
end type

event clicked;call super::clicked;long ll_row
integer li_temp
string ls_text

ll_row = dw_assessment_sort.get_selected_row()
if ll_row <= 0 then return
if ll_row >= dw_assessment_sort.rowcount() then
	pb_bottom.enabled = false
	return
end if
pb_bottom.enabled = true
dw_assessment_sort.setredraw(false)

li_temp = dw_assessment_sort.object.sort_sequence[ll_row + 1]

dw_assessment_sort.object.sort_sequence[ll_row + 1] = dw_assessment_sort.object.sort_sequence[ll_row]

dw_assessment_sort.object.sort_sequence[ll_row] = li_temp

dw_assessment_sort.sort()

ll_row = dw_assessment_sort.get_selected_row()

dw_assessment_sort.scrolltorow(ll_row)

dw_assessment_sort.recalc_page(ls_text)

dw_assessment_sort.update()

dw_assessment_sort.setredraw(true)

pb_up.enabled = true
pb_top.enabled = true

if ll_row < dw_assessment_sort.rowcount() then
	pb_down.enabled = true
	pb_bottom.enabled = true
else
	pb_down.enabled = false
	pb_bottom.enabled = false
end if

end event

type pb_bottom from u_picture_button within w_svc_assessment_move
integer x = 2606
integer y = 1040
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "buttonlast.bmp"
string disabledname = "buttonlastx.bmp"
end type

event clicked;call super::clicked;long ll_row,ll_rowcount
integer li_temp
string ls_text

ll_row = dw_assessment_sort.get_selected_row()
if ll_row <= 0 then return
ll_rowcount = dw_assessment_sort.rowcount()
if ll_row >= ll_rowcount then return

dw_assessment_sort.setredraw(false)

li_temp = dw_assessment_sort.object.sort_sequence[ll_rowcount]

dw_assessment_sort.object.sort_sequence[ll_row] = dw_assessment_sort.object.sort_sequence[ll_rowcount] + 1

dw_assessment_sort.sort()

ll_row = dw_assessment_sort.get_selected_row()

dw_assessment_sort.scrolltorow(ll_row)

dw_assessment_sort.recalc_page(ls_text)

dw_assessment_sort.update()

dw_assessment_sort.setredraw(true)

pb_up.enabled = true
pb_down.enabled = false
pb_top.enabled = true
enabled = false
end event

type pb_top from u_picture_button within w_svc_assessment_move
integer x = 2606
integer y = 340
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "buttontop.bmp"
string disabledname = "buttontopx.bmp"
end type

event clicked;long ll_row,ll_rowcount
integer li_temp
string ls_text
integer li_sts

ll_row = dw_assessment_sort.get_selected_row()
if ll_row <= 1 then return

dw_assessment_sort.setredraw(false)

dw_assessment_sort.object.sort_sequence[ll_row] = dw_assessment_sort.object.sort_sequence[1]
dw_assessment_sort.object.sort_sequence[1] = dw_assessment_sort.object.sort_sequence[1] + 1

dw_assessment_sort.sort()

ll_row = dw_assessment_sort.get_selected_row()

dw_assessment_sort.scrolltorow(ll_row)

dw_assessment_sort.recalc_page(ls_text)

li_sts = dw_assessment_sort.update()

dw_assessment_sort.setredraw(true)

pb_up.enabled = false
pb_down.enabled = true
pb_bottom.enabled = true
enabled = false
end event

type dw_assessment_sort from u_dw_pick_list within w_svc_assessment_move
integer x = 114
integer y = 124
integer width = 2469
integer height = 1444
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_assessment_move"
boolean vscrollbar = true
end type

