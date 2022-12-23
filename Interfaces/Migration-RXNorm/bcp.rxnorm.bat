
REM The installed path to UTF-8 compatible bcp. This is the 64-bit version.
SET PATH_TO_BCP="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\bcp.exe"

REM The server designation, this one is a local SQL SERVER Express 
REM I access through Windows user permisson
SET MSSQLSERVER=localhost\ENCOUNTERPRO

SET IMPORT_FILE_PATH=C:\Users\tofft\EncounterPro\RXNORM\RxNorm_full_prescribe_07062021\rrf

SET UTILITY_PATH=C:\Users\tofft\source\repos\RRF2TabDel\RRF2TabDel\bin\Debug

SET SCRIPT_PATH=C:\Users\tofft\EncounterPro\encounter_pro_os\Interfaces

REM Execute the table setup script. 
REM sqlcmd -i "%SCRIPT_PATH%\create_rxnorm_tables.sql" -S %MSSQLSERVER% -d interfaces -E

"%UTILITY_PATH%\RRF2TabDel.exe" "%IMPORT_FILE_PATH%\RXNCONSO.RRF"
"%UTILITY_PATH%\RRF2TabDel.exe" "%IMPORT_FILE_PATH%\RXNSAT.RRF"
"%UTILITY_PATH%\RRF2TabDel.exe" "%IMPORT_FILE_PATH%\RXNREL.RRF"

REM "%UTILITY_PATH%\RRF2TabDel.exe" "%IMPORT_FILE_PATH%\RXNATOMARCHIVE.RRF"
REM "%UTILITY_PATH%\RRF2TabDel.exe" "%IMPORT_FILE_PATH%\RXNCUI.RRF"
REM "%UTILITY_PATH%\RRF2TabDel.exe" "%IMPORT_FILE_PATH%\RXNCUICHANGES.RRF"
REM "%UTILITY_PATH%\RRF2TabDel.exe" "%IMPORT_FILE_PATH%\RXNDOC.RRF"
REM "%UTILITY_PATH%\RRF2TabDel.exe" "%IMPORT_FILE_PATH%\RXNSAB.RRF"
REM "%UTILITY_PATH%\RRF2TabDel.exe" "%IMPORT_FILE_PATH%\RXNSTY.RRF"

REM These are actually UTF8
%PATH_TO_BCP% RXNCONSO in "%IMPORT_FILE_PATH%\RXNCONSO.RRF.tabdel" -S %MSSQLSERVER% -C 65001 -d interfaces -T -c
REM %PATH_TO_BCP% RXNCUICHANGES in "%IMPORT_FILE_PATH%\RXNCUICHANGES.RRF.tabdel" -S %MSSQLSERVER% -C 65001 -d interfaces -T -c

REM These are actually ANSI
%PATH_TO_BCP% RXNSAT in "%IMPORT_FILE_PATH%\RXNSAT.RRF.tabdel" -S %MSSQLSERVER% -d interfaces -T -c
%PATH_TO_BCP% RXNREL in "%IMPORT_FILE_PATH%\RXNREL.RRF.tabdel" -S %MSSQLSERVER% -d interfaces -T -c

REM %PATH_TO_BCP% RXNATOMARCHIVE in "%IMPORT_FILE_PATH%\RXNATOMARCHIVE.RRF.tabdel" -S %MSSQLSERVER% -d interfaces -T -c
REM %PATH_TO_BCP% RXNCUI in "%IMPORT_FILE_PATH%\RXNCUI.RRF.tabdel" -S %MSSQLSERVER% -d interfaces -T -c
REM %PATH_TO_BCP% RXNDOC in "%IMPORT_FILE_PATH%\RXNDOC.RRF.tabdel" -S %MSSQLSERVER% -d interfaces -T -c
REM %PATH_TO_BCP% RXNSAB in "%IMPORT_FILE_PATH%\RXNSAB.RRF.tabdel" -S %MSSQLSERVER% -d interfaces -T -c
REM %PATH_TO_BCP% RXNSTY in "%IMPORT_FILE_PATH%\RXNSTY.RRF.tabdel" -S %MSSQLSERVER% -d interfaces -T -c

REM Index afterwards to save time and space!. 
REM sqlcmd -i "%SCRIPT_PATH%\create_rxnorm_indexes.sql" -S %MSSQLSERVER% -d interfaces -E

rem RXTerms from https://wwwcf.nlm.nih.gov/umlslicense/rxtermApp/rxTermData.cfm
REM SET IMPORT_FILE_PATH=E:\EncounterPro\RXNORM
REM %PATH_TO_BCP% RXTERMS in "%IMPORT_FILE_PATH%\RxTerms201806.txt" -S %MSSQLSERVER% -d interfaces -T -t | -c

pause