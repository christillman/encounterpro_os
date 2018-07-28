CREATE TRIGGER tr_p_Observation_update ON dbo.p_Observation
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @obs TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	parent_observation_sequence int NULL,
	abnormal_flag char(1) NULL,
	severity smallint NULL,
	parent_level int NOT NULL )

DECLARE @ll_rowcount int,
		@ll_parent_level int

-- If the abnormal_flag or severity is updated then bubble the values all the way up through the observation tree
IF UPDATE (abnormal_flag) OR UPDATE (severity)
	BEGIN
	SET @ll_rowcount = 1
	SET @ll_parent_level = 1

	INSERT INTO @obs (
		cpr_id ,
		observation_sequence ,
		parent_observation_sequence,
		abnormal_flag,
		severity,
		parent_level )
	SELECT cpr_id ,
		observation_sequence ,
		parent_observation_sequence ,
		abnormal_flag ,
		severity ,
		@ll_parent_level
	FROM inserted


	WHILE @ll_rowcount > 0
		BEGIN
		UPDATE o
		SET abnormal_flag = CASE WHEN o.abnormal_flag = 'Y' OR x.abnormal_flag = 'Y' THEN 'Y' ELSE 'N' END,
			severity = CASE WHEN o.severity < x.severity THEN x.severity ELSE o.severity END
		FROM p_Observation o
			INNER JOIN @obs x
			ON o.cpr_id = x.cpr_id
			AND o.observation_sequence = x.parent_observation_sequence
		WHERE x.parent_level = @ll_parent_level


		INSERT INTO @obs (
			cpr_id ,
			observation_sequence ,
			parent_observation_sequence,
			abnormal_flag,
			severity,
			parent_level )
		SELECT o.cpr_id ,
			o.observation_sequence ,
			o.parent_observation_sequence ,
			o.abnormal_flag,
			o.severity,
			@ll_parent_level + 1
		FROM @obs x
			INNER JOIN p_Observation o
			ON x.cpr_id = o.cpr_id
			AND x.parent_observation_sequence = o.observation_sequence
		WHERE x.parent_level = @ll_parent_level
		
		SET @ll_rowcount = @@ROWCOUNT
		SET @ll_parent_level = @ll_parent_level + 1
		END
	END

