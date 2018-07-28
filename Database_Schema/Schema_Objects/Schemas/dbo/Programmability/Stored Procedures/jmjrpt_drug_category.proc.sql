

CREATE PROCEDURE jmjrpt_drug_category
AS
select distinct cd.common_name
,cdc.description as Category
from c_drug_definition cd with (NOLOCK)
left outer join c_drug_drug_category cddc with (NOLOCK)
on cd.drug_id = cddc.drug_id
left outer join c_drug_category cdc with (NOLOCK)
on cddc.drug_category_id = cdc.drug_category_id
where cd.status = 'OK'
group by cd.common_name,cdc.description
order by cd.common_name