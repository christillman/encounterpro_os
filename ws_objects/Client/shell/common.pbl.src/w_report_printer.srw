$PBExportHeader$w_report_printer.srw
forward
global type w_report_printer from w_window_base
end type
type dw_printers from u_dw_pick_list within w_report_printer
end type
type cb_finished from commandbutton within w_report_printer
end type
type st_title from statictext within w_report_printer
end type
type st_2 from statictext within w_report_printer
end type
type cb_move from commandbutton within w_report_printer
end type
type cb_delete from commandbutton within w_report_printer
end type
type cb_insert from commandbutton within w_report_printer
end type
end forward

global type w_report_printer from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_printers dw_printers
cb_finished cb_finished
st_title st_title
st_2 st_2
cb_move cb_move
cb_delete cb_delete
cb_insert cb_insert
end type
global w_report_printer w_report_printer

type variables
string report_id

end variables

forward prototypes
public function integer save_changes ()
public function integer new_printer_selection (long pl_row)
public function integer refresh ()
end prototypes

public function integer save_changes ();long i
long ll_report_printer_sequence
string ls_office_id
long ll_computer_id
string ls_room_id
long ll_sort_sequence
string ls_printer

for i = 1 to dw_printers.rowcount()
	ll_report_printer_sequence = dw_printers.object.report_printer_sequence[i]
	ls_office_id = dw_printers.object.office_id[i]
	ll_computer_id = dw_printers.object.computer_id[i]
	ls_room_id = dw_printers.object.room_id[i]
	ll_sort_sequence = dw_printers.object.sort_sequence[i]
	ls_printer = dw_printers.object.printer[i]
	
	UPDATE o_Report_Printer
	SET office_id = :ls_office_id,
		computer_id = :ll_computer_id,
		room_id = :ls_room_id,
		printer = :ls_printer,
		sort_sequence = :ll_sort_sequence
	WHERE report_id = :report_id
	AND report_printer_sequence = :ll_report_printer_sequence;
	if not tf_check() then return -1
next

return 1

end function

public function integer new_printer_selection (long pl_row);string ls_column
str_popup popup
str_popup_return popup_return
long ll_computer_id
string ls_computername
string ls_logon_id
string ls_office_id
string ls_room_id
string ls_printer
long ll_sort_sequence
long i
integer li_sts


popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<All>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "" then setnull(popup_return.items[1])
ls_office_id = popup_return.items[1]

popup.dataobject = "dw_room_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<All>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0 

if popup_return.items[1] = "" then setnull(popup_return.items[1])
ls_room_id = popup_return.items[1]


popup.dataobject = "dw_computer_pick_list_all"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<All>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "" then
	setnull(ll_computer_id)
	setnull(ls_computername)
	setnull(ls_logon_id)
else
	ll_computer_id = long(popup_return.items[1])

	SELECT computername, logon_id
	INTO :ls_computername, :ls_logon_id
	FROM o_computers
	WHERE computer_id = :ll_computer_id;
	if not tf_check() then return 0
	if sqlca.sqlcode = 100 then
		setnull(ll_computer_id)
		setnull(ls_computername)
		setnull(ls_logon_id)
	end if
end if

popup.dataobject = "dw_select_printer"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.add_blank_row = false
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_printer = popup_return.items[1]

for i = 1 to dw_printers.rowcount()
	dw_printers.object.sort_sequence[i] = i
next

li_sts = save_changes()
if li_sts < 0 then return -1

ll_sort_sequence = dw_printers.rowcount() + 1

INSERT INTO o_Report_Printer (
	report_id,
	office_id,
	computer_id,
	room_id,
	printer,
	sort_sequence)
VALUES (
	:report_id,
	:ls_office_id,
	:ll_computer_id,
	:ls_room_id,
	:ls_printer,
	:ll_sort_sequence);
if not tf_check() then return -1	

refresh()

return 1


end function

public function integer refresh ();long ll_rows

ll_rows = dw_printers.retrieve(report_id)
if ll_rows < 0 then return -1

return 1

end function

on w_report_printer.create
int iCurrent
call super::create
this.dw_printers=create dw_printers
this.cb_finished=create cb_finished
this.st_title=create st_title
this.st_2=create st_2
this.cb_move=create cb_move
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_printers
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_move
this.Control[iCurrent+6]=this.cb_delete
this.Control[iCurrent+7]=this.cb_insert
end on

on w_report_printer.destroy
call super::destroy
destroy(this.dw_printers)
destroy(this.cb_finished)
destroy(this.st_title)
destroy(this.st_2)
destroy(this.cb_move)
destroy(this.cb_delete)
destroy(this.cb_insert)
end on

event open;call super::open;long ll_office_width

report_id = message.stringparm

SELECT description
INTO :st_title.text
FROM c_Report_Definition
WHERE report_id = :report_id;
if not tf_check() then
	close(this)
	return
end if
if sqlca.sqlcode = 100 then
	log.log(this, "w_report_printer.open.0014", "Report not found (" + report_id + ")", 4)
	close(this)
	return
end if

ll_office_width = 649 + ((dw_printers.width - 2945) / 5)

dw_printers.modify("office.width=" + string(ll_office_width))

dw_printers.settransobject(sqlca)

refresh()



end event

type pb_epro_help from w_window_base`pb_epro_help within w_report_printer
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_report_printer
end type

type dw_printers from u_dw_pick_list within w_report_printer
integer y = 276
integer width = 2917
integer height = 1132
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_o_report_printer_edit"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;cb_delete.enabled = true
cb_move.enabled = true

end event

event unselected;call super::unselected;cb_delete.enabled = false
cb_move.enabled = false

end event

event clicked;call super::clicked;string ls_column
str_popup popup
str_popup_return popup_return
long ll_computer_id
string ls_computername
string ls_logon_id
string ls_office_id
string ls_printer

// make sure dwo is valid
if isnull(dwo) or not isvalid(dwo) then return
if row <= 0 or isnull(row) then return


ls_column = upper(dwo.name)

CHOOSE CASE ls_column
	CASE "OFFICE_ID", "OFFICE"
		popup.dataobject = "dw_office_pick"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.add_blank_row = true
		popup.blank_text = "<Any>"
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		if popup_return.items[1] = "" then setnull(popup_return.items[1])
		object.office_id[row] = popup_return.items[1]
		object.office_nickname[row] = popup_return.descriptions[1]
	CASE "ROOM_ID", "ROOM"
		ls_office_id = object.office_id[row]
		if isnull(ls_office_id) then
			popup.dataobject = "dw_room_list"
			popup.argument_count = 0
		else
			popup.dataobject = "dw_room_list_office"
			popup.argument_count = 1
			popup.argument[1] = ls_office_id
		end if
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.add_blank_row = true
		popup.blank_text = "<Any>"
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		if popup_return.items[1] = "" then setnull(popup_return.items[1])
		object.room_id[row] = popup_return.items[1]
		object.room_name[row] = popup_return.descriptions[1]
	CASE "COMPUTERNAME", "LOGON_ID", "T_BACKGROUND", "COMPUTER"
		ls_office_id = object.office_id[row]
		if isnull(ls_office_id) then
			popup.dataobject = "dw_computer_pick_list_all"
			popup.argument_count = 0
		else
			popup.dataobject = "dw_computer_pick_list"
			popup.argument_count = 1
			popup.argument[1] = ls_office_id
		end if
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.add_blank_row = true
		popup.blank_text = "<Any>"
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		if popup_return.items[1] = "" then
			setnull(ll_computer_id)
			setnull(ls_computername)
			setnull(ls_logon_id)
		else
			ll_computer_id = long(popup_return.items[1])
	
			SELECT computername, logon_id
			INTO :ls_computername, :ls_logon_id
			FROM o_computers
			WHERE computer_id = :ll_computer_id;
			if not tf_check() then return
			if sqlca.sqlcode = 100 then
				setnull(ll_computer_id)
				setnull(ls_computername)
				setnull(ls_logon_id)
			end if
		end if
		
		object.computer_id[row] = ll_computer_id
		object.computername[row] = ls_computername
		object.logon_id[row] = ls_logon_id
	CASE "PRINTER"
		ls_printer = common_thread.select_printer_server()
		if len(ls_printer) > 0 then
			object.printer[row] = ls_printer
		end if
END CHOOSE


end event

type cb_finished from commandbutton within w_report_printer
integer x = 2427
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;integer li_sts

li_sts = save_changes()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error saving changes")
	return
end if

close(parent)


end event

type st_title from statictext within w_report_printer
integer width = 2921
integer height = 140
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Report"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_report_printer
integer x = 1115
integer y = 160
integer width = 686
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
string text = "Printer Selection"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_move from commandbutton within w_report_printer
integer x = 1920
integer y = 1448
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Move"
end type

event clicked;str_popup popup
long ll_row
integer li_sts
long ll_rowcount
long i

ll_row = dw_printers.get_selected_row()
if ll_row <= 0 then return 0

ll_rowcount = dw_printers.rowcount()
for i = 1 to ll_rowcount
	dw_printers.object.sort_sequence[ll_row] = i
next

popup.objectparm = dw_printers

openwithparm(w_pick_list_sort, popup)

return


end event

type cb_delete from commandbutton within w_report_printer
integer x = 1257
integer y = 1448
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete"
end type

event clicked;str_popup_return popup_return
long ll_row
long ll_rowcount
long ll_report_printer_sequence

ll_row = dw_printers.get_selected_row()
if ll_row <= 0 then return

openwithparm(w_pop_yes_no, "Are you sure you wish to delete this printer selection?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	ll_report_printer_sequence = dw_printers.object.report_printer_sequence[ll_row]
	DELETE o_Report_Printer
	WHERE report_id = :report_id
	AND report_printer_sequence = :ll_report_printer_sequence;
	if not tf_check() then return
	
	dw_printers.deleterow(ll_row)
end if


end event

type cb_insert from commandbutton within w_report_printer
integer x = 594
integer y = 1448
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insert"
end type

event clicked;long ll_row

ll_row = dw_printers.get_selected_row()
if ll_row <= 0 then setnull(ll_row)

new_printer_selection(ll_row)


end event

