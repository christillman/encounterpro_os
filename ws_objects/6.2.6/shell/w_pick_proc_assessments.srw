HA$PBExportHeader$w_pick_proc_assessments.srw
forward
global type w_pick_proc_assessments from w_window_base
end type
type pb_done from u_picture_button within w_pick_proc_assessments
end type
type pb_cancel from u_picture_button within w_pick_proc_assessments
end type
type dw_proc_assessments from u_dw_pick_list within w_pick_proc_assessments
end type
type st_title from statictext within w_pick_proc_assessments
end type
end forward

global type w_pick_proc_assessments from w_window_base
int X=0
int Y=0
int Width=1490
int Height=1200
WindowType WindowType=response!
boolean TitleBar=false
long BackColor=33538240
boolean ControlMenu=false
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
pb_done pb_done
pb_cancel pb_cancel
dw_proc_assessments dw_proc_assessments
st_title st_title
end type
global w_pick_proc_assessments w_pick_proc_assessments

type variables
string cpr_id
long encounter_id
long encounter_charge_id

end variables

forward prototypes
public function integer load_assessments ()
end prototypes

public function integer load_assessments ();long ll_rowcount
long i
string ls_bill_flag
long ll_problem_id

dw_proc_assessments.retrieve(cpr_id, encounter_id)

ll_rowcount = dw_proc_assessments.rowcount()
for i = 1 to ll_rowcount
	ll_problem_id = dw_proc_assessments.object.problem_id[i]
	
	SELECT bill_flag
	INTO :ls_bill_Flag
	FROM p_Encounter_Assessment_Charge
	WHERE cpr_id = :cpr_id
	AND encounter_id = :encounter_id
	AND problem_id = :ll_problem_id
	AND encounter_charge_id = :encounter_charge_id;
	if not tf_check() then return -1
	
	if sqlca.sqlcode = 100 then
		setnull(ls_bill_flag)
	end if

	dw_proc_assessments.setitem(i, "treatment_bill_flag", ls_bill_flag)

	if ls_bill_flag = "Y" then
		dw_proc_assessments.setitem(i, "selected_flag", 1)
	else
		dw_proc_assessments.setitem(i, "selected_flag", 0)
	end if
next

return 1



end function

on w_pick_proc_assessments.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.dw_proc_assessments=create dw_proc_assessments
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.dw_proc_assessments
this.Control[iCurrent+4]=this.st_title
end on

on w_pick_proc_assessments.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.dw_proc_assessments)
destroy(this.st_title)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts


popup = message.powerobjectparm
st_title.text = popup.title

if popup.data_row_count <> 3 then
	setnull(popup_return.item)
	closewithreturn(this, popup_return)
	return
end if

dw_proc_assessments.settransobject(sqlca)

cpr_id = popup.items[1]
encounter_id = long(popup.items[2])
encounter_charge_id = long(popup.items[3])

li_sts = load_assessments()

if li_sts <= 0 then
	setnull(popup_return.item)
	closewithreturn(this, popup_return)
	return
end if

end event

type pb_done from u_picture_button within w_pick_proc_assessments
int X=1198
int Y=936
int TabOrder=10
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;long ll_rowcount
long i
string ls_bill_flag
integer li_selected_flag
long ll_problem_id
str_popup_return popup_return
boolean lb_changed
boolean lb_any

 DECLARE lsp_set_assmnt_charge_billing PROCEDURE FOR dbo.sp_set_assmnt_charge_billing  
         @ps_cpr_id = :cpr_id,   
         @pl_encounter_id = :encounter_id,   
         @pl_problem_id = :ll_problem_id,   
         @pl_encounter_charge_id = :encounter_charge_id,   
         @ps_bill_flag = :ls_bill_flag,
			@ps_created_by = :current_scribe.user_id;

 DECLARE lsp_set_charge_billing PROCEDURE FOR dbo.sp_set_charge_billing  
         @ps_cpr_id = :cpr_id,   
         @pl_encounter_id = :encounter_id,   
         @pl_encounter_charge_id = :encounter_charge_id,   
         @ps_bill_flag = :ls_bill_flag,
			@ps_created_by = :current_scribe.user_id;

lb_changed = false
lb_any = false

ll_rowcount = dw_proc_assessments.rowcount()
for i = 1 to ll_rowcount
	ls_bill_flag = dw_proc_assessments.object.treatment_bill_flag[i]
	li_selected_flag = dw_proc_assessments.object.selected_flag[i]
	ll_problem_id = dw_proc_assessments.object.problem_id[i]

	if isnull(ls_bill_flag) and li_selected_flag = 1 &
	 or ls_bill_flag = "Y" and li_selected_flag = 0 &
	 or ls_bill_flag = "N" and li_selected_flag = 1 then lb_changed = true

	if li_selected_flag = 1 then
		lb_any = true
		ls_bill_flag = "Y"
	else
		ls_bill_flag = "N"
	end if
	
	EXECUTE lsp_set_assmnt_charge_billing;
	if not tf_check() then return
next

if lb_any then
	ls_bill_flag = "Y"
else
	ls_bill_flag = "N"
end if

EXECUTE lsp_set_charge_billing;
if not tf_check() then return

if lb_changed then
	popup_return.item = "CHANGED"
	popup_return.items[1] = "CHANGED"
	popup_return.item_count = 1
else
	setnull(popup_return.item)
	popup_return.item_count = 0
end if

closewithreturn(parent, popup_return)


end event

type pb_cancel from u_picture_button within w_pick_proc_assessments
int X=41
int Y=936
int TabOrder=20
boolean BringToTop=true
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type dw_proc_assessments from u_dw_pick_list within w_pick_proc_assessments
int X=110
int Y=212
int Width=1353
int Height=672
string DataObject="dw_pick_proc_assessments"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
boolean VScrollBar=true
end type

event constructor;call super::constructor;multiselect = true

end event

type st_title from statictext within w_pick_proc_assessments
int X=14
int Y=12
int Width=1463
int Height=180
boolean Enabled=false
boolean BringToTop=true
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=33538240
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

