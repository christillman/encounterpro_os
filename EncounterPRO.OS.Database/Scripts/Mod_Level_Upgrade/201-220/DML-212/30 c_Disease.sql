
DELETE FROM [c_Disease]
WHERE [disease_id] IN (14,15,19)
DELETE FROM [c_Disease_Group]
WHERE [disease_group] IN ('Yellow Fever','BCG','DTwP/DTaP','Smallpox-Monkeypox','Anthrax','Zoster')
-- the trigger should already take care of this
DELETE FROM [c_Disease_Group_Item]
WHERE [disease_group] IN ('Yellow Fever','BCG','DTwP/DTaP','Smallpox-Monkeypox','Anthrax','Zoster')

UPDATE [c_Disease]
SET [description] = 'TB (Tuberculosis)'
WHERE disease_id = 449

INSERT INTO [dbo].[c_Disease] ([description], [status], [disease_id]) VALUES
('Smallpox and Monkeypox','OK', 14),
('Anthrax','OK', 15),
('Herpes Zoster (Shingles)','OK', 19)

INSERT INTO [dbo].[c_Disease_Group] ([disease_group], [description], [status], [sort_sequence]) VALUES
('Smallpox-Monkeypox','Smallpox and Monkeypox','OK', 14),
('Anthrax','Anthrax','OK', 15),
('Yellow Fever','Yellow Fever','OK', 16),
('BCG','BCG','OK', 17),
('DTwP/DTaP','DTwP or DTaP','OK', 18),
('Zoster','Zoster','OK', 19)

INSERT INTO [dbo].[c_Disease_Group_Item] ([disease_group], [disease_id]) VALUES
('Smallpox-Monkeypox', 14),
('Anthrax', 15),
('Yellow Fever', 192),
('BCG', 449),
('DTwP/DTaP', 2),
('DTwP/DTaP', 3),
('DTwP/DTaP', 4),
('Zoster', 19)
