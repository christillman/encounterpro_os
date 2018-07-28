CREATE PROCEDURE sp_get_ss_user_profile
(
	@ps_user_id varchar(24)
)
AS

SELECT u.user_id as userid,
	u.last_name as lastname,
	u.first_name as firstname,
	u.dea_number as deanumber,
	u.license_flag as licenseflag,
	p.progress_value as spi,
	o.address1 as address1,
	o.address2 as address2,
	o.city as city,
	o.state as state,
	o.zip as zip,
	o.phone as phone,
	o.fax as fax,
	(SELECT customer_id from c_Database_Status where database_status='OK') as customerid,
	u.npi as npi
FROM c_user u
LEFT OUTER JOIN c_user_progress p
	ON p.progress_type='ID'
	AND p.progress_key='211^SureScript_SPI'
	AND p.user_id=u.user_id
	AND current_flag='Y'
LEFT OUTER JOIN c_office o
	ON o.office_id = COALESCE(u.office_id,
	(SELECT c1.office_id FROM c_office c1 where office_number= (SELECT min(c2.office_number) FROM c_office c2 where c2.status='OK')))
	AND o.status = 'OK'
WHERE u.actor_class='User'
AND u.status='OK'
AND u.user_id = @ps_user_id



