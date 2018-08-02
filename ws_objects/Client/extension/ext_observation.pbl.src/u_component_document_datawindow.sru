$PBExportHeader$u_component_document_datawindow.sru
forward
global type u_component_document_datawindow from u_component_document
end type
end forward

global type u_component_document_datawindow from u_component_document
end type
global u_component_document_datawindow u_component_document_datawindow

type variables

end variables

forward prototypes
protected function integer xx_do_source ()
end prototypes

protected function integer xx_do_source ();w_window_base lw_window
string ls_return
string ls_sql
integer li_sts



// Set the document objects
TRY
	set_document_context_objects()
CATCH (exception le_error)
	log.log(this, "u_component_document_datawindow.xx_do_source.0012", "Error setting document clinical objects (" + le_error.text + ")" , 4)
	THROW le_error
END TRY

ls_sql = get_attribute("datawindow_sql_script")
if len(ls_sql) > 0 then
	li_sts = create_temp_stored_proc(ls_sql)
	if li_sts < 0 then
		log.log(this, "u_component_document_datawindow.xx_do_source.0012", "Error creating temp stored proc from  datawindow_sql_script (" + ls_sql + ")" , 4)
		return -1
	end if
end if

// Open the window that will create and execute the datawindow.  We need to do it in a window because there are some dw features that are not supported in datastores.
openwithparm(lw_window, this, "w_doc_datawindow")
ls_return = message.stringparm

// If we created a temp stored proc then drop it now
drop_temp_stored_proc( )

CHOOSE CASE upper(ls_return)
	CASE "OK"
		return 1
	CASE "CANCEL"
		return 0
	CASE "ERROR"
		return -1
END CHOOSE

return 0

end function

on u_component_document_datawindow.create
call super::create
end on

on u_component_document_datawindow.destroy
call super::destroy
end on

