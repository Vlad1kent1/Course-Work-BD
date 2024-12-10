USE Credits
SELECT 'dbo.Clients' AS TableName, COUNT(*) AS [RowCount] FROM dbo.Clients
UNION ALL
SELECT 'dbo.Credit_Contracts' AS TableName, COUNT(*) AS [RowCount] FROM [dbo].[Credit_Contracts]
UNION ALL
SELECT 'dbo.Payments' AS TableName, COUNT(*) AS [RowCount] FROM [dbo].[Payments]
UNION ALL
SELECT 'dbo.Repayment_Schedule' AS TableName, COUNT(*) AS [RowCount] FROM dbo.Repayment_Schedule;

USE CreditsDW
SELECT 'dbo.DimClients' AS TableName, COUNT(*) AS [RowCount] FROM dbo.DimClients
UNION ALL
SELECT 'dbo.DimCreditContracts' AS TableName, COUNT(*) AS [RowCount] FROM [dbo].[DimCreditContracts]
UNION ALL
SELECT 'dbo.DimDate' AS TableName, COUNT(*) AS [RowCount] FROM [dbo].[DimDate]
UNION ALL
SELECT 'dbo.DimRepaymentSchedule' AS TableName, COUNT(*) AS [RowCount] FROM dbo.DimRepaymentSchedule
UNION ALL
SELECT 'dbo.FactPayments' AS TableName, COUNT(*) AS [RowCount] FROM [dbo].[FactPayments];
