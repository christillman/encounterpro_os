$PBExportHeader$u_configuration_node_printer.sru
forward
global type u_configuration_node_printer from u_configuration_node_base
end type
end forward

global type u_configuration_node_printer from u_configuration_node_base
end type
global u_configuration_node_printer u_configuration_node_printer

forward prototypes
public function boolean has_children ()
public function integer activate ()
public subroutine refresh_label ()
end prototypes

public function boolean has_children ();return false
end function

public function integer activate ();
openwithparm(w_pop_printer_edit, node.key)

return 2


end function

public subroutine refresh_label ();string ls_display_name
string ls_fax_flag

SELECT display_name, fax_flag
INTO :ls_display_name, :ls_fax_flag
FROM o_Computer_Printer
WHERE computer_id = 0
AND printer = :node.key;
if not tf_check() then return
if sqlca.sqlnrows = 1 then
	node.label = ls_display_name
	if upper(ls_fax_flag) = "Y" then
		node.label += "  (Fax)"
	end if
end if

end subroutine

on u_configuration_node_printer.create
call super::create
end on

on u_configuration_node_printer.destroy
call super::destroy
end on

