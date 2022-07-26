use pet_store;
DELIMITER $$
CREATE TRIGGER inventory_update AFTER INSERT ON store_order FOR EACH ROW BEGIN 
	INSERT INTO inventory_changes (change_date, member_id, product_id)
		VALUES (curdate(), new.member_id, new.product_id);
        
END;
$$ DELIMITER ;