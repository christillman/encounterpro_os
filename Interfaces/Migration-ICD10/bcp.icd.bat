
REM The installed path to UTF-8 compatible bcp. This is the 64-bit version.
SET PATH_TO_BCP="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\bcp.exe"

REM The server designation, this one is a local SQL SERVER Express 
REM I access through Windows user permisson
SET MSSQLSERVER=DESKTOP-GU15HUD\ENCOUNTERPRO_OS

SET IMPORT_FILE_PATH=C:\EncounterPro\ICD

SET SCRIPT_PATH=C:\EncounterPro\encounterpro_os\Interfaces

REM Execute the table setup script. 
sqlcmd -i "%SCRIPT_PATH%\create_icd_tables.sql" -S %MSSQLSERVER% -d EPRO_OS_105 -E

%PATH_TO_BCP% icd10cm_codes_2019 in "%IMPORT_FILE_PATH%\icd10cm_codes_2019.txt" -f "%SCRIPT_PATH%\icd10cm_codes.fmt" -S %MSSQLSERVER% -d EPRO_OS_105 -T


REM %PATH_TO_BCP% icd10cm_codes_2018 in "%IMPORT_FILE_PATH%\icd10cm_codes_2018_tabdel.txt" -S %MSSQLSERVER% -d interfaces -T -c
REM %PATH_TO_BCP% icd10_gem in "%IMPORT_FILE_PATH%\2018_I10gem.txt" -f "%SCRIPT_PATH%\2018_I10gem.fmt" -S %MSSQLSERVER% -d interfaces -T
REM %PATH_TO_BCP% icd9_gem in "%IMPORT_FILE_PATH%\2018_I9gem.txt" -f "%SCRIPT_PATH%\2018_I9gem.fmt" -S %MSSQLSERVER% -d interfaces -T

REM %PATH_TO_BCP% icd10pcs_codes_2019 in "%IMPORT_FILE_PATH%\icd10pcs_codes_2019_tabdel.txt" -S %MSSQLSERVER% -d interfaces -T -c
