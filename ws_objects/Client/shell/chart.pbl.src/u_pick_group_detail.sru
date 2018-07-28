$PBExportHeader$u_pick_group_detail.sru
forward
global type u_pick_group_detail from datawindow
end type
end forward

global type u_pick_group_detail from datawindow
int Width=1207
int Height=1160
int TabOrder=1
string DragIcon="Rectangle!"
string DataObject="dw_pick_proc"
boolean LiveScroll=true
event category_selected pbm_custom01
event detail_selected pbm_custom02
event back_to_category pbm_custom03
end type
global u_pick_group_detail u_pick_group_detail

type variables
boolean detail_list
boolean group_present
integer detail_height
integer lastrow
end variables

forward prototypes
public subroutine show_category ()
public subroutine show_detail (string ps_category)
public subroutine load (string ps_arg)
public subroutine load ()
public subroutine clear_selected ()
end prototypes

public subroutine show_category ();integer li_header

if group_present then
	detail_height = integer(describe("datawindow.detail.height"))
	modify("datawindow.detail.height=0")
	//dwmodify("#4.visible=0")
	setfilter("")
	filter()
	sort()
	groupcalc()
	detail_list = false
else
	detail_list = true
end if
end subroutine

public subroutine show_detail (string ps_category);string ls_filter

if group_present then
	modify("datawindow.detail.height=" + string(detail_height))
	//modify("#4.visible=1")
	ls_filter = "#1=~"" + ps_category + "~""
	setfilter(ls_filter)
	filter()
	sort()
	groupcalc()
	detail_list = true
end if

end subroutine

public subroutine load (string ps_arg);integer li_header

setredraw(false)

settransobject(sqlca)
retrieve(ps_arg)

li_header = integer(describe("datawindow.header.1.height"))
if li_header > 0 then
	group_present = true
	show_category()
else
	group_present = false
end if

setredraw(true)

end subroutine

public subroutine load ();integer li_header

setredraw(false)

settransobject(sqlca)
retrieve()

li_header = integer(describe("datawindow.header.1.height"))
if li_header > 0 then
	group_present = true
	show_category()
else
	group_present = false
end if

setredraw(true)

end subroutine

public subroutine clear_selected ();long ll_row, ll_end
integer li_selected_flag
string ls_column, ls_find

ls_column = describe("selected_flag.name")
if ls_column = "selected_flag" then
	ll_end = rowcount()
	ls_find = "selected_flag=1"
	ll_row = Find(ls_find, 1, ll_end)
	DO WHILE ll_row > 0
		setitem(ll_row, "selected_flag", 0)
		ll_row++
		IF ll_row > ll_end THEN EXIT 
		ll_row = Find(ls_find, ll_row, ll_end)
	LOOP
end if

end subroutine

event clicked;string ls_temp, ls_band
integer li_pos, li_selected_flag, i
string ls_category, ls_filter

lastrow = row
if (detail_list or not group_present) and lastrow > 0 then
	clear_selected()
	li_selected_flag = object.selected_flag[lastrow]
	setitem(lastrow, "selected_flag", 1 - li_selected_flag)
	postevent("detail_selected")
	return
end if

if not group_present then return

ls_temp = GetBandAtPointer()
li_pos = pos(ls_temp,"~t")
ls_band = left(ls_temp, li_pos - 1)
lastrow = integer(mid(ls_temp,li_pos, 4))

if lastrow <= 0 then return

setredraw(false)

if detail_list then
	if ls_band = "header.1" then
		show_category()
		postevent("back_to_category")
	end if
else
	ls_category = object.data[lastrow, 1]
	show_detail(ls_category)
	postevent("category_selected")
end if

setredraw(true)

end event

