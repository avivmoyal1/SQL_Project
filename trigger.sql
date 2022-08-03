use pet_store;

DELIMITER $$
CREATE TRIGGER update_order_products AFTER INSERT ON order_products FOR EACH ROW BEGIN 

	INSERT INTO inventory_changes (change_date, product_amount, member_id, product_id)
		SELECT 	(select order_date from store_order where order_id = NEW.order_id),
				NEW.product_amount,
				(SELECT member_id FROM store_order where order_id = NEW.order_id),
				NEW.product_id
			FROM store_order s
			WHERE s.order_id = NEW.order_id;
        
	UPDATE store_order
		SET price = price + ((SELECT price FROM product WHERE product_id = NEW.product_id) * NEW.product_amount)
		where order_id = NEW.order_id;
    
    UPDATE product
		SET amount = amount - NEW.product_amount
		WHERE product_id = NEW.product_id;
        
 		UPDATE delivery 
 			SET delivery_price = IF(((SELECT price FROM store_order WHERE order_id = NEW.order_id) > 180), 0, 30)
				WHERE delivery_id = (SELECT delivery FROM store_order WHERE order_id = NEW.order_id);

END;
$$ DELIMITER ;


