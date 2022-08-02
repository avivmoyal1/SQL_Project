SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$

drop function  employee_income;
CREATE FUNCTION 
	employee_income(in_name VARCHAR(100), in_month INT, in_year INT) RETURNS INTEGER
BEGIN
		DECLARE e_count INTEGER DEFAULT 0;
        SELECT sum(price) INTO e_count FROM store_order s
        INNER JOIN crew c
			ON
                s.member_id = c.member_id
		INNER JOIN person p
			ON
				p.person_id = c.person_id
		WHERE p.p_name = in_name and MONTH(s.order_date) = in_month and YEAR(s.order_date) = in_year;
        
		RETURN e_count;
END; $$

DELIMITER ;

-- drop function insert_order_product;

DELIMITER $$ 

CREATE FUNCTION 
	insert_order_product(in_order_id INT, in_product_id INT, in_product_amount INT) RETURNS VARCHAR(100)
BEGIN
	DECLARE total_amount INT DEFAULT 0;
    SELECT amount FROM product WHERE product_id = in_product_id INTO total_amount;
    
    IF total_amount < in_product_amount THEN
		RETURN "Did not succeed";
	ELSE 
		INSERT INTO order_products(order_id, product_id, product_amount)
		VALUES (in_order_id, in_product_id, in_product_amount);
		RETURN "Succeeded";
	END IF;
END; $$

DELIMITER ;
