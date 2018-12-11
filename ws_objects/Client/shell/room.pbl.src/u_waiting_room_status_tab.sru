$PBExportHeader$u_waiting_room_status_tab.sru
forward
global type u_waiting_room_status_tab from u_main_tabpage_base
end type
type st_empty from statictext within u_waiting_room_status_tab
end type
type uo_waiting_rooms from u_waiting_room_status within u_waiting_room_status_tab
end type
end forward

global type u_waiting_room_status_tab from u_main_tabpage_base
integer width = 2162
integer height = 1704
long backcolor = 33538240
long tabtextcolor = 33554432
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
st_empty st_empty
uo_waiting_rooms uo_waiting_rooms
end type
global u_waiting_room_status_tab u_waiting_room_status_tab

type variables
string rooms[]
integer room_count
end variables

forward prototypes
public subroutine refresh_tab ()
public subroutine initialize ()
public subroutine refresh ()
end prototypes

public subroutine refresh_tab ();refresh()

end subroutine

public subroutine initialize ();string ls_room_type
string ls_room_name
string ls_room_id
boolean lb_loop
 
 DECLARE lsp_get_rooms_in_type PROCEDURE FOR dbo.sp_get_rooms_in_type  
         @ps_room_type = :ls_room_type  ;


uo_waiting_rooms.initialize()

ls_room_type = "WAITING"
room_count = 0
lb_loop = true

EXECUTE lsp_get_rooms_in_type;
if not tf_check() then return

DO
	FETCH lsp_get_rooms_in_type INTO
		:ls_room_id,
		:ls_room_name;
	if not tf_check() then return
	
	if sqlca.sqlcode = 0 then
		room_count += 1
		rooms[room_count] = ls_room_id
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop


CLOSE lsp_get_rooms_in_type;

refresh_tab()

end subroutine

public subroutine refresh ();integer li_waiting_count

f_set_background_color(this)

uo_waiting_rooms.object.datawindow.color = color_background

if not visible then return

uo_waiting_rooms.width = width
uo_waiting_rooms.height = height
uo_waiting_rooms.refresh()

li_waiting_count = uo_waiting_rooms.rowcount()

if li_waiting_count = 0 then
	uo_waiting_rooms.visible = false
	st_empty.visible = true
	if text <> "Waiting" then text = "Waiting"
	if tabtextcolor <> color_black then tabtextcolor = color_black
else
	uo_waiting_rooms.visible = true
	st_empty.visible = false
	if text <> "Waiting " + string(li_waiting_count) then text = "Waiting " + string(li_waiting_count)
	if tabtextcolor <> color_text_error then tabtextcolor = color_text_error
end if

end subroutine

on u_waiting_room_status_tab.create
this.st_empty=create st_empty
this.uo_waiting_rooms=create uo_waiting_rooms
this.Control[]={this.st_empty,&
this.uo_waiting_rooms}
end on

on u_waiting_room_status_tab.destroy
destroy(this.st_empty)
destroy(this.uo_waiting_rooms)
end on

type st_empty from statictext within u_waiting_room_status_tab
boolean visible = false
integer x = 274
integer y = 40
integer width = 1874
integer height = 240
integer textsize = -36
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Empty"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_waiting_rooms from u_waiting_room_status within u_waiting_room_status_tab
integer width = 2162
boolean bringtotop = true
boolean border = false
end type

