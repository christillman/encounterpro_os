$PBExportHeader$w_post_attachment.srw
forward
global type w_post_attachment from w_window_base
end type
type dw_post_to from u_dw_pick_list within w_post_attachment
end type
type st_remove_title from statictext within w_post_attachment
end type
type st_2 from statictext within w_post_attachment
end type
type uo_image from u_picture_display within w_post_attachment
end type
type st_remove_yes from statictext within w_post_attachment
end type
type st_remove_no from statictext within w_post_attachment
end type
type cb_done from commandbutton within w_post_attachment
end type
type cb_cancel from commandbutton within w_post_attachment
end type
type st_apply_title from statictext within w_post_attachment
end type
type st_apply_yes from statictext within w_post_attachment
end type
type st_apply_no from statictext within w_post_attachment
end type
end forward

global type w_post_attachment from w_window_base
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event post_open pbm_custom01
dw_post_to dw_post_to
st_remove_title st_remove_title
st_2 st_2
uo_image uo_image
st_remove_yes st_remove_yes
st_remove_no st_remove_no
cb_done cb_done
cb_cancel cb_cancel
st_apply_title st_apply_title
st_apply_yes st_apply_yes
st_apply_no st_apply_no
end type
global w_post_attachment w_post_attachment

type variables
u_ds_attachments attachments

str_folder_selection_info folder_selection_info

str_attachment_context attachment_context

string attachment_file
string rendered_attachment_file

end variables

forward prototypes
public function integer load_post_to_list ()
public function integer post_to_folder (long pl_row)
public function integer post_to_folder (string ps_folder, string ps_context_object, string ps_context_object_type)
end prototypes

event post_open;
uo_image.display_picture(rendered_attachment_file)


end event

public function integer load_post_to_list ();Long 		ll_folder_count

dw_post_to.settransobject(sqlca)
ll_folder_count = dw_post_to.retrieve()
if ll_folder_count < 0 then return -1

Return 1


end function

public function integer post_to_folder (long pl_row);String ls_folder
String ls_context_object
String ls_context_object_type

if isnull(pl_row) or pl_row <= 0 then return 0

ls_folder = dw_post_to.object.folder[pl_row]
ls_context_object = dw_post_to.object.context_object[pl_row]
ls_context_object_type = dw_post_to.object.context_object_type[pl_row]

return post_to_folder(ls_folder, ls_context_object, ls_context_object_type)

end function

public function integer post_to_folder (string ps_folder, string ps_context_object, string ps_context_object_type);Long					ll_treatment_id
String				ls_progress_type
Integer				li_object_index
str_popup popup
str_popup_return 	popup_return
integer li_sts
string ls_default_attachment_description
string ls_temp
boolean lb_prompt_user

attachment_context.folder = ps_folder
attachment_context.context_object = ps_context_object
attachment_context.context_object_type = ps_context_object_type

if lower(attachment_context.context_object) = lower(folder_selection_info.context_object) then
	// If we're posting to the same context_object as we came from, then set the key the same
	attachment_context.object_key = folder_selection_info.object_key
	
	// Get the description based on the object
	CHOOSE CASE lower(attachment_context.context_object)
		CASE "encounter", "assessment", "treatment"
			attachment_context.description = sqlca.fn_patient_object_description( attachment_context.cpr_id, &
																											attachment_context.context_object, &
																											attachment_context.object_key)
		CASE ELSE
			if lower(folder_selection_info.extension) = "xml" then
				attachment_context.description = folder_selection_info.description
			else
				if gnv_app.cpr_mode = "CLIENT" then
					// Find out if this folder should preserve the attachment
					// description or default it to the folder name
					SELECT max(value)
					INTO :ls_default_attachment_description
					FROM c_Folder_Attribute
					WHERE folder = :attachment_context.folder
					AND attribute = 'Default Attachment Description';
					if not tf_check() then return -1
					if sqlca.sqlcode = 100 then ls_default_attachment_description = attachment_context.folder
					if isnull(ls_default_attachment_description) or trim(ls_default_attachment_description) = "" then ls_default_attachment_description = attachment_context.folder

					// See if the default description should be the original attachment description (presumably from the external source)
					if lower(ls_default_attachment_description) = "%attachment tag%" then
						ls_default_attachment_description = folder_selection_info.description
					end if

					SELECT max(value)
					INTO :ls_temp
					FROM c_Folder_Attribute
					WHERE folder = :attachment_context.folder
					AND attribute = 'Always Prompt';
					if not tf_check() then return -1
					if sqlca.sqlcode = 100 then ls_temp = "True"
					
					lb_prompt_user = f_string_to_boolean(ls_temp)
					
					if lb_prompt_user or isnull(ls_default_attachment_description) or ls_default_attachment_description = "" then
						// Either this folder is configured to always prompt, or a default description was not found
						popup.item = ls_default_attachment_description
						
						popup.title = "Enter Description:"
						popup.argument_count = 1
						popup.argument[1] = "POST|" + attachment_context.folder
						openwithparm(w_pop_prompt_string, popup)
						popup_return = message.powerobjectparm
						if popup_return.item_count <> 1 then
							return 0
						else
							attachment_context.description = popup_return.items[1]
						end if
					else
						// If we don't need to prompt for the description, just set it to the default
						attachment_context.description = ls_default_attachment_description
					end if
				else
					if len(folder_selection_info.description) > 0 then
						attachment_context.description = folder_selection_info.description
					else
						attachment_context.description = attachment_context.folder
					end if
				end if
			end if
	END CHOOSE
else
	// If we're posting to a different context_object, then pick the context object
	CHOOSE CASE lower(attachment_context.context_object)
		CASE "encounter","assessment","treatment"
			if gnv_app.cpr_mode = "CLIENT" then
				attachment_context.posting_file = true
				openwithparm(w_post_attachment_to_object, attachment_context)
				attachment_context = message.powerobjectparm
				if isnull(attachment_context.object_key) then return 0
			else
				log.log(this, "w_post_attachment.post_to_folder:0093", "Cannot assign object key in server mode", 4)
				return 0
			end if
		CASE ELSE
			if gnv_app.cpr_mode = "CLIENT" then
				popup.title = "Enter Description:"
				popup.item = attachment_context.folder
				popup.argument_count = 1
				popup.argument[1] = "POST|" + attachment_context.folder
				openwithparm(w_pop_prompt_string, popup)
				popup_return = message.powerobjectparm
				if popup_return.item_count <> 1 then
					return 0
				else
					attachment_context.description = popup_return.items[1]
				end if
			else
				attachment_context.description = attachment_context.folder
			end if
	END CHOOSE
end if


li_sts = f_get_attachment_workplan(attachment_context)
if li_sts <= 0 then return 0

return 1


end function

on w_post_attachment.create
int iCurrent
call super::create
this.dw_post_to=create dw_post_to
this.st_remove_title=create st_remove_title
this.st_2=create st_2
this.uo_image=create uo_image
this.st_remove_yes=create st_remove_yes
this.st_remove_no=create st_remove_no
this.cb_done=create cb_done
this.cb_cancel=create cb_cancel
this.st_apply_title=create st_apply_title
this.st_apply_yes=create st_apply_yes
this.st_apply_no=create st_apply_no
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_post_to
this.Control[iCurrent+2]=this.st_remove_title
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.uo_image
this.Control[iCurrent+5]=this.st_remove_yes
this.Control[iCurrent+6]=this.st_remove_no
this.Control[iCurrent+7]=this.cb_done
this.Control[iCurrent+8]=this.cb_cancel
this.Control[iCurrent+9]=this.st_apply_title
this.Control[iCurrent+10]=this.st_apply_yes
this.Control[iCurrent+11]=this.st_apply_no
end on

on w_post_attachment.destroy
call super::destroy
destroy(this.dw_post_to)
destroy(this.st_remove_title)
destroy(this.st_2)
destroy(this.uo_image)
destroy(this.st_remove_yes)
destroy(this.st_remove_no)
destroy(this.cb_done)
destroy(this.cb_cancel)
destroy(this.st_apply_title)
destroy(this.st_apply_yes)
destroy(this.st_apply_no)
end on

event open;call super::open;str_popup popup
long ll_folder_count
string ls_find
long ll_row
integer li_sts
string ls_context_object
string ls_context_object_type

folder_selection_info = message.powerobjectparm

// The initialize the other settings
attachment_context.user_cancelled = false

if len(folder_selection_info.cpr_id) > 0 then
	attachment_context.cpr_id = folder_selection_info.cpr_id
elseif isnull(current_patient) then
	setnull(attachment_context.cpr_id)
else
	attachment_context.cpr_id = current_patient.cpr_id
end if

attachment_file = folder_selection_info.filepath
rendered_attachment_file = folder_selection_info.rendered_filepath
if isnull(rendered_attachment_file) or trim(rendered_attachment_file) = "" then
	rendered_attachment_file = attachment_file
end if

CHOOSE CASE upper(folder_selection_info.apply_to_all_flag)
	CASE "Y"
		st_apply_yes.backcolor = color_object_selected
		attachment_context.apply_to_all = true
	CASE "N"
		st_apply_no.backcolor = color_object_selected
		attachment_context.apply_to_all = false
	CASE ELSE
		st_apply_title.visible = false
		st_apply_yes.visible = false	
		st_apply_no.visible = false
		attachment_context.apply_to_all = false
END CHOOSE

CHOOSE CASE upper(folder_selection_info.remove_flag)
	CASE "Y"
		st_remove_yes.backcolor = color_object_selected
		attachment_context.remove = true
	CASE "N"
		st_remove_no.backcolor = color_object_selected
		attachment_context.remove = false
	CASE ELSE
		st_remove_title.visible = false
		st_remove_yes.visible = false	
		st_remove_no.visible = false
		attachment_context.remove = false
END CHOOSE


dw_post_to.settransobject(sqlca)
ll_folder_count = dw_post_to.retrieve(folder_selection_info.context_object, &
													folder_selection_info.context_object_type, &
													folder_selection_info.attachment_type, &
													folder_selection_info.extension)
if ll_folder_count < 0 then
	log.log(this, "w_post_attachment:open", "Error getting folder list", 4)
	setnull(attachment_context.folder)
	closewithreturn(this, attachment_context)
	return
end if
if ll_folder_count = 0 then
	setnull(attachment_context.folder)
	closewithreturn(this, attachment_context)
	return
end if

// If a folder has already been specified, then find it
if len(folder_selection_info.attachment_folder) > 0 then
	SELECT context_object,
			context_object_type
	INTO	:ls_context_object,
			:ls_context_object_type
	FROM c_Folder
	WHERE folder = :folder_selection_info.attachment_folder;
	if not tf_check() then
		log.log(this, "w_post_attachment:open", "Error looking up pre-selected folder (" + folder_selection_info.attachment_folder + ")", 4)
		setnull(attachment_context.folder)
		closewithreturn(this, attachment_context)
		return
	end if
	if sqlca.sqlcode = 100 then
		log.log(this, "w_post_attachment:open", "Pre-selected folder not valid (" + folder_selection_info.attachment_folder + ")", 4)
		setnull(attachment_context.folder)
		closewithreturn(this, attachment_context)
		return
	end if
	
	// We found the selected folder so go ahead and post to it
	li_sts = post_to_folder(folder_selection_info.attachment_folder, ls_context_object, ls_context_object_type)
	if li_sts > 0 then
		closewithreturn(this, attachment_context)
		return
	end if
end if

// If there's a folder with the auto_select_flag = 'Y', then pick it automatically
ls_find = "auto_select_flag='Y'"
ll_row = dw_post_to.find(ls_find, 1, ll_folder_count)
if ll_row > 0 then
	li_sts = post_to_folder(ll_row)
	if li_sts <= 0 then
		setnull(attachment_context.folder)
	end if
	closewithreturn(this, attachment_context)
	return
end if

// If there's only one folder, then pick it automatically
if ll_folder_count = 1 then
	li_sts = post_to_folder(1)
	if li_sts <= 0 then
		setnull(attachment_context.folder)
	end if
	closewithreturn(this, attachment_context)
	return
end if

// If we didn't find an auto_pick row but we're in server mode, then pick the first folder
if gnv_app.cpr_mode = "SERVER" then
	li_sts = post_to_folder(1)
	if li_sts <= 0 then
		setnull(attachment_context.folder)
	end if
	closewithreturn(this, attachment_context)
	return
end if

if isnull(current_patient) then
	title = "Post Attachment To Folder"
else
	title = current_patient.id_line1()
end if

uo_image.initialize()

dw_post_to.object.description.width = dw_post_to.width - 128

postevent("post_open")

end event

type pb_epro_help from w_window_base`pb_epro_help within w_post_attachment
integer x = 2857
integer y = 1328
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_post_attachment
integer x = 59
integer y = 1656
end type

type dw_post_to from u_dw_pick_list within w_post_attachment
integer x = 1477
integer y = 56
integer width = 1326
integer height = 1356
integer taborder = 10
string dataobject = "dw_sp_folder_selection"
boolean vscrollbar = true
boolean border = false
end type

type st_remove_title from statictext within w_post_attachment
integer x = 119
integer y = 1164
integer width = 1042
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "Remove From Previous Folder"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_post_attachment
integer x = 942
integer y = 452
integer width = 411
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = ">> Post To >>"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_image from u_picture_display within w_post_attachment
integer x = 64
integer y = 80
integer width = 786
integer height = 1016
integer taborder = 60
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = styleraised!
end type

event picture_clicked;call super::picture_clicked;integer li_sts

//li_sts = view_image()

li_sts = f_open_file(attachment_file, false)

return

end event

on uo_image.destroy
call u_picture_display::destroy
end on

type st_remove_yes from statictext within w_post_attachment
integer x = 352
integer y = 1268
integer width = 251
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_remove_no.backcolor = color_object
attachment_context.remove = true

end event

type st_remove_no from statictext within w_post_attachment
integer x = 667
integer y = 1268
integer width = 251
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_remove_yes.backcolor = color_object
attachment_context.remove = false

end event

type cb_done from commandbutton within w_post_attachment
integer x = 2318
integer y = 1584
integer width = 494
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;integer li_sts
long ll_row

ll_row = dw_post_to.get_selected_row()
if ll_row <= 0 then return

li_sts = post_to_folder(ll_row)
if li_sts <= 0 then return

Closewithreturn(Parent, attachment_context)

end event

type cb_cancel from commandbutton within w_post_attachment
integer x = 1495
integer y = 1584
integer width = 494
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
setnull(attachment_context.folder)
attachment_context.user_cancelled = true
closewithreturn(parent, attachment_context)



end event

type st_apply_title from statictext within w_post_attachment
integer x = 114
integer y = 1408
integer width = 1042
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "Apply Selection to All Attachments"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_apply_yes from statictext within w_post_attachment
integer x = 347
integer y = 1512
integer width = 251
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_apply_no.backcolor = color_object
attachment_context.apply_to_all = true

end event

type st_apply_no from statictext within w_post_attachment
integer x = 663
integer y = 1512
integer width = 251
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_apply_yes.backcolor = color_object
attachment_context.apply_to_all = false

end event

