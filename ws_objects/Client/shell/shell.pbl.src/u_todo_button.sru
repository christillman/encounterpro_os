$PBExportHeader$u_todo_button.sru
forward
global type u_todo_button from commandbutton
end type
end forward

global type u_todo_button from commandbutton
int Width=554
int Height=109
int TabOrder=1
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type
global u_todo_button u_todo_button

type variables

end variables

forward prototypes
public subroutine refresh ()
end prototypes

public subroutine refresh ();integer li_todo_count

if isnull(current_user) then
	visible = false
	return
end if

SELECT count(*)
INTO :li_todo_count
FROM u_Todo_List
WHERE user_id = :current_user.user_id
AND status = "READY";
if not tf_check() then
	visible = false
	return
end if

if li_todo_count > 0 then
	text = "To Do (" + string(li_todo_count) + ")"
	visible = true
else
	visible = false
end if

end subroutine

on clicked;str_popup popup

if isnull(current_patient) then return


end on

