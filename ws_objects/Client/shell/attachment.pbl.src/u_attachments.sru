$PBExportHeader$u_attachments.sru
forward
global type u_attachments from userobject
end type
type pb_new_attachments from u_picture_button within u_attachments
end type
type st_page from statictext within u_attachments
end type
type pb_down from u_picture_button within u_attachments
end type
type pb_up from u_picture_button within u_attachments
end type
type dw_attachments from u_dw_pick_list within u_attachments
end type
end forward

global type u_attachments from userobject
integer width = 2862
integer height = 1352
long backcolor = 7191717
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event first_attachment ( long pl_attachment_id )
event ue_clicked ( )
event refreshed ( )
pb_new_attachments pb_new_attachments
st_page st_page
pb_down pb_down
pb_up pb_up
dw_attachments dw_attachments
end type
global u_attachments u_attachments

type variables
boolean 	initialized = false
String	attachment_folder
String	attachment_service
String	attachment_tag
string progress_type
string progress_key
String	new_attachment_folder


string context_object
long object_key


string tab_title = "Attachments"


end variables

forward prototypes
private subroutine initialize ()
public function integer display_attachments ()
public subroutine display ()
public function integer delete_attachment ()
public function integer delete_record ()
public function integer refresh (string ps_attachment_folder)
public function integer refresh ()
public function string get_progress_type ()
public subroutine display_image ()
public subroutine display_properties ()
public subroutine edit ()
public function integer initialize (string ps_context_object, string ps_attachment_tag, long pl_object_key)
public function integer initialize (string ps_context_object, long pl_object_key)
public function integer initialize (string ps_context_object, string ps_attachment_tag, long pl_object_key, string ps_attachment_folder)
public function integer initialize (string ps_context_object, string ps_attachment_tag, long pl_object_key, string ps_attachment_folder, string ps_progress_type, string ps_progress_key, string ps_new_attachment_folder)
end prototypes

event ue_clicked();long ll_row
long ll_attachment_id

ll_row = dw_attachments.get_selected_row()
If ll_row > 0 Then
	ll_attachment_id = dw_attachments.object.attachment_id[ll_row]
	current_patient.attachments.menu(ll_attachment_id, context_object, object_key)
End If

refresh()

end event

private subroutine initialize ();
dw_attachments.x = 0
dw_attachments.y = 0
dw_attachments.width = width - pb_new_attachments.width - 24
dw_attachments.height = height

pb_new_attachments.x = dw_attachments.width + 12
pb_down.x = pb_new_attachments.x
pb_up.x = pb_new_attachments.x
st_page.x = pb_new_attachments.x

pb_up.y = 12
pb_down.y = pb_up.y + pb_up.height + 12
st_page.y = pb_down.y + pb_down.height + 12
pb_new_attachments.y = st_page.y + st_page.height + 150


dw_attachments.object.t_back.width = dw_attachments.width - 120
//pb_up.x = width - pb_up.width
//pb_up.y = 0
////pb_down.x = pb_up.x
//pb_down.y = height - pb_down.height

dw_attachments.Settransobject(SQLCA)
Setnull(attachment_folder)
Setnull(new_attachment_folder)
Setnull(attachment_tag)
Setnull(progress_type)
Setnull(progress_key)

end subroutine

public function integer display_attachments ();Long ll_rows
string ls_filter

dw_attachments.Setredraw(false)
dw_attachments.reset()
dw_attachments.Setfilter("")
dw_attachments.Filter()

ll_rows = dw_attachments.retrieve(current_patient.cpr_id, context_object, object_key)
If not tf_check() Then Return -1

ls_filter = ""

// Is any attachment folder filter??
If Len(attachment_folder) > 0 Then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "attachment_folder='"+attachment_folder+"'"
elseif context_object = "Patient" and isnull(progress_type) and isnull(progress_key) then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "(isnull(folder_status) or upper(folder_status) = 'OK')"
end if

if context_object = "Patient" then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "upper(attachment_type)<>'SIGNATURE'"
End If

// Is any progress_type filter ??
If Len(progress_type) > 0 Then 
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "progress_type='"+progress_type+"'"
End If

// Is any progress_key filter ??
If Len(progress_key) > 0 Then 
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "progress_key='"+progress_key+"'"
End If

dw_attachments.Setfilter(ls_filter)
dw_attachments.Filter()

// Up & Down Buttons
dw_attachments.last_page = 0
dw_attachments.set_page(1, pb_up,pb_down,st_page)

dw_attachments.Setredraw(true)

ll_rows = dw_attachments.rowcount()

if ll_rows <= 0 then
	text = tab_title
else
	text = tab_title + " (" + string(ll_rows) + ")"
end if

Return ll_rows


end function

public subroutine display ();Long		ll_attachment_id,ll_row

ll_row = dw_attachments.get_selected_row()
If ll_row > 0 Then
	ll_attachment_id = dw_attachments.object.attachment_id[ll_row]
	f_display_attachment(ll_attachment_id)
End If

display_attachments()

end subroutine

public function integer delete_attachment ();long ll_attachment_id,ll_row
string ls_progress_type
string ls_progress_key
datetime ldt_progress_date_time
string ls_progress
long ll_risk_level

setnull(ls_progress)
setnull(ll_risk_level)

ll_row = dw_attachments.get_selected_row()
If ll_row > 0 then
	ll_attachment_id = dw_attachments.object.attachment_id[ll_row]
	ls_progress_type = dw_attachments.object.progress_type[ll_row]
	ls_progress_key = dw_attachments.object.progress_key[ll_row]
	ldt_progress_date_time = dw_attachments.object.progress_date_time[ll_row]
	current_patient.attachments.add_progress(ll_attachment_id,"DELETED","attachment deleted")
	
	CHOOSE CASE lower(context_object)
		CASE "patient"
			current_patient.set_progress( ls_progress_type, ls_progress_key, ldt_progress_date_time, ls_progress, ll_risk_level)
		CASE "encounter"
			current_patient.encounters.set_encounter_progress(object_key, ls_progress_type, ls_progress_key, ls_progress, ll_risk_level, ldt_progress_date_time)
		CASE "assessment"
			current_patient.assessments.set_progress(object_key, ls_progress_type, ls_progress_key, ls_progress, ll_risk_level, ldt_progress_date_time)
		CASE "treatment"
			current_patient.treatments.set_treatment_progress(object_key, ls_progress_type, ls_progress_key, ls_progress, ldt_progress_date_time, ll_risk_level)
	END CHOOSE
End If

return display_attachments()



end function

public function integer delete_record ();Long ll_row

ll_row = dw_attachments.get_selected_row()
If ll_row > 0 Then
 dw_attachments.deleterow(ll_row)
End If

Return dw_attachments.rowcount()


end function

public function integer refresh (string ps_attachment_folder);attachment_folder = ps_attachment_folder
Return display_attachments()


end function

public function integer refresh ();integer li_sts

li_sts = display_attachments()

this.event POST refreshed()

return li_sts

end function

public function string get_progress_type ();str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

if not isnull(progress_type) then return progress_type
return "Attachment"

//CHOOSE CASE lower(attachment_object)
//	CASE "patient"
//		return "Attachment"
////		popup.dataobject = "dw_patient_progress_type_pick"
////		popup.argument[1] = 
//	CASE "encounter"
//		popup.dataobject = "dw_encounter_progress_type_pick"
//		popup.argument[1] = current_patient.encounters.encounter_type(atch_encounter_id)
//	CASE "assessment"
//		popup.dataobject = "dw_assessment_progress_type_pick"
//		popup.argument[1] = current_patient.assessments.assessment_type(atch_problem_id)
//	CASE "treatment"
//		popup.dataobject = "dw_treatment_progress_type_pick"
//		popup.argument[1] = current_patient.treatments.treatment_type(atch_treatment_id)
//	CASE "observation"
//		return "Attachment"
////		popup.dataobject = "dw_treatment_progress_type_pick"
////		popup.argument[1] = current_patient.encounters.encounter_type(atch_encounter_id)
//	CASE ELSE
//		return ls_null
//END CHOOSE
//
//popup.datacolumn = 2
//popup.displaycolumn = 2
//popup.argument_count = 1
//popup.auto_singleton = true
//openwithparm(w_pop_pick, popup)
//popup_return = message.powerobjectparm
//if popup_return.item_count <> 1 then return ls_null
//
//return popup_return.items[1]
//
//
end function

public subroutine display_image ();Long		ll_attachment_id,ll_row
oleobject luo_ImageViewer
integer li_sts

ll_row = dw_attachments.get_selected_row()
If ll_row > 0 Then
	ll_attachment_id = dw_attachments.object.attachment_id[ll_row]
	f_display_attachment_image(ll_attachment_id)
End If


end subroutine

public subroutine display_properties ();Long		ll_attachment_id,ll_row
u_component_attachment luo_attachment
integer li_sts

ll_row = dw_attachments.get_selected_row()
If ll_row > 0 Then
	ll_attachment_id = dw_attachments.object.attachment_id[ll_row]
	li_sts = current_patient.attachments.attachment(luo_attachment, ll_attachment_id)
	if li_sts <= 0 then
		log.log(this, "u_attachments.display_properties:0010", "Error getting attachment object", 4)
		return
	end if
	openwithparm(w_attachment_properties, luo_attachment)
	component_manager.destroy_component(luo_attachment)
End If

display_attachments()

end subroutine

public subroutine edit ();Long		ll_attachment_id,ll_row

ll_row = dw_attachments.get_selected_row()
If ll_row > 0 Then
	ll_attachment_id = dw_attachments.object.attachment_id[ll_row]
	f_edit_attachment(ll_attachment_id)
End If

display_attachments()

end subroutine

public function integer initialize (string ps_context_object, string ps_attachment_tag, long pl_object_key);initialize(ps_context_object, pl_object_key)
attachment_tag = ps_attachment_tag

Return 1


end function

public function integer initialize (string ps_context_object, long pl_object_key);initialize()

context_object = ps_context_object
object_key = pl_object_key

Return 1
end function

public function integer initialize (string ps_context_object, string ps_attachment_tag, long pl_object_key, string ps_attachment_folder);
initialize(ps_context_object, pl_object_key)

attachment_tag = ps_attachment_tag
attachment_folder = ps_attachment_folder

Return 1


end function

public function integer initialize (string ps_context_object, string ps_attachment_tag, long pl_object_key, string ps_attachment_folder, string ps_progress_type, string ps_progress_key, string ps_new_attachment_folder);
initialize(ps_context_object, pl_object_key)

attachment_tag = ps_attachment_tag
attachment_folder = ps_attachment_folder
progress_type = ps_progress_type
progress_key = ps_progress_key
new_attachment_folder = ps_new_attachment_folder

Return 1


end function

on u_attachments.create
this.pb_new_attachments=create pb_new_attachments
this.st_page=create st_page
this.pb_down=create pb_down
this.pb_up=create pb_up
this.dw_attachments=create dw_attachments
this.Control[]={this.pb_new_attachments,&
this.st_page,&
this.pb_down,&
this.pb_up,&
this.dw_attachments}
end on

on u_attachments.destroy
destroy(this.pb_new_attachments)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.dw_attachments)
end on

type pb_new_attachments from u_picture_button within u_attachments
integer x = 2537
integer y = 428
integer width = 146
integer height = 124
integer taborder = 50
string picturename = "icon_new.bmp"
string disabledname = "icon_new.bmp"
end type

event clicked;Integer li_sts
String ls_cpr_id
Long	 ll_encounter_id
string ls_progress_type
string ls_attachment_folder

str_attributes lstra_attributes

setnull(ll_encounter_id)

If isnull(current_patient) Then
	log.log(this,"u_attachments.pb_new_attachments.clicked:0012","Attachments can't be created without valid patient context",3)
	Return
End If
If Not isnull(current_patient.open_encounter) Then
	// except patient attach. everything else need valid encounter
	ll_encounter_id = current_patient.open_encounter.encounter_id
End If

If isnull(attachment_service) Or Len(attachment_service) = 0 Then &
	attachment_service = "EXTERNAL_SOURCE"

ls_progress_type = get_progress_type()
if isnull(ls_progress_type) then return

f_attribute_add_attribute(lstra_attributes, "attachment_context_object", context_object)

ls_attachment_folder = new_attachment_folder
if isnull(ls_attachment_folder) then ls_attachment_folder = attachment_folder

if not isnull(object_key) then f_attribute_add_attribute(lstra_attributes, "attachment_object_key", string(object_key))
if not isnull(ls_attachment_folder) then f_attribute_add_attribute(lstra_attributes, "attachment_folder", ls_attachment_folder)
if not isnull(attachment_tag) then f_attribute_add_attribute(lstra_attributes, "comment_title", attachment_tag)
if not isnull(ls_progress_type) then f_attribute_add_attribute(lstra_attributes, "progress_type", ls_progress_type)
if not isnull(progress_key) then f_attribute_add_attribute(lstra_attributes, "progress_key", progress_key)

li_sts = service_list.do_service(attachment_service,lstra_attributes)
If li_sts <= 0 Then Return

refresh()


end event

type st_page from statictext within u_attachments
integer x = 2537
integer y = 260
integer width = 142
integer height = 116
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_down from u_picture_button within u_attachments
integer x = 2537
integer y = 136
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_attachments.current_page
li_last_page = dw_attachments.last_page

dw_attachments.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type pb_up from u_picture_button within u_attachments
integer x = 2537
integer y = 12
integer width = 146
integer height = 124
integer taborder = 20
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_attachments.current_page

dw_attachments.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type dw_attachments from u_dw_pick_list within u_attachments
integer width = 2478
integer height = 1280
integer taborder = 30
string dataobject = "dw_attachments"
boolean vscrollbar = true
end type

event clicked;call super::clicked;if get_selected_row() > 0 Then parent.event post ue_clicked()
end event

