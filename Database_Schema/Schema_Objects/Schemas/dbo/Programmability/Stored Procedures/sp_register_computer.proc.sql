CREATE PROCEDURE sp_register_computer
	(
	@ps_office_id varchar(4) = NULL,
	@ps_logon_id varchar(40),
	@ps_computername varchar(40),
	@pl_computer_id int OUTPUT
	)
AS

SELECT @pl_computer_id = computer_id
FROM o_Computers
WHERE computername = @ps_computername 
AND office_id = @ps_office_id 
AND logon_id = @ps_logon_id 

IF @@ROWCOUNT = 1
	RETURN

INSERT INTO o_Computers
	(
	computername,
	office_id,
	logon_id,
	status)
VALUES (
	@ps_computername,
	@ps_office_id,
	@ps_logon_id,
	'OK')

SELECT @pl_computer_id = @@IDENTITY


