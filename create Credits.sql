USE master

CREATE DATABASE [Credits]
CONTAINMENT = NONE
ON PRIMARY 
(
    NAME = N'Credits', 
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Credits.mdf', 
    SIZE = 500MB,                             
    MAXSIZE = UNLIMITED,                           
    FILEGROWTH = 50MB                         
)
LOG ON 
(
    NAME = N'Credits_log', 
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Credits_log.ldf', 
    SIZE = 2000MB,                             
    MAXSIZE = 20GB,                            
    FILEGROWTH = 10%                        
);

USE [Credits]

-- ��������� ������� Clients
CREATE TABLE Clients (
    id INT PRIMARY KEY IDENTITY(1,1), -- ��������� ������������� �볺���
    account_number NVARCHAR(50) UNIQUE NOT NULL, -- ��������� ����� �������
    name NVARCHAR(255) NOT NULL, -- ����� ��'� �볺���
    tax_code NVARCHAR(50) UNIQUE NOT NULL, -- ��������� ���������� ���
    legal_address NVARCHAR(255), -- ������������ �������� ������
    actual_address NVARCHAR(255), -- �������� ������
    boss_name NVARCHAR(255), -- ����� ��'� �������� ��� ��������
    rating FLOAT -- ������� �볺���
);

-- ��������� ������� Credit_Contracts
CREATE TABLE Credit_Contracts (
    id INT PRIMARY KEY IDENTITY(1,1), -- ��������� ������������� ���������� ��������
    contract_number NVARCHAR(50) UNIQUE NOT NULL, -- ��������� ����� ��������
    start_date DATE NOT NULL, -- ���� ������� ��������
    amount DECIMAL(15, 2) NOT NULL, -- �������� ���� �������
    term INT NOT NULL, -- ��������� ������� � ����
    interest_rate FLOAT NOT NULL, -- г��� ��������� ������
    repayment_schedule_type NVARCHAR(50), -- ��� ������� ���������
    collateral NVARCHAR(255), -- ���� �������
    client_id INT NOT NULL, -- ��������� �� �볺���
    FOREIGN KEY (client_id) REFERENCES Clients(id) -- ��'���� � �������� Clients
);

-- ��������� ������� Repayment_Schedule
CREATE TABLE Repayment_Schedule (
    id INT PRIMARY KEY IDENTITY(1,1), -- ��������� ������������� ������� ���������
    payment_date DATE NOT NULL, -- ����������� ���� ���������
    repayment_amount DECIMAL(15, 2) NOT NULL, -- ������� ���� ���������
    charge_amount DECIMAL(15, 2) NOT NULL, -- ��������� ������� �� ���� ���������
    contract_id INT NOT NULL, -- ��������� �� ��������� ������
    FOREIGN KEY (contract_id) REFERENCES Credit_Contracts(id) -- ��'���� � �������� Credit_Contracts
);

-- ��������� ������� Payments
CREATE TABLE Payments (
    id INT PRIMARY KEY IDENTITY(1,1), -- ��������� ������������� �������
    payment_date DATE NOT NULL, -- ���� ��������� �������
    payment_amount DECIMAL(15, 2) NOT NULL, -- �������� ���� �������
    client_id INT NOT NULL, -- ��������� �� �볺���
    schedule_id INT NOT NULL, -- ��������� �� ������ ���������
    FOREIGN KEY (client_id) REFERENCES Clients(id), -- ��'���� � �������� Clients
    FOREIGN KEY (schedule_id) REFERENCES Repayment_Schedule(id) -- ��'���� � �������� Repayment_Schedule
);
