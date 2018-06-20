Create Procedure [EntityCode].[CustomerInfoInsert]	
	@FirstName			nvarchar(50),
	@MiddleName			nvarchar(50),
	@LastName			nvarchar(50),
	@BirthDate			datetime,
	@GenderId			int,
	@CustomerTypeKey	uniqueidentifier,
	@ActivityContextId	int,
	@Key				uniqueidentifier
AS
	-- Local variables
	Declare @Id As int
	Declare @EntityId As Int
	Declare @CustomerTypeId As int
	-- Initialize
	Select  @Key			= IsNull(NullIf(@Key, N'00000000-0000-0000-0000-000000000000'), NewId())
	Select 	@FirstName		= RTRIM(LTRIM(@FirstName))
	Select 	@MiddleName		= RTRIM(LTRIM(@MiddleName))
	Select 	@LastName		= RTRIM(LTRIM(@LastName))

	-- Only update with good data
	If ((@FirstName <> '') Or (@MiddleName <> '') Or (@LastName <> '')) And @ActivityContextId <> -1
	Begin
		Begin Tran;
		-- Insert
		Begin Try
			-- Get CustomerTypeId from key
			Select @CustomerTypeId = IsNull(CustomerTypeId, -1) From [Entity].[CustomerType] Where CustomerTypeKey = @CustomerTypeKey
			-- Create Customer record
			Insert Into [Entity].[Customer] (CustomerKey, FirstName, MiddleName, LastName, BirthDate, GenderId, CustomerTypeId, ActivityContextId)
				Values (@Key, @FirstName, @MiddleName, @LastName, @BirthDate, @GenderId, @CustomerTypeId, @ActivityContextId)	
			Select	@Id = SCOPE_IDENTITY()
			Commit;
		End Try
		Begin Catch
			Rollback;
			Exec [Activity].[ExceptionLogInsertByActivity] @ActivityContextId;
			Throw;
		End Catch
	End	

	-- Return data
	Select IsNull(@Id, -1) As Id, IsNull(@Key, N'00000000-0000-0000-0000-000000000000') As [Key]
