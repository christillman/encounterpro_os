
REM The installed path to UTF-8 compatible bcp. This is the 64-bit version.
SET PATH_TO_BCP="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\bcp.exe"

REM The server designation, this one is a local SQL SERVER Express 
REM I access through Windows user permisson
SET MSSQLSERVER=DESKTOP-GU15HUD\ENCOUNTERPRO

SET IMPORT_FILE_PATH=C:\EncounterPro\RXNORM\RxNorm_full_prescribe_05012023\rrf

SET UTILITY_PATH=C:\Users\tofft\source\repos\RRF2TabDel\RRF2TabDel\bin\Debug

SET SCRIPT_PATH=C:\EncounterPro\encounterpro_os\Interfaces\Migration-RXNorm

REM Execute the table setup script. 
sqlcmd -i "%SCRIPT_PATH%\create_rxnorm_tables.sql" -S %MSSQLSERVER% -d interfaces -E
REM or
sqlcmd -i "%SCRIPT_PATH%\truncate_rxnorm_tables.sql" -S %MSSQLSERVER% -d interfaces -E

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
sqlcmd -i "%SCRIPT_PATH%\create_rxnorm_indexes.sql" -S %MSSQLSERVER% -d interfaces -E

rem RXTerms from https://data.lhncbc.nlm.nih.gov/public/rxterms/release/RxTerms202305.zip
SET IMPORT_FILE_PATH=C:\EncounterPro\RXNORM\RxTerms202305
%PATH_TO_BCP% RXTERMS in "%IMPORT_FILE_PATH%\RxTerms202305.txt" -S %MSSQLSERVER% -d interfaces -T -t "|" -c
