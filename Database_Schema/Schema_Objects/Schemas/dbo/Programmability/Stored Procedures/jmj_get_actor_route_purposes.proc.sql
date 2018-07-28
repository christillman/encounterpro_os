CREATE PROCEDURE jmj_get_actor_route_purposes (
	@ps_user_id varchar(24),
	@ps_document_route varchar(24) )
AS

IF @ps_user_id IS NULL
	BEGIN
	RAISERROR ('Null user_id',16,-1)
	RETURN
	END

IF @ps_document_route IS NULL
	BEGIN
	RAISERROR ('Null document_route',16,-1)
	RETURN
	END

SELECT [purpose]
      ,[allow_flag]
      ,selected_flag=0
FROM dbo.fn_actor_route_purposes(@ps_user_id, @ps_document_route)


