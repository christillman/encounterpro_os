CREATE TRIGGER tr_p_patient_update ON dbo.p_Patient
FOR UPDATE
AS


IF @@ROWCOUNT = 0
	RETURN

DECLARE @ll_count int

IF UPDATE(billing_id)
	BEGIN
	SELECT @ll_count = count(*)
	FROM inserted i
	WHERE EXISTS (
		SELECT 1
		FROM p_Patient p
		WHERE p.billing_id = i.billing_id
		AND p.cpr_id <> i.cpr_id)

	IF @ll_count > 0
		BEGIN
		RAISERROR('ERROR:  Duplicate billing_id.  Update will be aborted', 16, -1)
		ROLLBACK TRANSACTION
		RETURN
		END
	END

IF UPDATE(primary_provider_id)
	UPDATE p
	SET primary_provider_id = NULL
	FROM inserted i
		INNER JOIN p_Patient p
		ON i.cpr_id = p.cpr_id
	WHERE i.primary_provider_id = ''

-- Update Alias Table
IF UPDATE(last_name)
	BEGIN
	UPDATE a
	SET last_name = i.last_name
	FROM p_Patient_Alias a
		INNER JOIN inserted i
		ON a.cpr_id = i.cpr_id
		AND a.alias_type = 'Primary'
	WHERE i.last_name IS NOT NULL

	IF @@ROWCOUNT = 0
		BEGIN
		INSERT INTO [p_Patient_Alias] (
			[cpr_id] ,
			[alias_type] ,
			[first_name] ,
			[last_name] ,
			[middle_name] ,
			[name_prefix] ,
			[name_suffix] ,
			[degree] ,
			[created] ,
			[created_by] ,
			[id] )
		SELECT [cpr_id] ,
			'Primary' ,
			[first_name] ,
			[last_name] ,
			[middle_name] ,
			[name_prefix] ,
			[name_suffix] ,
			[degree] ,
			[created] ,
			COALESCE([created_by], '#SYSTEM') ,
			newid()
		FROM inserted i
		WHERE last_name IS NOT NULL
		AND NOT EXISTS (SELECT 1
						FROM [p_Patient_Alias] a
						WHERE i.cpr_id = a.cpr_id
						AND a.alias_type = 'Primary')
		END
	END

IF UPDATE(first_name)
	UPDATE a
	SET first_name = i.first_name
	FROM p_Patient_Alias a
		INNER JOIN inserted i
		ON a.cpr_id = i.cpr_id
		AND a.alias_type = 'Primary'

IF UPDATE(middle_name)
	UPDATE a
	SET middle_name = i.middle_name
	FROM p_Patient_Alias a
		INNER JOIN inserted i
		ON a.cpr_id = i.cpr_id
		AND a.alias_type = 'Primary'

IF UPDATE(name_prefix)
	UPDATE a
	SET name_prefix = i.name_prefix
	FROM p_Patient_Alias a
		INNER JOIN inserted i
		ON a.cpr_id = i.cpr_id
		AND a.alias_type = 'Primary'

IF UPDATE(name_suffix)
	UPDATE a
	SET name_suffix = i.name_suffix
	FROM p_Patient_Alias a
		INNER JOIN inserted i
		ON a.cpr_id = i.cpr_id
		AND a.alias_type = 'Primary'

IF UPDATE(degree)
	UPDATE a
	SET degree = i.degree
	FROM p_Patient_Alias a
		INNER JOIN inserted i
		ON a.cpr_id = i.cpr_id
		AND a.alias_type = 'Primary'

IF UPDATE(phone_number)
	BEGIN
	UPDATE p
	SET phone_number = dbo.fn_pretty_phone(p.phone_number)
	FROM p_Patient p
		INNER JOIN inserted i
		ON p.cpr_id = i.cpr_id

	UPDATE p
	SET phone_number_7digit = RIGHT(p.phone_number, 8)
	FROM p_Patient p
		INNER JOIN inserted i
		ON p.cpr_id = i.cpr_id
	END

