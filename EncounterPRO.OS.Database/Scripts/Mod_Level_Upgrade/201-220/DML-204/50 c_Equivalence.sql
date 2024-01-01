
-- Almost all records are bogus, NULL equivalence_group_id
-- (need to remove from insertion procedures)
DELETE a
FROM [c_Equivalence] a
WHERE equivalence_group_id IS NULL

-- Most other groups have only single members; again bogus
DELETE a
FROM [c_Equivalence] a
WHERE equivalence_group_id IN (2,9,10,11,12,13)


