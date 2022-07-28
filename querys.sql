use pet_store;

-- querys ------------------------------------------------------------------------------------------
-- 1
SELECT product_name, amount from product;

-- 2 ----------------------------------------------------------------------------------------------- 
SELECT s.order_id, s.customer_id, s.member_id, s.delivery, s.price, s.order_date, p.product_name, o.product_amount FROM store_order s
	LEFT JOIN order_products o 
	ON
		s.order_id = o.order_id
	LEFT JOIN product p
	ON
		p.product_id = o.product_id
	WHERE order_date >= curdate() - INTERVAL 100 WEEK
    ORDER BY order_date DESC; 

-- 3 -----------------------------------------------------------------------------------------------
SELECT c.member_id, p.p_name,sum(o.product_amount) AS total_amount FROM person p
	INNER JOIN crew c 
    ON
		c.person_id = p.person_id
	INNER JOIN store_order s
    ON
		s.member_id = c.member_id
	LEFT JOIN order_products o
    ON 
		o.order_id = s.order_id
	GROUP BY p.p_name
	ORDER BY sum(o.product_amount) DESC LIMIT 1;        
       
-- 4  -----------------------------------------------------------------------------------------------
SELECT c.member_id ,p.p_name, sum(s.price) AS total_price FROM person p
	INNER JOIN crew c 
    ON
		c.person_id = p.person_id
	INNER JOIN store_order s
    ON
		s.member_id = c.member_id
	LEFT JOIN order_products o
    ON 
		o.order_id = s.order_id
	GROUP BY p.p_name
	ORDER BY total_price DESC LIMIT 1; 
    
    SELECT * FROM person p
	INNER JOIN crew c 
    ON
		c.person_id = p.person_id
	INNER JOIN store_order s
    ON
		s.member_id = c.member_id
	LEFT JOIN order_products o
    ON 
		o.order_id = s.order_id;  
    
-- 5  -----------------------------------------------------------------------------------------------
SELECT c.customer_id, p.p_name, s.order_id, pr.product_name,s.price FROM person p	
	INNER JOIN customer c 
    ON
		p.person_id = c.person_id
	INNER JOIN store_order s 
	ON
		s.customer_id = c.customer_id
	LEFT JOIN order_products o
	ON
		o.order_id = s.order_id
	LEFT JOIN product pr
    ON
		pr.product_id = o.product_id
	WHERE delivery IS NULL;
    
-- 6 -----------------------------------------------------------------------------------------------
SELECT  c.customer_id, p.p_name FROM person p	
	INNER JOIN customer c 
    ON
		p.person_id = c.person_id
	LEFT JOIN store_order s 
	ON
		s.customer_id = c.customer_id
	WHERE s.customer_id IS NULL;
	
-- 7 -----------------------------------------------------------------------------------------------
SELECT c.customer_id, p.p_name, count(*) AS delivery_amount FROM person p 
	INNER JOIN customer c
    ON 	
		p.person_id = c.person_id
	INNER JOIN store_order s
    ON
		c.customer_id = s.customer_id
	GROUP BY p.p_name
    having delivery_amount > 1
    ORDER BY delivery_amount DESC;

-- 8 -----------------------------------------------------------------------------------------------
SELECT sum(price) as revenues FROM store_order 
	WHERE order_date >= curdate() - INTERVAL 6 month; 
    
    
    
    


