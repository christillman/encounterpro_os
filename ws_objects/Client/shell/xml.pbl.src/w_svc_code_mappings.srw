$PBExportHeader$w_svc_code_mappings.srw
forward
global type w_svc_code_mappings from w_window_base
end type
type gb_mapping_filter from groupbox within w_svc_code_mappings
end type
type st_interface_service from statictext within w_svc_code_mappings
end type
type st_code_domain_title from statictext within w_svc_code_mappings
end type
type cb_ok from commandbutton within w_svc_code_mappings
end type
type dw_code_domain from u_dw_pick_list within w_svc_code_mappings
end type
type sle_code_domain_filter from singlelineedit within w_svc_code_mappings
end type
type rb_failed_document from radiobutton within w_svc_code_mappings
end type
type rb_all_mappings from radiobutton within w_svc_code_mappings
end type
type rb_all_document from radiobutton within w_svc_code_mappings
end type
type tab_mappings from u_tab_interface_domain_mappings within w_svc_code_mappings
end type
type tab_mappings from u_tab_interface_domain_mappings within w_svc_code_mappings
end type
type rb_unmapped_is_mappings from radiobutton within w_svc_code_mappings
end type
type rb_all_is_mappings from radiobutton within w_svc_code_mappings
end type
type gb_domain_filter from groupbox within w_svc_code_mappings
end type
end forward

global type w_svc_code_mappings from w_window_base
integer width = 2898
integer height = 1808
string title = "Interface Service Code Mappings"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
gb_mapping_filter gb_mapping_filter
st_interface_service st_interface_service
st_code_domain_title st_code_domain_title
cb_ok cb_ok
dw_code_domain dw_code_domain
sle_code_domain_filter sle_code_domain_filter
rb_failed_document rb_failed_document
rb_all_mappings rb_all_mappings
rb_all_document rb_all_document
tab_mappings tab_mappings
rb_unmapped_is_mappings rb_unmapped_is_mappings
rb_all_is_mappings rb_all_is_mappings
gb_domain_filter gb_domain_filter
end type
global w_svc_code_mappings w_svc_code_mappings

type variables
u_component_service service

long mapping_attachment_id

string code_domain_filter
string code_domain_filter_text
string document_code_domain_filter

string successful_document_mappings
string failed_document_mappings
string all_document_mappings

string successful_codes
string failed_codes
string all_codes

//string code_domain
//
//string mapping_filter
//string document_mapping_filter

end variables

forward prototypes
public function integer refresh ()
public subroutine set_code_domain_filter ()
public function integer initialize_code_domains ()
public subroutine check_code_domain ()
end prototypes

public function integer refresh ();string ls_code_version
long ll_count
long ll_row

setnull(ls_code_version)

//sle_mapping_filter.text = mapping_filter
sle_code_domain_filter.text = code_domain_filter_text

// determine the document based filters
if rb_all_document.checked then
	document_code_domain_filter = "(mapping_count > 0)"
	if not isnull(tab_mappings.document) then
		tab_mappings.document_mapping_filter = "(exists_in_document <> 0)"
	elseif len(all_document_mappings) > 0 then
		tab_mappings.document_mapping_filter = "(code IN (" + all_codes + "))"
	else
		tab_mappings.document_mapping_filter = "(1 = 2)"
	end if
elseif rb_failed_document.checked then
	document_code_domain_filter = "(failed_mapping_count > 0)"
	if not isnull(tab_mappings.document) then
		tab_mappings.document_mapping_filter = "(failed_in_document <> 0)"
	elseif len(failed_document_mappings) > 0 then
		tab_mappings.document_mapping_filter = "(code IN (" + failed_codes + "))"
	else
		tab_mappings.document_mapping_filter = "(1 = 2)"
	end if
else
	document_code_domain_filter = ""
	tab_mappings.document_mapping_filter = ""
end if

if rb_unmapped_is_mappings.checked then
	if len(tab_mappings.document_mapping_filter) > 0 then
		tab_mappings.document_mapping_filter += " and (lower(default_status)='unmapped')"
	else
		tab_mappings.document_mapping_filter = "lower(default_status)='unmapped'"
	end if
end if


set_code_domain_filter()

ll_row = dw_code_domain.get_selected_row()
if ll_row > 0 then
	tab_mappings.code_domain = dw_code_domain.object.code_domain[ll_row]

//	dw_mappings.settransobject(sqlca)
//	ll_count = dw_mappings.retrieve(interface_owner_id, code_domain, ls_code_version)
//
//	set_mapping_filter()
else
	setnull(tab_mappings.code_domain)
end if

tab_mappings.refresh()

return 1

end function

public subroutine set_code_domain_filter ();string ls_description
integer li_len
long ll_row
long i
string ls_filter

ls_filter = ""
if len(code_domain_filter) > 0 then
	ls_filter = code_domain_filter
end if
if len(document_code_domain_filter) > 0 then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += document_code_domain_filter
end if

dw_code_domain.setfilter(ls_filter)
dw_code_domain.filter()

ll_row = dw_code_domain.get_selected_row()
if ll_row <= 0 then
	// We just filtered out the selected domain
	// unselect all the filtered records
	for i = 1 to dw_code_domain.filteredcount( )
		dw_code_domain.object.selected_flag.filter[i] = 0
	next
	// If there is at least one domain then select the first one
	if dw_code_domain.rowcount() >= 1 then
		dw_code_domain.object.selected_flag[1] = 1
		tab_mappings.code_domain = dw_code_domain.object.code_domain[1]
	else
		setnull(tab_mappings.code_domain)
	end if
	tab_mappings.refresh()
end if



end subroutine

public function integer initialize_code_domains ();long ll_code_domain_count
long ll_current_code_domain_count
long ll_current_failed_count
long ll_failed_count
long ll_code_id_count
string lsa_code_id[]
long ll_code_id
long i
string ls_code_domain
string ls_code
string ls_find
long ll_row
string ls_which
u_ds_data luo_data
string ls_status

dw_code_domain.settransobject(sqlca)
ll_code_domain_count = dw_code_domain.retrieve(tab_mappings.interface_owner_id, tab_mappings.document_direction)
if ll_code_domain_count > 0 then
	dw_code_domain.object.selected_flag[1] = 1
end if

successful_codes = ""
failed_codes = ""

if not isnull(tab_mappings.document) then
	luo_data = CREATE u_ds_data
	luo_data.set_dataobject("dw_document_mapping_count_by_status")
	luo_data.retrieve(tab_mappings.document.patient_workplan_item_id)
	for i = 1 to luo_data.rowcount()
		ls_code_domain = luo_data.object.code_domain[i]
		ls_status = luo_data.object.status[i]
		ll_code_domain_count = luo_data.object.mapping_count[i]
		if upper(ls_status) = "FAILED" then
			ll_failed_count = ll_code_domain_count
		else
			ll_failed_count = 0
		end if
		
		ls_find = "lower(code_domain)='" + lower(ls_code_domain) + "'"
		ll_row = dw_code_domain.find(ls_find, 1, dw_code_domain.rowcount())
		if ll_row > 0 then
			ll_current_code_domain_count = dw_code_domain.object.mapping_count[ll_row]
			ll_current_failed_count = dw_code_domain.object.mapping_count[ll_row]
			if ll_current_code_domain_count > 0 then
				ll_code_domain_count += ll_current_code_domain_count
			end if
			if ll_current_failed_count > 0 then
				ll_failed_count += ll_current_failed_count
			end if
			dw_code_domain.object.mapping_count[ll_row] = ll_code_domain_count
			dw_code_domain.object.failed_mapping_count[ll_row] = ll_failed_count
		end if
	next
	
	
	
	DESTROY luo_data
elseif mapping_attachment_id > 0 then
	ls_which = "Failed"
	ll_code_id_count = f_parse_string(failed_document_mappings, ",", lsa_code_id)
	DO WHILE true
		for i = 1 to ll_code_id_count
			if isnumber(lsa_code_id[i]) then
				ll_code_id = long(lsa_code_id[i])
				SELECT code_domain, code
				INTO :ls_code_domain, :ls_code
				FROM c_XML_Code
				WHERE code_id = :ll_code_id;
				if not tf_check() then return -1
				if len(ls_code_domain) > 0 then
					ls_find = "code_domain='" + ls_code_domain + "'"
					ll_row = dw_code_domain.find(ls_find, 1, dw_code_domain.rowcount())
					if ll_row > 0 then
						dw_code_domain.object.mapping_count[ll_row] = dw_code_domain.object.mapping_count[ll_row] + 1
						if ls_which = "Failed" then
							dw_code_domain.object.failed_mapping_count[ll_row] = dw_code_domain.object.mapping_count[ll_row] + 1
						end if
					end if
				end if
				if len(ls_code) > 0 then
					if ls_which = "Failed" then
						if len(failed_codes) > 0 then failed_codes += ","
						failed_codes += "'" + ls_code + "'"
					else
						if len(successful_codes) > 0 then successful_codes += ","
						successful_codes += "'" + ls_code + "'"
					end if
				end if
			end if
		next
		
		if ls_which = "Failed" then
			ls_which = "Successful"
			ll_code_id_count = f_parse_string(successful_document_mappings, ",", lsa_code_id)
		else
			exit
		end if
	LOOP
	
	all_codes = ""
	if len(successful_codes) > 0 then
		all_codes = successful_codes
	end if
	if len(failed_codes) > 0 then
		if len(all_codes) > 0 then all_codes += ","
		all_codes += failed_codes
	end if
else
	luo_data = CREATE u_ds_data
	luo_data.set_dataobject("dw_code_domains_unmapped_only")
	luo_data.retrieve(tab_mappings.interface_owner_id)
	for i = 1 to luo_data.rowcount()
		ls_code_domain = luo_data.object.code_domain[i]
		ls_find = "code_domain='" + ls_code_domain + "'"
		ll_row = dw_code_domain.find(ls_find, 1, dw_code_domain.rowcount())
		if ll_row > 0 then
			dw_code_domain.object.failed_mapping_count[ll_row] = 1
		end if
	next
	DESTROY luo_data
end if

return 1

end function

public subroutine check_code_domain ();long ll_count
long ll_row
string ls_code_domain

ll_row = dw_code_domain.get_selected_row()

if isnull(mapping_attachment_id) and ll_row > 0 then
	ls_code_domain = dw_code_domain.object.code_domain[ll_row]
	
	SELECT count(*)
	INTO :ll_count
	FROM c_XML_Code c
	WHERE owner_id = :tab_mappings.interface_owner_id
	AND code_domain = :ls_code_domain
	AND status = 'Unmapped';
	if not tf_check() then return
	if ll_count > 0 then
		dw_code_domain.object.failed_mapping_count[ll_row] = 1
	else
		dw_code_domain.object.failed_mapping_count[ll_row] = 0
	end if
end if

end subroutine

on w_svc_code_mappings.create
int iCurrent
call super::create
this.gb_mapping_filter=create gb_mapping_filter
this.st_interface_service=create st_interface_service
this.st_code_domain_title=create st_code_domain_title
this.cb_ok=create cb_ok
this.dw_code_domain=create dw_code_domain
this.sle_code_domain_filter=create sle_code_domain_filter
this.rb_failed_document=create rb_failed_document
this.rb_all_mappings=create rb_all_mappings
this.rb_all_document=create rb_all_document
this.tab_mappings=create tab_mappings
this.rb_unmapped_is_mappings=create rb_unmapped_is_mappings
this.rb_all_is_mappings=create rb_all_is_mappings
this.gb_domain_filter=create gb_domain_filter
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_mapping_filter
this.Control[iCurrent+2]=this.st_interface_service
this.Control[iCurrent+3]=this.st_code_domain_title
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.dw_code_domain
this.Control[iCurrent+6]=this.sle_code_domain_filter
this.Control[iCurrent+7]=this.rb_failed_document
this.Control[iCurrent+8]=this.rb_all_mappings
this.Control[iCurrent+9]=this.rb_all_document
this.Control[iCurrent+10]=this.tab_mappings
this.Control[iCurrent+11]=this.rb_unmapped_is_mappings
this.Control[iCurrent+12]=this.rb_all_is_mappings
this.Control[iCurrent+13]=this.gb_domain_filter
end on

on w_svc_code_mappings.destroy
call super::destroy
destroy(this.gb_mapping_filter)
destroy(this.st_interface_service)
destroy(this.st_code_domain_title)
destroy(this.cb_ok)
destroy(this.dw_code_domain)
destroy(this.sle_code_domain_filter)
destroy(this.rb_failed_document)
destroy(this.rb_all_mappings)
destroy(this.rb_all_document)
destroy(this.tab_mappings)
destroy(this.rb_unmapped_is_mappings)
destroy(this.rb_all_is_mappings)
destroy(this.gb_domain_filter)
end on

event open;call super::open;integer li_sts
str_attributes lstr_attributes
long ll_count
string ls_temp
str_popup_return popup_return
long ll_interfaceserviceid
long ll_document_patient_workplan_item_id
long document_patient_workplan_item_id

service = message.powerobjectparm

if not current_user.check_privilege("Edit Mappings") then
	openwithparm(w_pop_message, "You are not authorized to edit interface mappings")
	popup_return.item_count = 1
	popup_return.items[1] = "OK"
	closewithreturn(this, popup_return)
	return
end if

// Resize before initializing so that the radio buttons get grouped
this.event trigger resize(0, width, height)

service.get_attribute("interfaceserviceid", ll_interfaceserviceid)
service.get_attribute("mapping_attachment_id", mapping_attachment_id)
service.get_attribute("document_patient_workplan_item_id", ll_document_patient_workplan_item_id)

if isnull(ll_interfaceserviceid) then
	if isnull(ll_document_patient_workplan_item_id) then
		log.log(this, "w_svc_code_mappings:open", "Either interfaceserviceid or document_patient_workplan_item_id is required", 4)
		popup_return.item_count = 1
		popup_return.items[1] = "ERROR"
		closewithreturn(this, popup_return)
		return
	end if
	
	ll_interfaceserviceid = sqlca.fn_document_interfaceserviceid(ll_document_patient_workplan_item_id)
	if not tf_check() then
		popup_return.item_count = 1
		popup_return.items[1] = "ERROR"
		closewithreturn(this, popup_return)
		return
	end if
end if

setnull(tab_mappings.code_version)

SELECT description, owner_id
INTO :st_interface_service.text, :tab_mappings.interface_owner_id
FROM c_Component_Interface
WHERE interfaceserviceid = :ll_interfaceserviceid;
if not tf_check() then
	popup_return.item_count = 1
	popup_return.items[1] = "ERROR"
	closewithreturn(this, popup_return)
	return
end if
if sqlca.sqlnrows = 0 then
	log.log(this, "w_svc_code_mappings:open", "InterfaceServiceID  not found (" + string(ll_interfaceserviceid) + ")", 4)
	popup_return.item_count = 1
	popup_return.items[1] = "ERROR"
	closewithreturn(this, popup_return)
	return
end if

if tab_mappings.interface_owner_id = sqlca.customer_id then
	st_interface_service.text += " (Local)"
end if

if ll_document_patient_workplan_item_id > 0 then
	tab_mappings.document_direction = "OUT"
	tab_mappings.document = CREATE u_component_wp_item_document
	li_sts = tab_mappings.document.initialize(ll_document_patient_workplan_item_id)
else
	tab_mappings.document_direction = "IN"
	setnull(tab_mappings.document)
end if

if mapping_attachment_id > 0 or not isnull(tab_mappings.document) then
	gb_domain_filter.visible = true
	rb_all_document.visible = true
	rb_all_mappings.visible = true
	rb_failed_document.visible = true
	rb_all_document.checked = true
	
	gb_mapping_filter.visible = true
	rb_all_is_mappings.visible = true
	rb_unmapped_is_mappings.visible = true
	rb_all_is_mappings.checked = true
	
	if mapping_attachment_id > 0 then
		successful_document_mappings = f_get_attachment_progress_value(mapping_attachment_id, "Successful Mappings")
		failed_document_mappings = f_get_attachment_progress_value(mapping_attachment_id, "Failed Mappings")
		all_document_mappings = ""
		if len(successful_document_mappings) > 0 then
			all_document_mappings = successful_document_mappings
		end if
		if len(failed_document_mappings) > 0 then
			if len(all_document_mappings) > 0 then all_document_mappings += ","
			all_document_mappings += failed_document_mappings
		end if
		if len(all_document_mappings) = 0 then
			setnull(all_document_mappings)
		end if
	end if
else
	rb_all_document.visible = false
	rb_all_mappings.visible = false
	rb_failed_document.visible = false
	gb_domain_filter.visible = false
	
	gb_mapping_filter.visible = true
	rb_all_is_mappings.visible = true
	rb_unmapped_is_mappings.visible = true
	rb_all_is_mappings.checked = true
end if

li_sts = initialize_code_domains()
if li_sts < 0 then
	popup_return.item_count = 1
	popup_return.items[1] = "ERROR"
	closewithreturn(this, popup_return)
	return
end if

//dw_mappings.object.compute_owner_code.width = int((dw_mappings.width - 1080) / 2)

code_domain_filter = ""
//mapping_filter = ""

tab_mappings.initialize()

refresh()

postevent("post_open")

end event

event resize;call super::resize;st_interface_service.width = width

gb_domain_filter.x = 32
gb_domain_filter.y = height - gb_domain_filter.height - 132

rb_failed_document.x = gb_domain_filter.x + 40
rb_failed_document.y = gb_domain_filter.y + 80
rb_all_document.x = gb_domain_filter.x + 40
rb_all_document.y = rb_failed_document.y + 80
rb_all_mappings.x = gb_domain_filter.x + 40
rb_all_mappings.y = rb_all_document.y + 80


gb_mapping_filter.x = tab_mappings.x
gb_mapping_filter.y = gb_domain_filter.y
gb_mapping_filter.width = rb_unmapped_is_mappings.width + 80
gb_mapping_filter.height = gb_domain_filter.height

rb_unmapped_is_mappings.x = gb_mapping_filter.x + 40
rb_unmapped_is_mappings.y = rb_failed_document.y
rb_all_is_mappings.x = gb_mapping_filter.x + 40
rb_all_is_mappings.y = rb_unmapped_is_mappings.y + 80

cb_ok.x = width - cb_ok.width - 50
cb_ok.y = height - cb_ok.height - 150

tab_mappings.width = width - tab_mappings.x - 50
tab_mappings.height = gb_domain_filter.y - tab_mappings.y - 30


dw_code_domain.height = gb_domain_filter.y - 30 - dw_code_domain.y

end event

event post_open;call super::post_open;if tab_mappings.document_direction = "IN" then
	tab_mappings.selecttab(1)
elseif tab_mappings.document_direction = "OUT" then
	tab_mappings.selecttab(2)
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_code_mappings
integer x = 2830
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_code_mappings
integer x = 0
integer y = 1112
end type

type gb_mapping_filter from groupbox within w_svc_code_mappings
integer x = 983
integer y = 1460
integer width = 1074
integer height = 400
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Mappings"
end type

type st_interface_service from statictext within w_svc_code_mappings
integer width = 2903
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Interface Service ###"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_code_domain_title from statictext within w_svc_code_mappings
integer x = 37
integer y = 124
integer width = 663
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Code Domain     Filter:"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_svc_code_mappings
integer x = 2432
integer y = 1584
integer width = 402
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return popup_return


popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type dw_code_domain from u_dw_pick_list within w_svc_code_mappings
integer x = 23
integer y = 192
integer width = 1047
integer height = 1136
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_c_xml_code_domain"
boolean vscrollbar = true
end type

event selected;call super::selected;
refresh()

end event

type sle_code_domain_filter from singlelineedit within w_svc_code_mappings
event key_up pbm_keyup
integer x = 704
integer y = 96
integer width = 370
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event key_up;string ls_filter

if len(this.text) > 0 then
	code_domain_filter_text = this.text
	ls_filter = "(lower(code_domain) like '" + lower(code_domain_filter_text) + "%')"
else
	code_domain_filter_text = ""
	ls_filter = ""
end if

if code_domain_filter <> ls_filter then
	code_domain_filter = ls_filter
	set_code_domain_filter()
end if


end event

type rb_failed_document from radiobutton within w_svc_code_mappings
integer x = 69
integer y = 1432
integer width = 823
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Failed Document Mappings"
end type

event clicked;refresh()

end event

type rb_all_mappings from radiobutton within w_svc_code_mappings
integer x = 69
integer y = 1592
integer width = 823
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "All Mappings"
end type

event clicked;refresh()

end event

type rb_all_document from radiobutton within w_svc_code_mappings
integer x = 69
integer y = 1512
integer width = 823
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "All Document Mappings"
end type

event clicked;refresh()

end event

type tab_mappings from u_tab_interface_domain_mappings within w_svc_code_mappings
integer x = 1102
integer y = 112
integer width = 1769
integer taborder = 20
boolean bringtotop = true
end type

event mappingchanged;call super::mappingchanged;check_code_domain()
end event

type rb_unmapped_is_mappings from radiobutton within w_svc_code_mappings
integer x = 1120
integer y = 1540
integer width = 581
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Unmapped Only"
end type

event clicked;refresh()

end event

type rb_all_is_mappings from radiobutton within w_svc_code_mappings
integer x = 1134
integer y = 1644
integer width = 581
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "All Mappings"
end type

event clicked;refresh()

end event

type gb_domain_filter from groupbox within w_svc_code_mappings
integer x = 32
integer y = 1356
integer width = 923
integer height = 332
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Domains"
end type

