HA$PBExportHeader$u_user_resizable.sru
forward
global type u_user_resizable from userobject
end type
end forward

global type u_user_resizable from userobject
integer width = 411
integer height = 432
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
end type
global u_user_resizable u_user_resizable

type variables
boolean zoom_dw_on_resize = false


end variables

forward prototypes
public subroutine resize_and_move_objects (real pr_x_factor, real pr_y_factor)
end prototypes

public subroutine resize_and_move_objects (real pr_x_factor, real pr_y_factor);long i
dragobject dobj
line ln
rectangle rect
datawindow dw
picturebutton pb
u_user_resizable rr

for i = 1 to upperbound(control)
	CHOOSE CASE control[i].typeof()
		CASE line!
			ln = control[i]
			ln.beginx *= pr_x_factor
			ln.beginy *= pr_y_factor
			ln.endx *= pr_x_factor
			ln.endy *= pr_y_factor
		CASE rectangle!
			rect = control[i]
			rect.x *= pr_x_factor
			rect.y *= pr_y_factor
			rect.width *= pr_x_factor
			rect.height *= pr_y_factor
		CASE datawindow! // datawindows can get zoomed
			dw = control[i]
			dw.x *= pr_x_factor
			dw.y *= pr_y_factor
			dw.width *= pr_x_factor
			dw.height *= pr_y_factor
			// Do the zoom
			if zoom_dw_on_resize then
				dw.Object.DataWindow.zoom = string(int(pr_x_factor*100)) 
			end if
		CASE picturebutton!
			pb = control[i]
			pb.x *= pr_x_factor
			pb.y *= pr_y_factor
			pb.width *= pr_x_factor
			pb.height *= pr_y_factor
			pb.originalsize = false
		CASE userobject!
			if 1 = 2 then
				rr = control[i]
				rr.x *= pr_x_factor
				rr.y *= pr_y_factor
				rr.width *= pr_x_factor
				rr.height *= pr_y_factor
				rr.resize_and_move_objects(pr_x_factor, pr_y_factor)
			else
				dobj = control[i]
				dobj.x *= pr_x_factor
				dobj.y *= pr_y_factor
				dobj.width *= pr_x_factor
				dobj.height *= pr_y_factor
			end if
		CASE ELSE
			dobj = control[i]
			dobj.x *= pr_x_factor
			dobj.y *= pr_y_factor
			dobj.width *= pr_x_factor
			dobj.height *= pr_y_factor
	END CHOOSE
next

end subroutine

on u_user_resizable.create
end on

on u_user_resizable.destroy
end on

