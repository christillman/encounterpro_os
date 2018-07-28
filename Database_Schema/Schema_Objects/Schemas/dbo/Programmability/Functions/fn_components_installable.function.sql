CREATE FUNCTION dbo.fn_components_installable (
	@pl_computer_id int
	)

RETURNS @components TABLE (
	[component_id] [varchar](24) NOT NULL,
	[component_type] [varchar](24) NOT NULL,
	[component_install_type] [varchar](24) NULL,
	[component] [varchar](24) NOT NULL,
	[component_base_class] [varchar](128) NULL,
	[component_wrapper_class] [varchar](255) NULL,
	[description] [varchar](80) NULL,
	[license_data] [varchar](2000) NULL,
	[license_status] [varchar](24) NOT NULL ,
	[license_expiration_date] [datetime] NULL,
	[normal_or_testing] [char] (1) NOT NULL,
	[version] [int] NULL,
	[version_name] [varchar] (64) NULL,
	[component_class] [varchar](128) NULL,
	[component_location] [varchar](255) NULL,
	[component_data] [varchar](255) NULL,
	[release_status] [varchar] (12) NULL ,
	[release_status_date_time] [datetime] NULL ,
	[installer] [varchar] (24) NOT NULL ,
	[independence] [varchar] (24) NOT NULL ,
	[id] [uniqueidentifier] NOT NULL ,
	[status] [varchar](12) NOT NULL ,
	[owner_id] [int] NULL,
	[created] [datetime] NOT NULL ,
	[last_updated] [datetime] NULL
	)
AS

BEGIN

DECLARE @ls_computer_id varchar(40),
		@ls_component_trial_mode varchar(255)

SET @ls_computer_id = CAST(@pl_computer_id AS varchar(40))

SET @ls_component_trial_mode = dbo.fn_get_specific_preference('SYSTEM', 'Computer', @ls_computer_id, 'Component Trial Mode')
IF LEFT(@ls_component_trial_mode, 1) IN ('T', 'Y')
	BEGIN
	INSERT INTO @components (
		component_id
		,component_type
		,component_install_type
		,component
		,component_base_class
		,component_wrapper_class
		,description
		,license_data
		,license_status
		,license_expiration_date
		,normal_or_testing
		,version
		,version_name
		,component_class
		,component_location
		,component_data
		,release_status
		,release_status_date_time
		,installer
		,independence
		,id
		,status
		,owner_id
		,created
		,last_updated )
	SELECT d.component_id
			,d.component_type
			,d.component_install_type
			,d.component
			,t.base_class
			,t.component_wrapper_class
			,d.description
			,d.license_data
			,d.license_status
			,d.license_expiration_date
			,'T'
			,v.version
			,v.compile_name
			,v.component_class
			,v.component_location
			,v.component_data
			,v.release_status
			,v.release_status_date_time
			,v.installer
			,v.independence
			,d.id
			,d.status
			,d.owner_id
			,d.created
			,d.last_updated
	FROM dbo.c_Component_Definition d
		INNER JOIN c_Component_Type t
		ON d.component_type = t.component_type
		INNER JOIN c_Component_Version v
		ON d.component_id = v.component_id
		AND d.testing_version = v.version
	WHERE v.independence IN ('Single', 'Multi')
	END

INSERT INTO @components (
	component_id
	,component_type
	,component_install_type
	,component
	,component_base_class
	,component_wrapper_class
	,description
	,license_data
	,license_status
	,license_expiration_date
	,normal_or_testing
	,version
	,version_name
	,component_class
	,component_location
	,component_data
	,release_status
	,release_status_date_time
	,installer
	,independence
	,id
	,status
	,owner_id
	,created
	,last_updated )
SELECT d.component_id
		,d.component_type
		,d.component_install_type
		,d.component
		,t.base_class
		,t.component_wrapper_class
		,d.description
		,d.license_data
		,d.license_status
		,d.license_expiration_date
		,'N'
		,v.version
		,v.compile_name
		,v.component_class
		,v.component_location
		,v.component_data
		,v.release_status
		,v.release_status_date_time
		,v.installer
		,v.independence
		,d.id
		,d.status
		,d.owner_id
		,d.created
		,d.last_updated
FROM dbo.c_Component_Definition d
	INNER JOIN c_Component_Type t
	ON d.component_type = t.component_type
	INNER JOIN c_Component_Version v
	ON d.component_id = v.component_id
	AND d.normal_version = v.version
WHERE v.independence IN ('Single', 'Multi')
AND NOT EXISTS (
	SELECT 1
	FROM @components x
	WHERE x.component_id = d.component_id)


RETURN

END

