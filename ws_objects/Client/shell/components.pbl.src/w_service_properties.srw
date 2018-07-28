$PBExportHeader$w_service_properties.srw
forward
global type w_service_properties from w_window_base
end type
type cb_ok from commandbutton within w_service_properties
end type
type dw_service_history from u_dw_pick_list within w_service_properties
end type
type st_status from statictext within w_service_properties
end type
type st_status_title from statictext within w_service_properties
end type
type st_dispatch_date from statictext within w_service_properties
end type
type st_created_by_title from statictext within w_service_properties
end type
type st_created from statictext within w_service_properties
end type
type st_created_title from statictext within w_service_properties
end type
type st_title from statictext within w_service_properties
end type
type st_created_by from statictext within w_service_properties
end type
type st_storage_flag_title from statictext within w_service_properties
end type
type st_service from statictext within w_service_properties
end type
type st_extension_title from statictext within w_service_properties
end type
type st_description from statictext within w_service_properties
end type
type st_attachment_type_title from statictext within w_service_properties
end type
type st_owned_by from statictext within w_service_properties
end type
type st_attached_by_title from statictext within w_service_properties
end type
type st_completed_by from statictext within w_service_properties
end type
type st_attachment_date_title from statictext within w_service_properties
end type
type st_ordered_for from statictext within w_service_properties
end type
type st_attachment_folder_title from statictext within w_service_properties
end type
type st_end_date from statictext within w_service_properties
end type
type st_3 from statictext within w_service_properties
end type
type st_begin_date from statictext within w_service_properties
end type
type st_5 from statictext within w_service_properties
end type
type st_ordered_by from statictext within w_service_properties
end type
type st_7 from statictext within w_service_properties
end type
type dw_service_attributes from u_dw_pick_list within w_service_properties
end type
type st_flags_background from statictext within w_service_properties
end type
type st_flags_title from statictext within w_service_properties
end type
type st_in_office_flag_title from statictext within w_service_properties
end type
type st_4 from statictext within w_service_properties
end type
type st_6 from statictext within w_service_properties
end type
type st_8 from statictext within w_service_properties
end type
type st_10 from statictext within w_service_properties
end type
type st_11 from statictext within w_service_properties
end type
type st_12 from statictext within w_service_properties
end type
type st_in_office_flag from statictext within w_service_properties
end type
type st_step_flag from statictext within w_service_properties
end type
type st_auto_perform_flag from statictext within w_service_properties
end type
type st_cancel_workplan_flag from statictext within w_service_properties
end type
type st_consolidate_flag from statictext within w_service_properties
end type
type st_owner_flag from statictext within w_service_properties
end type
type st_priority from statictext within w_service_properties
end type
type st_context_object_title from statictext within w_service_properties
end type
type st_object_description_title from statictext within w_service_properties
end type
type st_object_description from statictext within w_service_properties
end type
type st_context_object from statictext within w_service_properties
end type
type st_expiration_date from statictext within w_service_properties
end type
type st_expiration_date_title from statictext within w_service_properties
end type
type st_escalation_date from statictext within w_service_properties
end type
type st_escalation_date_title from statictext within w_service_properties
end type
type st_9 from statictext within w_service_properties
end type
type st_1 from statictext within w_service_properties
end type
type st_patient_workplan_item_id from statictext within w_service_properties
end type
type st_patient_workplan_item_id_title from statictext within w_service_properties
end type
type cb_pedigree from commandbutton within w_service_properties
end type
type st_debug_mode from statictext within w_service_properties
end type
type st_debug_mode_title from statictext within w_service_properties
end type
end forward

global type w_service_properties from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_ok cb_ok
dw_service_history dw_service_history
st_status st_status
st_status_title st_status_title
st_dispatch_date st_dispatch_date
st_created_by_title st_created_by_title
st_created st_created
st_created_title st_created_title
st_title st_title
st_created_by st_created_by
st_storage_flag_title st_storage_flag_title
st_service st_service
st_extension_title st_extension_title
st_description st_description
st_attachment_type_title st_attachment_type_title
st_owned_by st_owned_by
st_attached_by_title st_attached_by_title
st_completed_by st_completed_by
st_attachment_date_title st_attachment_date_title
st_ordered_for st_ordered_for
st_attachment_folder_title st_attachment_folder_title
st_end_date st_end_date
st_3 st_3
st_begin_date st_begin_date
st_5 st_5
st_ordered_by st_ordered_by
st_7 st_7
dw_service_attributes dw_service_attributes
st_flags_background st_flags_background
st_flags_title st_flags_title
st_in_office_flag_title st_in_office_flag_title
st_4 st_4
st_6 st_6
st_8 st_8
st_10 st_10
st_11 st_11
st_12 st_12
st_in_office_flag st_in_office_flag
st_step_flag st_step_flag
st_auto_perform_flag st_auto_perform_flag
st_cancel_workplan_flag st_cancel_workplan_flag
st_consolidate_flag st_consolidate_flag
st_owner_flag st_owner_flag
st_priority st_priority
st_context_object_title st_context_object_title
st_object_description_title st_object_description_title
st_object_description st_object_description
st_context_object st_context_object
st_expiration_date st_expiration_date
st_expiration_date_title st_expiration_date_title
st_escalation_date st_escalation_date
st_escalation_date_title st_escalation_date_title
st_9 st_9
st_1 st_1
st_patient_workplan_item_id st_patient_workplan_item_id
st_patient_workplan_item_id_title st_patient_workplan_item_id_title
cb_pedigree cb_pedigree
st_debug_mode st_debug_mode
st_debug_mode_title st_debug_mode_title
end type
global w_service_properties w_service_properties

type variables
u_component_service service



end variables

on w_service_properties.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.dw_service_history=create dw_service_history
this.st_status=create st_status
this.st_status_title=create st_status_title
this.st_dispatch_date=create st_dispatch_date
this.st_created_by_title=create st_created_by_title
this.st_created=create st_created
this.st_created_title=create st_created_title
this.st_title=create st_title
this.st_created_by=create st_created_by
this.st_storage_flag_title=create st_storage_flag_title
this.st_service=create st_service
this.st_extension_title=create st_extension_title
this.st_description=create st_description
this.st_attachment_type_title=create st_attachment_type_title
this.st_owned_by=create st_owned_by
this.st_attached_by_title=create st_attached_by_title
this.st_completed_by=create st_completed_by
this.st_attachment_date_title=create st_attachment_date_title
this.st_ordered_for=create st_ordered_for
this.st_attachment_folder_title=create st_attachment_folder_title
this.st_end_date=create st_end_date
this.st_3=create st_3
this.st_begin_date=create st_begin_date
this.st_5=create st_5
this.st_ordered_by=create st_ordered_by
this.st_7=create st_7
this.dw_service_attributes=create dw_service_attributes
this.st_flags_background=create st_flags_background
this.st_flags_title=create st_flags_title
this.st_in_office_flag_title=create st_in_office_flag_title
this.st_4=create st_4
this.st_6=create st_6
this.st_8=create st_8
this.st_10=create st_10
this.st_11=create st_11
this.st_12=create st_12
this.st_in_office_flag=create st_in_office_flag
this.st_step_flag=create st_step_flag
this.st_auto_perform_flag=create st_auto_perform_flag
this.st_cancel_workplan_flag=create st_cancel_workplan_flag
this.st_consolidate_flag=create st_consolidate_flag
this.st_owner_flag=create st_owner_flag
this.st_priority=create st_priority
this.st_context_object_title=create st_context_object_title
this.st_object_description_title=create st_object_description_title
this.st_object_description=create st_object_description
this.st_context_object=create st_context_object
this.st_expiration_date=create st_expiration_date
this.st_expiration_date_title=create st_expiration_date_title
this.st_escalation_date=create st_escalation_date
this.st_escalation_date_title=create st_escalation_date_title
this.st_9=create st_9
this.st_1=create st_1
this.st_patient_workplan_item_id=create st_patient_workplan_item_id
this.st_patient_workplan_item_id_title=create st_patient_workplan_item_id_title
this.cb_pedigree=create cb_pedigree
this.st_debug_mode=create st_debug_mode
this.st_debug_mode_title=create st_debug_mode_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.dw_service_history
this.Control[iCurrent+3]=this.st_status
this.Control[iCurrent+4]=this.st_status_title
this.Control[iCurrent+5]=this.st_dispatch_date
this.Control[iCurrent+6]=this.st_created_by_title
this.Control[iCurrent+7]=this.st_created
this.Control[iCurrent+8]=this.st_created_title
this.Control[iCurrent+9]=this.st_title
this.Control[iCurrent+10]=this.st_created_by
this.Control[iCurrent+11]=this.st_storage_flag_title
this.Control[iCurrent+12]=this.st_service
this.Control[iCurrent+13]=this.st_extension_title
this.Control[iCurrent+14]=this.st_description
this.Control[iCurrent+15]=this.st_attachment_type_title
this.Control[iCurrent+16]=this.st_owned_by
this.Control[iCurrent+17]=this.st_attached_by_title
this.Control[iCurrent+18]=this.st_completed_by
this.Control[iCurrent+19]=this.st_attachment_date_title
this.Control[iCurrent+20]=this.st_ordered_for
this.Control[iCurrent+21]=this.st_attachment_folder_title
this.Control[iCurrent+22]=this.st_end_date
this.Control[iCurrent+23]=this.st_3
this.Control[iCurrent+24]=this.st_begin_date
this.Control[iCurrent+25]=this.st_5
this.Control[iCurrent+26]=this.st_ordered_by
this.Control[iCurrent+27]=this.st_7
this.Control[iCurrent+28]=this.dw_service_attributes
this.Control[iCurrent+29]=this.st_flags_background
this.Control[iCurrent+30]=this.st_flags_title
this.Control[iCurrent+31]=this.st_in_office_flag_title
this.Control[iCurrent+32]=this.st_4
this.Control[iCurrent+33]=this.st_6
this.Control[iCurrent+34]=this.st_8
this.Control[iCurrent+35]=this.st_10
this.Control[iCurrent+36]=this.st_11
this.Control[iCurrent+37]=this.st_12
this.Control[iCurrent+38]=this.st_in_office_flag
this.Control[iCurrent+39]=this.st_step_flag
this.Control[iCurrent+40]=this.st_auto_perform_flag
this.Control[iCurrent+41]=this.st_cancel_workplan_flag
this.Control[iCurrent+42]=this.st_consolidate_flag
this.Control[iCurrent+43]=this.st_owner_flag
this.Control[iCurrent+44]=this.st_priority
this.Control[iCurrent+45]=this.st_context_object_title
this.Control[iCurrent+46]=this.st_object_description_title
this.Control[iCurrent+47]=this.st_object_description
this.Control[iCurrent+48]=this.st_context_object
this.Control[iCurrent+49]=this.st_expiration_date
this.Control[iCurrent+50]=this.st_expiration_date_title
this.Control[iCurrent+51]=this.st_escalation_date
this.Control[iCurrent+52]=this.st_escalation_date_title
this.Control[iCurrent+53]=this.st_9
this.Control[iCurrent+54]=this.st_1
this.Control[iCurrent+55]=this.st_patient_workplan_item_id
this.Control[iCurrent+56]=this.st_patient_workplan_item_id_title
this.Control[iCurrent+57]=this.cb_pedigree
this.Control[iCurrent+58]=this.st_debug_mode
this.Control[iCurrent+59]=this.st_debug_mode_title
end on

on w_service_properties.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.dw_service_history)
destroy(this.st_status)
destroy(this.st_status_title)
destroy(this.st_dispatch_date)
destroy(this.st_created_by_title)
destroy(this.st_created)
destroy(this.st_created_title)
destroy(this.st_title)
destroy(this.st_created_by)
destroy(this.st_storage_flag_title)
destroy(this.st_service)
destroy(this.st_extension_title)
destroy(this.st_description)
destroy(this.st_attachment_type_title)
destroy(this.st_owned_by)
destroy(this.st_attached_by_title)
destroy(this.st_completed_by)
destroy(this.st_attachment_date_title)
destroy(this.st_ordered_for)
destroy(this.st_attachment_folder_title)
destroy(this.st_end_date)
destroy(this.st_3)
destroy(this.st_begin_date)
destroy(this.st_5)
destroy(this.st_ordered_by)
destroy(this.st_7)
destroy(this.dw_service_attributes)
destroy(this.st_flags_background)
destroy(this.st_flags_title)
destroy(this.st_in_office_flag_title)
destroy(this.st_4)
destroy(this.st_6)
destroy(this.st_8)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.st_12)
destroy(this.st_in_office_flag)
destroy(this.st_step_flag)
destroy(this.st_auto_perform_flag)
destroy(this.st_cancel_workplan_flag)
destroy(this.st_consolidate_flag)
destroy(this.st_owner_flag)
destroy(this.st_priority)
destroy(this.st_context_object_title)
destroy(this.st_object_description_title)
destroy(this.st_object_description)
destroy(this.st_context_object)
destroy(this.st_expiration_date)
destroy(this.st_expiration_date_title)
destroy(this.st_escalation_date)
destroy(this.st_escalation_date_title)
destroy(this.st_9)
destroy(this.st_1)
destroy(this.st_patient_workplan_item_id)
destroy(this.st_patient_workplan_item_id_title)
destroy(this.cb_pedigree)
destroy(this.st_debug_mode)
destroy(this.st_debug_mode_title)
end on

event open;call super::open;


service = message.powerobjectparm

st_description.text = service.description
st_service.text = datalist.service_description(service.service)

st_created_by.text = user_list.user_full_name(service.created_by)
st_ordered_by.text = user_list.user_full_name(service.ordered_by)
st_ordered_for.text = user_list.user_full_name(service.ordered_for)
st_completed_by.text = user_list.user_full_name(service.completed_by)
st_owned_by.text = user_list.user_full_name(service.owned_by)
st_created_by.backcolor = user_list.user_color(service.created_by)
st_ordered_by.backcolor = user_list.user_color(service.ordered_by)
st_ordered_for.backcolor = user_list.user_color(service.ordered_for)
st_completed_by.backcolor = user_list.user_color(service.completed_by)
st_owned_by.backcolor = user_list.user_color(service.owned_by)

st_created.text = string(service.created)
st_dispatch_date.text = string(service.dispatch_date)
st_begin_date.text = string(service.begin_date)
st_end_date.text = string(service.end_date)
st_escalation_date.text = string(service.escalation_date)
st_expiration_date.text = string(service.expiration_date)
st_status.text = service.status

st_in_office_flag.text = service.in_office_flag
st_step_flag.text = service.step_flag
st_auto_perform_flag.text = service.auto_perform_flag
st_cancel_workplan_flag.text = service.cancel_workplan_flag
st_consolidate_flag.text = service.consolidate_flag
st_owner_flag.text = service.owner_flag
st_priority.text = string(service.priority)

st_context_object.text = wordcap(service.context_object)
st_object_description.text = service.context_description

st_patient_workplan_item_id.text = string(service.patient_workplan_item_id)

dw_service_history.settransobject(sqlca)
dw_service_history.retrieve(service.patient_workplan_item_id)

dw_service_attributes.settransobject(sqlca)
dw_service_attributes.retrieve(service.patient_workplan_item_id)

boolean lb_debug_mode
service.get_attribute("debug_mode", lb_debug_mode, false)
if lb_debug_mode then
	st_debug_mode.text = "Yes"
else
	st_debug_mode.text = "No"
end if

if user_list.is_user_privileged(current_user.user_id, "Edit System Config") then
	st_debug_mode.borderstyle = styleraised!
	st_debug_mode.enabled = true
elseif lb_debug_mode then
	st_debug_mode.borderstyle = stylebox!
	st_debug_mode.enabled = false
else
	st_debug_mode.visible = false
	st_debug_mode_title.visible = false
end if




end event

type pb_epro_help from w_window_base`pb_epro_help within w_service_properties
integer x = 2670
integer width = 256
integer height = 128
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_service_properties
integer x = 59
integer y = 1564
end type

type cb_ok from commandbutton within w_service_properties
integer x = 2386
integer y = 1592
integer width = 471
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;close(parent)

end event

type dw_service_history from u_dw_pick_list within w_service_properties
integer x = 46
integer y = 1192
integer width = 1719
integer height = 360
integer taborder = 20
string dataobject = "dw_p_patient_wp_item_progress"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event post_click;call super::post_click;//string ls_temp_file,ls_progress_type
//integer li_sts
//blob lbl_attachment
//long ll_attachment_progress_sequence
//
//ls_progress_type = object.progress_type[clicked_row]
//CHOOSE CASE upper(ls_progress_type)
//	CASE "CREATED"
//		ls_temp_file = f_temp_file(attachment.extension)
//		if isnull(ls_temp_file) then return
//		
//		ll_attachment_progress_sequence = object.attachment_progress_sequence[clicked_row]
//			
//		SELECTBLOB attachment_image
//		INTO :lbl_attachment
//		FROM p_Attachment
//		WHERE attachment_id = :attachment.attachment_id
//		USING sqlca;
//		if not tf_check() then 
//			log.log(this,"post_click()","unable to get attachment image",3)
//			return
//		end if
//	
//		li_sts = log.file_write(lbl_attachment, ls_temp_file)
//		if li_sts <= 0 Then return
//		
//		ole_attachment.insertfile(ls_temp_file)
//		ole_attachment.activate(offsite!)
//	CASE "UPDATE"
//		ls_temp_file = f_temp_file(attachment.extension)
//		if isnull(ls_temp_file) then return
//		
//		ll_attachment_progress_sequence = object.attachment_progress_sequence[clicked_row]
//			
//		SELECTBLOB attachment_image
//		INTO :lbl_attachment
//		FROM p_Attachment_Progress
//		WHERE attachment_id = :attachment.attachment_id
//		AND attachment_progress_sequence = :ll_attachment_progress_sequence
//		USING sqlca;
//		if not tf_check() then 
//			log.log(this,"post_click()","unable to get attachment image",3)
//			return
//		end if
//	
//		li_sts = log.file_write(lbl_attachment, ls_temp_file)
//		if li_sts <= 0 Then return
//		
//		ole_attachment.insertfile(ls_temp_file)
//		ole_attachment.activate(offsite!)
//END CHOOSE
//
//
end event

type st_status from statictext within w_service_properties
integer x = 2002
integer y = 748
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_status_title from statictext within w_service_properties
integer x = 1486
integer y = 748
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Current Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_dispatch_date from statictext within w_service_properties
integer x = 2002
integer y = 328
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_created_by_title from statictext within w_service_properties
integer x = 1486
integer y = 328
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Dispatch Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_created from statictext within w_service_properties
integer x = 2002
integer y = 244
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_created_title from statictext within w_service_properties
integer x = 1554
integer y = 244
integer width = 425
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Create Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_service_properties
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Service Properties"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_created_by from statictext within w_service_properties
integer x = 567
integer y = 328
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_storage_flag_title from statictext within w_service_properties
integer x = 50
integer y = 328
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Created By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_service from statictext within w_service_properties
integer x = 567
integer y = 244
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_extension_title from statictext within w_service_properties
integer x = 50
integer y = 244
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Service:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_description from statictext within w_service_properties
integer x = 567
integer y = 160
integer width = 2254
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_attachment_type_title from statictext within w_service_properties
integer x = 18
integer y = 160
integer width = 526
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_owned_by from statictext within w_service_properties
integer x = 567
integer y = 664
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_attached_by_title from statictext within w_service_properties
integer x = 50
integer y = 664
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Current Owner:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_completed_by from statictext within w_service_properties
integer x = 567
integer y = 580
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_attachment_date_title from statictext within w_service_properties
integer x = 32
integer y = 580
integer width = 512
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Completed By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ordered_for from statictext within w_service_properties
integer x = 567
integer y = 496
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_attachment_folder_title from statictext within w_service_properties
integer x = 50
integer y = 496
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Ordered For:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_end_date from statictext within w_service_properties
integer x = 2002
integer y = 496
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_3 from statictext within w_service_properties
integer x = 1486
integer y = 496
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "End Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_begin_date from statictext within w_service_properties
integer x = 2002
integer y = 412
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_5 from statictext within w_service_properties
integer x = 1554
integer y = 412
integer width = 425
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Begin Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ordered_by from statictext within w_service_properties
integer x = 567
integer y = 412
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_7 from statictext within w_service_properties
integer x = 50
integer y = 412
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Ordered By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_service_attributes from u_dw_pick_list within w_service_properties
integer x = 1797
integer y = 1192
integer width = 1024
integer height = 360
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_p_patient_wp_item_attribute_small"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event post_click;call super::post_click;//string ls_temp_file,ls_progress_type
//integer li_sts
//blob lbl_attachment
//long ll_attachment_progress_sequence
//
//ls_progress_type = object.progress_type[clicked_row]
//CHOOSE CASE upper(ls_progress_type)
//	CASE "CREATED"
//		ls_temp_file = f_temp_file(attachment.extension)
//		if isnull(ls_temp_file) then return
//		
//		ll_attachment_progress_sequence = object.attachment_progress_sequence[clicked_row]
//			
//		SELECTBLOB attachment_image
//		INTO :lbl_attachment
//		FROM p_Attachment
//		WHERE attachment_id = :attachment.attachment_id
//		USING sqlca;
//		if not tf_check() then 
//			log.log(this,"post_click()","unable to get attachment image",3)
//			return
//		end if
//	
//		li_sts = log.file_write(lbl_attachment, ls_temp_file)
//		if li_sts <= 0 Then return
//		
//		ole_attachment.insertfile(ls_temp_file)
//		ole_attachment.activate(offsite!)
//	CASE "UPDATE"
//		ls_temp_file = f_temp_file(attachment.extension)
//		if isnull(ls_temp_file) then return
//		
//		ll_attachment_progress_sequence = object.attachment_progress_sequence[clicked_row]
//			
//		SELECTBLOB attachment_image
//		INTO :lbl_attachment
//		FROM p_Attachment_Progress
//		WHERE attachment_id = :attachment.attachment_id
//		AND attachment_progress_sequence = :ll_attachment_progress_sequence
//		USING sqlca;
//		if not tf_check() then 
//			log.log(this,"post_click()","unable to get attachment image",3)
//			return
//		end if
//	
//		li_sts = log.file_write(lbl_attachment, ls_temp_file)
//		if li_sts <= 0 Then return
//		
//		ole_attachment.insertfile(ls_temp_file)
//		ole_attachment.activate(offsite!)
//END CHOOSE
//
//
end event

type st_flags_background from statictext within w_service_properties
integer x = 1865
integer y = 848
integer width = 955
integer height = 252
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_flags_title from statictext within w_service_properties
integer x = 1623
integer y = 844
integer width = 229
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Flags:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_in_office_flag_title from statictext within w_service_properties
integer x = 1883
integer y = 860
integer width = 366
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "In Office Flag:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_service_properties
integer x = 1883
integer y = 916
integer width = 366
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Step Flag:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within w_service_properties
integer x = 1883
integer y = 972
integer width = 366
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Auto Pfm Flag:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_8 from statictext within w_service_properties
integer x = 1883
integer y = 1028
integer width = 366
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Cancel WP Flag:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_10 from statictext within w_service_properties
integer x = 2345
integer y = 864
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Consolidate Flag:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_11 from statictext within w_service_properties
integer x = 2345
integer y = 916
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Owner Flag:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_12 from statictext within w_service_properties
integer x = 2345
integer y = 976
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Priority:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_in_office_flag from statictext within w_service_properties
integer x = 2263
integer y = 864
integer width = 73
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Y"
boolean focusrectangle = false
end type

type st_step_flag from statictext within w_service_properties
integer x = 2263
integer y = 920
integer width = 73
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "N"
boolean focusrectangle = false
end type

type st_auto_perform_flag from statictext within w_service_properties
integer x = 2263
integer y = 976
integer width = 73
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "N"
boolean focusrectangle = false
end type

type st_cancel_workplan_flag from statictext within w_service_properties
integer x = 2263
integer y = 1032
integer width = 73
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "N"
boolean focusrectangle = false
end type

type st_consolidate_flag from statictext within w_service_properties
integer x = 2743
integer y = 864
integer width = 73
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "N"
boolean focusrectangle = false
end type

type st_owner_flag from statictext within w_service_properties
integer x = 2743
integer y = 920
integer width = 73
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "N"
boolean focusrectangle = false
end type

type st_priority from statictext within w_service_properties
integer x = 2743
integer y = 976
integer width = 73
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "N"
boolean focusrectangle = false
end type

type st_context_object_title from statictext within w_service_properties
integer x = 50
integer y = 872
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Context Object:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_object_description_title from statictext within w_service_properties
integer x = 41
integer y = 956
integer width = 503
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Obj Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_object_description from statictext within w_service_properties
integer x = 567
integer y = 960
integer width = 1079
integer height = 152
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_context_object from statictext within w_service_properties
integer x = 567
integer y = 876
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_expiration_date from statictext within w_service_properties
integer x = 2002
integer y = 664
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_expiration_date_title from statictext within w_service_properties
integer x = 1486
integer y = 664
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Expiration Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_escalation_date from statictext within w_service_properties
integer x = 2002
integer y = 580
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_escalation_date_title from statictext within w_service_properties
integer x = 1499
integer y = 580
integer width = 480
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Escalation Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_9 from statictext within w_service_properties
integer x = 1797
integer y = 1124
integer width = 288
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Attributes"
boolean focusrectangle = false
end type

type st_1 from statictext within w_service_properties
integer x = 55
integer y = 1124
integer width = 247
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "History"
boolean focusrectangle = false
end type

type st_patient_workplan_item_id from statictext within w_service_properties
integer x = 567
integer y = 748
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_patient_workplan_item_id_title from statictext within w_service_properties
integer x = 50
integer y = 748
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Item ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_pedigree from commandbutton within w_service_properties
integer x = 46
integer y = 1592
integer width = 471
integer height = 104
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Pedigree"
end type

type st_debug_mode from statictext within w_service_properties
integer x = 1504
integer y = 1604
integer width = 242
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if st_debug_mode.text = "No" then
	service.set_attribute( "debug_mode", "True")
	st_debug_mode.text = "Yes"
else
	service.set_attribute( "debug_mode", "False")
	st_debug_mode.text = "No"
end if

end event

type st_debug_mode_title from statictext within w_service_properties
integer x = 1056
integer y = 1608
integer width = 425
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Debug_mode:"
alignment alignment = right!
boolean focusrectangle = false
end type

