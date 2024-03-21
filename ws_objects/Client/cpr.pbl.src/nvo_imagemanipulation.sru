$PBExportHeader$nvo_imagemanipulation.sru
forward
global type nvo_imagemanipulation from dotnetobject
end type
end forward

global type nvo_imagemanipulation from dotnetobject
event ue_error ( )
end type
global nvo_imagemanipulation nvo_imagemanipulation

type variables

PUBLIC:
String is_assemblypath = "C:\Program Files (x86)\Common Files\EncounterPRO-OS\EncounterPRO.OS.Utilities\EncounterPRO.OS.Utilities.dll"
String is_classname = "EncounterPRO.OS.ImageManipulation"

/* Exception handling -- Indicates how proxy handles .NET exceptions */
Boolean ib_CrashOnException = False

/*      Error types       */
Constant Int SUCCESS        =  0 // No error since latest reset
Constant Int LOAD_FAILURE   = -1 // Failed to load assembly
Constant Int CREATE_FAILURE = -2 // Failed to create .NET object
Constant Int CALL_FAILURE   = -3 // Call to .NET function failed

/* Latest error -- Public reset via of_ResetError */
PRIVATEWRITE Long il_ErrorType   
PRIVATEWRITE Long il_ErrorNumber 
PRIVATEWRITE String is_ErrorText 

PRIVATE:
/*  .NET object creation */
Boolean ib_objectCreated

/* Error handler -- Public access via of_SetErrorHandler/of_ResetErrorHandler/of_GetErrorHandler
    Triggers "ue_Error" event for each error when no current error handler */
PowerObject ipo_errorHandler // Each error triggers <ErrorHandler, ErrorEvent>
String is_errorEvent
end variables

forward prototypes
public subroutine of_seterrorhandler (powerobject apo_newhandler, string as_newevent)
public subroutine of_signalerror ()
private subroutine of_setdotneterror (string as_failedfunction, string as_errortext)
public subroutine of_reseterror ()
public function boolean of_createondemand ()
private subroutine of_setassemblyerror (long al_errortype, string as_actiontext, long al_errornumber, string as_errortext)
public subroutine of_geterrorhandler (ref powerobject apo_currenthandler,ref string as_currentevent)
public subroutine of_reseterrorhandler ()
public function long of_logevent(string as_objectname,string as_scriptname,string as_message,long al_severity)
public subroutine  of_getimagesize(string as_sourcefile,ref long al_width,ref long al_height)
public subroutine  of_getimageinfo(string as_sourcefile,ref long al_width,ref long al_height,ref long al_hresolution,ref long al_vresolution)
public subroutine  of_getimagesizepixels(string as_sourcefile,ref long al_width,ref long al_height)
public function long of_convertto1bppbmp(string as_sourcefile,string as_outputfile)
public function long of_resizedarkenbitmap(string as_sourcefile,string as_outputfile,long al_outputwidth,long al_outputheight,long al_luminancecutoff)
end prototypes

event ue_error ( );
/*-----------------------------------------------------------------------------------------*/
/*  Handler undefined or call failed (event undefined) => Signal object itself */
/*-----------------------------------------------------------------------------------------*/
end event

public subroutine of_seterrorhandler (powerobject apo_newhandler, string as_newevent);
//*-----------------------------------------------------------------*/
//*    of_seterrorhandler:  
//*                       Register new error handler (incl. event)
//*-----------------------------------------------------------------*/

This.ipo_errorHandler = apo_newHandler
This.is_errorEvent = Trim(as_newEvent)
end subroutine

public subroutine of_signalerror ();
//*-----------------------------------------------------------------------------*/
//* PRIVATE of_SignalError
//* Triggers error event on previously defined error handler.
//* Calls object's own UE_ERROR when handler or its event is undefined.
//*
//* Handler is "DEFINED" when
//* 	1) <ErrorEvent> is non-empty
//*	2) <ErrorHandler> refers to valid object
//*	3) <ErrorEvent> is actual event on <ErrorHandler>
//*-----------------------------------------------------------------------------*/

Boolean lb_handlerDefined
If This.is_errorEvent > '' Then
	If Not IsNull(This.ipo_errorHandler) Then
		lb_handlerDefined = IsValid(This.ipo_errorHandler)
	End If
End If

If lb_handlerDefined Then
	/* Try to call defined handler*/
	Long ll_status
	ll_status = This.ipo_errorHandler.TriggerEvent(This.is_errorEvent)
	If ll_status = 1 Then Return
End If

/* Handler undefined or call failed (event undefined) => Signal object itself*/
This.event ue_Error( )
end subroutine

private subroutine of_setdotneterror (string as_failedfunction, string as_errortext);
//*----------------------------------------------------------------------------------------*/
//* PRIVATE of_setDotNETError
//* Sets error description for specified error condition exposed by call to .NET  
//*
//* Error description layout
//*			| Call <failedFunction> failed.<EOL>
//*			| Error Text: <errorText> (*)
//* (*): Line skipped when <ErrorText> is empty
//*----------------------------------------------------------------------------------------*/

/* Format description*/
String ls_error
ls_error = "Call " + as_failedFunction + " failed."
If Len(Trim(as_errorText)) > 0 Then
	ls_error += "~r~nError Text: " + as_errorText
End If

/* Retain state in instance variables*/
This.il_ErrorType = This.CALL_FAILURE
This.is_ErrorText = ls_error
This.il_ErrorNumber = 0
end subroutine

public subroutine of_reseterror ();
//*--------------------------------------------*/
//* PUBLIC of_ResetError
//* Clears previously registered error
//*--------------------------------------------*/

This.il_ErrorType = This.SUCCESS
This.is_ErrorText = ''
This.il_ErrorNumber = 0
end subroutine

public function boolean of_createondemand ();
//*--------------------------------------------------------------*/
//*  PUBLIC   of_createOnDemand( )
//*  Return   True:  .NET object created
//*               False: Failed to create .NET object
//*  Loads .NET assembly and creates instance of .NET class.
//*  Uses .NET Framework when loading .NET assembly.
//*  Signals error If an error occurs.
//*  Resets any prior error when load + create succeeds.
//*--------------------------------------------------------------*/

This.of_ResetError( )
If This.ib_objectCreated Then Return True // Already created => DONE

Long ll_status 
String ls_action

/* Load assembly using .NET Framework */
ls_action = 'Load ' + This.is_AssemblyPath
DotNetAssembly lnv_assembly
lnv_assembly = Create DotNetAssembly
ll_status = lnv_assembly.LoadWithDotNetFramework(This.is_AssemblyPath)

/* Abort when load fails */
If ll_status <> 1 Then
	This.of_SetAssemblyError(This.LOAD_FAILURE, ls_action, ll_status, lnv_assembly.ErrorText)
	This.of_SignalError( )
	Return False // Load failed => ABORT
End If

/*   Create .NET object */
ls_action = 'Create ' + This.is_ClassName
ll_status = lnv_assembly.CreateInstance(is_ClassName, This)

/* Abort when create fails */
If ll_status <> 1 Then
	This.of_SetAssemblyError(This.CREATE_FAILURE, ls_action, ll_status, lnv_assembly.ErrorText)
	This.of_SignalError( )
	Return False // Load failed => ABORT
End If

This.ib_objectCreated = True
Return True
end function

private subroutine of_setassemblyerror (long al_errortype, string as_actiontext, long al_errornumber, string as_errortext);
//*----------------------------------------------------------------------------------------------*/
//* PRIVATE of_setAssemblyError
//* Sets error description for specified error condition report by an assembly function
//*
//* Error description layout
//* 		| <actionText> failed.<EOL>
//* 		| Error Number: <errorNumber><EOL>
//* 		| Error Text: <errorText> (*)
//*  (*): Line skipped when <ErrorText> is empty
//*----------------------------------------------------------------------------------------------*/

/*    Format description */
String ls_error
ls_error = as_actionText + " failed.~r~n"
ls_error += "Error Number: " + String(al_errorNumber) + "."
If Len(Trim(as_errorText)) > 0 Then
	ls_error += "~r~nError Text: " + as_errorText
End If

/*  Retain state in instance variables */
This.il_ErrorType = al_errorType
This.is_ErrorText = ls_error
This.il_ErrorNumber = al_errorNumber
end subroutine

public subroutine of_geterrorhandler (ref powerobject apo_currenthandler,ref string as_currentevent);
//*-------------------------------------------------------------------------*/
//* PUBLIC of_GetErrorHandler
//* Return as REF-parameters current error handler (incl. event)
//*-------------------------------------------------------------------------*/

apo_currentHandler = This.ipo_errorHandler
as_currentEvent = This.is_errorEvent
end subroutine

public subroutine of_reseterrorhandler ();
//*---------------------------------------------------*/
//* PUBLIC of_ResetErrorHandler
//* Removes current error handler (incl. event)
//*---------------------------------------------------*/

SetNull(This.ipo_errorHandler)
SetNull(This.is_errorEvent)
end subroutine

public function long of_logevent(string as_objectname,string as_scriptname,string as_message,long al_severity);
//*-----------------------------------------------------------------*/
//*  .NET function : LogEvent
//*   Argument:
//*              String as_objectname
//*              String as_scriptname
//*              String as_message
//*              Long al_severity
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "LogEvent"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.logevent(as_objectname,as_scriptname,as_message,al_severity)
	Return ll_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(ll_result)
	Return ll_result
End Try
end function

public subroutine  of_getimagesize(string as_sourcefile,ref long al_width,ref long al_height);
//*-----------------------------------------------------------------*/
//*  .NET function : GetImageSize
//*   Argument:
//*              String as_sourcefile
//*              Long al_width
//*              Long al_height
//*   Return : (None)
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function

/* Set the dotnet function name */
ls_function = "GetImageSize"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		Return 
	End If

	/* Trigger the dotnet function */
	This.getimagesize(as_sourcefile,ref al_width,ref al_height)
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

End Try
end subroutine

public subroutine  of_getimageinfo(string as_sourcefile,ref long al_width,ref long al_height,ref long al_hresolution,ref long al_vresolution);
//*-----------------------------------------------------------------*/
//*  .NET function : GetImageInfo
//*   Argument:
//*              String as_sourcefile
//*              Long al_width
//*              Long al_height
//*              Long al_hresolution
//*              Long al_vresolution
//*   Return : (None)
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function

/* Set the dotnet function name */
ls_function = "GetImageInfo"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		Return 
	End If

	/* Trigger the dotnet function */
	This.getimageinfo(as_sourcefile,ref al_width,ref al_height,ref al_hresolution,ref al_vresolution)
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

End Try
end subroutine

public subroutine  of_getimagesizepixels(string as_sourcefile,ref long al_width,ref long al_height);
//*-----------------------------------------------------------------*/
//*  .NET function : GetImageSizePixels
//*   Argument:
//*              String as_sourcefile
//*              Long al_width
//*              Long al_height
//*   Return : (None)
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function

/* Set the dotnet function name */
ls_function = "GetImageSizePixels"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		Return 
	End If

	/* Trigger the dotnet function */
	This.getimagesizepixels(as_sourcefile,ref al_width,ref al_height)
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

End Try
end subroutine

public function long of_convertto1bppbmp(string as_sourcefile,string as_outputfile);
//*-----------------------------------------------------------------*/
//*  .NET function : ConvertTo1bppBmp
//*   Argument:
//*              String as_sourcefile
//*              String as_outputfile
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "ConvertTo1bppBmp"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.convertto1bppbmp(as_sourcefile,as_outputfile)
	Return ll_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(ll_result)
	Return ll_result
End Try
end function

public function long of_resizedarkenbitmap(string as_sourcefile,string as_outputfile,long al_outputwidth,long al_outputheight,long al_luminancecutoff);
//*-----------------------------------------------------------------*/
//*  .NET function : ResizeDarkenBitmap
//*   Argument:
//*              String as_sourcefile
//*              String as_outputfile
//*              Long al_outputwidth
//*              Long al_outputheight
//*              Long al_luminancecutoff
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "ResizeDarkenBitmap"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.resizedarkenbitmap(as_sourcefile,as_outputfile,al_outputwidth,al_outputheight,al_luminancecutoff)
	Return ll_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(ll_result)
	Return ll_result
End Try
end function

on nvo_imagemanipulation.create
call super::create
triggerevent( this, "constructor" )
end on

on nvo_imagemanipulation.destroy
triggerevent( this, "destructor" )
call super::destroy
end on

