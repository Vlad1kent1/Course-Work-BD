USE master

CREATE DATABASE [CreditsDW]
CONTAINMENT = NONE
ON PRIMARY 
(
    NAME = N'CreditsDW', 
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\CreditsDW.mdf', 
    SIZE = 500MB,                             
    MAXSIZE = UNLIMITED,                           
    FILEGROWTH = 50MB                         
)
LOG ON 
(
    NAME = N'CreditsDW_log', 
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\CreditsDW_log.ldf', 
    SIZE = 2000MB,                             
    MAXSIZE = 20GB,                            
    FILEGROWTH = 10%                        
);

USE CreditsDW

-- ��������� ������� DimDate
CREATE TABLE DimDate (
    date_id INT PRIMARY KEY IDENTITY(1,1), -- ��������� ������������� ����
    date DATE NOT NULL UNIQUE, -- ����
    day INT NOT NULL, -- ���� �����
    month INT NOT NULL, -- ̳����
    year INT NOT NULL, -- г�
    week INT, -- ������� ����
    quarter INT -- ������� ����
);

-- ��������� ������� DimClients
CREATE TABLE DimClients (
    clients_id INT PRIMARY KEY IDENTITY(1,1), -- ��������� ������������� �볺���
    name NVARCHAR(255) NOT NULL, -- ��'� �볺���
    account_number NVARCHAR(50) NOT NULL UNIQUE, -- ����� �������
    tax_code NVARCHAR(50) NOT NULL UNIQUE, -- ���������� ���
    legal_address NVARCHAR(255), -- �������� ������
    actual_address NVARCHAR(255), -- �������� ������
    boss_name NVARCHAR(255), -- ��'� ��������
    rating FLOAT, -- ������� �볺���
	Cl_Key INT NOT NULL UNIQUE
);

-- ��������� ������� DimCreditContracts
CREATE TABLE DimCreditContracts (
    credit_id INT PRIMARY KEY IDENTITY(1,1), -- ��������� ������������� ���������� ��������
    contract_number NVARCHAR(50) NOT NULL UNIQUE, -- ����� ��������
    start_date DATE NOT NULL, -- ���� �������
    amount DECIMAL(18, 2) NOT NULL, -- ���� �������
    term INT NOT NULL, -- ����� ������� (� ����)
    interest_rate FLOAT NOT NULL, -- г��� ��������� ������
    repayment_schedule_type NVARCHAR(50), -- ��� ������� ���������
    collateral NVARCHAR(255), -- ���������� ��� �������
	Cr_Key INT NOT NULL UNIQUE
);

-- ��������� ������� DimRepaymentSchedule
CREATE TABLE DimRepaymentSchedule (
    rep_id INT PRIMARY KEY IDENTITY(1,1), -- ��������� ������������� ������� ���������
    payment_date DATE NOT NULL, -- ���� �������
    repayment_amount DECIMAL(18, 2) NOT NULL, -- ���� ��������� �����
    charge_amount DECIMAL(18, 2) NOT NULL, -- ���� �������
    credit_id INT NOT NULL, -- ��������� �� DimCreditContracts
    FOREIGN KEY (credit_id) REFERENCES DimCreditContracts(credit_id),
	Rep_Key INT NOT NULL UNIQUE
);

-- ��������� ������� FactPayments
CREATE TABLE FactPayments (
    fact_id INT PRIMARY KEY IDENTITY(1,1), -- ��������� ������������� �������
    payment_date_id INT NOT NULL, -- ��������� �� DimDate
    clients_id INT NOT NULL, -- ��������� �� DimClients
    contract_id INT NOT NULL, -- ��������� �� DimCreditContracts
    rep_id INT NOT NULL, -- ��������� �� DimRepaymentSchedule
    payment_amount DECIMAL(18, 2) NOT NULL, -- ���� �������
    repayment_amount DECIMAL(18, 2), -- ���� ��������� �����
    charge_amount DECIMAL(18, 2), -- ���� �������
    penalty_amount DECIMAL(18, 2), -- ���� ���
    FOREIGN KEY (payment_date_id) REFERENCES DimDate(date_id),
    FOREIGN KEY (clients_id) REFERENCES DimClients(clients_id),
    FOREIGN KEY (contract_id) REFERENCES DimCreditContracts(credit_id),
    FOREIGN KEY (rep_id) REFERENCES DimRepaymentSchedule(rep_id)
);
