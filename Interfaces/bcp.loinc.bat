
REM The installed path to UTF-8 compatible bcp. This is the 64-bit version.
SET PATH_TO_BCP="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\bcp.exe"

REM The server designation, this one is a local SQL SERVER Express 
REM I access through Windows user permisson
SET MSSQLSERVER=DESKTOP-GU15HUD\ENCOUNTERPRO

SET IMPORT_FILE_PATH=E:\EncounterPro\LOINC\Loinc_2.64_Text_2.64

SET UTILITY_PATH=C:\Users\tofft\source\repos\ConsoleApp1\ConsoleApp1\bin\Debug

SET SCRIPT_PATH=E:\EncounterPro\encounter_pro_os\Interfaces

REM Execute the table setup script. 
sqlcmd -i "%SCRIPT_PATH%\create_loinc_tables.sql" -S %MSSQLSERVER% -d interfaces -E

"%UTILITY_PATH%\Csv2TabDel.exe" "%IMPORT_FILE_PATH%\Loinc.csv"
"%UTILITY_PATH%\Csv2TabDel.exe" "%IMPORT_FILE_PATH%\MapTo.csv"
"%UTILITY_PATH%\Csv2TabDel.exe" "%IMPORT_FILE_PATH%\SourceOrganization.csv"

%PATH_TO_BCP% Loinc in "%IMPORT_FILE_PATH%\Loinc.csv.tabdel" -S %MSSQLSERVER% -C 65001 -d interfaces -T -c -F 2
%PATH_TO_BCP% LoincMapTo in "%IMPORT_FILE_PATH%\MapTo.csv.tabdel" -S %MSSQLSERVER% -C 65001 -d interfaces -T -c -F 2
%PATH_TO_BCP% LoincSourceOrganization in "%IMPORT_FILE_PATH%\SourceOrganization.csv.tabdel" -S %MSSQLSERVER% -C 65001 -d interfaces -T -c -F 2
