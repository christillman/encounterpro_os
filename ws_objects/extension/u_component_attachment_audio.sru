HA$PBExportHeader$u_component_attachment_audio.sru
forward
global type u_component_attachment_audio from u_component_attachment
end type
end forward

global type u_component_attachment_audio from u_component_attachment
end type
global u_component_attachment_audio u_component_attachment_audio

forward prototypes
public function integer xx_display ()
public function integer xx_transcribe ()
end prototypes

public function integer xx_display ();w_attachment_audio_display lw_window

openwithparm(lw_window, this, "w_attachment_audio_display")

return 1

end function

public function integer xx_transcribe ();w_attachment_audio_display lw_window

openwithparm(lw_window, this, "w_attachment_audio_display")

return 1

end function

on u_component_attachment_audio.create
call super::create
end on

on u_component_attachment_audio.destroy
call super::destroy
end on

