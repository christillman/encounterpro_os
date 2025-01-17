﻿$PBExportHeader$w_ext_observation_wlca_at10.srw
forward
global type w_ext_observation_wlca_at10 from window
end type
type ole_at10 from olecustomcontrol within w_ext_observation_wlca_at10
end type
end forward

global type w_ext_observation_wlca_at10 from window
boolean visible = false
integer width = 2533
integer height = 1408
boolean titlebar = true
string title = "Untitled"
long backcolor = 67108864
ole_at10 ole_at10
end type
global w_ext_observation_wlca_at10 w_ext_observation_wlca_at10

type variables
u_component_observation observation_component

string attachment_path


end variables

forward prototypes
public function integer connect_device ()
public function integer disconnect_device ()
end prototypes

public function integer connect_device ();string ls_devicetype
string ls_recordpath
string ls_comport
string ls_commportnum
long ll_completioninterval
long ll_nakinterval


ls_devicetype = observation_component.get_attribute("devicetype")
if isnull(ls_devicetype) then ls_devicetype = "0"

ls_comport = observation_component.get_attribute("comport")
if isnull(ls_comport) then ls_comport = "38400,n,8,1"

ls_commportnum = observation_component.get_attribute("commportnum")
if isnull(ls_commportnum) then ls_commportnum = "1"

observation_component.get_attribute("completioninterval", ll_completioninterval)
if isnull(ll_completioninterval) then ll_completioninterval = 4000

observation_component.get_attribute("NAKInterval", ll_nakinterval)
if isnull(ll_nakinterval) then ll_nakinterval = 1000

ole_at10.object.devicetype = ls_devicetype
ole_at10.object.RecordPath = attachment_path
ole_at10.object.COMPort = ls_comport
ole_at10.object.CommPortNum = ls_commportnum
ole_at10.object.CompletionInterval = ll_completioninterval
ole_at10.object.NAKInterval = ll_nakinterval

ole_at10.object.PollingEnable = true

observation_component.set_connected_status(ole_at10.object.PollingEnable)

return 1

end function

public function integer disconnect_device ();
ole_at10.object.PollingEnable = false

observation_component.set_connected_status(false)


return 1

end function

event open;integer li_reconnect_timer

observation_component = message.powerobjectparm

observation_component.set_connected_status(false)

observation_component.get_attribute("reconnect_timer", li_reconnect_timer)
if not isnull(li_reconnect_timer) then timer(li_reconnect_timer)



end event

on w_ext_observation_wlca_at10.create
this.ole_at10=create ole_at10
this.Control[]={this.ole_at10}
end on

on w_ext_observation_wlca_at10.destroy
destroy(this.ole_at10)
end on

event timer;if not observation_component.connected then
	connect_device()
end if

end event

type ole_at10 from olecustomcontrol within w_ext_observation_wlca_at10
event xmodemoncomm ( ref long result )
integer x = 302
integer y = 248
integer width = 201
integer height = 156
integer taborder = 10
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_ext_observation_wlca_at10.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

event xmodemoncomm;
if result = 20000 then
	observation_component.timer_ding()
else
	observation_component.mylog.log(this, "w_ext_observation_wlca_at10.ole_at10.xmodemoncomm:0005", "Error receiving file (" + string(result) + ")", 4)
end if

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
04w_ext_observation_wlca_at10.bin 
2800000c00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000300000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000002fffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000d9c939a001c13d3c00000004000000800000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe000000000000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a00000002000000010000000440ef0d7b4804f03917af7988603ef6a000000000d9c939a001c13d3cd9c939a001c13d3c000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000048000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff
29ffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000b29300000048000800034757f20b000000200065005f00740078006e0065007800740000048c000800034757f20affffffe00065005f00740078006e0065007900740000040800002878000000000000289c00000000000028bc00000000000028de0000000000002900000000000000292200000000000029420000000000002968000000000000298e00000000000029b400000000000029dc0000000000002a060000000000002a260000000000002a5a0000000000002a7e0000000000002aa60000000000002ac00000000000002ae40000000000002b080000000000002b260000000000002b4a0000000000002b6a0000000000002b860000000000002ba80000000000002bd40000000000002c000000000000002c1e0000000000002c440000000000002c700000000000002c940000000000002cbe0000000000002cde0000000000002d000000000000002d220000000000002d460000000000002d6e0000000000002d8e0000000000002db20000000000002dda0000000000002e000000000000002e280000000000002e460000000000002e680000000000002e880000000000002eb40000000000002ed40000000000002eec0000000000002f100000000000002f300000000000002f4c0000000000002f6c0000000000002f8a0000000000002fa60000000000002fc40000000000002fe60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
14w_ext_observation_wlca_at10.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
