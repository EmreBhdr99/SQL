

--- Session 06

---UNION

---UNION'da iþleme alýnacak kümelerin sütun sayýlarý eþit olmalý ve UNION iþlemi yapýlacak karþýlýklý sütunlarýn veri tipleri ayný olmalýdýr.


-- Charlotte þehrindeki müþteriler ile Aurora þehrindeki müþterilerin soyisimlerini listeleyin

select last_name
from sale.customer
where city= 'Charlotte'
union                    ---DISTINC özelliði saðlar. Tekrarlý olanlarý getirmez.
select last_name 
from sale.customer
where city= 'Aurora'
-- deðiþkenlerin sýrasý ve sayýsý önemli


---- Müþteriler ile çalýþanlarýn e-mail'lerini içeren unique olacak þekilde sorgulayýn.

select email
from sale.customer
union
select email
from sale.staff
;

--- Müþterilerin içinde Thomas isminde veya Thomas soyisminde olanlarý listeleyiniz.

select first_name,last_name
from sale.customer
where first_name = 'Thomas'
union all                 --UNION 'a göre daha hýzlý çalýþýr. DESTINICT özelliði yok!!
select first_name,last_name
from sale.customer
where last_name = 'Thomas'


----INTERSECT


-- Write a query that returns brands that have products for both 2018 and 2019.

select pp.brand_id, pb.brand_name
from  product.product pp, product.brand pb   --- INNER JOIN YAPMIÞ OLDUK.
where pp.brand_id = pb.brand_id and
	  pp.model_year = 2018
INTERSECT
select pp.brand_id, pb.brand_name
from  product.product pp, product.brand pb   --- INNER JOIN YAPMIÞ OLDUK.
where pp.brand_id = pb.brand_id and
	  pp.model_year = 2019        ---model_year'lar kesiþmeyeceði için boþ küme döndürmemesi adýna select'e model_year verilmedi.



-- Write a query that returns brands that have orders for both 2018 and 2019 and 2020.

SELECT first_name, last_name
FROM sale.customer sc, sale.orders so
WHERE sc.customer_id = so.customer_id and
	  YEAR (so.order_date) = 2018
INTERSECT
SELECT first_name, last_name
FROM sale.customer sc, sale.orders so
WHERE sc.customer_id = so.customer_id and
	  YEAR (so.order_date) = 2019
INTERSECT
SELECT first_name, last_name 
FROM sale.customer sc, sale.orders so
WHERE sc.customer_id = so.customer_id and
	  YEAR (so.order_date) = 2020
;
select	*
from
	(
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2018
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A, sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2019
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2020
	) A, sale.orders B
where	a.customer_id = b.customer_id and Year(b.order_date) in (2018, 2019, 2020)
order by a.customer_id, b.order_date
;




---- Charlotte þehrindeki müþterilerin soyisimleri ile Aurora þehrindeki müþterilerin soyisimleri ayný olanlarý listeleyiniz.


select last_name
from sale.customer
where city = 'Charlotte'
intersect
select last_name
from sale.customer
where city = 'Aurora'
;

-- Ayný emaile sahip müþteri ile çalýþanlarý sorgulayýnýz. 

select	email
from	sale.staff
intersect
select	email             -- Ayný emaile sahip müþteri ve çalýþan yok!!
from	sale.customer


----EXCEPT
--- Deðiþkenlerin sýrasý ve sayýsý önemlidir!!!

----- Write a query that returns brands that have a 2018 model product but not a 2019 model product.

SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
    AND A.model_year = 2018
EXCEPT
SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
    AND A.model_year = 2019
;

--- Sadece 2019 yýlýnda sipariþ verilen diðer yýllarda sipariþ verilmeyen ürünleri getiriniz.

---YÖNTEM1----
SELECT soi.product_id,pp.product_name
FROM product.product pp, sale.orders so, sale.order_item soi
WHERE  YEAR(so.order_date) = 2019 AND
		so.order_id = soi.order_id AND
		pp.product_id = soi.product_id
EXCEPT
SELECT soi.product_id,pp.product_name
FROM product.product pp, sale.orders so, sale.order_item soi
WHERE  YEAR(so.order_date) <> 2019 AND
		so.order_id = soi.order_id AND
		pp.product_id = soi.product_id

--- YÖNTEM2---
		select	C.product_id, D.product_name
from	
	(
	select	B.product_id
	from	sale.orders A, sale.order_item B
	where	Year(A.order_date) = 2019 AND
			A.order_id = B.order_id
	except
	select	B.product_id
	from	sale.orders A, sale.order_item B
	where	Year(A.order_date) <> 2019 AND
			A.order_id = B.order_id
	) C, product.product D
where	C.product_id = D.product_id
;


-- 5 marka

select	brand_id, brand_name
from	product.brand
except
select	*
from	(
		select	A.brand_id, B.brand_name
		from	product.product A, product.brand B
		where	a.brand_id = b.brand_id and
				a.model_year = 2018
		INTERSECT
		select	A.brand_id, B.brand_name
		from	product.product A, product.brand B
		where	a.brand_id = b.brand_id and
				a.model_year = 2019
		) A


------ Aggregate function kaynak sorgudan  bir sütun almak zorundadýr.
SELECT *
FROM
			(
			SELECT	b.product_id, year(a.order_date) OrderYear, B.item_id
			FROM	SALE.orders A, sale.order_item B
			where	A.order_id = B.order_id
			) A
PIVOT
(
	count(item_id)  ----count(*) verince hata verdik kaynak sorgudan bir sütun istiyor.
	FOR OrderYear IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
order by 1

-----------

---CASE


SELECT order_id, order_status,
	 CASE order_status
		  WHEN 1 Then 'Pending'
		  WHEN 2 Then 'Processing'
		  WHEN 3 Then 'Rejected'
		  WHEN 4 Then 'Completed'
	 END order_status_desc
FROM sale.orders
;

----Store_id 1 olanlara Davi techno Retail, 2 olanlara The BFLO Store, 3 olanlara Burkes Outlet ata.

SELECT first_name, last_name, store_id,
	CASE store_id
		WHEN 1 THEN 'Davi techno Retail'
		WHEN 2 THEN 'The BFLO Store'
		WHEN 3 THEN 'Burkes Outlet'
	END AS store_name
FROM sale.staff



-- searched case
select	order_id, order_status,
		case
			when order_status = 1 then 'Pending'
			when order_status = 2 then 'Processing'
			when order_status = 3 then 'Rejected'
			when order_status = 4 then 'Completed'
			else 'other'
		end order_status_desc
from	sale.orders
;

------Müþterilerin e-mail adreslerindeki servis saðlayýcýlarýný yeni(Gmaili,Hotmail,Yahoo,Diðerleri olarak) bir sütun oluþturarak belirtiniz.

SELECT first_name, last_name,email,
	CASE
		WHEN email LIKE '%gmail%' THEN 'Gmail'
		WHEN email LIKE '%hotmail%' THEN 'Hotmail'
		WHEN email LIKE '%yahoo%' THEN 'Yahoo'
		ELSE 'Other'
	END AS email_service_provider
FROM sale.customer

------ Ayný sipariþte hem mp4 player, hem Computer Accessories hem de Speakers kategorilerinde ürün sipariþ veren müþterileri bulunuz.

select	C.first_name, C.last_name
from	(
		select	c.order_id, count(distinct a.category_id) uniqueCategory
		from	product.category A, product.product B, sale.order_item C
		where	A.category_name in ('Computer Accessories', 'Speakers', 'mp4 player') AND
				A.category_id = B.category_id AND
				B.product_id = C.product_id
		group by C.order_id
		having	count(distinct a.category_id) = 3
		) A, sale.orders B, sale.customer C
where	A.order_id = B.order_id AND
		B.customer_id = C.customer_id
;