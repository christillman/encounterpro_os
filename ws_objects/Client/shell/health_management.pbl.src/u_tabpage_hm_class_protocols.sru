$PBExportHeader$u_tabpage_hm_class_protocols.sru
forward
global type u_tabpage_hm_class_protocols from u_tabpage_hm_class_base
end type
type st_no_protocols from statictext within u_tabpage_hm_class_protocols
end type
type cb_add_protocol from commandbutton within u_tabpage_hm_class_protocols
end type
type tab_protocols from u_tab_hm_class_protocols within u_tabpage_hm_class_protocols
end type
type tab_protocols from u_tab_hm_class_protocols within u_tabpage_hm_class_protocols
end type
end forward

global type u_tabpage_hm_class_protocols from u_tabpage_hm_class_base
st_no_protocols st_no_protocols
cb_add_protocol cb_add_protocol
tab_protocols tab_protocols
end type
global u_tabpage_hm_class_protocols u_tabpage_hm_class_protocols

forward prototypes
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
end prototypes

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);integer li_sts

tab_protocols.width = width
tab_protocols.height = height - cb_add_protocol.height - 40

st_no_protocols.x = (width - st_no_protocols.width) / 2
st_no_protocols.y = (height - st_no_protocols.height) / 2

cb_add_protocol.x = width - cb_add_protocol.width - 20
cb_add_protocol.y = height - cb_add_protocol.height - 20

li_sts = tab_protocols.initialize(pstr_hm_context)
if li_sts = 0 then
	tab_protocols.visible = false
	st_no_protocols.visible = true
else
	tab_protocols.visible = true
	st_no_protocols.visible = false
end if

return li_sts


end function

on u_tabpage_hm_class_protocols.create
int iCurrent
call super::create
this.st_no_protocols=create st_no_protocols
this.cb_add_protocol=create cb_add_protocol
this.tab_protocols=create tab_protocols
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_no_protocols
this.Control[iCurrent+2]=this.cb_add_protocol
this.Control[iCurrent+3]=this.tab_protocols
end on

on u_tabpage_hm_class_protocols.destroy
call super::destroy
destroy(this.st_no_protocols)
destroy(this.cb_add_protocol)
destroy(this.tab_protocols)
end on

type st_no_protocols from statictext within u_tabpage_hm_class_protocols
integer x = 823
integer y = 680
integer width = 1074
integer height = 92
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "No Protocols are Defined"
boolean focusrectangle = false
end type

type cb_add_protocol from commandbutton within u_tabpage_hm_class_protocols
integer x = 1755
integer y = 1380
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Protocol"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_description
long ll_protocol_sequence

popup.title = "Enter new name for protocol"
popup.datacolumn = 40
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = popup_return.items[1]

INSERT INTO dbo.c_Maintenance_Protocol (
	maintenance_rule_id,
	description,
	created_by,
	title)
VALUES (
	:hmclasstab.hm_class.maintenance_rule_id,
	:ls_description,
	:current_scribe.user_id,
	:ls_description);
if not tf_check() then return

SELECT SCOPE_IDENTITY()
INTO :ll_protocol_sequence
FROM c_1_record;
if not tf_check() then return -1

tab_protocols.hm_class.protocol_count += 1
tab_protocols.hm_class.protocol[hmclasstab.hm_class.protocol_count].title = ls_description
tab_protocols.hm_class.protocol[hmclasstab.hm_class.protocol_count].description = ls_description
tab_protocols.hm_class.protocol[hmclasstab.hm_class.protocol_count].protocol_sequence = ll_protocol_sequence
tab_protocols.hm_class.protocol[hmclasstab.hm_class.protocol_count].protocol_item_count = 0
setnull(tab_protocols.hm_class.protocol[hmclasstab.hm_class.protocol_count].interval)
setnull(tab_protocols.hm_class.protocol[hmclasstab.hm_class.protocol_count].interval_unit)

tab_protocols.open_protocol(hmclasstab.hm_class.protocol_count)
tab_protocols.selecttab(hmclasstab.hm_class.protocol_count)

// Now copy the protocol section to the parent tab in case it references the protocols
hmclasstab.hm_class.protocol_count = tab_protocols.hm_class.protocol_count
hmclasstab.hm_class.protocol = tab_protocols.hm_class.protocol

end event

type tab_protocols from u_tab_hm_class_protocols within u_tabpage_hm_class_protocols
integer width = 2002
integer height = 1000
end type

