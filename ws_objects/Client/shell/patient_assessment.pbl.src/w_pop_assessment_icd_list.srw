$PBExportHeader$w_pop_assessment_icd_list.srw
forward
global type w_pop_assessment_icd_list from w_window_base
end type
type pb_cancel from u_picture_button within w_pop_assessment_icd_list
end type
type pb_ok from u_picture_button within w_pop_assessment_icd_list
end type
type dw_chapter from u_dw_pick_list within w_pop_assessment_icd_list
end type
type dw_block from u_dw_pick_list within w_pop_assessment_icd_list
end type
type dw_level_3 from u_dw_pick_list within w_pop_assessment_icd_list
end type
end forward

global type w_pop_assessment_icd_list from w_window_base
integer x = 434
integer y = 604
integer width = 3973
integer height = 2040
windowtype windowtype = response!
boolean center = true
pb_cancel pb_cancel
pb_ok pb_ok
dw_chapter dw_chapter
dw_block dw_block
dw_level_3 dw_level_3
end type
global w_pop_assessment_icd_list w_pop_assessment_icd_list

type variables
string which_code
end variables

event open;call super::open;

dw_chapter.settransobject(sqlca)
dw_block.settransobject(sqlca)
dw_level_3.settransobject(sqlca)

dw_chapter.retrieve()
dw_chapter.setfocus()


end event

on w_pop_assessment_icd_list.create
int iCurrent
call super::create
this.pb_cancel=create pb_cancel
this.pb_ok=create pb_ok
this.dw_chapter=create dw_chapter
this.dw_block=create dw_block
this.dw_level_3=create dw_level_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_cancel
this.Control[iCurrent+2]=this.pb_ok
this.Control[iCurrent+3]=this.dw_chapter
this.Control[iCurrent+4]=this.dw_block
this.Control[iCurrent+5]=this.dw_level_3
end on

on w_pop_assessment_icd_list.destroy
call super::destroy
destroy(this.pb_cancel)
destroy(this.pb_ok)
destroy(this.dw_chapter)
destroy(this.dw_block)
destroy(this.dw_level_3)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_assessment_icd_list
boolean visible = true
integer x = 1691
integer y = 1772
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_assessment_icd_list
end type

type pb_cancel from u_picture_button within w_pop_assessment_icd_list
integer x = 119
integer y = 1696
integer width = 256
integer height = 224
integer taborder = 20
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_ok from u_picture_button within w_pop_assessment_icd_list
integer x = 3374
integer y = 1696
integer taborder = 10
boolean default = true
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "button26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

string ls_icd_code

// if using icd_10_who
	//ls_icd_code = dw_level_3.Object.icd10_who_code[dw_level_3.lastrow]
// else
	ls_icd_code = dw_level_3.Object.icd10_code[dw_level_3.lastrow]
// end if

if ls_icd_code = "" then
	setnull(popup_return.item)
	popup_return.item_count = 0
else
	popup_return.items[1] = ls_icd_code + '%'
	popup_return.descriptions[1] = ls_icd_code
	popup_return.item_count = 1
end if

closewithreturn(parent, popup_return)

end event

type dw_chapter from u_dw_pick_list within w_pop_assessment_icd_list
integer x = 128
integer y = 52
integer width = 795
integer height = 1636
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_icd_chapter"
boolean vscrollbar = true
end type

event clicked;call super::clicked;
string ls_chapter 

ls_chapter = Object.chapter[lastrow]

dw_block.retrieve(ls_chapter)



end event

type dw_block from u_dw_pick_list within w_pop_assessment_icd_list
integer x = 960
integer y = 52
integer width = 1307
integer height = 1636
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_icd_block_descr"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;
string ls_range 

ls_range = Object.range[lastrow]

dw_level_3.retrieve(ls_range)

if dw_level_3.rowcount() = 1 then 
	dw_level_3.set_row(1)
end if
end event

type dw_level_3 from u_dw_pick_list within w_pop_assessment_icd_list
integer x = 2304
integer y = 52
integer width = 1518
integer height = 1640
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_icd_level_3"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;
pb_ok.event clicked ()

end event

