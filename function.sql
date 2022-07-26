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

