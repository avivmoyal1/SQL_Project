use pet_store;
-- querys --

-- 1

SELECT product_name, amount from product;

-- 2  function ??------------------------------------------------------------------------------------
SELECT * FROM store_order 
	WHERE order_date >= curdate() - INTERVAL 100 WEEK; 

-- 3 -----------------------------------------------------------------------------------------------
SELECT crew.member_id ,p_name, count(*) as amount, SUM(store_order.price) as total_price FROM person 
	INNER JOIN  crew 
    ON
		crew.person_id = person.person_id 
	INNER JOIN store_order
    ON
		store_order.member_id = crew.member_id
	group by p_name 
    ORDER BY amount DESC LIMIT 1;
    
-- 4  -----------------------------------------------------------------------------------------------
SELECT c.member_id ,p.p_name, sum(s.price) as total FROM person p
	INNER JOIN  crew c
    ON
		c.person_id = p.person_id 
	INNER JOIN store_order s
    ON
		s.member_id = c.member_id
	group by p_name 
    ORDER BY total DESC LIMIT 1;
    
-- 5  -----------------------------------------------------------------------------------------------
SELECT  c.customer_id, p.p_name, s.order_id, s.product_id,s.price FROM person p	
	INNER JOIN customer c 
    ON
		p.person_id = c.person_id
	INNER JOIN store_order s 
	ON
		s.customer_id = c.customer_id
	where s.delivery IS NULL;
    
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
    
-- 8 function ??------------------------------------------------------------------------------------

SELECT sum(price) as revenues FROM store_order 
	WHERE order_date >= curdate() - INTERVAL 6 month; 
    
    
    
    


