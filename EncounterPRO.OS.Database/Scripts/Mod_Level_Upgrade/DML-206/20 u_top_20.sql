-- Sync up u_top_20 with c_Assessment_Definition

UPDATE u
SET u.item_text = d.description  
FROM u_top_20 u
JOIN c_Assessment_Definition d ON d.assessment_id = u.item_id
WHERE top_20_code LIKE '%ASSESS%'
AND d.description != u.item_text
