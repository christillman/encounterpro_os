HA$PBExportHeader$u_component_service_portrait.sru
forward
global type u_component_service_portrait from u_component_service
end type
end forward

global type u_component_service_portrait from u_component_service
end type
global u_component_service_portrait u_component_service_portrait

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();String ls_attachment_tag,ls_attachment_service

str_attributes lstr_attributes

ls_attachment_service = get_attribute("attachment_service")
If isnull(ls_attachment_service) then ls_attachment_service = "ATTACHMENT"

ls_attachment_tag = get_attribute("comment_title")
If isnull(ls_attachment_tag) then ls_attachment_tag = "Portrait"

lstr_attributes.attribute_count = 1
lstr_attributes.attribute[1].attribute = "comment_title"
lstr_attributes.attribute[1].value = ls_attachment_tag

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "context_object"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = "patient"

service_list.do_service(cpr_id,encounter_id,ls_attachment_service,lstr_attributes)

Return 1
end function

on u_component_service_portrait.create
call super::create
end on

on u_component_service_portrait.destroy
call super::destroy
end on

