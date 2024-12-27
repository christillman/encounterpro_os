# In Admin powershell, you may need to Install-Module SQLServer from PSGallery

function CopyData
{
    [CmdletBinding()]
    param( 
  
        [Parameter(Mandatory=$true)]
        [string] $SourceServerInstance,
 
        [Parameter(Mandatory=$true)]
        [string] $SourceDatabase,        
         
        [Parameter(Mandatory=$true)]
        [string] $TargetServerInstance,
         
        [Parameter(Mandatory=$false)]
        [string] $SourceTableAndSchema,

		[Parameter(Mandatory=$true)]
		[string] $TargetDatabase,
		
        [Parameter(Mandatory=$false)]
        [string] $TargetSchema,
		
        [Parameter(Mandatory=$false)]
        [string] $TargetTable,
         
        [Parameter(Mandatory=$false)]
        [int] $BulkCopyBatchSize = 1000000,
 
        [Parameter(Mandatory=$false)]
        [int] $BulkCopyTimeout = 600,
 		
		[Parameter(Mandatory=$true)]
		[string] $SourceQuery
 
    )
	$TargetTableAndSchema = $TargetSchema + "." + $TargetTable
	$conTargetString = $conTargetString = "Server=$TargetServerInstance;Database=$TargetDatabase;User ID=demo1@srv-goehr-demo;Password=Gr33nOl1ve;"

	$conTarget = New-Object System.Data.SQLClient.SQLConnection($conTargetString)
	$conTarget.Open()

	# Preserve the identity values, don't create new ones
	$copyOptions = [System.Data.SQLClient.SqlBulkCopyOptions]::TableLock + [System.Data.SQLClient.SqlBulkCopyOptions]::KeepIdentity
	$conBulk = New-Object System.Data.SQLClient.SQLBulkCopy($conTargetString, $copyOptions)
	$conBulk.DestinationTableName = $TargetTableAndSchema
	$conBulk.BatchSize = $BulkCopyBatchSize

	$cmdTarget = New-Object System.Data.SQLClient.SQLCommand
	$cmdTarget.Connection = $conTarget

	$cmdTarget.CommandText = "truncate table $TargetTableAndSchema"
	$cmdTarget.ExecuteNonQuery() | Out-Null

	$conSourceString = "Data Source=$SourceServerInstance;Initial Catalog=$SourceDatabase;Integrated Security=True"
	$conSource = New-Object System.Data.SQLClient.SQLConnection($conSourceString)
	$conSource.Open()

	$cmdSource = New-Object System.Data.SQLClient.SQLCommand
	$cmdSource.CommandText = $SourceQuery
	$cmdSource.Connection = $conSource

	$tabSource = $cmdSource.ExecuteReader()
	$conBulk.WriteToServer($tabSource)

	$conSource.Close()
	$conSource.Dispose()

	$conTarget.Close()
	$conTarget.Dispose() 
}

function Copy-SQLTable
{
    [CmdletBinding()]
    param( 
  
        [Parameter(Mandatory=$true)]
        [string] $SourceServerInstance,
 
        [Parameter(Mandatory=$true)]
        [string] $SourceDatabase,        
         
        [Parameter(Mandatory=$true)]
        [string] $TargetServerInstance,
         
        [Parameter(Mandatory=$false)]
        [string] $SourceTableAndSchema,

		[Parameter(Mandatory=$true)]
		[string] $TargetDatabase,
		
        [Parameter(Mandatory=$false)]
        [string] $TargetSchema,
		
        [Parameter(Mandatory=$false)]
        [string] $TargetTable,
         
        [Parameter(Mandatory=$false)]
        [int] $BulkCopyBatchSize = 10000,
 
        [Parameter(Mandatory=$false)]
        [int] $BulkCopyTimeout = 600,
 		
		[Parameter(Mandatory=$true)]
		[string] $AccessToken
 
    )
	# Write-Host "Processing $SourceTableAndSchema"
	# $Tablescript = ($table.Script() | Out-String)
	# $Tablescript
	$date = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
 	Write-Host "Copying to $TargetSchema.$TargetTable ${date}"

	# With SqlServer module we need to build our input query as we want it 
	# instead of instead of building a column map. 
	# Get the column names from the target database, that way we 
	# avoid columns left behind, Write-SqlTableData doesn't care 
	# about the column names, as long as the data types are correct
	# and the source database is case insensitive so column names are
	# interpreted correctly with different case
	$columnsQuery = "SELECT STRING_AGG( c.name,'],[') FROM sys.columns c `
join sys.tables t on t.object_id = c.object_id `
join sys.schemas s on s.schema_id = t.schema_id `
WHERE s.name = '$TargetSchema' AND t.name='$TargetTable' and c.is_computed = 0"
 	# $columnsQuery += " AND c.name NOT LIKE '%TimeStamp'"
	# Exclude columns which are new to the migrated database (they won't be in the source database)
	"columnsQuery: $columnsQuery"
	$columns = Invoke-Sqlcmd -ServerInstance $TargetServerInstance -Database $TargetDatabase -Query $columnsQuery -AccessToken $AccessToken -QueryTimeout 300
	# We internally quoted the column list columns because of columns with spaces and invalid column name symbols like &
	# Now we need to surround the result with the beginning and ending quote symbols
	$colList = "[" + $columns[0] + "]"
	$sourceQuery = "select $colList from $SourceTableAndSchema"
	# colList: $colList"
	"sourceQuery: $sourceQuery"

	# $dataTable = Invoke-Sqlcmd -ServerInstance $SourceServerInstance -Database $SourceDatabase -TrustServerCertificate -Query $sourceQuery -As DataTable
	# avoid error if there are no rows in the source table
#	if ($dataTable -ne $null -and $dataTable.Rows.Count -gt 0) {
		try
		{    
			CopyData -SourceServerInstance $SourceServerInstance -SourceDatabase $SourceDatabase -SourceTableAndSchema $SourceTableAndSchema -TargetServerInstance $TargetServerInstance -TargetDatabase $TargetDatabase -TargetSchema $TargetSchema -TargetTable $TargetTable -SourceQuery $sourceQuery
			# Write-SqlTableData -Timeout 900 -ProgressAction SilentlyContinue -InputData $dataTable -ServerInstance $TargetServerInstance -Database $TargetDatabase -SchemaName $TargetSchema -TableName $TargetTable -AccessToken $AccessToken
		}
		catch
		{
			[Exception]$ex = $_.Exception
			write-host $ex.Message
			throw $ex
		}
#	}
}


function Copy-SQLTables
{
    [CmdletBinding()]
    param( 
  
        [Parameter(Mandatory=$true)]
        [string] $SourceServerInstance,
 
        [Parameter(Mandatory=$true)]
        [string] $SourceDatabase,        
         
        [Parameter(Mandatory=$true)]
        [string] $TargetServerInstance,

		[Parameter(Mandatory=$true)]
		[string] $TargetDatabase,
         
        [Parameter(Mandatory=$false)]
        [string[]] $Tables,

        [Parameter(Mandatory=$false)]
        [int] $BulkCopyBatchSize = 1000000,
 
        [Parameter(Mandatory=$false)]
        [int] $BulkCopyTimeout = 600,
  		
		[Parameter(Mandatory=$true)]
		[string] $AccessToken
    )
  	
    try
    {    
           
        foreach($table in $Tables)
        {
			$SourceTableAndSchema = $table
			$TargetSchema = $table.split(".")[0]
			$TargetTable = $table.split(".")[1]
			# Write-Host "Calling Copy-SQLTable for $SourceTableAndSchema"
			Copy-SQLTable -SourceServerInstance $SourceServerInstance -SourceDatabase $SourceDatabase -SourceTableAndSchema $SourceTableAndSchema -TargetServerInstance $TargetServerInstance -TargetDatabase $TargetDatabase -TargetSchema $TargetSchema -TargetTable $TargetTable -AccessToken $AccessToken -BulkCopyBatchSize 50000
         }
 
    }
    catch
    {
        [Exception]$ex = $_.Exception
        write-host $ex.Message
		throw $ex
    }
    finally
    {
        #Return value if any
    }
}


function Table-List
{
<# select '''' + s.name + '.' + t.name + ''', `' from sys.tables t
join sys.schemas s on s.schema_id = t.schema_id
where s.name not in ('jrn','stg')
order by 1
 #>
 
# List of schema.table
[string[]] $tables = @( 
'dbo.b_Appointment_Type', `
'dbo.b_Provider_Translation', `
'dbo.b_Resource', `
'dbo.c_1_record', `
'dbo.c_Actor_Address', `
'dbo.c_Actor_Class', `
'dbo.c_Actor_Class_Purpose', `
'dbo.c_Actor_Class_Route', `
'dbo.c_Actor_Class_Type', `
'dbo.c_Actor_Communication', `
'dbo.c_Actor_Route_Purpose', `
'dbo.c_Administration_Frequency', `
'dbo.c_Administration_Method', `
'dbo.c_Administration_Method_Proc', `
'dbo.c_Adverse_Reaction_Drug', `
'dbo.c_Adverse_Reaction_Drug_Class', `
'dbo.c_Age_Range', `
'dbo.c_Age_Range_Assessment', `
'dbo.c_Age_Range_Category', `
'dbo.c_Age_Range_Procedure', `
'dbo.c_Allergen', `
'dbo.c_Allergen_Drug', `
'dbo.c_Allergen_Drug_Class', `
'dbo.c_Allergy_Drug', `
'dbo.c_Assessment_Category', `
'dbo.c_Assessment_Coding', `
'dbo.c_Assessment_Definition', `
'dbo.c_Assessment_Type', `
'dbo.c_Assessment_Type_Progress_Key', `
'dbo.c_Assessment_Type_Progress_Type', `
'dbo.c_Attachment_Extension', `
'dbo.c_Attachment_Extension_Attribute', `
'dbo.c_Attachment_Location', `
'dbo.c_Attachment_Type', `
'dbo.c_Authority', `
'dbo.c_Authority_Category', `
'dbo.c_Authority_Formulary', `
'dbo.c_Authority_Type', `
'dbo.c_Cdc_BmiAge', `
'dbo.c_Cdc_HcAgeInf', `
'dbo.c_Cdc_LenAgeInf', `
'dbo.c_Cdc_StatAge', `
'dbo.c_Cdc_WtAge', `
'dbo.c_Cdc_WtAgeInf', `
'dbo.c_Cdc_WtLenInf', `
'dbo.c_Cdc_WtStat', `
'dbo.c_Chart', `
'dbo.c_Chart_Alert_Category', `
'dbo.c_Chart_Page_Attribute', `
'dbo.c_Chart_Page_Definition', `
'dbo.c_Chart_Section', `
'dbo.c_Chart_Section_Page', `
'dbo.c_Chart_Section_Page_Attribute', `
'dbo.c_Classification_Set', `
'dbo.c_Classification_Set_Item', `
'dbo.c_Common_Assessment', `
'dbo.c_Common_Drug', `
'dbo.c_Common_Observation', `
'dbo.c_Common_Procedure', `
'dbo.c_Component', `
'dbo.c_Component_Attribute', `
'dbo.c_Component_Attribute_Def', `
'dbo.c_Component_Base_Attribute', `
'dbo.c_Component_Base_Attribute_Def', `
'dbo.c_Component_Definition', `
'dbo.c_Component_Interface', `
'dbo.c_component_interface_object_log', `
'dbo.c_component_interface_route', `
'dbo.c_component_interface_route_property', `
'dbo.c_Component_Log', `
'dbo.c_Component_Param', `
'dbo.c_Component_Param_Class', `
'dbo.c_Component_Registry', `
'dbo.c_Component_Type', `
'dbo.c_Component_Version', `
'dbo.c_Config_Log', `
'dbo.c_Config_Object', `
'dbo.c_Config_Object_Category', `
'dbo.c_Config_Object_Library', `
'dbo.c_Config_Object_Type', `
'dbo.c_Config_Object_Version', `
'dbo.c_Consultant', `
'dbo.c_CPT_Updates', `
'dbo.c_Database_Column', `
'dbo.c_Database_Maintenance', `
'dbo.c_Database_Modification_Dependancy', `
'dbo.c_Database_Script', `
'dbo.c_Database_Script_Log', `
'dbo.c_Database_Script_Type', `
'dbo.c_Database_Status', `
'dbo.c_Database_System', `
'dbo.c_Database_Table', `
'dbo.c_Disease', `
'dbo.c_Disease_Assessment', `
'dbo.c_Disease_Group', `
'dbo.c_Disease_Group_Item', `
'dbo.c_Display_Command_Definition', `
'dbo.c_Display_Format', `
'dbo.c_Display_Format_Item', `
'dbo.c_Display_Script', `
'dbo.c_Display_Script_Cmd_Attribute', `
'dbo.c_Display_Script_Command', `
'dbo.c_Document_Purpose', `
'dbo.c_Document_Route', `
'dbo.c_Document_Type', `
'dbo.c_Domain', `
'dbo.c_Domain_Master', `
'dbo.c_Dosage_Form', `
'dbo.c_Drug_Administration', `
'dbo.c_Drug_Brand', `
'dbo.c_Drug_Category', `
'dbo.c_Drug_Compound', `
'dbo.c_Drug_Definition', `
'dbo.c_Drug_Definition_Archive', `
'dbo.c_Drug_Drug_Category', `
'dbo.c_Drug_EPC', `
'dbo.c_Drug_Formulation', `
'dbo.c_Drug_Generic', `
'dbo.c_Drug_HCPCS', `
'dbo.c_Drug_Instruction', `
'dbo.c_Drug_Interaction', `
'dbo.c_Drug_Interaction_Class', `
'dbo.c_Drug_Maker', `
'dbo.c_Drug_Pack', `
'dbo.c_Drug_Pack_Formulation', `
'dbo.c_Drug_Package', `
'dbo.c_Drug_Package_Archive', `
'dbo.c_Drug_Package_Dispense', `
'dbo.c_Drug_Source_Formulation', `
'dbo.c_Drug_Tall_Man', `
'dbo.c_Drug_Type', `
'dbo.c_Encounter_Procedure', `
'dbo.c_Encounter_Type', `
'dbo.c_Encounter_Type_Progress_Key', `
'dbo.c_Encounter_Type_Progress_Type', `
'dbo.c_EPC', `
'dbo.c_Epro_Object', `
'dbo.c_Equivalence', `
'dbo.c_Equivalence_Group', `
'dbo.c_Event', `
'dbo.c_External_Observation', `
'dbo.c_External_Observation_Location', `
'dbo.c_External_Observation_Result', `
'dbo.c_External_Source', `
'dbo.c_External_Source_Attribute', `
'dbo.c_External_Source_Type', `
'dbo.c_Folder', `
'dbo.c_Folder_Attribute', `
'dbo.c_Folder_Selection', `
'dbo.c_Folder_Workplan', `
'dbo.c_Formulary', `
'dbo.c_Formulary_Type', `
'dbo.c_Growth_Data', `
'dbo.c_ICD_Code', `
'dbo.c_ICD_Properties', `
'dbo.c_ICD_Updates', `
'dbo.c_Immunization_Dose_Schedule', `
'dbo.c_Immunization_Schedule', `
'dbo.c_List_Item', `
'dbo.c_Location', `
'dbo.c_Location_Domain', `
'dbo.c_Maintenance_Assessment', `
'dbo.c_Maintenance_Metric', `
'dbo.c_Maintenance_Patient_Class', `
'dbo.c_Maintenance_Policy', `
'dbo.c_Maintenance_Procedure', `
'dbo.c_Maintenance_Protocol', `
'dbo.c_Maintenance_Protocol_Item', `
'dbo.c_Maintenance_Treatment', `
'dbo.c_Material', `
'dbo.c_Material_Item', `
'dbo.c_Menu', `
'dbo.c_Menu_Item', `
'dbo.c_Menu_Item_Attribute', `
'dbo.c_Message_Definition', `
'dbo.c_Message_Fkey', `
'dbo.c_Message_Part', `
'dbo.c_Message_Stream', `
'dbo.c_Object_Default_Progress_Type', `
'dbo.c_Observation',
'dbo.c_Observation_Result', `
'dbo.c_Observation_Category', `
'dbo.c_Observation_Observation_Cat', `
'dbo.c_Observation_Result_Qualifier', `
'dbo.c_Observation_Result_Range', `
'dbo.c_Observation_Result_Set', `
'dbo.c_Observation_Result_Set_Item', `
'dbo.c_Observation_Stage', `
'dbo.c_Observation_Treatment_Type', `
'dbo.c_Observation_Tree', `
'dbo.c_Observation_Tree_Root', `
'dbo.c_Observation_Type', `
'dbo.c_Office', `
'dbo.c_Owner', `
'dbo.c_Package', `
'dbo.c_Package_Administration_Method', `
'dbo.c_Package_Archive', `
'dbo.c_Patient_material', `
'dbo.c_Patient_material_category', `
'dbo.c_Preference', `
'dbo.c_Preference_Type', `
'dbo.c_Preferred_Provider', `
'dbo.c_Prescription_Format', `
'dbo.c_Privilege', `
'dbo.c_Procedure', `
'dbo.c_Procedure_Category', `
'dbo.c_Procedure_Coding', `
'dbo.c_Procedure_Extra_Charge', `
'dbo.c_Procedure_Material', `
'dbo.c_Procedure_Type', `
'dbo.c_Property', `
'dbo.c_Property_Attribute', `
'dbo.c_Property_Type', `
'dbo.c_Qualifier', `
'dbo.c_Qualifier_Domain', `
'dbo.c_Qualifier_Domain_Category', `
'dbo.c_Query_Term', `
'dbo.c_Report_Attribute', `
'dbo.c_Report_Category', `
'dbo.c_Report_Definition', `
'dbo.c_Report_Params', `
'dbo.c_Report_Recipient', `
'dbo.c_Report_Type', `
'dbo.c_Risk_Factor', `
'dbo.c_Role', `
'dbo.c_Room_Type', `
'dbo.c_Specialty', `
'dbo.c_Specialty_Assessment_Category', `
'dbo.c_Specialty_Drug_Category', `
'dbo.c_Specialty_Observation_Category', `
'dbo.c_Specialty_Procedure_Category', `
'dbo.c_Specimen_Type', `
'dbo.c_Stream', `
'dbo.c_Synonym', `
'dbo.c_Table_Altkey', `
'dbo.c_Table_Fkey', `
'dbo.c_Table_Update', `
'dbo.c_Therapy_Model', `
'dbo.c_Treatment_Type', `
'dbo.c_Treatment_Type_List', `
'dbo.c_Treatment_Type_List_Attribute', `
'dbo.c_Treatment_Type_List_Def', `
'dbo.c_Treatment_Type_Progress_Key', `
'dbo.c_Treatment_Type_Progress_Type', `
'dbo.c_Treatment_Type_Service', `
'dbo.c_Treatment_Type_Service_Attribute', `
'dbo.c_Treatment_Type_Workplan', `
'dbo.c_Unit', `
'dbo.c_Unit_Conversion', `
'dbo.c_Unit_Type', `
'dbo.c_User', `
'dbo.c_User_Progress', `
'dbo.c_User_Role', `
'dbo.c_Vaccine', `
'dbo.c_Vaccine_Disease', `
'dbo.c_Vaccine_Maker', `
'dbo.c_Vaccine_Schedule', `
'dbo.c_Vial_Schedule', `
'dbo.c_Vial_Type', `
'dbo.c_Workplan', `
'dbo.c_Workplan_Item', `
'dbo.c_Workplan_Item_Attribute', `
'dbo.c_Workplan_Selection', `
'dbo.c_Workplan_Step', `
'dbo.c_Workplan_Step_Room', `
'dbo.c_Workplan_Type', `
'dbo.c_XML_Class', `
'dbo.c_XML_Class_Selection', `
'dbo.c_XML_Code', `
'dbo.c_XML_Code_Domain', `
'dbo.c_XML_Code_Domain_Item', `
'dbo.em_Category', `
'dbo.em_Component', `
'dbo.em_Component_Level', `
'dbo.em_Component_Rule', `
'dbo.em_Component_Rule_Item', `
'dbo.em_Documentation_Guide', `
'dbo.em_Element', `
'dbo.em_Observation_Element', `
'dbo.em_Risk', `
'dbo.em_Type', `
'dbo.em_Type_Level', `
'dbo.em_Type_Rule', `
'dbo.em_Type_Rule_Item', `
'dbo.em_Visit_Code_Group', `
'dbo.em_Visit_Code_Item', `
'dbo.em_Visit_Level', `
'dbo.em_Visit_Level_Rule', `
'dbo.em_Visit_Level_Rule_Item', `
'dbo.icd_block', ` `
'dbo.icd10_rwanda', ` `
'dbo.icd10_who', ` `
'dbo.icd10cm_codes', `
'dbo.o_Active_Services', `
'dbo.o_box', `
'dbo.o_Component_Attribute', `
'dbo.o_Component_Base_Attribute', `
'dbo.o_Component_Computer_Attribute', `
'dbo.o_Component_Preference', `
'dbo.o_Component_Selection', `
'dbo.o_Computer_External_Source', `
'dbo.o_Computer_Printer', `
'dbo.o_Computer_Printer_Office', `
'dbo.o_Computers', `
'dbo.o_Event_Component_Attribute', `
'dbo.o_Event_Component_Trigger', `
'dbo.o_Event_Queue', `
'dbo.o_Event_Queue_Attribute', `
'dbo.o_External_Source_Attribute', `
'dbo.o_Group_Rooms', `
'dbo.o_Groups', `
'dbo.o_Log', `
'dbo.o_menu_selection', `
'dbo.o_Message_Log', `
'dbo.o_Message_Subscription', `
'dbo.o_office', `
'dbo.o_Preferences', `
'dbo.o_printer', `
'dbo.o_Report_Attribute', `
'dbo.o_Report_Printer', `
'dbo.o_Report_Trigger', `
'dbo.o_Rooms', `
'dbo.o_Server_Component', `
'dbo.o_Service', `
'dbo.o_Service_Attribute', `
'dbo.o_Service_Schedule', `
'dbo.o_Service_Schedule_Attribute', `
'dbo.o_Service_Trigger', `
'dbo.o_Treatment_Service', `
'dbo.o_Treatment_Type_Default_Mode', `
'dbo.o_User_Logins', `
'dbo.o_User_Privilege', `
'dbo.o_User_Service', `
'dbo.o_User_Service_Lock', `
'dbo.o_Users', `
'dbo.p_Adverse_Reaction', `
'dbo.p_Adverse_Sensitivity_Test', `
'dbo.p_Assessment', `
'dbo.p_assessment_Progress', `
'dbo.p_Assessment_Treatment', `
'dbo.p_Attachment', `
'dbo.p_Attachment_Progress', `
'dbo.p_Chart_Alert', `
'dbo.p_Chart_Alert_Progress', `
'dbo.p_Classification_Set_Item', `
'dbo.p_Encounter_Assessment', `
'dbo.p_Encounter_Assessment_Charge', `
'dbo.p_Encounter_Charge', `
'dbo.p_Encounter_Charge_Modifier', `
'dbo.p_Family_History', `
'dbo.p_Family_Illness', `
'dbo.p_Lastkey', `
'dbo.p_Letter', `
'dbo.p_Maintenance_Class', `
'dbo.p_Material_Used', `
'dbo.p_Object_Security', `
'dbo.p_Objective_Location', `
'dbo.p_Observation', `
'dbo.p_Observation_Comment_Save', `
'dbo.p_Observation_Location', `
'dbo.p_Observation_Result', `
'dbo.p_Observation_Result_Progress', `
'dbo.p_Observation_Result_Qualifier', `
'dbo.p_Patient', `
'dbo.p_Patient_Alias', `
'dbo.p_Patient_Authority', `
'dbo.p_Patient_Encounter', `
'dbo.p_Patient_Encounter_Progress', `
'dbo.p_Patient_Guarantor', `
'dbo.p_patient_list_item', `
'dbo.p_Patient_Progress', `
'dbo.p_Patient_Relation', `
'dbo.p_Patient_WP', `
'dbo.p_Patient_WP_Archive', `
'dbo.p_Patient_WP_Item', `
'dbo.p_Patient_WP_Item_Archive', `
'dbo.p_Patient_WP_Item_Attribute', `
'dbo.p_Patient_WP_Item_Attribute_Archive', `
'dbo.p_Patient_WP_Item_Progress', `
'dbo.p_Patient_WP_Item_Progress_Archive', `
'dbo.p_Propensity', `
'dbo.p_Treatment_Item', `
'dbo.p_Treatment_Progress', `
'dbo.pbcatcol', `
'dbo.pbcatedt', `
'dbo.pbcatfmt', `
'dbo.pbcattbl', `
'dbo.pbcatvld', `
'dbo.r_Assessment_Treatment_Efficacy', `
'dbo.r_Efficacy_Data', `
'dbo.u_assessment_treat_def_attrib', `
'dbo.u_assessment_treat_definition', `
'dbo.u_Chart_Selection', `
'dbo.u_Display_Format_Selection', `
'dbo.u_Display_Script_Selection', `
'dbo.u_Exam_Default_Results', `
'dbo.u_Exam_Definition', `
'dbo.u_Exam_Selection', `
'dbo.u_Top_20', `
'dbo.x_document_mapping', `
'dbo.x_encounterpro_Arrived', `
'dbo.x_External_Application', `
'dbo.x_External_Application_Message', `
'dbo.x_Integration_Operation', `
'dbo.x_Integration_Operation_Tree', `
'dbo.x_Integrations', `
'dbo.x_MedMan_Arrived', `
'dbo.x_Message_Type', `
'dbo.x_Performance_Log', `
'dbo.x_Property_Exception', `
'dbo.x_Translate_A', `
'dbo.x_Translate_P', `
'dbo.x_Translation_Rule', `
'dbo.x_Translation_Set' 
)

return $tables
}

function Audit-Table-List
{
<# select '''' + s.name + '.' + t.name + ''', `' from sys.tables t
join sys.schemas s on s.schema_id = t.schema_id
where s.name in ('adt')
order by 1
 #>
 
[string[]] $tables = @( `
'adt.BrandNames', `
'adt.Categories', `
'adt.Contracts', `
'adt.ContractsCategories', `
'adt.ContractsDevices', `
'adt.DeviceNames', `
'adt.Devices', `
'adt.DevicesCategories', `
'adt.DeviceSortDimensions', `
'adt.Manufacturers', `
'adt.Prices', `
'adt.Suppliers', `
'adt.UOMs' `
)

return $tables
}

function Create-Database-Object
{
	param( 

		[Parameter(Mandatory=$true)]
		[string] $FullPath,

		[Parameter(Mandatory=$true)]
		[string] $ServerInstance,

		[Parameter(Mandatory=$true)]
		[string] $Database,
		
		[Parameter(Mandatory=$true)]
		[string] $AccessToken

	)
	# $FullPath
	$ObjectItem = Get-Item -Path $FullPath
	# $ObjectItem
	$testFileName = $ObjectItem.Name
	$testObjectName = $testFileName.replace(".sql","").replace("dbo.","")
	# $testObjectName
	$checkExistsSQL = "SELECT count(*) from sys.objects where name = '$testObjectName'"
	# $checkExistsSQL
	$count = Invoke-Sqlcmd -Query $checkExistsSQL -ServerInstance $ServerInstance -Database $Database -AccessToken $AccessToken -QueryTimeout 300
	# $count[0]
	if ($count[0] -eq '0') {
		$testObjectName
		# https://stackoverflow.com/questions/21008180/copy-file-with-square-brackets-in-the-filename-and-use-wildcard
		# must escape the square brackets, they are considered wildcard characters
		$itemName = $FullPath.replace('[','``[').replace(']','``]')
		
		# Even with the escaping, Invoke-Sqlcmd fails silently. Use a tempfile
		$tempFile = "$env:TEMP\temp.sql"
		Copy-Item "$itemName" $tempFile
		# Write-Host "Executing $tempFile"
		Invoke-Sqlcmd -InputFile $tempFile -ServerInstance $ServerInstance -Database $Database -AccessToken $AccessToken -QueryTimeout 300 -Verbose
		Remove-Item $tempFile
	}

}

function Run-Folder
{
	param( 

		[Parameter(Mandatory=$true)]
		[string] $SourceFolder,

		[Parameter(Mandatory=$true)]
		[string] $Match,

		[Parameter(Mandatory=$true)]
		[string] $ServerInstance,

		[Parameter(Mandatory=$true)]
		[string] $Database,
		
		[Parameter(Mandatory=$true)]
		[string] $AccessToken
	)

	$items = get-childitem -Path $SourceFolder -filter $Match
	# $items
	foreach ($item in $items) {
		# $item.FullName
		Create-Database-Object -FullPath $item.FullName -ServerInstance $ServerInstance -Database $Database -AccessToken $AccessToken
	}
}


function Run-AllFiles
{
	param( 

		[Parameter(Mandatory=$true)]
		[string] $SourceFolder,

		[Parameter(Mandatory=$true)]
		[string] $Match,

		[Parameter(Mandatory=$true)]
		[string] $ServerInstance,

		[Parameter(Mandatory=$true)]
		[string] $Database,
		
		[Parameter(Mandatory=$true)]
		[string] $AccessToken
	)

	$tempFile = "$env:TEMP\temp.sql"
	if (Test-Path $tempFile) {
		Remove-Item $tempFile
	}
	$items = get-childitem -Path $SourceFolder -filter $Match
	# $items
	foreach ($item in $items) {
		$item.FullName
		$From = Get-Content -Path $item.FullName
		Add-Content -Path $tempFile -Value $From
	}
	Write-Host "Executing $tempFile"
	Invoke-Sqlcmd -InputFile $tempFile -ServerInstance $ServerInstance -Database $Database -AccessToken $AccessToken -QueryTimeout 300 -Verbose
	Remove-Item $tempFile
}

Function Get-SqlDatabaseAccessToken {
    <#
    .SYNOPSIS
    Function Get-SqlDatabaseAccessToken returns access token to connect to Azure SQL Database service.
    .DESCRIPTION
    Function Get-SqlDatabaseAccessToken returns access token to connect to Azure SQL Database service.
    The script authenticate user via default browser. If any step fails, the function returns $null.
	Thanks to https://svitla.com/blog/azure-sql-database/
    .PARAMETER TenantID
    Tenant Id for Azure subscription
    .PARAMETER SubscriptionID
    Azure Subscription Id
    .INPUTS
    None. You cannot pipe objects to Get-SqlDatabaseAccessToken.
    .OUTPUTS
    Get-SqlDatabaseAccessToken returns $null or access token to Azure SQL Database service
    .EXAMPLE
    PS> Get-SqlDatabaseAccessToken -TenantId "2a64c3b0-239f-425b-b657-b2642c95b456" -SubscriptionId "8b84f941-acb0-4397-80ae-f9cb92855a20"
    Returns access token to connect to Azure SQL Database service in Azure subscription '998419f1-5d94-4627-814a-cb2bcd6eee42'
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        # Azure TenantID
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[0-9A-F]{8}[-]{1}(?:[0-9A-F]{4}-){3}[0-9A-F]{12}$')]
        [string]$TenantID,
 
        # Azure SubscriptionID
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[0-9A-F]{8}[-]{1}(?:[0-9A-F]{4}-){3}[0-9A-F]{12}$')]
        [string]$SubscriptionID
    )
 
    #region Connect to Azure and get access token
    # NOTE: connection command will authenticate via default browser
    Connect-AzAccount -Tenant $TenantID | Out-Host;
    if (-not $?) {
        Write-Verbose "Can't connect to Azure Tenant";
        return $null;
    }
    Set-AzContext -Subscription $SubscriptionID | Out-Host;
    if (-not $?) {
        Write-Verbose "Can't connect to Azure Subscription";
        return $null;
    }
	# Adding -AsSecureString here breaks the function when used in Invoke-Sqlcmd
    $objectAccessToken = (Get-AzAccessToken -ResourceUrl "https://database.windows.net/");
    $accessToken = $objectAccessToken.Token;
    if ( -not $accessToken) {
        Write-Verbose "AccessToken is empty, can't connect to Azure SQL Database";
        return $null;
    }
    #endregion
 
    return $accessToken;
}

function Get-ObjectNameParts {
    <#
    .SYNOPSIS
        Parse a one, two, or three part object name into seperate paths
 
    .DESCRIPTION
        Takes a one, two or three part object name and splits them into Database, Schema and Name
 
    .PARAMETER ObjectName
        The object name to parse. You can specify a one, two, or three part object name.
        If the object has special characters they must be wrapped in square brackets [ ].
        If the name contains character ']' this must be escaped by duplicating the character
 
    .NOTES
        Tags: Object, Internal
        Author: Patrick Flynn (@sqllensman)
 
        Website: https://dbatools.io
        Copyright: (c) 2018 by dbatools, licensed under MIT
        License: MIT https://opensource.org/licenses/MIT
 
    .EXAMPLE
        Get-ObjectNameParts -ObjectName 'table'
 
        Parses a three-part name into its constitute parts.
 
    .EXAMPLE
        Get-ObjectNameParts -ObjectName '[Bad. Name]]].[Schema.With.Dots]]].[Another .Silly]] Name..]'
 
        Parses a three-part name into its constitute parts. Uses square brackets to enclose special characters.
    #>
    param (
        [string]$ObjectName
    )
    process {
        $fqtns = @()
        #Object names with a ']' charcter in the name need to be handeled
        #Require charcter to be escaped by being duplicated as per T-SQL QuoteName function
        #These need to be temporarily replaced to allow the object name to be parsed.
        $t = $ObjectName
        if ($t.Contains(']]')) {
            for ($i = 0; $i -le 65535; $i++) {
                $hexStr = '{0:X4}' -f $i
                $fixChar = [regex]::Unescape("\u$hexStr")
                if (!$t.Contains($fixChar)) {
                    $t = $t.Replace(']]', $fixChar)
                    break
                }
            }
        } else {
            $fixChar = $null
        }
        #If the dbo schema is empty as in database..table, it has to filled temorarily to let the regex work.
        if ($t.Contains('..')) {
            for ($i = 0; $i -le 65535; $i++) {
                $hexStr = '{0:X4}' -f $i
                $fixSchema = [regex]::Unescape("\u$hexStr")
                if (!$t.Contains($fixSchema)) {
                    $t = $t.Replace('..', ".$fixSchema.")
                    break
                }
            }
        } else {
            $fixSchema = $null
        }
        $splitName = [regex]::Matches($t, "(\[.+?\])|([^\.]+)").Value
        $dotcount = $splitName.Count

        $dbName = $schema = $name = $null

        switch ($dotcount) {
            1 {
                $name = $t
                $parsed = $true
            }
            2 {
                $schema = $splitName[0]
                $name = $splitName[1]
                $parsed = $true
            }
            3 {
                $dbName = $splitName[0]
                $schema = $splitName[1]
                $name = $splitName[2]
                $parsed = $true
            }
            default {
                $parsed = $false
            }
        }
        if ($dbName -like "[[]*[]]") {
            $dbName = $dbName.Substring(1, ($dbName.Length - 2))
            if ($fixChar) {
                $dbName = $dbName.Replace($fixChar, ']')
            }
        }

        if ($schema -like "[[]*[]]") {
            $schema = $schema.Substring(1, ($schema.Length - 2))
            if ($fixChar) {
                $schema = $schema.Replace($fixChar, ']')
            }
        }

        if ($name -like "[[]*[]]") {
            $name = $name.Substring(1, ($name.Length - 2))
            if ($fixChar) {
                $name = $name.Replace($fixChar, ']')
            }
        }

        if ($fixSchema) {
            $dbName = $dbName.Replace($fixSchema, '')
            if ($schema -eq $fixSchema) {
                $schema = $null
            } else {
                $schema = $dbName.Replace($fixSchema, '')
            }
            $name = $name.Replace($fixSchema, '')
        }

        $fqtns = [PSCustomObject] @{
            InputValue = $ObjectName
            Database   = $dbName
            Schema     = $schema
            Name       = $name
            Parsed     = $parsed
        }
        return $fqtns
    }
}

