USE Credits

DELIMITER $$

-- ������ ��� ������������� ���������� ��������
CREATE TRIGGER CalculateClientRating
AFTER INSERT OR UPDATE ON Payments
FOR EACH ROW
BEGIN
    DECLARE S DECIMAL(10, 2);         -- ���� �������
    DECLARE D INT;                   -- ����� �������� (� ����)
    DECLARE D_fact INT;              -- ��������� ����� ������������ �������� (� ����)
    DECLARE S_zal DECIMAL(10, 2);    -- ������� ���� �������
    DECLARE P_fact DECIMAL(10, 2);   -- �������� ������� ��������
    DECLARE d_ahead INT;             -- ���� ��� ������������
    DECLARE d_late INT;              -- ���� ��� ����������
    DECLARE rating FLOAT;            -- ������� �볺���

    -- �������� ��� ��� ��������� ������, ���'������ �� �볺����
    SELECT 
        cc.amount, 
        cc.term, 
        DATEDIFF(CURDATE(), cc.start_date) AS D_fact,
        (cc.amount - IFNULL(SUM(p.payment_amount), 0)) AS S_zal,
        IFNULL(SUM(r.charge_amount), 0) AS P_fact,
        SUM(DATEDIFF(r.payment_date, CURDATE())) AS d_ahead,
        SUM(DATEDIFF(CURDATE(), r.payment_date)) AS d_late
    INTO 
        S, D, D_fact, S_zal, P_fact, d_ahead, d_late
    FROM 
        Credit_Contracts cc
    LEFT JOIN 
        Payments p ON p.client_id = cc.client_id
    LEFT JOIN 
        Repayment_Schedule r ON r.contract_id = cc.id
    WHERE 
        cc.client_id = NEW.client_id
    GROUP BY 
        cc.id;

    -- ����������� �������
    SET rating = (S + P_fact) / D_fact 
                 - S_zal / (D - D_fact)
                 + EXP(-d_ahead) 
                 - EXP(d_late);

    -- ��������� ������� � ������� �볺���
    UPDATE Clients
    SET rating = rating
    WHERE id = NEW.client_id;
END$$

DELIMITER ;


DELIMITER //

CREATE TRIGGER calculate_daily_penalty
AFTER UPDATE ON Payments
FOR EACH ROW
BEGIN
    DECLARE overdue_days INT;
    DECLARE remaining_balance DECIMAL(15, 2);
    
    -- ���������� ������� ��� ������������
    IF NEW.payment_date > (SELECT payment_date FROM Repayment_Schedule WHERE id = NEW.schedule_id) THEN
        SET overdue_days = DATEDIFF(NEW.payment_date, (SELECT payment_date FROM Repayment_Schedule WHERE id = NEW.schedule_id));
        SET remaining_balance = (SELECT repayment_amount + charge_amount FROM Repayment_Schedule WHERE id = NEW.schedule_id);

        -- ����������� ��� 1% �� ����� ���� ������������
        UPDATE Repayment_Schedule
        SET charge_amount = charge_amount + (remaining_balance * 0.01 * overdue_days)
        WHERE id = NEW.schedule_id;
    END IF;
END;
//

DELIMITER ;


DELIMITER //

CREATE TRIGGER calculate_one_time_penalty
AFTER UPDATE ON Payments
FOR EACH ROW
BEGIN
    DECLARE overdue_days INT;
    DECLARE total_debt DECIMAL(15, 2);
    
    -- ���������� ������� ��� ������������ �� ���� ��������� ��������
    IF NEW.payment_date > (SELECT DATE_ADD(start_date, INTERVAL term DAY) FROM Credit_Contracts WHERE id = (SELECT contract_id FROM Repayment_Schedule WHERE id = NEW.schedule_id)) THEN
        SET overdue_days = DATEDIFF(NEW.payment_date, (SELECT DATE_ADD(start_date, INTERVAL term DAY) FROM Credit_Contracts WHERE id = (SELECT contract_id FROM Repayment_Schedule WHERE id = NEW.schedule_id)));
        
        IF overdue_days > 10 THEN
            SET total_debt = (SELECT SUM(repayment_amount + charge_amount) FROM Repayment_Schedule WHERE contract_id = (SELECT contract_id FROM Repayment_Schedule WHERE id = NEW.schedule_id));
            
            -- ����������� ���������� ��� 15%
            UPDATE Repayment_Schedule
            SET charge_amount = charge_amount + (total_debt * 0.15)
            WHERE contract_id = (SELECT contract_id FROM Repayment_Schedule WHERE id = NEW.schedule_id);
        END IF;
    END IF;
END;
//

DELIMITER ;
