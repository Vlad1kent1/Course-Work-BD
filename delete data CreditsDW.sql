USE CreditsDW;

-- ��������� �������� ��������� ������
ALTER TABLE FactPayments NOCHECK CONSTRAINT ALL;
ALTER TABLE DimRepaymentSchedule NOCHECK CONSTRAINT ALL;
ALTER TABLE DimCreditContracts NOCHECK CONSTRAINT ALL;
ALTER TABLE DimClients NOCHECK CONSTRAINT ALL;
ALTER TABLE DimDate NOCHECK CONSTRAINT ALL;

-- ��������� �����
DELETE FROM FactPayments;
DELETE FROM DimCreditContracts;
DELETE FROM DimRepaymentSchedule;
DELETE FROM DimClients;
DELETE FROM DimDate;

DBCC CHECKIDENT ('FactPayments', RESEED, 0);
DBCC CHECKIDENT ('DimCreditContracts', RESEED, 0);
DBCC CHECKIDENT ('DimRepaymentSchedule', RESEED, 0);
DBCC CHECKIDENT ('DimClients', RESEED, 0);
DBCC CHECKIDENT ('DimDate', RESEED, 0);


-- ��������� �������� ��������� ������
ALTER TABLE FactPayments CHECK CONSTRAINT ALL;
ALTER TABLE DimRepaymentSchedule CHECK CONSTRAINT ALL;
ALTER TABLE DimCreditContracts CHECK CONSTRAINT ALL;
ALTER TABLE DimClients CHECK CONSTRAINT ALL;
ALTER TABLE DimDate CHECK CONSTRAINT ALL;