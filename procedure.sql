-- 1
DELIMITER $$ 

CREATE PROCEDURE set_delivery(in_order_id INT, in_member_id INT)
BEGIN
	INSERT INTO delivery (member_id,order_date,delivery_price)
	VALUES
		(in_member_id,curdate(),30);
	
    UPDATE store_order
    SET
		delivery = (SELECT delivery_id FROM delivery ORDER BY delivery_id DESC LIMIT 1)
	where order_id = in_order_id;

END; $$

DELIMITER ;

-- 2

DELIMITER $$ 

CREATE PROCEDURE bestseller(in_amount INT, in_days INT)
BEGIN
	SELECT p.product_id, p.product_name, p.category, p.price FROM product p
		INNER JOIN store_order s
		ON 
			p.product_id = s.product_id
		WHERE s.order_date >= curdate() - INTERVAL in_days DAY
		GROUP BY P.PRODUCT_id
		ORDER BY count(p.product_id) LIMIT in_amount;

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

