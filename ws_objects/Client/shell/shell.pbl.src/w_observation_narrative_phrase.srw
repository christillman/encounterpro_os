$PBExportHeader$w_observation_narrative_phrase.srw
forward
global type w_observation_narrative_phrase from w_window_base
end type
type pb_done from u_picture_button within w_observation_narrative_phrase
end type
type pb_cancel from u_picture_button within w_observation_narrative_phrase
end type
type rte_narrative from richtextedit within w_observation_narrative_phrase
end type
type st_title from statictext within w_observation_narrative_phrase
end type
type st_1 from statictext within w_observation_narrative_phrase
end type
type cb_insert_token from commandbutton within w_observation_narrative_phrase
end type
type st_results from statictext within w_observation_narrative_phrase
end type
type dw_results from u_dw_pick_list within w_observation_narrative_phrase
end type
end forward

global type w_observation_narrative_phrase from w_window_base
integer x = 0
integer y = 0
integer height = 1832
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
rte_narrative rte_narrative
st_title st_title
st_1 st_1
cb_insert_token cb_insert_token
st_results st_results
dw_results dw_results
end type
global w_observation_narrative_phrase w_observation_narrative_phrase

type variables
string narrative_phrase
string observation_id

end variables

on w_observation_narrative_phrase.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.rte_narrative=create rte_narrative
this.st_title=create st_title
this.st_1=create st_1
this.cb_insert_token=create cb_insert_token
this.st_results=create st_results
this.dw_results=create dw_results
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.rte_narrative
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_insert_token
this.Control[iCurrent+7]=this.st_results
this.Control[iCurrent+8]=this.dw_results
end on

on w_observation_narrative_phrase.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.rte_narrative)
destroy(this.st_title)
destroy(this.st_1)
destroy(this.cb_insert_token)
destroy(this.st_results)
destroy(this.dw_results)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return

popup = message.powerobjectparm

popup_return.item_count = 0

if popup.data_row_count <> 3 then
	log.log(this, "open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

observation_id = popup.items[1]
narrative_phrase = popup.items[2]

rte_narrative.pastertf( narrative_phrase )

// Check if we should allow editing
if f_string_to_boolean(popup.items[3]) then
	rte_narrative.displayonly = false
	cb_insert_token.visible = true
else
	rte_narrative.displayonly = true
	cb_insert_token.visible = false
end if

st_title.text = popup.title

if not isnull(current_patient) then
	title = current_patient.id_line()
else
	title = "Narrative Phrase Edit"
end if

dw_results.settransobject(sqlca)
dw_results.retrieve(observation_id, "PERFORM")

rte_narrative.setfocus()



end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_narrative_phrase
boolean visible = true
end type

type pb_done from u_picture_button within w_observation_narrative_phrase
integer x = 2597
integer y = 1480
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = trim(rte_narrative.copyrtf(false))
if popup_return.items[1] = "" then setnull(popup_return.items[1])

closewithreturn(parent, popup_return)


end event

type pb_cancel from u_picture_button within w_observation_narrative_phrase
integer x = 55
integer y = 1480
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type rte_narrative from richtextedit within w_observation_narrative_phrase
integer x = 64
integer y = 180
integer width = 2738
integer height = 844
integer taborder = 20
boolean bringtotop = true
boolean init_vscrollbar = true
boolean init_wordwrap = true
boolean init_returnsvisible = true
boolean init_tabsvisible = true
boolean init_inputfieldsvisible = true
boolean init_inputfieldnamesvisible = true
boolean init_rulerbar = true
boolean init_toolbar = true
boolean init_popmenu = true
string init_documentname = "NarrativePhrase"
borderstyle borderstyle = stylelowered!
end type

type st_title from statictext within w_observation_narrative_phrase
integer width = 2921
integer height = 136
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Title"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_observation_narrative_phrase
integer x = 64
integer y = 112
integer width = 517
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Narrative Phrase:"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_insert_token from commandbutton within w_observation_narrative_phrase
integer x = 69
integer y = 1072
integer width = 709
integer height = 112
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insert <Results> Token"
end type

event clicked;rte_narrative.InputFieldInsert("<Result>")
rte_narrative.setfocus()


end event

type st_results from statictext within w_observation_narrative_phrase
integer x = 1079
integer y = 1080
integer width = 741
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Results"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_results from u_dw_pick_list within w_observation_narrative_phrase
integer x = 1079
integer y = 1156
integer width = 741
integer height = 548
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_result_display_list"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event clicked;str_popup popup
integer li_sts

popup.item = observation_id
popup.title = datalist.observation_description(observation_id)

openwithparm(w_observation_result_edit, popup)

settransobject(sqlca)

retrieve(observation_id, "PERFORM")


end event

