

---Session 11 -----

--Count of product by each category and brand

--- Group by ile çözüm.
select category_id,brand_id,COUNT(product_id) CountOfProduct
from product.product
group by category_id,brand_id

--Window Function ile çözüm
select distinct brand_id,category_id,COUNT(product_id) OVER(PARTITION BY brand_id,category_id) CountOfProduct
from product.product


--First Value

-- Herbir maðazada en çok stok bulunan ürünleri listeleyiniz.

select  distinct store_id, 
				first_value(product_id) over( partition by store_id order by quantity desc ) most_stocked_prod,
				first_value(product_id) over (order by quantity desc) most_quantity
from product.stock
;

SELECT * FROM product.stock ORDER BY 1,3 DESC
;


----Write a query that returns customers and their most valuable order with total amount of it.

select b.customer_id
from sale.order_item A, sale.orders B
where A.order_id = B.order_id



SELECT	customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) net_price
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
GROUP BY customer_id, B.order_id
ORDER BY 1,3 DESC
;

WITH T1 AS
(
SELECT	customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) net_price
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
GROUP BY customer_id, B.order_id
)
SELECT DISTINCT customer_id,
FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY net_price DESC) MV_ORDER,
FIRST_VALUE(net_price) OVER (PARTITION BY customer_id ORDER BY net_price DESC) MVORDER_NET_PRICE
FROM T1
;


--Write a query that returns first order date by month.

select distinct YEAR(order_date) ord_year,
	   MONTH(order_date) ord_month,
	   FIRST_VALUE(order_date) OVER(PARTITION BY YEAR(order_date),MONTH(order_date) ORDER BY order_date) first_ord_date
from sale.orders

--- Last Value

-- Herbir maðazada en çok stok bulunan ürünleri listeleyiniz.

--Çözüm1
SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC, product_id DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod
FROM	product.stock
----Çözüm2
SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC, product_id DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod
FROM	product.stock


---Lag Function


--Çözüm1
SELECT	DISTINCT A.order_id, B.staff_id, B.first_name, B.last_name, order_date,
		LEAD(order_date, 1) OVER(PARTITION BY B.staff_id ORDER BY order_id) next_order_date
FROM	sale.orders A, sale.staff B
WHERE	A.staff_id = B.staff_id
;