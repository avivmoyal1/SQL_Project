use pet_store;

DELIMITER $$
CREATE TRIGGER inventory_update AFTER INSERT ON order_products FOR EACH ROW BEGIN 
	INSERT INTO inventory_changes (change_date, product_amount, member_id, product_id)
    SELECT 	curdate(),
			NEW.product_amount,
			(SELECT member_id FROM store_order where order_id = NEW.order_id),
            NEW.product_id
		FROM store_order s
		WHERE s.order_id = NEW.order_id;
END;
$$ DELIMITER ;
--  DROP TRIGGER update_price;
DELIMITER $$
CREATE TRIGGER update_price AFTER INSERT ON order_products FOR EACH ROW BEGIN 
	UPDATE store_order
    SET price = price + ((SELECT price FROM product WHERE product_id = NEW.product_id) * NEW.product_amount)
    where order_id = NEW.order_id;
END;
$$ DELIMITER ;


DELIMITER $$
CREATE TRIGGER update_amount AFTER INSERT ON order_products FOR EACH ROW BEGIN 
	UPDATE product
    SET amount = amount - NEW.product_amount
    WHERE product_id = NEW.product_id;
END;
$$ DELIMITER ;