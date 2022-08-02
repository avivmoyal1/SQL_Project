-- 1
DELIMITER $$ 

CREATE PROCEDURE set_delivery(in_order_id INT, in_member_id INT)
BEGIN
	DECLARE fee INT;
    SELECT price INTO fee FROM store_order where order_id = in_order_id; 
    
    IF fee > 180 THEN 
		SET fee = 0;
    ELSE
		SET fee = 30;
	END IF;
	INSERT INTO delivery (member_id,order_date,delivery_price)
	VALUES
		(in_member_id,curdate(),fee);
	
    UPDATE store_order
    SET
		delivery = (SELECT delivery_id FROM delivery ORDER BY delivery_id DESC LIMIT 1), 
        price = price + fee
	where order_id = in_order_id;

END; $$

DELIMITER ;

-- 2
DROP PROCEDURE bestseller;
DELIMITER $$ 

CREATE PROCEDURE bestseller(in_amount INT, in_days INT)
BEGIN

        SELECT p.product_id, p.product_name, p.category, p.price ,sum(o.product_amount) AS amount, (p.price * sum(o.product_amount)) AS total_price FROM product p
		INNER JOIN order_products o
		ON
			o.product_id = p.product_id
		INNER JOIN store_order s 
		ON 
			s.order_id = o.order_id
		WHERE s.order_date >= curdate() - INTERVAL in_days DAY
		GROUP BY p.product_id
		ORDER BY amount DESC limit in_amount;

END; $$

DELIMITER ;

-- 3

DELIMITER $$ 

CREATE PROCEDURE discount(in_order_id INT, in_percent INT)
BEGIN
	UPDATE store_order
	SET
		price = price - (price * in_percent / 100 )
	where order_id = in_order_id;

END; $$

DELIMITER ;

