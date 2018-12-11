$PBExportHeader$u_tab_user_profile.sru
forward
global type u_tab_user_profile from u_tab_manager
end type
type tabpage_user_information from u_tabpage_user_user_information within u_tab_user_profile
end type
type tabpage_user_information from u_tabpage_user_user_information within u_tab_user_profile
end type
type tabpage_person from u_tabpage_user_person_information within u_tab_user_profile
end type
type tabpage_person from u_tabpage_user_person_information within u_tab_user_profile
end type
type tabpage_organization from u_tabpage_user_org_information within u_tab_user_profile
end type
type tabpage_organization from u_tabpage_user_org_information within u_tab_user_profile
end type
type tabpage_infosys from u_tabpage_user_infosys_information within u_tab_user_profile
end type
type tabpage_infosys from u_tabpage_user_infosys_information within u_tab_user_profile
end type
type tabpage_contact_info from u_tabpage_user_contact_info within u_tab_user_profile
end type
type tabpage_contact_info from u_tabpage_user_contact_info within u_tab_user_profile
end type
type tabpage_authorities from u_tabpage_user_authorities within u_tab_user_profile
end type
type tabpage_authorities from u_tabpage_user_authorities within u_tab_user_profile
end type
type tabpage_user_roles from u_tabpage_user_roles within u_tab_user_profile
end type
type tabpage_user_roles from u_tabpage_user_roles within u_tab_user_profile
end type
type tabpage_user_permissions from u_tabpage_user_permissions within u_tab_user_profile
end type
type tabpage_user_permissions from u_tabpage_user_permissions within u_tab_user_profile
end type
type tabpage_document_routes from u_tabpage_user_document_routes within u_tab_user_profile
end type
type tabpage_document_routes from u_tabpage_user_document_routes within u_tab_user_profile
end type
type tabpage_id_numbers from u_tabpage_user_id_numbers within u_tab_user_profile
end type
type tabpage_id_numbers from u_tabpage_user_id_numbers within u_tab_user_profile
end type
type tabpage_user_audit from u_tabpage_user_audit within u_tab_user_profile
end type
type tabpage_user_audit from u_tabpage_user_audit within u_tab_user_profile
end type
end forward

global type u_tab_user_profile from u_tab_manager
integer width = 3127
integer height = 1948
boolean boldselectedtext = true
boolean createondemand = false
tabposition tabposition = tabsonbottom!
tabpage_user_information tabpage_user_information
tabpage_person tabpage_person
tabpage_organization tabpage_organization
tabpage_infosys tabpage_infosys
tabpage_contact_info tabpage_contact_info
tabpage_authorities tabpage_authorities
tabpage_user_roles tabpage_user_roles
tabpage_user_permissions tabpage_user_permissions
tabpage_document_routes tabpage_document_routes
tabpage_id_numbers tabpage_id_numbers
tabpage_user_audit tabpage_user_audit
end type
global u_tab_user_profile u_tab_user_profile

type variables
u_user user
end variables

forward prototypes
public function integer initialize (u_user puo_user)
end prototypes

public function integer initialize (u_user puo_user);integer i
u_tabpage_user_base luo_tab
integer li_first_visible

user = puo_user
li_first_visible = 0

page_count = upperbound(control)

for i = 1 to page_count
	pages[i] = control[i]
	luo_tab = pages[i]
	luo_tab.parent_tab = this
	luo_tab.user = user
	luo_tab.initialize()
	if upper(luo_tab.tag) = "ALL" or upper(luo_tab.tag) = upper(user.actor_type) or upper(luo_tab.tag) = upper(user.actor_class) then
		luo_tab.visible = true
		if li_first_visible = 0 then li_first_visible = i
	else
		luo_tab.visible = false
	end if
next

return li_first_visible

end function

on u_tab_user_profile.create
this.tabpage_user_information=create tabpage_user_information
this.tabpage_person=create tabpage_person
this.tabpage_organization=create tabpage_organization
this.tabpage_infosys=create tabpage_infosys
this.tabpage_contact_info=create tabpage_contact_info
this.tabpage_authorities=create tabpage_authorities
this.tabpage_user_roles=create tabpage_user_roles
this.tabpage_user_permissions=create tabpage_user_permissions
this.tabpage_document_routes=create tabpage_document_routes
this.tabpage_id_numbers=create tabpage_id_numbers
this.tabpage_user_audit=create tabpage_user_audit
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_user_information
this.Control[iCurrent+2]=this.tabpage_person
this.Control[iCurrent+3]=this.tabpage_organization
this.Control[iCurrent+4]=this.tabpage_infosys
this.Control[iCurrent+5]=this.tabpage_contact_info
this.Control[iCurrent+6]=this.tabpage_authorities
this.Control[iCurrent+7]=this.tabpage_user_roles
this.Control[iCurrent+8]=this.tabpage_user_permissions
this.Control[iCurrent+9]=this.tabpage_document_routes
this.Control[iCurrent+10]=this.tabpage_id_numbers
this.Control[iCurrent+11]=this.tabpage_user_audit
end on

on u_tab_user_profile.destroy
call super::destroy
destroy(this.tabpage_user_information)
destroy(this.tabpage_person)
destroy(this.tabpage_organization)
destroy(this.tabpage_infosys)
destroy(this.tabpage_contact_info)
destroy(this.tabpage_authorities)
destroy(this.tabpage_user_roles)
destroy(this.tabpage_user_permissions)
destroy(this.tabpage_document_routes)
destroy(this.tabpage_id_numbers)
destroy(this.tabpage_user_audit)
end on

type tabpage_user_information from u_tabpage_user_user_information within u_tab_user_profile
integer x = 18
integer y = 16
integer width = 3090
integer height = 1820
string text = "User"
end type

type tabpage_person from u_tabpage_user_person_information within u_tab_user_profile
integer x = 18
integer y = 16
integer width = 3090
integer height = 1820
string text = "Person"
end type

type tabpage_organization from u_tabpage_user_org_information within u_tab_user_profile
integer x = 18
integer y = 16
integer width = 3090
integer height = 1820
string text = "Organization"
end type

type tabpage_infosys from u_tabpage_user_infosys_information within u_tab_user_profile
integer x = 18
integer y = 16
integer width = 3090
integer height = 1820
string text = "Info System"
end type

type tabpage_contact_info from u_tabpage_user_contact_info within u_tab_user_profile
integer x = 18
integer y = 16
integer width = 3090
integer height = 1820
string text = "Contact Info"
end type

type tabpage_authorities from u_tabpage_user_authorities within u_tab_user_profile
integer x = 18
integer y = 16
integer width = 3090
integer height = 1820
string text = "Payers"
end type

type tabpage_user_roles from u_tabpage_user_roles within u_tab_user_profile
integer x = 18
integer y = 16
integer width = 3090
integer height = 1820
string text = "Roles"
end type

type tabpage_user_permissions from u_tabpage_user_permissions within u_tab_user_profile
integer x = 18
integer y = 16
integer width = 3090
integer height = 1820
string text = "Permissions"
end type

type tabpage_document_routes from u_tabpage_user_document_routes within u_tab_user_profile
integer x = 18
integer y = 16
integer width = 3090
integer height = 1820
string text = "Routes"
end type

type tabpage_id_numbers from u_tabpage_user_id_numbers within u_tab_user_profile
integer x = 18
integer y = 16
integer width = 3090
integer height = 1820
string text = "ID Numbers"
end type

type tabpage_user_audit from u_tabpage_user_audit within u_tab_user_profile
integer x = 18
integer y = 16
integer width = 3090
integer height = 1820
string text = "Audit"
end type

