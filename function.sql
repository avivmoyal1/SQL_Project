SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$ 
CREATE FUNCTION 
	employee_income(in_name VARCHAR(100), in_month INT, in_year INT) RETURNS INTEGER
BEGIN
		DECLARE e_count INTEGER DEFAULT 0;
        SELECT sum(price) INTO e_count FROM store_order INNER JOIN crew 
			ON
                store_order.member_id = crew.member_id
		INNER JOIN person
			ON
				person.person_id = crew.person_id
		INNER JOIN delivery
			ON
				delivery.delivery_id = store_order.delivery
		WHERE person.p_name = in_name and MONTH(delivery.order_date) = in_month and YEAR(delivery.order_date) = in_year;
        
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
