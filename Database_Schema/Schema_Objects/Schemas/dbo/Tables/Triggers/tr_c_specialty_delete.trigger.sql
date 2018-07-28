CREATE TRIGGER tr_c_specialty_delete ON dbo.c_Specialty
FOR DELETE
AS

DECLARE @ls_specialty_id varchar(24),
		@ls_description varchar(80)

SELECT @ls_specialty_id = max(specialty_id),
	@ls_description = max(description)
FROM deleted

IF EXISTS(SELECT 1 FROM deleted where specialty_id in ('$','$AAANONE'))
BEGIN
            RAISERROR ('Deleting Specialty Records is not allowed (%s, %s)', 16, -1, @ls_specialty_id, @ls_description )
            ROLLBACK TRANSACTION
            RETURN
END

IF EXISTS (SELECT 1
            FROM deleted
            WHERE specialty_id in (SELECT DISTINCT specialty_id FROM c_user)
            OR specialty_id in (SELECT DISTINCT specialty_id FROM p_treatment_item)
            OR specialty_id in (SELECT DISTINCT referral_specialty_id FROM c_treatment_type)
            OR specialty_id in (
                    SELECT c.specialty_id
                    FROM c_consultant c
                              INNER JOIN (SELECT DISTINCT consultant_id = progress_value
                                                FROM p_treatment_progress
                                                  WHERE progress_type = 'Property'
                                                  AND progress_key = 'Consultant') p
                              ON c.consultant_id = p.consultant_id
                    )
            )
      BEGIN
            RAISERROR ('Deleting Specialty Records is not allowed (%s, %s)', 16, -1, @ls_specialty_id, @ls_description )
            ROLLBACK TRANSACTION
            RETURN
      END

