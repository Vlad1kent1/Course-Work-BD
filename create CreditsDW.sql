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

-- Створення таблиці DimDate
CREATE TABLE DimDate (
    date_id INT PRIMARY KEY IDENTITY(1,1), -- Унікальний ідентифікатор дати
    date DATE NOT NULL UNIQUE, -- Дата
    day INT NOT NULL, -- День місяця
    month INT NOT NULL, -- Місяць
    year INT NOT NULL, -- Рік
    week INT, -- Тиждень року
    quarter INT -- Квартал року
);

-- Створення таблиці DimClients
CREATE TABLE DimClients (
    clients_id INT PRIMARY KEY IDENTITY(1,1), -- Унікальний ідентифікатор клієнта
    name NVARCHAR(255) NOT NULL, -- Ім'я клієнта
    account_number NVARCHAR(50) NOT NULL UNIQUE, -- Номер рахунку
    tax_code NVARCHAR(50) NOT NULL UNIQUE, -- Податковий код
    legal_address NVARCHAR(255), -- Юридична адреса
    actual_address NVARCHAR(255), -- Фактична адреса
    boss_name NVARCHAR(255), -- Ім'я керівника
    rating FLOAT, -- Рейтинг клієнта
	Cl_Key INT NOT NULL UNIQUE
);

-- Створення таблиці DimCreditContracts
CREATE TABLE DimCreditContracts (
    credit_id INT PRIMARY KEY IDENTITY(1,1), -- Унікальний ідентифікатор кредитного договору
    contract_number NVARCHAR(50) NOT NULL UNIQUE, -- Номер договору
    start_date DATE NOT NULL, -- Дата початку
    amount DECIMAL(18, 2) NOT NULL, -- Сума кредиту
    term INT NOT NULL, -- Термін кредиту (у днях)
    interest_rate FLOAT NOT NULL, -- Річна відсоткова ставка
    repayment_schedule_type NVARCHAR(50), -- Тип графіка погашення
    collateral NVARCHAR(255), -- Інформація про заставу
	Cr_Key INT NOT NULL UNIQUE
);

-- Створення таблиці DimRepaymentSchedule
CREATE TABLE DimRepaymentSchedule (
    rep_id INT PRIMARY KEY IDENTITY(1,1), -- Унікальний ідентифікатор графіка погашення
    payment_date DATE NOT NULL, -- Дата платежу
    repayment_amount DECIMAL(18, 2) NOT NULL, -- Сума основного боргу
    charge_amount DECIMAL(18, 2) NOT NULL, -- Сума відсотків
    credit_id INT NOT NULL, -- Посилання на DimCreditContracts
    FOREIGN KEY (credit_id) REFERENCES DimCreditContracts(credit_id),
	Rep_Key INT NOT NULL UNIQUE
);

-- Створення таблиці FactPayments
CREATE TABLE FactPayments (
    fact_id INT PRIMARY KEY IDENTITY(1,1), -- Унікальний ідентифікатор платежу
    payment_date_id INT NOT NULL, -- Посилання на DimDate
    clients_id INT NOT NULL, -- Посилання на DimClients
    contract_id INT NOT NULL, -- Посилання на DimCreditContracts
    rep_id INT NOT NULL, -- Посилання на DimRepaymentSchedule
    payment_amount DECIMAL(18, 2) NOT NULL, -- Сума платежу
    repayment_amount DECIMAL(18, 2), -- Сума основного боргу
    charge_amount DECIMAL(18, 2), -- Сума відсотків
    penalty_amount DECIMAL(18, 2), -- Сума пені
    FOREIGN KEY (payment_date_id) REFERENCES DimDate(date_id),
    FOREIGN KEY (clients_id) REFERENCES DimClients(clients_id),
    FOREIGN KEY (contract_id) REFERENCES DimCreditContracts(credit_id),
    FOREIGN KEY (rep_id) REFERENCES DimRepaymentSchedule(rep_id)
);
