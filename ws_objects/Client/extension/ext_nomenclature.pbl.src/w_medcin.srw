$PBExportHeader$w_medcin.srw
forward
global type w_medcin from window
end type
type pb_1 from u_pb_help_button within w_medcin
end type
type cb_2 from commandbutton within w_medcin
end type
type cb_therapy2 from commandbutton within w_medcin
end type
type cb_diagnoses2 from commandbutton within w_medcin
end type
type cb_tests2 from commandbutton within w_medcin
end type
type cb_exam2 from commandbutton within w_medcin
end type
type cb_history2 from commandbutton within w_medcin
end type
type cb_symptoms2 from commandbutton within w_medcin
end type
type cb_1 from commandbutton within w_medcin
end type
type st_2 from statictext within w_medcin
end type
type st_1 from statictext within w_medcin
end type
type cb_up_one from commandbutton within w_medcin
end type
type sle_1 from singlelineedit within w_medcin
end type
type cb_top from commandbutton within w_medcin
end type
type dw_n from datawindow within w_medcin
end type
end forward

global type w_medcin from window
boolean visible = false
integer width = 2926
integer height = 1832
windowtype windowtype = response!
long backcolor = 33538240
pb_1 pb_1
cb_2 cb_2
cb_therapy2 cb_therapy2
cb_diagnoses2 cb_diagnoses2
cb_tests2 cb_tests2
cb_exam2 cb_exam2
cb_history2 cb_history2
cb_symptoms2 cb_symptoms2
cb_1 cb_1
st_2 st_2
st_1 st_1
cb_up_one cb_up_one
sle_1 sle_1
cb_top cb_top
dw_n dw_n
end type
global w_medcin w_medcin

type variables
string is_part, is_top
long il_clickedrow
string is_pctrl
end variables

forward prototypes
public subroutine enable_all_buttons ()
public subroutine store_browser_state (long row)
public subroutine retrieve_data (string part, string pctrl, long row)
end prototypes

public subroutine enable_all_buttons ();cb_symptoms2.Enabled = True
cb_diagnoses2.Enabled = True
cb_exam2.Enabled = True
cb_tests2.Enabled = True
cb_therapy2.Enabled = True
cb_history2.Enabled = True


end subroutine

public subroutine store_browser_state (long row);			RegistrySet(gnv_app.registry_key + "\Nomenclature\Medcin", &
							"part", RegString!, is_part)
			RegistrySet(gnv_app.registry_key + "\Nomenclature\Medcin", & 
							"pctrl", RegString!, dw_n.GetItemString(row,"pctrl"))
			RegistrySet(gnv_app.registry_key + "\Nomenclature\Medcin", & 
							"clickedrow", RegString!, string(dw_n.GetRow())) //dw_n.GetClickedRow() which generated error if nothing had been clicked
	
end subroutine

public subroutine retrieve_data (string part, string pctrl, long row);string ls_part, ls_pctrl, ls_clickedrow, ls_NewSelectString
int li_length

RegistryGet(gnv_app.registry_key + "\Nomenclature\Medcin", &
				"part", RegString!, ls_part)
				
RegistryGet(gnv_app.registry_key + "\Nomenclature\Medcin", & 
				"pctrl", RegString!, ls_pctrl)

RegistryGet(gnv_app.registry_key + "\Nomenclature\Medcin", & 
				"clickedrow", RegString!, ls_clickedrow)

IF pctrl = '' THEN

	CHOOSE CASE part
		CASE "symptoms"
			ls_pctrl = "A"
		
		CASE "history"
			ls_pctrl = "B"
		
		CASE "exam"
			ls_pctrl = "C"
		
		CASE "tests"
			ls_pctrl = "D"
		
		CASE "diagnoses"
			ls_pctrl = "F"
		
		CASE "therapy"
			ls_pctrl = "G"
		
		CASE ELSE
		
	END CHOOSE
	
ELSE
	
	ls_pctrl = pctrl

END IF

//IF pctrl <> '' THEN
//		ls_pctrl = pctrl
//END IF

ls_NewSelectString = 'SELECT c_nomenclature_medcin.level2 , &
									c_nomenclature_medcin.subs , &
									c_nomenclature_medcin.pctrl , &
									c_nomenclature_medcin.desce &
									FROM c_nomenclature_medcin  &
									WHERE ( c_nomenclature_medcin.pctrl like ~'[ ]' + ls_pctrl + '%~' ) &
									ORDER BY c_nomenclature_medcin.level2 ASC, c_nomenclature_medcin.pctrl ASC '

dw_n.SetSQLSelect(ls_NewSelectString)
dw_n.SetFilter("")							
dw_n.Retrieve()





				



end subroutine

on w_medcin.create
this.pb_1=create pb_1
this.cb_2=create cb_2
this.cb_therapy2=create cb_therapy2
this.cb_diagnoses2=create cb_diagnoses2
this.cb_tests2=create cb_tests2
this.cb_exam2=create cb_exam2
this.cb_history2=create cb_history2
this.cb_symptoms2=create cb_symptoms2
this.cb_1=create cb_1
this.st_2=create st_2
this.st_1=create st_1
this.cb_up_one=create cb_up_one
this.sle_1=create sle_1
this.cb_top=create cb_top
this.dw_n=create dw_n
this.Control[]={this.pb_1,&
this.cb_2,&
this.cb_therapy2,&
this.cb_diagnoses2,&
this.cb_tests2,&
this.cb_exam2,&
this.cb_history2,&
this.cb_symptoms2,&
this.cb_1,&
this.st_2,&
this.st_1,&
this.cb_up_one,&
this.sle_1,&
this.cb_top,&
this.dw_n}
end on

on w_medcin.destroy
destroy(this.pb_1)
destroy(this.cb_2)
destroy(this.cb_therapy2)
destroy(this.cb_diagnoses2)
destroy(this.cb_tests2)
destroy(this.cb_exam2)
destroy(this.cb_history2)
destroy(this.cb_symptoms2)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_up_one)
destroy(this.sle_1)
destroy(this.cb_top)
destroy(this.dw_n)
end on

event open;string ls_part, ls_pctrl, ls_clickedrow
int iLength

Close(this)
Return
end event

type pb_1 from u_pb_help_button within w_medcin
integer x = 2633
integer y = 1688
integer width = 256
integer height = 128
integer taborder = 30
end type

type cb_2 from commandbutton within w_medcin
boolean visible = false
integer x = 1998
integer y = 1796
integer width = 78
integer height = 108
integer taborder = 30
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "none"
end type

event clicked;retrieve_data("exam","CAKAH",1)
end event

type cb_therapy2 from commandbutton within w_medcin
integer x = 2469
integer y = 1528
integer width = 430
integer height = 124
integer taborder = 110
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Therapy"
end type

event clicked;retrieve_data("therapy","G",1)

enable_all_buttons()
this.Enabled = FALSE

is_part = "therapy"

is_top = "G"
end event

type cb_diagnoses2 from commandbutton within w_medcin
integer x = 1861
integer y = 1528
integer width = 539
integer height = 124
integer taborder = 100
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Diagnoses"
end type

event clicked;retrieve_data("diagnoses","F",1)

enable_all_buttons()
this.Enabled = FALSE

is_part = "diagnoses"

is_top = "F"


end event

type cb_tests2 from commandbutton within w_medcin
integer x = 1472
integer y = 1528
integer width = 320
integer height = 124
integer taborder = 90
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Tests"
end type

event clicked;retrieve_data("tests","D",1)

enable_all_buttons()
this.Enabled = FALSE

is_part = "tests"

is_top = "D"


end event

type cb_exam2 from commandbutton within w_medcin
integer x = 1083
integer y = 1528
integer width = 320
integer height = 124
integer taborder = 80
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Exam"
end type

event clicked;retrieve_data("exam","C",1)

enable_all_buttons()
this.Enabled = FALSE

is_part = "exam"

is_top = "C"


end event

type cb_history2 from commandbutton within w_medcin
integer x = 631
integer y = 1528
integer width = 384
integer height = 124
integer taborder = 70
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "History"
end type

event clicked;retrieve_data("history","B",1)

enable_all_buttons()
this.Enabled = FALSE

is_part = "history"

is_top = "B"




end event

type cb_symptoms2 from commandbutton within w_medcin
integer x = 37
integer y = 1528
integer width = 526
integer height = 124
integer taborder = 60
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Symptoms"
end type

event clicked;retrieve_data("symptoms","A",1)

enable_all_buttons()
this.Enabled = FALSE

is_part = "symptoms"

is_top = "A"

end event

type cb_1 from commandbutton within w_medcin
integer x = 1765
integer y = 1688
integer width = 754
integer height = 116
integer taborder = 20
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;store_browser_state(il_clickedrow)
CloseWithReturn ( parent, "" )
end event

type st_2 from statictext within w_medcin
integer x = 1257
integer y = 32
integer width = 1559
integer height = 84
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Touch Phrase to Return It to EncounterPRO"
boolean focusrectangle = false
end type

type st_1 from statictext within w_medcin
integer x = 160
integer y = 32
integer width = 987
integer height = 84
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Touch ~'+~' to Expand Options"
boolean focusrectangle = false
end type

type cb_up_one from commandbutton within w_medcin
integer x = 942
integer y = 1688
integer width = 704
integer height = 116
integer taborder = 50
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Go Up Level"
end type

event clicked;int ilength
string sPctrl, sNewSelectString, sNewCode

sPctrl = dw_n.GetItemString(1,"pctrl")

ilength = Len(sPctrl) - 2
sNewCode = Right(Left(sPctrl, ilength), ilength - 1)

//messagebox("sNewCode", sNewCode)

IF sNewCode = "" THEN
	sNewCode = is_top
END IF


sNewSelectString = 'SELECT c_nomenclature_medcin.level2 , &
									c_nomenclature_medcin.subs , &
									c_nomenclature_medcin.pctrl , &
									c_nomenclature_medcin.desce &
									FROM c_nomenclature_medcin  &
									WHERE ( c_nomenclature_medcin.pctrl like ~'[ ]' + sNewCode + '%~')'
									
dw_n.SetSQLSelect(sNewSelectString)
dw_n.SetFilter("")
dw_n.Retrieve()



end event

type sle_1 from singlelineedit within w_medcin
boolean visible = false
integer x = 1979
integer y = 1832
integer width = 1312
integer height = 92
integer taborder = 120
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

type cb_top from commandbutton within w_medcin
integer x = 46
integer y = 1688
integer width = 786
integer height = 112
integer taborder = 40
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Go To Top"
end type

event clicked;int ilength
string slength
string scode, sNewSelectString

//dw_n.SelectRow ( 1, true )


sNewSelectString = 'SELECT c_nomenclature_medcin.level2 , &
									c_nomenclature_medcin.subs , &
									c_nomenclature_medcin.pctrl , &
									c_nomenclature_medcin.desce &
									FROM c_nomenclature_medcin  &
									WHERE ( c_nomenclature_medcin.pctrl like ~'[ ]' + is_top + '%~' ) &
									ORDER BY c_nomenclature_medcin.level2 ASC, c_nomenclature_medcin.pctrl ASC '


is_pctrl = ""									
					
									
//messagebox ("sNewSelectString", sNewSelectString)

dw_n.SetSQLSelect(sNewSelectString)


dw_n.SetFilter("")

dw_n.retrieve()

//messagebox("dw_n.RowCount()", dw_n.RowCount())

end event

type dw_n from datawindow within w_medcin
integer x = 32
integer y = 128
integer width = 2843
integer height = 1376
integer taborder = 10
string dataobject = "dw_nomenclature_medcin"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;int ilength
string slength, sName, sPhrase

if row < 1 then
	return
end if

il_clickedrow = row

sName = dwo.Name

sle_1.text = dw_n.GetItemString(row,"desce")

CHOOSE CASE dwo.Name
	CASE "desce"
		store_browser_state(row)
		CloseWithReturn ( parent, dw_n.GetItemString(row,"desce") )
	CASE ELSE
		ilength = len(dw_n.GetItemString(row,"pctrl"))
		dw_n.SetFilter("Left(pctrl, " + string(ilength) + ") = ~"" + dw_n.GetItemString(row,"pctrl") + "~"")
		dw_n.Filter()
END CHOOSE


end event

