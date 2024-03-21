$PBExportHeader$nvo_utilities.sru
forward
global type nvo_utilities from dotnetobject
end type
end forward

global type nvo_utilities from dotnetobject
event ue_error ( )
end type
global nvo_utilities nvo_utilities

type variables

PUBLIC:
String is_assemblypath = "C:\Program Files (x86)\Common Files\EncounterPRO-OS\EncounterPRO.OS.Utilities\EncounterPRO.OS.Utilities.dll"
String is_classname = "EncounterPRO.OS.Utilities"

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
public function long of_initializeeventlog(string as_source)
public function long of_logevent(string as_objectname,string as_scriptname,string as_message,long al_severity)
public function boolean of_isuseradmin()
public function long of_closeeventlog(string as_source)
public function boolean of_isdomainuserexists(string as_user)
public subroutine  of_domainremoveuser(string as_user)
public subroutine  of_domaincreateuser(string as_user,string as_password,boolean abln_adminprivileges)
public function long of_convertimage(string as_sourcefile,string as_destfile)
public subroutine  of_zip(string as_sourcepath,string as_destfile,long al_compression,boolean abln_subdir)
public function any of_getfilelist(string as_sourcepath,boolean abln_subdir)
public subroutine  of_unzip(string as_sourcefile,string as_destpath,boolean abln_preservepath,string as_zipentry[])
public function any of_zipcontents(string as_sourcefile)
public function blob of_converthextobinary(string as_hex_text)
public function string of_convertbinarytohex(blob ablo_binary)
public function blob of_convertbase64tobinary(string as_base64_text)
public function string of_convertbinarytobase64(blob ablo_binary)
public subroutine  of_setdefaultprinter(string as_newdefaultprinter)
public function string of_getdefaultprinter()
public subroutine  of_executeprogram(string as_executable,string as_arguments)
public subroutine  of_executeprogramas(string as_executable,string as_arguments,string as_asusername,string as_aspassword)
public subroutine  of_executeprogramtimeout(string as_executable,string as_arguments,long al_timeout_milliseconds)
public function long of_bytestofile(string as_filename,blob ablo_data)
public function blob of_filetobytes(string as_filename)
public function long of_saveclipboardtofile(string as_ps_file)
public function long of_getmainwindowhandle(long al_pid)
public function long of_screen_resolution_x()
public function long of_screen_resolution_y()
public function long of_printer_resolution_x()
public function long of_printer_resolution_y()
public function boolean of_closemainwindow(long al_pid,long al_timeout)
public function string of_transformxml(string as_xml,string as_xsl)
public function string of_encryptstring(string as_value,string as_keystring)
public function string of_decryptstring(string as_value,string as_keystring)
public function string get_epversion()
public subroutine  set_epversion(string as_value)
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

public function long of_initializeeventlog(string as_source);
//*-----------------------------------------------------------------*/
//*  .NET function : InitializeEventLog
//*   Argument:
//*              String as_source
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "InitializeEventLog"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.initializeeventlog(as_source)
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

public function boolean of_isuseradmin();
//*-----------------------------------------------------------------*/
//*  .NET function : IsUserAdmin
//*   Return : Boolean
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Boolean lbln_result

/* Set the dotnet function name */
ls_function = "IsUserAdmin"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(lbln_result)
		Return lbln_result
	End If

	/* Trigger the dotnet function */
	lbln_result = This.isuseradmin()
	Return lbln_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(lbln_result)
	Return lbln_result
End Try
end function

public function long of_closeeventlog(string as_source);
//*-----------------------------------------------------------------*/
//*  .NET function : CloseEventLog
//*   Argument:
//*              String as_source
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "CloseEventLog"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.closeeventlog(as_source)
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

public function boolean of_isdomainuserexists(string as_user);
//*-----------------------------------------------------------------*/
//*  .NET function : IsDomainUserExists
//*   Argument:
//*              String as_user
//*   Return : Boolean
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Boolean lbln_result

/* Set the dotnet function name */
ls_function = "IsDomainUserExists"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(lbln_result)
		Return lbln_result
	End If

	/* Trigger the dotnet function */
	lbln_result = This.isdomainuserexists(as_user)
	Return lbln_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(lbln_result)
	Return lbln_result
End Try
end function

public subroutine  of_domainremoveuser(string as_user);
//*-----------------------------------------------------------------*/
//*  .NET function : DomainRemoveUser
//*   Argument:
//*              String as_user
//*   Return : (None)
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function

/* Set the dotnet function name */
ls_function = "DomainRemoveUser"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		Return 
	End If

	/* Trigger the dotnet function */
	This.domainremoveuser(as_user)
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

End Try
end subroutine

public subroutine  of_domaincreateuser(string as_user,string as_password,boolean abln_adminprivileges);
//*-----------------------------------------------------------------*/
//*  .NET function : DomainCreateUser
//*   Argument:
//*              String as_user
//*              String as_password
//*              Boolean abln_adminprivileges
//*   Return : (None)
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function

/* Set the dotnet function name */
ls_function = "DomainCreateUser"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		Return 
	End If

	/* Trigger the dotnet function */
	This.domaincreateuser(as_user,as_password,abln_adminprivileges)
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

End Try
end subroutine

public function long of_convertimage(string as_sourcefile,string as_destfile);
//*-----------------------------------------------------------------*/
//*  .NET function : ConvertImage
//*   Argument:
//*              String as_sourcefile
//*              String as_destfile
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "ConvertImage"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.convertimage(as_sourcefile,as_destfile)
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

public subroutine  of_zip(string as_sourcepath,string as_destfile,long al_compression,boolean abln_subdir);
//*-----------------------------------------------------------------*/
//*  .NET function : ZIP
//*   Argument:
//*              String as_sourcepath
//*              String as_destfile
//*              Long al_compression
//*              Boolean abln_subdir
//*   Return : (None)
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function

/* Set the dotnet function name */
ls_function = "ZIP"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		Return 
	End If

	/* Trigger the dotnet function */
	This.zip(as_sourcepath,as_destfile,al_compression,abln_subdir)
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

End Try
end subroutine

public function any of_getfilelist(string as_sourcepath,boolean abln_subdir);
//*-----------------------------------------------------------------*/
//*  .NET function : GetFileList
//*   Argument:
//*              String as_sourcepath
//*              Boolean abln_subdir
//*   Return : String[]
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Any ls_result

/* Set the dotnet function name */
ls_function = "GetFileList"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ls_result)
		Return ls_result
	End If

	/* Trigger the dotnet function */
	ls_result = This.getfilelist(as_sourcepath,abln_subdir)
	Return ls_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(ls_result)
	Return ls_result
End Try
end function

public subroutine  of_unzip(string as_sourcefile,string as_destpath,boolean abln_preservepath,string as_zipentry[]);
//*-----------------------------------------------------------------*/
//*  .NET function : UnZIP
//*   Argument:
//*              String as_sourcefile
//*              String as_destpath
//*              Boolean abln_preservepath
//*              String as_zipentry[]
//*   Return : (None)
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function

/* Set the dotnet function name */
ls_function = "UnZIP"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		Return 
	End If

	/* Trigger the dotnet function */
	This.unzip(as_sourcefile,as_destpath,abln_preservepath,as_zipentry)
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

End Try
end subroutine

public function any of_zipcontents(string as_sourcefile);
//*-----------------------------------------------------------------*/
//*  .NET function : ZIPContents
//*   Argument:
//*              String as_sourcefile
//*   Return : String[]
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Any ls_result

/* Set the dotnet function name */
ls_function = "ZIPContents"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ls_result)
		Return ls_result
	End If

	/* Trigger the dotnet function */
	ls_result = This.zipcontents(as_sourcefile)
	Return ls_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(ls_result)
	Return ls_result
End Try
end function

public function blob of_converthextobinary(string as_hex_text);
//*-----------------------------------------------------------------*/
//*  .NET function : ConvertHexToBinary
//*   Argument:
//*              String as_hex_text
//*   Return : Blob
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Blob lbyt_result

/* Set the dotnet function name */
ls_function = "ConvertHexToBinary"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(lbyt_result)
		Return lbyt_result
	End If

	/* Trigger the dotnet function */
	lbyt_result = This.converthextobinary(as_hex_text)
	Return lbyt_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(lbyt_result)
	Return lbyt_result
End Try
end function

public function string of_convertbinarytohex(blob ablo_binary);
//*-----------------------------------------------------------------*/
//*  .NET function : ConvertBinaryToHex
//*   Argument:
//*              Blob ablo_binary
//*   Return : String
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
String ls_result

/* Set the dotnet function name */
ls_function = "ConvertBinaryToHex"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ls_result)
		Return ls_result
	End If

	/* Trigger the dotnet function */
	ls_result = This.convertbinarytohex(ablo_binary)
	Return ls_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(ls_result)
	Return ls_result
End Try
end function

public function blob of_convertbase64tobinary(string as_base64_text);
//*-----------------------------------------------------------------*/
//*  .NET function : ConvertBase64ToBinary
//*   Argument:
//*              String as_base64_text
//*   Return : Blob
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Blob lbyt_result

/* Set the dotnet function name */
ls_function = "ConvertBase64ToBinary"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(lbyt_result)
		Return lbyt_result
	End If

	/* Trigger the dotnet function */
	lbyt_result = This.convertbase64tobinary(as_base64_text)
	Return lbyt_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(lbyt_result)
	Return lbyt_result
End Try
end function

public function string of_convertbinarytobase64(blob ablo_binary);
//*-----------------------------------------------------------------*/
//*  .NET function : ConvertBinaryToBase64
//*   Argument:
//*              Blob ablo_binary
//*   Return : String
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
String ls_result

/* Set the dotnet function name */
ls_function = "ConvertBinaryToBase64"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ls_result)
		Return ls_result
	End If

	/* Trigger the dotnet function */
	ls_result = This.convertbinarytobase64(ablo_binary)
	Return ls_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(ls_result)
	Return ls_result
End Try
end function

public subroutine  of_setdefaultprinter(string as_newdefaultprinter);
//*-----------------------------------------------------------------*/
//*  .NET function : SetDefaultPrinter
//*   Argument:
//*              String as_newdefaultprinter
//*   Return : (None)
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function

/* Set the dotnet function name */
ls_function = "SetDefaultPrinter"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		Return 
	End If

	/* Trigger the dotnet function */
	This.setdefaultprinter(as_newdefaultprinter)
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

End Try
end subroutine

public function string of_getdefaultprinter();
//*-----------------------------------------------------------------*/
//*  .NET function : GetDefaultPrinter
//*   Return : String
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
String ls_result

/* Set the dotnet function name */
ls_function = "GetDefaultPrinter"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ls_result)
		Return ls_result
	End If

	/* Trigger the dotnet function */
	ls_result = This.getdefaultprinter()
	Return ls_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(ls_result)
	Return ls_result
End Try
end function

public subroutine  of_executeprogram(string as_executable,string as_arguments);
//*-----------------------------------------------------------------*/
//*  .NET function : ExecuteProgram
//*   Argument:
//*              String as_executable
//*              String as_arguments
//*   Return : (None)
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function

/* Set the dotnet function name */
ls_function = "ExecuteProgram"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		Return 
	End If

	/* Trigger the dotnet function */
	This.executeprogram(as_executable,as_arguments)
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

End Try
end subroutine

public subroutine  of_executeprogramas(string as_executable,string as_arguments,string as_asusername,string as_aspassword);
//*-----------------------------------------------------------------*/
//*  .NET function : ExecuteProgramAs
//*   Argument:
//*              String as_executable
//*              String as_arguments
//*              String as_asusername
//*              String as_aspassword
//*   Return : (None)
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function

/* Set the dotnet function name */
ls_function = "ExecuteProgramAs"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		Return 
	End If

	/* Trigger the dotnet function */
	This.executeprogramas(as_executable,as_arguments,as_asusername,as_aspassword)
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

End Try
end subroutine

public subroutine  of_executeprogramtimeout(string as_executable,string as_arguments,long al_timeout_milliseconds);
//*-----------------------------------------------------------------*/
//*  .NET function : ExecuteProgramTimeout
//*   Argument:
//*              String as_executable
//*              String as_arguments
//*              Long al_timeout_milliseconds
//*   Return : (None)
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function

/* Set the dotnet function name */
ls_function = "ExecuteProgramTimeout"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		Return 
	End If

	/* Trigger the dotnet function */
	This.executeprogramtimeout(as_executable,as_arguments,al_timeout_milliseconds)
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

End Try
end subroutine

public function long of_bytestofile(string as_filename,blob ablo_data);
//*-----------------------------------------------------------------*/
//*  .NET function : BytesToFile
//*   Argument:
//*              String as_filename
//*              Blob ablo_data
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "BytesToFile"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.bytestofile(as_filename,ablo_data)
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

public function blob of_filetobytes(string as_filename);
//*-----------------------------------------------------------------*/
//*  .NET function : FileToBytes
//*   Argument:
//*              String as_filename
//*   Return : Blob
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Blob lbyt_result

/* Set the dotnet function name */
ls_function = "FileToBytes"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(lbyt_result)
		Return lbyt_result
	End If

	/* Trigger the dotnet function */
	lbyt_result = This.filetobytes(as_filename)
	Return lbyt_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(lbyt_result)
	Return lbyt_result
End Try
end function

public function long of_saveclipboardtofile(string as_ps_file);
//*-----------------------------------------------------------------*/
//*  .NET function : SaveClipboardToFile
//*   Argument:
//*              String as_ps_file
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "SaveClipboardToFile"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.saveclipboardtofile(as_ps_file)
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

public function long of_getmainwindowhandle(long al_pid);
//*-----------------------------------------------------------------*/
//*  .NET function : GetMainWindowHandle
//*   Argument:
//*              Long al_pid
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "GetMainWindowHandle"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.getmainwindowhandle(al_pid)
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

public function long of_screen_resolution_x();
//*-----------------------------------------------------------------*/
//*  .NET function : screen_resolution_x
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "screen_resolution_x"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.screen_resolution_x()
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

public function long of_screen_resolution_y();
//*-----------------------------------------------------------------*/
//*  .NET function : screen_resolution_y
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "screen_resolution_y"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.screen_resolution_y()
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

public function long of_printer_resolution_x();
//*-----------------------------------------------------------------*/
//*  .NET function : printer_resolution_x
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "printer_resolution_x"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.printer_resolution_x()
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

public function long of_printer_resolution_y();
//*-----------------------------------------------------------------*/
//*  .NET function : printer_resolution_y
//*   Return : Long
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Long ll_result

/* Set the dotnet function name */
ls_function = "printer_resolution_y"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ll_result)
		Return ll_result
	End If

	/* Trigger the dotnet function */
	ll_result = This.printer_resolution_y()
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

public function boolean of_closemainwindow(long al_pid,long al_timeout);
//*-----------------------------------------------------------------*/
//*  .NET function : CloseMainWindow
//*   Argument:
//*              Long al_pid
//*              Long al_timeout
//*   Return : Boolean
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
Boolean lbln_result

/* Set the dotnet function name */
ls_function = "CloseMainWindow"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(lbln_result)
		Return lbln_result
	End If

	/* Trigger the dotnet function */
	lbln_result = This.closemainwindow(al_pid,al_timeout)
	Return lbln_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(lbln_result)
	Return lbln_result
End Try
end function

public function string of_transformxml(string as_xml,string as_xsl);
//*-----------------------------------------------------------------*/
//*  .NET function : TransformXML
//*   Argument:
//*              String as_xml
//*              String as_xsl
//*   Return : String
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
String ls_result

/* Set the dotnet function name */
ls_function = "TransformXML"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ls_result)
		Return ls_result
	End If

	/* Trigger the dotnet function */
	ls_result = This.transformxml(as_xml,as_xsl)
	Return ls_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(ls_result)
	Return ls_result
End Try
end function

public function string of_encryptstring(string as_value,string as_keystring);
//*-----------------------------------------------------------------*/
//*  .NET function : EncryptString
//*   Argument:
//*              String as_value
//*              String as_keystring
//*   Return : String
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
String ls_result

/* Set the dotnet function name */
ls_function = "EncryptString"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ls_result)
		Return ls_result
	End If

	/* Trigger the dotnet function */
	ls_result = This.encryptstring(as_value,as_keystring)
	Return ls_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(ls_result)
	Return ls_result
End Try
end function

public function string of_decryptstring(string as_value,string as_keystring);
//*-----------------------------------------------------------------*/
//*  .NET function : DecryptString
//*   Argument:
//*              String as_value
//*              String as_keystring
//*   Return : String
//*-----------------------------------------------------------------*/
/* .NET  function name */
String ls_function
String ls_result

/* Set the dotnet function name */
ls_function = "DecryptString"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ls_result)
		Return ls_result
	End If

	/* Trigger the dotnet function */
	ls_result = This.decryptstring(as_value,as_keystring)
	Return ls_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_function, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(ls_result)
	Return ls_result
End Try
end function

public function string get_epversion();
//*-----------------------------------------------------------------*/
//*  .NET property : EPVersion
//*   Return : String
//*-----------------------------------------------------------------*/
/* .NET  property name */
String ls_property
String ls_result

/* Set the dotnet property name */
ls_property = "EPVersion"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		SetNull(ls_result)
		Return ls_result
	End If

	/* Trigger the dotnet property */
	ls_result = This.epversion
	Return ls_result
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_property, re_error.text)
	This.of_SignalError( )

	/*  Indicate error occurred */
	SetNull(ls_result)
	Return ls_result
End Try
end function

public subroutine  set_epversion(string as_value);
//*-----------------------------------------------------------------*/
//*  .NET property : EPVersion
//*   Argument:
//*              String as_value
//*   Return : (None)
//*-----------------------------------------------------------------*/
/* .NET  property name */
String ls_property

/* Set the dotnet property name */
ls_property = "EPVersion"

Try
	/* Create .NET object */
	If Not This.of_createOnDemand( ) Then
		Return 
	End If

	/* Trigger the dotnet property */
	This.epversion = as_value
Catch(runtimeerror re_error)

	If This.ib_CrashOnException Then Throw re_error

	/*   Handle .NET error */
	This.of_SetDotNETError(ls_property, re_error.text)
	This.of_SignalError( )

End Try
end subroutine

on nvo_utilities.create
call super::create
triggerevent( this, "constructor" )
end on

on nvo_utilities.destroy
triggerevent( this, "destructor" )
call super::destroy
end on

