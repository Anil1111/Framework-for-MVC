Create View [EntityCode].[CustomerInfo]
As
Select	C.[CustomerId] As [Id],
		Cast(C.[CustomerKey] As uniqueidentifier) As [Key],
		C.[FirstName], 
		C.[MiddleName], 
		C.[LastName], 
		C.[BirthDate], 
		C.[GenderId],
		Cast(CT.[CustomerTypeKey] As uniqueidentifier) As [CustomerTypeKey],
		C.[ActivityContextId],
		C.[CreatedDate], 
		C.[ModifiedDate]
From	[Entity].[Customer] C
Join	[Entity].[CustomerType] CT On C.CustomerTypeId = CT.CustomerTypeId
