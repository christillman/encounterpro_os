$PBExportHeader$w_document_properties.srw
forward
global type w_document_properties from w_window_base
end type
type cb_ok from commandbutton within w_document_properties
end type
type dw_service_history from u_dw_pick_list within w_document_properties
end type
type st_status from statictext within w_document_properties
end type
type st_status_title from statictext within w_document_properties
end type
type st_dispatch_date from statictext within w_document_properties
end type
type st_dispatch_date_title from statictext within w_document_properties
end type
type st_created from statictext within w_document_properties
end type
type st_created_title from statictext within w_document_properties
end type
type st_created_by from statictext within w_document_properties
end type
type st_storage_flag_title from statictext within w_document_properties
end type
type st_description from statictext within w_document_properties
end type
type st_attachment_type_title from statictext within w_document_properties
end type
type st_dispatched_by from statictext within w_document_properties
end type
type st_sent_by_title from statictext within w_document_properties
end type
type st_ordered_for from statictext within w_document_properties
end type
type st_attachment_folder_title from statictext within w_document_properties
end type
type st_ordered_by from statictext within w_document_properties
end type
type st_7 from statictext within w_document_properties
end type
type dw_service_attributes from u_dw_pick_list within w_document_properties
end type
type st_document_objects_title from statictext within w_document_properties
end type
type st_context_object_title from statictext within w_document_properties
end type
type st_object_description_title from statictext within w_document_properties
end type
type st_object_description from statictext within w_document_properties
end type
type st_context_object from statictext within w_document_properties
end type
type st_9 from statictext within w_document_properties
end type
type st_1 from statictext within w_document_properties
end type
type st_patient_workplan_item_id from statictext within w_document_properties
end type
type st_patient_workplan_item_id_title from statictext within w_document_properties
end type
type dw_document_objects from u_dw_pick_list within w_document_properties
end type
type cb_show_document_objects from commandbutton within w_document_properties
end type
type st_title from statictext within w_document_properties
end type
type st_route from statictext within w_document_properties
end type
type st_route_title from statictext within w_document_properties
end type
type st_completed_date from statictext within w_document_properties
end type
type st_completed_date_title from statictext within w_document_properties
end type
type cb_view_document from commandbutton within w_document_properties
end type
type cb_pedigree from commandbutton within w_document_properties
end type
type st_mapping_status_title from statictext within w_document_properties
end type
type st_mapping_status from statictext within w_document_properties
end type
type st_document_created_title from statictext within w_document_properties
end type
type st_document_created from statictext within w_document_properties
end type
type cb_edit_mappings from commandbutton within w_document_properties
end type
type st_error_message from statictext within w_document_properties
end type
end forward

global type w_document_properties from w_window_base
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
st_dispatch_date_title st_dispatch_date_title
st_created st_created
st_created_title st_created_title
st_created_by st_created_by
st_storage_flag_title st_storage_flag_title
st_description st_description
st_attachment_type_title st_attachment_type_title
st_dispatched_by st_dispatched_by
st_sent_by_title st_sent_by_title
st_ordered_for st_ordered_for
st_attachment_folder_title st_attachment_folder_title
st_ordered_by st_ordered_by
st_7 st_7
dw_service_attributes dw_service_attributes
st_document_objects_title st_document_objects_title
st_context_object_title st_context_object_title
st_object_description_title st_object_description_title
st_object_description st_object_description
st_context_object st_context_object
st_9 st_9
st_1 st_1
st_patient_workplan_item_id st_patient_workplan_item_id
st_patient_workplan_item_id_title st_patient_workplan_item_id_title
dw_document_objects dw_document_objects
cb_show_document_objects cb_show_document_objects
st_title st_title
st_route st_route
st_route_title st_route_title
st_completed_date st_completed_date
st_completed_date_title st_completed_date_title
cb_view_document cb_view_document
cb_pedigree cb_pedigree
st_mapping_status_title st_mapping_status_title
st_mapping_status st_mapping_status
st_document_created_title st_document_created_title
st_document_created st_document_created
cb_edit_mappings cb_edit_mappings
st_error_message st_error_message
end type
global w_document_properties w_document_properties

type variables
u_component_wp_item_document document




end variables

forward prototypes
public subroutine document_objects_menu ()
end prototypes

public subroutine document_objects_menu ();




return


end subroutine

on w_document_properties.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.dw_service_history=create dw_service_history
this.st_status=create st_status
this.st_status_title=create st_status_title
this.st_dispatch_date=create st_dispatch_date
this.st_dispatch_date_title=create st_dispatch_date_title
this.st_created=create st_created
this.st_created_title=create st_created_title
this.st_created_by=create st_created_by
this.st_storage_flag_title=create st_storage_flag_title
this.st_description=create st_description
this.st_attachment_type_title=create st_attachment_type_title
this.st_dispatched_by=create st_dispatched_by
this.st_sent_by_title=create st_sent_by_title
this.st_ordered_for=create st_ordered_for
this.st_attachment_folder_title=create st_attachment_folder_title
this.st_ordered_by=create st_ordered_by
this.st_7=create st_7
this.dw_service_attributes=create dw_service_attributes
this.st_document_objects_title=create st_document_objects_title
this.st_context_object_title=create st_context_object_title
this.st_object_description_title=create st_object_description_title
this.st_object_description=create st_object_description
this.st_context_object=create st_context_object
this.st_9=create st_9
this.st_1=create st_1
this.st_patient_workplan_item_id=create st_patient_workplan_item_id
this.st_patient_workplan_item_id_title=create st_patient_workplan_item_id_title
this.dw_document_objects=create dw_document_objects
this.cb_show_document_objects=create cb_show_document_objects
this.st_title=create st_title
this.st_route=create st_route
this.st_route_title=create st_route_title
this.st_completed_date=create st_completed_date
this.st_completed_date_title=create st_completed_date_title
this.cb_view_document=create cb_view_document
this.cb_pedigree=create cb_pedigree
this.st_mapping_status_title=create st_mapping_status_title
this.st_mapping_status=create st_mapping_status
this.st_document_created_title=create st_document_created_title
this.st_document_created=create st_document_created
this.cb_edit_mappings=create cb_edit_mappings
this.st_error_message=create st_error_message
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.dw_service_history
this.Control[iCurrent+3]=this.st_status
this.Control[iCurrent+4]=this.st_status_title
this.Control[iCurrent+5]=this.st_dispatch_date
this.Control[iCurrent+6]=this.st_dispatch_date_title
this.Control[iCurrent+7]=this.st_created
this.Control[iCurrent+8]=this.st_created_title
this.Control[iCurrent+9]=this.st_created_by
this.Control[iCurrent+10]=this.st_storage_flag_title
this.Control[iCurrent+11]=this.st_description
this.Control[iCurrent+12]=this.st_attachment_type_title
this.Control[iCurrent+13]=this.st_dispatched_by
this.Control[iCurrent+14]=this.st_sent_by_title
this.Control[iCurrent+15]=this.st_ordered_for
this.Control[iCurrent+16]=this.st_attachment_folder_title
this.Control[iCurrent+17]=this.st_ordered_by
this.Control[iCurrent+18]=this.st_7
this.Control[iCurrent+19]=this.dw_service_attributes
this.Control[iCurrent+20]=this.st_document_objects_title
this.Control[iCurrent+21]=this.st_context_object_title
this.Control[iCurrent+22]=this.st_object_description_title
this.Control[iCurrent+23]=this.st_object_description
this.Control[iCurrent+24]=this.st_context_object
this.Control[iCurrent+25]=this.st_9
this.Control[iCurrent+26]=this.st_1
this.Control[iCurrent+27]=this.st_patient_workplan_item_id
this.Control[iCurrent+28]=this.st_patient_workplan_item_id_title
this.Control[iCurrent+29]=this.dw_document_objects
this.Control[iCurrent+30]=this.cb_show_document_objects
this.Control[iCurrent+31]=this.st_title
this.Control[iCurrent+32]=this.st_route
this.Control[iCurrent+33]=this.st_route_title
this.Control[iCurrent+34]=this.st_completed_date
this.Control[iCurrent+35]=this.st_completed_date_title
this.Control[iCurrent+36]=this.cb_view_document
this.Control[iCurrent+37]=this.cb_pedigree
this.Control[iCurrent+38]=this.st_mapping_status_title
this.Control[iCurrent+39]=this.st_mapping_status
this.Control[iCurrent+40]=this.st_document_created_title
this.Control[iCurrent+41]=this.st_document_created
this.Control[iCurrent+42]=this.cb_edit_mappings
this.Control[iCurrent+43]=this.st_error_message
end on

on w_document_properties.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.dw_service_history)
destroy(this.st_status)
destroy(this.st_status_title)
destroy(this.st_dispatch_date)
destroy(this.st_dispatch_date_title)
destroy(this.st_created)
destroy(this.st_created_title)
destroy(this.st_created_by)
destroy(this.st_storage_flag_title)
destroy(this.st_description)
destroy(this.st_attachment_type_title)
destroy(this.st_dispatched_by)
destroy(this.st_sent_by_title)
destroy(this.st_ordered_for)
destroy(this.st_attachment_folder_title)
destroy(this.st_ordered_by)
destroy(this.st_7)
destroy(this.dw_service_attributes)
destroy(this.st_document_objects_title)
destroy(this.st_context_object_title)
destroy(this.st_object_description_title)
destroy(this.st_object_description)
destroy(this.st_context_object)
destroy(this.st_9)
destroy(this.st_1)
destroy(this.st_patient_workplan_item_id)
destroy(this.st_patient_workplan_item_id_title)
destroy(this.dw_document_objects)
destroy(this.cb_show_document_objects)
destroy(this.st_title)
destroy(this.st_route)
destroy(this.st_route_title)
destroy(this.st_completed_date)
destroy(this.st_completed_date_title)
destroy(this.cb_view_document)
destroy(this.cb_pedigree)
destroy(this.st_mapping_status_title)
destroy(this.st_mapping_status)
destroy(this.st_document_created_title)
destroy(this.st_document_created)
destroy(this.cb_edit_mappings)
destroy(this.st_error_message)
end on

event open;call super::open;long ll_patient_workplan_item_id
string ls_dispatched_by
long ll_count

if message.doubleparm > 0 then
	ll_patient_workplan_item_id = message.doubleparm
	document = CREATE u_component_wp_item_document
	document.initialize(ll_patient_workplan_item_id)
elseif message.longparm > 0 then
	ll_patient_workplan_item_id = message.longparm
	document = CREATE u_component_wp_item_document
	document.initialize(ll_patient_workplan_item_id)
elseif isvalid(message.powerobjectparm) then
	document = message.powerobjectparm
end if
	
/////////////////////////

st_description.text = document.description

st_created_by.text = user_list.user_full_name(document.created_by)
st_created_by.backcolor = user_list.user_color(document.created_by)

st_ordered_by.text = user_list.user_full_name(document.ordered_by)
st_ordered_by.backcolor = user_list.user_color(document.ordered_by)

st_ordered_for.text = user_list.user_full_name(document.ordered_for)
st_ordered_for.backcolor = user_list.user_color(document.ordered_for)

st_route.text = document.dispatch_method

/////////////////////////

st_created.text = string(document.created)

//ls_dispatched_by = document.dispatched_by()
st_dispatched_by.text = user_list.user_full_name(ls_dispatched_by)
st_dispatched_by.backcolor = user_list.user_color(ls_dispatched_by)

st_dispatch_date.text = string(document.dispatch_date)

st_completed_date.text = string(document.end_date)



st_status.text = document.status
if lower(st_status.text) = "error" then
	st_error_message.text  = document.get_attribute("error_message")
	if len(st_error_message.text) > 0 then
		st_error_message.visible = true
	else
		st_error_message.visible = false
	end if
else
	st_error_message.visible = false
end if
	
/////////////////////////

if document.document_created then
	st_document_created.text = "Yes"
	cb_view_document.visible = true
else
	st_document_created.text = "No"
	cb_view_document.visible = false
end if

st_mapping_status.text = document.document_mapping_status()
if isnull(st_mapping_status.text) then
	st_mapping_status.text = "Error"
	cb_edit_mappings.visible = false
elseif 	upper(st_mapping_status.text) = "NA" then
	cb_edit_mappings.visible = false
else
	cb_edit_mappings.visible = true
end if

if lower(st_mapping_status.text) = "failed" or lower(st_mapping_status.text) = "error" then
	st_mapping_status.textcolor = color_text_error
end if

st_context_object.text = wordcap(document.context_object)
st_object_description.text = document.context_description

st_patient_workplan_item_id.text = string(document.patient_workplan_item_id)

dw_document_objects.settransobject(sqlca)
ll_count = dw_document_objects.retrieve(document.patient_workplan_item_id)
if ll_count > 0 then
	st_document_objects_title.text = "Document Objects (" + string(ll_count) + ")"
else
	st_document_objects_title.text = "Document Objects"
end if

dw_service_history.settransobject(sqlca)
dw_service_history.retrieve(document.patient_workplan_item_id)

dw_service_attributes.settransobject(sqlca)
dw_service_attributes.retrieve(document.patient_workplan_item_id)




end event

type pb_epro_help from w_window_base`pb_epro_help within w_document_properties
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_document_properties
integer x = 59
integer y = 1564
end type

type cb_ok from commandbutton within w_document_properties
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

type dw_service_history from u_dw_pick_list within w_document_properties
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
//			log.log(this,"w_document_properties.dw_service_history.post_click:0020","unable to get attachment image",3)
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
//			log.log(this,"w_document_properties.dw_service_history.post_click:0042","unable to get attachment image",3)
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

type st_status from statictext within w_document_properties
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

type st_status_title from statictext within w_document_properties
integer x = 1486
integer y = 580
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

type st_dispatch_date from statictext within w_document_properties
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

type st_dispatch_date_title from statictext within w_document_properties
integer x = 1486
integer y = 412
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
string text = "Dispatched Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_created from statictext within w_document_properties
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

type st_created_title from statictext within w_document_properties
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

type st_created_by from statictext within w_document_properties
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

type st_storage_flag_title from statictext within w_document_properties
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
string text = "Created By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_description from statictext within w_document_properties
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

type st_attachment_type_title from statictext within w_document_properties
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

type st_dispatched_by from statictext within w_document_properties
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

type st_sent_by_title from statictext within w_document_properties
integer x = 1522
integer y = 328
integer width = 457
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
string text = "Dispatched By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ordered_for from statictext within w_document_properties
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

type st_attachment_folder_title from statictext within w_document_properties
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
string text = "Recipient:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ordered_by from statictext within w_document_properties
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

type st_7 from statictext within w_document_properties
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
string text = "Ordered By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_service_attributes from u_dw_pick_list within w_document_properties
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
//			log.log(this,"w_document_properties.dw_service_attributes.post_click:0020","unable to get attachment image",3)
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
//			log.log(this,"w_document_properties.dw_service_attributes.post_click:0042","unable to get attachment image",3)
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

type st_document_objects_title from statictext within w_document_properties
integer x = 1792
integer y = 808
integer width = 905
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
string text = "Document Objects"
boolean focusrectangle = false
end type

type st_context_object_title from statictext within w_document_properties
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

type st_object_description_title from statictext within w_document_properties
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

type st_object_description from statictext within w_document_properties
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

type st_context_object from statictext within w_document_properties
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

type st_9 from statictext within w_document_properties
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

type st_1 from statictext within w_document_properties
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

type st_patient_workplan_item_id from statictext within w_document_properties
integer x = 567
integer y = 792
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

type st_patient_workplan_item_id_title from statictext within w_document_properties
integer x = 50
integer y = 792
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
string text = "Document ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_document_objects from u_dw_pick_list within w_document_properties
integer x = 1797
integer y = 884
integer width = 1024
integer height = 212
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_document_objects_small"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_show_document_objects from commandbutton within w_document_properties
integer x = 2715
integer y = 816
integer width = 105
integer height = 64
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_popup popup

popup.title = "Document Objects"
popup.dataobject = "dw_document_objects_display"
popup.argument_count = 1
popup.numeric_argument = true
popup.argument[1] = string(document.patient_workplan_item_id)
openwithparm(w_pop_display_datawindow, popup)

end event

type st_title from statictext within w_document_properties
integer width = 2921
integer height = 120
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Document Properties"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_route from statictext within w_document_properties
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

type st_route_title from statictext within w_document_properties
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
string text = "Route:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_completed_date from statictext within w_document_properties
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

type st_completed_date_title from statictext within w_document_properties
integer x = 1486
integer y = 496
integer width = 498
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
string text = "Sent Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_view_document from commandbutton within w_document_properties
integer x = 1047
integer y = 580
integer width = 229
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "View"
end type

event clicked;document.document_view(false)

end event

type cb_pedigree from commandbutton within w_document_properties
integer x = 46
integer y = 1592
integer width = 471
integer height = 104
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Pedigree"
end type

type st_mapping_status_title from statictext within w_document_properties
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
string text = "Mapping Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_mapping_status from statictext within w_document_properties
integer x = 567
integer y = 664
integer width = 457
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
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;document.edit_mappings()
end event

type st_document_created_title from statictext within w_document_properties
integer x = 119
integer y = 580
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
string text = "Doc Created:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_document_created from statictext within w_document_properties
integer x = 567
integer y = 580
integer width = 457
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
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;document.edit_mappings()
end event

type cb_edit_mappings from commandbutton within w_document_properties
integer x = 1047
integer y = 664
integer width = 229
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit"
end type

event clicked;
if current_user.check_privilege("Edit Mappings") then
	document.edit_mappings()
else
	openwithparm(w_pop_message, "You are not authorized to edit interface mappings")
end if

end event

type st_error_message from statictext within w_document_properties
integer x = 1527
integer y = 664
integer width = 1294
integer height = 132
boolean bringtotop = true
integer textsize = -8
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

