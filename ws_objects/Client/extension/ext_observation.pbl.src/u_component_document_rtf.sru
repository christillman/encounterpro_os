$PBExportHeader$u_component_document_rtf.sru
forward
global type u_component_document_rtf from u_component_document
end type
end forward

global type u_component_document_rtf from u_component_document
end type
global u_component_document_rtf u_component_document_rtf

type variables

end variables

forward prototypes
protected function integer xx_do_source ()
end prototypes

protected function integer xx_do_source ();w_ext_document_rtf lw_rtf
string ls_return

openwithparm(lw_rtf, this, "w_ext_document_rtf")
ls_return = upper(message.stringparm)

if ls_return = "CANCEL" then return 0
if ls_return = "ERROR" then return -1
if ls_return <> "OK" then return -1


return 1

end function

on u_component_document_rtf.create
call super::create
end on

on u_component_document_rtf.destroy
call super::destroy
end on

