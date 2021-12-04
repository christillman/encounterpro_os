$PBExportHeader$u_cpr_multi_page_tab.sru
forward
global type u_cpr_multi_page_tab from tab
end type
end forward

global type u_cpr_multi_page_tab from tab
integer width = 1152
integer height = 864
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean raggedright = true
boolean perpendiculartext = true
integer selectedtab = 1
event refresh ( )
end type
global u_cpr_multi_page_tab u_cpr_multi_page_tab

type variables
u_cpr_multi_page_section mysection

end variables

event key;mysection.key_down(key, keyflags)

end event

event getfocus;//mysection.key_down(key, keyflags)
if selectedtab > 0 and isvalid(mysection) and not isnull(mysection) then
	if isvalid(mysection.this_section.page[selectedtab].page_object) and not isnull(mysection.this_section.page[selectedtab].page_object) then
		mysection.this_section.page[selectedtab].page_object.setfocus()
	end if
end if


end event

