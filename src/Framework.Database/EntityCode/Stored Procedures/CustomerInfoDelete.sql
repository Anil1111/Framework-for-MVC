Create Procedure [EntityCode].[CustomerInfoDelete]
	@Id					int,
	@ActivityContextId	int,
	@Key				uniqueidentifier
AS
	Begin Tran;
	Begin Try	
		Delete
		From	[Entity].[Customer]
		Where	CustomerKey = @Key
		Commit;
	End Try
	Begin Catch
		Rollback;
		Exec [Activity].[ExceptionLogInsertByActivity] @ActivityContextId;
		Throw;
	End Catch