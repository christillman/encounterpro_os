$PBExportHeader$u_tabpage_interface_code_mappings.sru
forward
global type u_tabpage_interface_code_mappings from u_tabpage
end type
type cb_clear_filter from commandbutton within u_tabpage_interface_code_mappings
end type
type dw_mappings from u_dw_pick_list within u_tabpage_interface_code_mappings
end type
type st_filter_title from statictext within u_tabpage_interface_code_mappings
end type
type sle_mapping_filter from singlelineedit within u_tabpage_interface_code_mappings
end type
end forward

global type u_tabpage_interface_code_mappings from u_tabpage
string tag = "BY CODE"
cb_clear_filter cb_clear_filter
dw_mappings dw_mappings
st_filter_title st_filter_title
sle_mapping_filter sle_mapping_filter
end type
global u_tabpage_interface_code_mappings u_tabpage_interface_code_mappings

type variables
u_tab_interface_domain_mappings mytab

string mapping_filter

string last_code_domain

string code_dataobject = "dw_xml_code_domain_codes"
string epro_id_dataobject = "dw_fn_xml_epro_domain_ids"

string edit_which // "code" or "epro_id"
end variables

forward prototypes
public subroutine edit_mappings (long pl_row)
public function integer initialize ()
public subroutine refresh ()
public subroutine set_mapping_filter (string ps_new_mapping_filter)
end prototypes

public subroutine edit_mappings (long pl_row);str_c_xml_code lstr_mapping


if pl_row <= 0 then return

lstr_mapping = f_empty_xml_code()

if tag = "BY CODE" then
	lstr_mapping.owner_id = mytab.interface_owner_id
	lstr_mapping.code_domain = mytab.code_domain
	lstr_mapping.code_version = mytab.code_version
	lstr_mapping.code = dw_mappings.object.code[pl_row]
	lstr_mapping.code_description = dw_mappings.object.code_description[pl_row]
	lstr_mapping.epro_domain = dw_mappings.object.epro_domain[pl_row]
else
	lstr_mapping.owner_id = mytab.interface_owner_id
	lstr_mapping.code_domain = mytab.code_domain
	lstr_mapping.code_version = mytab.code_version
	lstr_mapping.epro_id = dw_mappings.object.epro_id[pl_row]
	lstr_mapping.epro_description = dw_mappings.object.epro_description[pl_row]
	lstr_mapping.epro_domain = dw_mappings.object.epro_domain[pl_row]
end if

openwithparm(w_xml_code_mapping_edit, lstr_mapping)


refresh()

mytab.event POST mappingchanged()

return

end subroutine

public function integer initialize ();long ll_total

mytab = parent_tab

dw_mappings.width = width
dw_mappings.height = height - 130

st_filter_title.y = dw_mappings.height + 20
sle_mapping_filter.y = st_filter_title.y
cb_clear_filter.y = sle_mapping_filter.y + sle_mapping_filter.height - cb_clear_filter.height

ll_total = st_filter_title.width + sle_mapping_filter.width + cb_clear_filter.width + 20

st_filter_title.x = (width - ll_total) / 2
sle_mapping_filter.x = st_filter_title.x + st_filter_title.width
cb_clear_filter.x = sle_mapping_filter.x + sle_mapping_filter.width + 20

dw_mappings.object.compute_owner_code.width = int((dw_mappings.width - 1080) / 2)

return 1

end function

public subroutine refresh ();long ll_patient_workplan_item_id
long ll_count

if tag = "BY CODE" then
	if edit_which <> "epro_id" then setnull(last_code_domain)
	dw_mappings.dataobject = code_dataobject
	edit_which = "epro_id"
else
	if edit_which <> "code" then setnull(last_code_domain)
	dw_mappings.dataobject = epro_id_dataobject
	edit_which = "code"
end if

if isnull(mytab.document) or not isvalid(mytab.document) then
	ll_patient_workplan_item_id = 0
else
	ll_patient_workplan_item_id = mytab.document.patient_workplan_item_id
end if

if isnull(mytab.code_domain) then
	dw_mappings.reset()
	return
else
	if isnull(last_code_domain) or mytab.code_domain <> last_code_domain then
		sle_mapping_filter.text = ""
		mapping_filter = ""
	end if
	set_mapping_filter(mapping_filter)
	dw_mappings.settransobject(sqlca)
	ll_count = dw_mappings.retrieve(mytab.interface_owner_id, mytab.code_domain, ll_patient_workplan_item_id)
end if

last_code_domain = mytab.code_domain


return

end subroutine

public subroutine set_mapping_filter (string ps_new_mapping_filter);string ls_description
integer li_len
string ls_filter

mapping_filter = ps_new_mapping_filter

ls_filter = ""
if len(mapping_filter) > 0 then
	ls_filter = mapping_filter
end if

if len(mytab.document_mapping_filter) > 0 then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += mytab.document_mapping_filter
end if

dw_mappings.setfilter(ls_filter)
dw_mappings.filter()


return

end subroutine

on u_tabpage_interface_code_mappings.create
int iCurrent
call super::create
this.cb_clear_filter=create cb_clear_filter
this.dw_mappings=create dw_mappings
this.st_filter_title=create st_filter_title
this.sle_mapping_filter=create sle_mapping_filter
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_clear_filter
this.Control[iCurrent+2]=this.dw_mappings
this.Control[iCurrent+3]=this.st_filter_title
this.Control[iCurrent+4]=this.sle_mapping_filter
end on

on u_tabpage_interface_code_mappings.destroy
call super::destroy
destroy(this.cb_clear_filter)
destroy(this.dw_mappings)
destroy(this.st_filter_title)
destroy(this.sle_mapping_filter)
end on

type cb_clear_filter from commandbutton within u_tabpage_interface_code_mappings
integer x = 1189
integer y = 1252
integer width = 197
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;sle_mapping_filter.text = ""
set_mapping_filter("")

end event

type dw_mappings from u_dw_pick_list within u_tabpage_interface_code_mappings
integer width = 1659
integer height = 1216
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_xml_code_domain_codes"
boolean vscrollbar = true
end type

event buttonclicked;call super::buttonclicked;
CHOOSE CASE lower(dwo.name)
	CASE "b_edit"
		edit_mappings(row)
END CHOOSE

clear_selected()

return

end event

event selected;call super::selected;long ll_mapping_owner_id
long ll_mapping_count
long ll_code_id
long ll_new_code_id
string ls_code
long ll_owner_id
string ls_code_domain
string ls_code_version
string ls_code_description
string ls_epro_description
long ll_epro_owner_id
string ls_epro_domain
string ls_param_class
string ls_epro_id
string ls_status
string ls_mapping_owner_status

CHOOSE CASE lower(lastcolumnname)
	CASE "compute_epro_code"
		// Make sure the user can edit the default code
		ll_mapping_owner_id = object.default_mapping_owner_id[selected_row]
		ll_mapping_count = object.mapping_count[selected_row]
		if ll_mapping_owner_id <> sqlca.customer_id and ll_mapping_count > 0 then return
		
		ll_code_id = object.default_code_id[selected_row]
		
		ll_new_code_id = f_edit_mapping(ll_code_id, edit_which)
		if ll_new_code_id > 0 then
			// refresh row to display new mapping

			SELECT c.owner_id, c.code_domain, c.code_version, c.code, c.code_description, c.epro_domain, c.epro_id, c.epro_description, c.epro_owner_id, c.mapping_owner_id, c.status
			INTO :ll_owner_id, :ls_code_domain, :ls_code_version, :ls_code, :ls_code_description, :ls_epro_domain, :ls_epro_id, :ls_epro_description, :ll_epro_owner_id, :ll_mapping_owner_id, :ls_status
			FROM c_XML_Code c
			WHERE c.code_id = :ll_new_code_id;
			if not tf_check() then return
			if sqlca.sqlnrows < 1 then
				log.log(this, "u_tabpage_interface_code_mappings.dw_mappings.selected:0037", "code_id not found (" + string(ll_new_code_id) + ")", 4)
				return
			end if
			
			if tag = "BY CODE" then
				object.default_epro_id[selected_row] = ls_epro_id
				object.default_epro_description[selected_row] = ls_epro_description
				object.default_epro_owner_id[selected_row] = ll_epro_owner_id
			else
				object.default_code[selected_row] = ls_code
				object.default_code_description[selected_row] = ls_code_description
			end if
			object.default_code_id[selected_row] = ll_new_code_id
			object.default_mapping_owner_id[selected_row] = ll_mapping_owner_id
			if ll_mapping_owner_id = sqlca.customer_id then
				ls_mapping_owner_status = "Local"
			elseif ll_mapping_owner_id = 0 then
				ls_mapping_owner_status = "EncounterPRO"
			else
				ls_mapping_owner_status = "Interface"
			end if
			object.default_mapping_owner_status[selected_row] = ls_mapping_owner_status
			object.default_status[selected_row] = ls_status
			
			object.mapping_count[selected_row] = 1
			
			mytab.event POST mappingchanged()
		end if
END CHOOSE

clear_selected()


end event

type st_filter_title from statictext within u_tabpage_interface_code_mappings
integer x = 174
integer y = 1228
integer width = 187
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Filter:"
boolean focusrectangle = false
end type

type sle_mapping_filter from singlelineedit within u_tabpage_interface_code_mappings
event key_up pbm_keyup
integer x = 361
integer y = 1228
integer width = 814
integer height = 88
integer taborder = 10
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

if len(sle_mapping_filter.text) > 0 then
	ls_filter = "(lower(compute_owner_code) like '%" + lower(this.text) + "%')"
	ls_filter += " OR (lower(epro_domain) like '%" + lower(this.text) + "%')"
	ls_filter += " OR (lower(compute_epro_code) like '%" + lower(this.text) + "%')"
else
	ls_filter = ""
end if

// If the mapping filter has changed the set the new one
if mapping_filter <> ls_filter then
	set_mapping_filter(ls_filter)
end if



end event

