-- querys --

-- 1

SELECT product_name, amount from product;

-- 2

-- ?? function ??

-- 3
SELECT count(*) as amount ,crew.member_id ,p_name FROM person 
	INNER JOIN  crew 
    ON
		crew.person_id = person.person_id 
	INNER JOIN store_order
    ON
		store_order.member_id = crew.member_id
	group by p_name 
    ORDER BY amount DESC LIMIT 1;
	
    
-- 4 

SELECT 