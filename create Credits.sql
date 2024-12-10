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

-- Створення таблиці Clients
CREATE TABLE Clients (
    id INT PRIMARY KEY IDENTITY(1,1), -- Унікальний ідентифікатор клієнта
    account_number NVARCHAR(50) UNIQUE NOT NULL, -- Унікальний номер рахунку
    name NVARCHAR(255) NOT NULL, -- Повне ім'я клієнта
    tax_code NVARCHAR(50) UNIQUE NOT NULL, -- Унікальний податковий код
    legal_address NVARCHAR(255), -- Зареєстрована юридична адреса
    actual_address NVARCHAR(255), -- Фактична адреса
    boss_name NVARCHAR(255), -- Повне ім'я керівника або власника
    rating FLOAT -- Рейтинг клієнта
);

-- Створення таблиці Credit_Contracts
CREATE TABLE Credit_Contracts (
    id INT PRIMARY KEY IDENTITY(1,1), -- Унікальний ідентифікатор кредитного договору
    contract_number NVARCHAR(50) UNIQUE NOT NULL, -- Унікальний номер договору
    start_date DATE NOT NULL, -- Дата початку договору
    amount DECIMAL(15, 2) NOT NULL, -- Загальна сума кредиту
    term INT NOT NULL, -- Тривалість кредиту в днях
    interest_rate FLOAT NOT NULL, -- Річна відсоткова ставка
    repayment_schedule_type NVARCHAR(50), -- Тип графіка погашення
    collateral NVARCHAR(255), -- Опис застави
    client_id INT NOT NULL, -- Посилання на клієнта
    FOREIGN KEY (client_id) REFERENCES Clients(id) -- Зв'язок з таблицею Clients
);

-- Створення таблиці Repayment_Schedule
CREATE TABLE Repayment_Schedule (
    id INT PRIMARY KEY IDENTITY(1,1), -- Унікальний ідентифікатор графіка погашення
    payment_date DATE NOT NULL, -- Запланована дата погашення
    repayment_amount DECIMAL(15, 2) NOT NULL, -- Основна сума погашення
    charge_amount DECIMAL(15, 2) NOT NULL, -- Нараховані відсотки до дати погашення
    contract_id INT NOT NULL, -- Посилання на кредитний договір
    FOREIGN KEY (contract_id) REFERENCES Credit_Contracts(id) -- Зв'язок з таблицею Credit_Contracts
);

-- Створення таблиці Payments
CREATE TABLE Payments (
    id INT PRIMARY KEY IDENTITY(1,1), -- Унікальний ідентифікатор платежу
    payment_date DATE NOT NULL, -- Дата здійснення платежу
    payment_amount DECIMAL(15, 2) NOT NULL, -- Загальна сума платежу
    client_id INT NOT NULL, -- Посилання на клієнта
    schedule_id INT NOT NULL, -- Посилання на графік погашення
    FOREIGN KEY (client_id) REFERENCES Clients(id), -- Зв'язок з таблицею Clients
    FOREIGN KEY (schedule_id) REFERENCES Repayment_Schedule(id) -- Зв'язок з таблицею Repayment_Schedule
);
