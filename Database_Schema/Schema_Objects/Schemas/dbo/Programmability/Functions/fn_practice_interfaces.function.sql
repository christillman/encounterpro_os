CREATE FUNCTION dbo.fn_practice_interfaces()

RETURNS @interfaces TABLE (
	owner_id int NOT NULL,
	interfaceServiceId int NOT NULL,
	interfacedescription varchar(80) NOT NULL,
	subscriber_owner_id int NOT NULL,
	interfaceServiceType varchar(80) NOT NULL,
	sortSequence int NOT NULL,
	description varchar(50) NOT NULL,
	document_route varchar(24) NULL,
	receive_flag char(1) NULL,
	send_flag char(1) NULL,
	serviceState varchar(20) NOT NULL,
	status varchar(12) NOT NULL,
	created datetime NOT NULL ,
	id uniqueidentifier NOT NULL ,
	last_updated datetime NOT NULL ,
	interfaceServiceType_description varchar(80) NULL ,
	interfaceServiceType_icon varchar(255) NULL
	)

AS
BEGIN

INSERT INTO @interfaces (
	owner_id ,
	interfaceServiceId ,
	interfacedescription ,
	subscriber_owner_id ,
	interfaceServiceType ,
	sortSequence ,
	description ,
	document_route ,
	receive_flag ,
	send_flag ,
	serviceState ,
	status ,
	created ,
	id ,
	last_updated ,
	interfaceServiceType_description ,
	interfaceServiceType_icon )
SELECT i.owner_id ,
	i.interfaceServiceId ,
	i.description ,
	i.subscriber_owner_id ,
	i.interfaceServiceType ,
	i.sortSequence ,
	i.description ,
	i.document_route ,
	i.receive_flag ,
	i.send_flag ,
	i.serviceState ,
	i.status ,
	i.created ,
	i.id ,
	i.last_updated ,
	d.domain_item_description ,
	d.domain_item_bitmap
FROM c_component_interface i
	LEFT OUTER JOIN c_Domain d
	ON d.domain_id = 'InterfaceServiceType'
	AND i.interfaceServiceType = d.domain_item

UPDATE x
SET interfaceServiceType_description = COALESCE(interfaceServiceType_description, interfaceServiceType),
	interfaceServiceType_icon = COALESCE(interfaceServiceType_icon, 'interface_bidirectional_icon.bmp')
FROM @interfaces x


DECLARE @suffix TABLE (
	interfaceserviceid int NOT NULL,
	suffix varchar(30) NULL)

DECLARE @ll_customer_id int

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

INSERT INTO @suffix (
	interfaceserviceid,
	suffix)
SELECT interfaceserviceid,
	CASE status WHEN 'OK' THEN CASE owner_id WHEN @ll_customer_id THEN 'Local' ELSE '' END 
				ELSE CASE owner_id WHEN @ll_customer_id THEN 'Local, Disabled' ELSE 'Disabled' END END
FROM @interfaces

UPDATE x
SET interfacedescription = interfacedescription + ' (' + s.suffix + ')'
FROM @interfaces x
	INNER JOIN @suffix s
	ON x.interfaceserviceid = s.interfaceserviceid
WHERE LEN(s.suffix) > 0

RETURN
END
