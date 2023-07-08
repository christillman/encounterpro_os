# Install powershell if needed (cmd)
winget search Microsoft.PowerShell
winget install --id Microsoft.Powershell --source winget

# Run powershell as administrator
Set-PSRepository PSGallery
Install-Module dbatools
Get-DbaComputerCertificate -ComputerName localhost
# Shows available certificate details. Copy the thumbprint
Set-DbaNetworkCertificate -SqlInstance "localhost\EncounterPro" -Thumbprint 677AA5F78E2AB8A4C8210380CB125D9006089047
# In SQL Server configuration manager, Properties in Network Configuration -> Protocols set Certificate and tick Force Encryption

# If all that doesn't work,
Set-DbatoolsConfig -FullName sql.connection.trustcert -Value $true -Register
Set-DbatoolsConfig -FullName sql.connection.encrypt -Value $false -Register
# and tick the Trust Server Certificate box in SSMS conneciton dialog.

# Import-DbaCsv -Path "C:\EncounterPro\RXNORM\05_02_2022_UgandaDrugs_Massaged_Review 1-Revised.csv" -SqlInstance "[DESKTOP-GU15HUD\EncounterPro]"  -Database EncounterPro_Os  -Truncate  -KeepNulls  -AutoCreateTable -UseFileNameForSchema  -TrimmingOption All  -Encoding UTF8  -SkipEmptyLine  -SupportsMultiline  -UseColumnDefault  -NoTransaction  -EnableException 
# Import-DbaCsv -Path "C:\EncounterPro\RXNORM\202303_UgandaNumbers.txt" -SqlInstance "[DESKTOP-GU15HUD\EncounterPro]"  -Database EncounterPro_Os  -Truncate  -KeepNulls  -AutoCreateTable -UseFileNameForSchema  -TrimmingOption All  -Encoding UTF8  -SkipEmptyLine  -SupportsMultiline  -UseColumnDefault  -NoTransaction  -EnableException 
Import-DbaCsv -Path "C:\EncounterPro\encounterpro_os\Interfaces\Migration-Uganda\UgandaJune2023.csv"  -SqlInstance "localhost\EncounterPro"  -Database EncounterPro_Os  -Truncate  -KeepNulls  -AutoCreateTable -UseFileNameForSchema  -TrimmingOption All  -Encoding UTF8  -SkipEmptyLine  -SupportsMultiline  -UseColumnDefault  -NoTransaction  -EnableException
