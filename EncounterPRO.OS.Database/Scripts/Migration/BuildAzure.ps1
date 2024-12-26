
# !!!!Caution!!!! Drops the target database
# Takes about an hour to run.

# Azure needs slightly different syntax at times, so this script is used instead of Build.ps.
# These installs may be needed
# python -m pip install --upgrade pip
# pip install python-certifi-win32
# In Powershell 7, elevated:
# Install-Module -Name Az.Accounts -Repository PSGallery -Force

# $env:AZURE_CLI_DISABLE_CONNECTION_VERIFICATION = '1'

$ReleaseVersion = "229"
Write-Host "Build release version direct to Azure: $ReleaseVersion"

#Import-Module -Name dbatools
# this import seems to take a few minutes in a new window
Import-Module SqlServer
Import-Module -Name Az.Accounts
$date = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
Write-Host "Build started: ${date}"
$BaseFolder = (Get-Item .\..\..).FullName
. "$BaseFolder\Scripts\Migration\BuildAzureFunctions.ps1"

$SourceServerInstance = "DESKTOP-1EOB2VV\ENCOUNTERPRO"
$SourceDatabase = "GreenOliveDemo"
$TargetServerInstance = "srv-goehr-demo.database.windows.net"
$TargetDatabase = "GreenOliveDemo"
$ResourceGroupName = "rg-greenolivedemo"

$ErrorActionPreference = 'Stop'

# Not sure if this is needed
# az login --scope https://database.windows.net/.default

Write-Host "Connecting to Azure; note: this token lasts for one hour."
# Connect to the master database. The token also seems to work for a specific database, 
# but not using Get-SqlInstance; just using the target server and database strings.
$AccessToken = Get-SqlDatabaseAccessToken -TenantId "f85e5b8f-980b-4c00-86ba-cb8b7b5b6921" -SubscriptionId "5549f619-d566-4cf0-89cb-699e269440cc"
# $AzureServerMaster = Get-SqlInstance -ServerInstance $TargetServerInstance -AccessToken $AccessToken
<# 
Write-Host "Checking target version"
# first, does a database of this name already exist?
$return = Invoke-Sqlcmd -ServerInstance $AzureServerMaster -AccessToken $AccessToken -Query "select name from sys.databases where name = '$TargetDatabase'"
if ($return.count -eq 1){
	$tableExists = Invoke-Sqlcmd -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken -Query "SELECT 'found' FROM sys.tables WHERE name = 'Version'" | select-string "found"
	if ($tableExists) {
		$releaseExists = Invoke-Sqlcmd -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken -Query "SELECT 'found' FROM dbo.Version WHERE Version = '$ReleaseVersion'" | select-string "found"
		if ($releaseExists) {
			Write-Host "The $ReleaseVersion version has already been deployed to $TargetServerInstance $TargetDatabase. Please increment."
			# exit
		}
	}
	# In case you have difficulty with the script deleting the database, here's who is connected
	Write-Host "Active sessions in target database:"
	Invoke-Sqlcmd -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken -Query "select login_name, host_name, program_name from sys.dm_exec_sessions where login_name like '%pharmac%'"
} #>
<# 
Write-Host "Running 01-CreateAzureDB.sql in master (takes a minute or two to show progress)"
$VarArray = "DATABASE_NAME=$TargetDatabase"
Invoke-Sqlcmd -InputFile "$BaseFolder\Script\Migration\01-CreateAzureDB.sql" -ServerInstance $AzureServerMaster -AccessToken $AccessToken -Variable $VarArray -Verbose

Write-Host "Running 02-DBConfig_Schema_User.sql in $TargetDatabase"
Invoke-Sqlcmd -InputFile "$BaseFolder\Script\Migration\02-DBConfig_Schema_User.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken -Verbose
 #>
 
# Done in PosdtInstall Write-Host "Creating application role"
# Invoke-Sqlcmd -InputFile "$BaseFolder\Scripts\Migration\CreateApplicationRole.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken -Verbose
<## 
Write-Host "Pre-Creating tables"
Create-Database-Object -FullPath "$BaseFolder\Tables\Pre-Create\dbo.c_Database_Status.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken
Create-Database-Object -FullPath "$BaseFolder\Tables\Pre-Create\dbo.c_Observation_Result_Set.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken

Write-Host "Pre-Creating functions"
Create-Database-Object -FullPath "$BaseFolder\Functions\Pre-Create\dbo.get_client_datetime.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken
Run-AllFiles -SourceFolder "$BaseFolder\Functions\Pre-Create" -Match "*.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken

Write-Host "Creating tables"
Run-AllFiles -SourceFolder "$BaseFolder\Tables" -Match "*.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken

Write-Host "Copying data from $SourceDatabase to $TargetDatabase"
$tables = Table-List
Copy-SQLTables -SourceServerInstance $SourceServerInstance -SourceDatabase $SourceDatabase -TargetServerInstance $TargetServerInstance -TargetDatabase $TargetDatabase -Tables $tables -BulkCopyBatchSize 50000 -AccessToken $AccessToken
 ##>

 <# 
Write-Host "Copying to dev.DeviceNames"
# DeviceNames is special case because of strange dateadded text formatting
$ConnectString = "Data Source=sql-pharmac-medical-devices-dbserver.database.windows.net;Pooling=False;Multiple Active Result Sets=False;Encrypt=True;Trust Server Certificate=False;Packet Size=4096;Authentication=ActiveDirectoryInteractive"
$DataConnection = Connect-DbaInstance -SqlInstance $ConnectString -Database $TargetDatabase -AccessToken $AccessToken -NonPooledConnection
$dataset = Invoke-DbaQuery -Query "SELECT [DeviceNameID],[DeviceName], convert(datetime,[DateAdded],0) AS DateAdded FROM [dev].[DeviceNames]" -SqlInstance $SourceSQLInstance -Database $SourceDatabase -As DataSet
$dataset | Write-DbaDbTableData -Schema "dev" -Table "DeviceNames" -BatchSize $BulkCopyBatchSize -EnableException -SqlInstance $AzureServerMD 

Write-Host "Creating triggers"
Run-AllFiles -SourceFolder "$BaseFolder\Triggers" -Match "*.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken

Write-Host "Creating demo triggers"
Run-AllFiles -SourceFolder "C:\EncounterPro\Azure\Demo\Triggers" -Match "*.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken

 #>
<#
Write-Host "Creating column constraints"
Invoke-Sqlcmd -InputFile "$BaseFolder\Constraint\ColumnConstraints.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken 

Write-Host "Creating foreign key constraints"
Invoke-Sqlcmd -InputFile "$BaseFolder\Constraint\ForeignKeyConstraints.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken 

Write-Host "Creating indexes"
Invoke-Sqlcmd -InputFile "$BaseFolder\Index\DropCreateIndexes.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken 
#>
<# 
Write-Host "Creating journalling tables and triggers"
# We haven't done procedures yet, but we need this one now
Create-Database-Object -FullPath "$BaseFolder\Procedure\dbo.Generate_Journalling.StoredProcedure.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken
# and this view
Create-Database-Object -FullPath "$BaseFolder\View\dbo.vwExcluded_From_Audit.View.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken
# -Verbose 4>&1 dumps the PRINT statements from the stored proc into the file
Invoke-Sqlcmd -Query "exec dbo.Generate_Journalling" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken -Verbose 4>&1 | Out-File -Encoding utf8 "$BaseFolder\Script\GeneratedJournalling.sql"
Create-Database-Object -FullPath "$BaseFolder\Script\GeneratedJournalling.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken
#>

 <##
Write-Host "Creating dependent view functions"
Run-AllFiles -SourceFolder "$BaseFolder\Views\Pre-Create" -Match "*.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken
 ##>

Write-Host "Creating views"
Run-AllFiles -SourceFolder "$BaseFolder\Views" -Match "*.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken

Write-Host "Creating $BaseFolder\Functions"
Run-AllFiles -SourceFolder "$BaseFolder\Functions" -Match "*.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken

#Write-Host "Creating dependent procedures"
#Run-Folder -SourceFolder "$BaseFolder\Procedures\Pre-Create" -Match "*.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken

Write-Host "Creating procedures"
Run-AllFiles -SourceFolder "$BaseFolder\Procedures" -Match "*.sql" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken

Write-Host "Updating statistics"
Invoke-Sqlcmd -Query "EXEC sp_UpdateStats" -ServerInstance $TargetServerInstance -Database $TargetDatabase -AccessToken $AccessToken 

$date = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
Write-Host "Migration complete: ${date}"
