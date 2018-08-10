$PBExportHeader$w_modmedrepair.srw
forward
global type w_modmedrepair from w_window_base
end type
type cb_repair from commandbutton within w_modmedrepair
end type
type dw_med_list from u_dw_pick_list within w_modmedrepair
end type
type st_1 from statictext within w_modmedrepair
end type
type st_2 from statictext within w_modmedrepair
end type
type st_3 from statictext within w_modmedrepair
end type
type st_4 from statictext within w_modmedrepair
end type
type st_mod_ok from statictext within w_modmedrepair
end type
type st_5 from statictext within w_modmedrepair
end type
end forward

global type w_modmedrepair from w_window_base
integer height = 1824
boolean resizable = false
event refresh ( )
event windowposchanging pbm_windowposchanging
cb_repair cb_repair
dw_med_list dw_med_list
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_mod_ok st_mod_ok
st_5 st_5
end type
global w_modmedrepair w_modmedrepair

type variables
boolean doing_service
datastore id_parms
boolean initializing = true

string ls_fix_sp = "~r~n&
CREATE  PROCEDURE [jmjfix_modified_med_list]~r~n&
AS~r~n&
~r~n&
DECLARE @modified TABLE (~r~n&
 cpr_id varchar(12) NOT NULL,~r~n&
 billing_id varchar(24) NULL,~r~n&
 original_treatment_id int NOT NULL,~r~n&
 modified_treatment_id int NOT NULL,~r~n&
 original_date datetime NOT NULL,~r~n&
 modified_date datetime NOT NULL,~r~n&
 original_treatment_description varchar(1024) NULL,~r~n&
 modified_treatment_description varchar(1024) NULL,~r~n&
 modified_description_count int NULL)~r~n&
~r~n&
INSERT INTO @modified (~r~n&
 cpr_id ,~r~n&
 original_treatment_id ,~r~n&
 modified_treatment_id ,~r~n&
 original_date,~r~n&
 modified_date )~r~n&
SELECT t1.cpr_id ,~r~n&
 t2.treatment_id ,~r~n&
 t1.treatment_id ,~r~n&
 t2.begin_date,~r~n&
 t1.begin_date~r~n&
FROM p_Treatment_Item t1 WITH (NOLOCK)~r~n&
 INNER JOIN p_Treatment_Item t2 WITH (NOLOCK)~r~n&
 ON t1.cpr_id = t2.cpr_id~r~n&
 AND t1.original_treatment_id = t2.treatment_id~r~n&
WHERE t1.treatment_type = 'MEDICATION'~r~n&
~r~n&
UPDATE x~r~n&
SET modified_treatment_description = COALESCE(p.progress_value, CAST(p.progress AS varchar(1024))),~r~n&
	modified_description_count = y.modified_description_count~r~n&
FROM @modified x~r~n&
	INNER JOIN (SELECT cpr_id,~r~n&
						treatment_id,~r~n&
						max(treatment_progress_sequence) as treatment_progress_sequence,~r~n&
						count(treatment_progress_sequence) as modified_description_count~r~n&
				FROM p_Treatment_Progress~r~n&
				WHERE progress_type = 'Modify'~r~n&
				AND progress_key = 'treatment_description'~r~n&
				AND current_flag = 'Y'~r~n&
				GROUP BY cpr_id, treatment_id) y~r~n&
	ON x.cpr_id = y.cpr_id~r~n&
	AND x.modified_treatment_id = y.treatment_id~r~n&
	INNER JOIN p_Treatment_Progress p~r~n&
	ON x.cpr_id = p.cpr_id~r~n&
	AND x.modified_treatment_id = p.treatment_id~r~n&
	AND y.treatment_progress_sequence = p.treatment_progress_sequence~r~n&
~r~n&
UPDATE x~r~n&
SET original_treatment_description = COALESCE(p.progress_value, CAST(p.progress AS varchar(1024)))~r~n&
FROM @modified x~r~n&
	INNER JOIN (SELECT cpr_id, treatment_id, max(treatment_progress_sequence) as treatment_progress_sequence~r~n&
				FROM p_Treatment_Progress~r~n&
				WHERE progress_type = 'Modify'~r~n&
				AND progress_key = 'treatment_description'~r~n&
				AND current_flag = 'Y'~r~n&
				GROUP BY cpr_id, treatment_id) y~r~n&
	ON x.cpr_id = y.cpr_id~r~n&
	AND x.original_treatment_id = y.treatment_id~r~n&
	INNER JOIN p_Treatment_Progress p~r~n&
	ON x.cpr_id = p.cpr_id~r~n&
	AND x.original_treatment_id = p.treatment_id~r~n&
	AND y.treatment_progress_sequence = p.treatment_progress_sequence~r~n&
~r~n&
SELECT cpr_id ,~r~n&
  COALESCE(billing_id, cpr_id) as billing_id ,~r~n&
  original_treatment_id ,~r~n&
  modified_treatment_id ,~r~n&
  original_date ,~r~n&
  modified_date ,~r~n&
  original_treatment_description~r~n&
FROM @modified~r~n&
WHERE original_treatment_description = modified_treatment_description~r~n&
AND modified_description_count = 1~r~n&
UNION~r~n&
SELECT i.cpr_id ,~r~n&
	COALESCE(pp.billing_id, i.cpr_id) as billing_id ,~r~n&
	i.treatment_id as original_treatment_id,~r~n&
	i.treatment_id as modified_treatment_id,~r~n&
	begin_date as original_date ,~r~n&
	begin_date as modified_date ,~r~n&
	treatment_description as original_treatment_description~r~n&
FROM p_Treatment_Item i WITH (NOLOCK)~r~n&
	INNER JOIN p_Patient pp~r~n&
	ON i.cpr_id = pp.cpr_id~r~n&
WHERE LEN(treatment_description) >= 78~r~n&
AND PATINDEX('%refill%', treatment_description) = 0~r~n&
AND refills > 0~r~n&
AND treatment_type = 'MEDICATION'~r~n&
AND NOT EXISTS (~r~n&
	SELECT 1~r~n&
	FROM p_Treatment_Progress p~r~n&
	WHERE i.cpr_id = p.cpr_id~r~n&
	AND i.treatment_id = p.treatment_id~r~n&
	AND p.progress_type = 'Modify'~r~n&
	AND p.progress_key = 'treatment_description')~r~n&
~r~n&
~r~n&
GO~r~n&
~r~n"

end variables

forward prototypes
public subroutine refresh_main ()
public subroutine doing_service ()
public subroutine not_doing_service ()
public function integer refresh ()
public subroutine set_window_state (string ps_window_state)
public subroutine save_window_state ()
public subroutine save_window_state (long pl_x, long pl_y, long pl_width, long pl_height)
end prototypes

event windowposchanging;if not initializing and newwidth > 0 and newheight > 0 then
	save_window_state(xpos, ypos, newwidth, newheight)
end if


end event

public subroutine refresh_main ();
title = office_description + "  Logged On:  "
if not isnull(current_user) then
	title += current_user.user_full_name
else
	title += "<None>"
end if

end subroutine

public subroutine doing_service ();doing_service = true

end subroutine

public subroutine not_doing_service ();doing_service = false

end subroutine

public function integer refresh ();long ll_count

title = office_description + "  Logged On:  "
if not isnull(current_user) then
	title += current_user.user_full_name
else
	title += "<None>"
end if



ll_count = dw_med_list.retrieve()

if ll_count > 0 then
	st_mod_ok.visible = false
	cb_repair.visible = true
else
	st_mod_ok.visible = true
	cb_repair.visible = false
end if


return 1

end function

public subroutine set_window_state (string ps_window_state);string lsa_state[]
integer li_count
long ll_x
long ll_y
long ll_width
long ll_height

li_count = f_parse_string(ps_window_state, ",", lsa_state)
if li_count < 5 then return

if lower(lsa_state[5]) = "maximized" then
	windowstate = maximized!
	return
end if

if not isnumber(lsa_state[1]) then return
if not isnumber(lsa_state[2]) then return
if not isnumber(lsa_state[3]) then return
if not isnumber(lsa_state[4]) then return

ll_x = long(lsa_state[1])
ll_y = long(lsa_state[2])
ll_width = long(lsa_state[3])
ll_height = long(lsa_state[4])

if ll_width <= 500 then return
if ll_height <= 500 then return

move(ll_x, ll_y)
resize(ll_width, ll_height)


end subroutine

public subroutine save_window_state ();
save_window_state(x, y, width, height)

end subroutine

public subroutine save_window_state (long pl_x, long pl_y, long pl_width, long pl_height);string ls_window_state

ls_window_state = string(pl_x)
ls_window_state += "," + string(pl_y)
ls_window_state += "," + string(pl_width)
ls_window_state += "," + string(pl_height)
ls_window_state += ","

CHOOSE CASE windowstate
	CASE normal!
		ls_window_state += "normal"
	CASE maximized!
		ls_window_state += "maximized"
	CASE ELSE
		ls_window_state += "normal"
END CHOOSE

datalist.update_preference("SYSTEM", "Computer", string(computer_id), "window_state", ls_window_state)

end subroutine

on w_modmedrepair.create
int iCurrent
call super::create
this.cb_repair=create cb_repair
this.dw_med_list=create dw_med_list
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_mod_ok=create st_mod_ok
this.st_5=create st_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_repair
this.Control[iCurrent+2]=this.dw_med_list
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.st_mod_ok
this.Control[iCurrent+8]=this.st_5
end on

on w_modmedrepair.destroy
call super::destroy
destroy(this.cb_repair)
destroy(this.dw_med_list)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_mod_ok)
destroy(this.st_5)
end on

event close;
if isvalid(w_image_objects) then close(w_image_objects)

If not isnull(current_user) Then
	current_user.logoff(true)
End If

end event

event resize;call super::resize;


pb_epro_help.x = newwidth - 275


end event

event open;integer li_count
integer li_sts

li_sts = f_initialize_objects()
if li_sts < 0 then
	openwithparm(w_pop_message, "Error initializing objects")
	close(this)
	return
end if


SELECT count(*)
INTO :li_count
FROM sysobjects
WHERE type = 'P'
AND name = 'jmjfix_modified_med_list';
if not tf_check() then
	close(this)
	return
end if

if li_count = 0 then
	li_sts = sqlca.execute_string(ls_fix_sp)
	if li_sts <= 0 then
		close(this)
		return
	end if
end if

dw_med_list.settransobject(sqlca)

refresh()


end event

type pb_epro_help from w_window_base`pb_epro_help within w_modmedrepair
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_modmedrepair
end type

type cb_repair from commandbutton within w_modmedrepair
integer x = 1120
integer y = 1536
integer width = 562
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Repair Medications"
end type

event clicked;str_treatment_description lstr_treatment
long ll_count
long i
string ls_cpr_id
long ll_treatment_id
integer li_sts
string ls_description
long ll_null
integer li_index
str_popup_return popup_return

setnull(ll_null)

openwithparm(w_pop_yes_no, "Are you sure you wish to repair the treatments listed?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

ll_count = dw_med_list.rowcount()


li_index = f_please_wait_open()

f_please_wait_progress_bar(li_index, 0, ll_count)

for i = 1 to ll_count
	ls_cpr_id = dw_med_list.object.cpr_id[i]
	ll_treatment_id = dw_med_list.object.modified_treatment_id[i]
	
	li_sts = f_get_treatment_structure(ls_cpr_id, ll_treatment_id, lstr_treatment)
	if li_sts <= 0 then
		openwithparm(w_pop_message, "Error Repairing Treatment")
		return
	end if
	
	ls_description = drugdb.treatment_drug_sig(lstr_treatment)
	if len(ls_description) > 0 then
		li_sts = f_set_progress(ls_cpr_id, &
										"Treatment", &
										ll_treatment_id, &
										"Modify", &
										"treatment_description", &
										ls_description, &
										datetime(today(), now()), &
										ll_null, &
										ll_null, &
										ll_null)
	end if
	
	f_please_wait_progress_bump(li_index)
	
next

f_please_wait_close(li_index)

refresh()


end event

type dw_med_list from u_dw_pick_list within w_modmedrepair
integer x = 87
integer y = 228
integer width = 2743
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_jmjfix_modified_med_list"
boolean vscrollbar = true
end type

type st_1 from statictext within w_modmedrepair
integer width = 2921
integer height = 108
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Modified Medication Repair Utility"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_modmedrepair
integer x = 457
integer y = 156
integer width = 229
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Original"
boolean focusrectangle = false
end type

type st_3 from statictext within w_modmedrepair
integer x = 768
integer y = 156
integer width = 233
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Modified"
boolean focusrectangle = false
end type

type st_4 from statictext within w_modmedrepair
integer x = 1074
integer y = 156
integer width = 677
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Medication Description"
boolean focusrectangle = false
end type

type st_mod_ok from statictext within w_modmedrepair
boolean visible = false
integer x = 462
integer y = 752
integer width = 2071
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "All modified treatments appear OK"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_modmedrepair
integer x = 114
integer y = 156
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Patient ID"
boolean focusrectangle = false
end type

