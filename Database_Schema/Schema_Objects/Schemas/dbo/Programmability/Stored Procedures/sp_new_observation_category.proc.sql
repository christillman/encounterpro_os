CREATE PROCEDURE sp_new_observation_category (
	@ps_treatment_type varchar(24),
	@ps_observation_category_id varchar(24),
	@ps_description varchar(80),
	@pi_sort_sequence smallint,
	@ps_observation_id varchar(24) = NULL)
AS

INSERT INTO c_observation_category (
	treatment_type,
	observation_category_id,
	description,
	sort_sequence )
VALUES (
	@ps_treatment_type,
	@ps_observation_category_id,
	@ps_description,
	@pi_sort_sequence )

-- If an observation_id is supplied, then add the link to the new category
IF @ps_observation_id IS NOT NULL
	INSERT INTO c_observation_observation_cat (
		treatment_type,
		observation_category_id,
		observation_id)
	VALUES (
		@ps_treatment_type,
		@ps_observation_category_id,
		@ps_observation_id )



