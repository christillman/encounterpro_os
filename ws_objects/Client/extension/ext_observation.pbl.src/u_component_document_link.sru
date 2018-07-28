$PBExportHeader$u_component_document_link.sru
forward
global type u_component_document_link from u_component_document
end type
end forward

global type u_component_document_link from u_component_document
end type
global u_component_document_link u_component_document_link

type variables

end variables

forward prototypes
protected function integer xx_do_source ()
end prototypes

protected function integer xx_do_source ();w_doc_link lw_link
string ls_return

openwithparm(lw_link, this, "w_doc_link")
ls_return = upper(message.stringparm)

if ls_return = "CANCEL" then return 0
if ls_return = "ERROR" then return -1
if ls_return <> "OK" then return -1


return 1

end function

on u_component_document_link.create
call super::create
end on

on u_component_document_link.destroy
call super::destroy
end on

