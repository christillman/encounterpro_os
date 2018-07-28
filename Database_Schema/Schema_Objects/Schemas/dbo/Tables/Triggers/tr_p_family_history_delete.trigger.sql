CREATE TRIGGER tr_p_family_history_delete ON dbo.p_Family_History
FOR DELETE
AS
DELETE p_Family_Illness
FROM deleted
WHERE p_Family_Illness.cpr_id = deleted.cpr_id
AND p_Family_Illness.family_history_sequence = deleted.family_history_sequence

