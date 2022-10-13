

--- Session


---select clause
select order_id,
	   list_price,
	   (
	   select avg(list_price)
	   from product.product
	   ) AS avg_price
from sale.order_item
;


---where clause
select order_id,order_date
from sale.orders
where order_date in(
					select distinct top 5 order_date
					from sale.orders
					order by order_date desc
					)
;

---from clause
select order_id, order_date
from   (
		select top 5 * 
		from sale.orders
		order by order_date desc
		) A      ---from'da tanýmlanan subquery'nin alias'ý olmak zorunda.


---order id'lere göre toplam list_price hesaplayýn.

--Çözüm 1
select	order_id, sum(list_price) sum_list_price
from	sale.order_item
group by	order_id

--Çözüm2

SELECT	so.order_id,
		(
		SELECT	sum(list_price)
		FROM	sale.order_item
		WHERE	order_id=so.order_id
		) AS total_price
FROM	sale.order_item so1
GROUP BY so.order_id

-- Davis Thomas'nýn çalýþtýðý maðazadaki tüm personelleri listeleyin.

select	*
from	sale.staff
where	store_id = (
					select	store_id
					from	sale.staff
					where	first_name = 'Davis' and last_name = 'Thomas'
					)
;
				
				 
--- Charles Cussona 'nýn manager olduðu kiþileri listeleyiniz.

select *
from sale.staff
where manager_id = (
					select staff_id
					from sale.staff
					where  first_name = 'Charles' and last_name ='Cussona'  --manager_id'si 2
					)
;

-- 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)' isimli üründen pahalý olan ürünleri listeleyin.
-- Product id, product name, model_year, fiyat, marka adý ve kategori adý alanlarýna ihtiyaç duyulmaktadýr.


select A.product_id, a.product_name, a.model_year, a.list_price, b.brand_name, c.category_name
from product.product A, product.brand B, product.category C
where list_price >
	(select list_price
	from product.product
	where product_name='Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')
	and A.brand_id = B.brand_id
	and A.category_id = C.category_id
;
-- Laurel Goldammer isimli müþterinin alýþveriþ yaptýðý tarihlerde alýþveriþ yapan tüm müþterileri listeleyiniz.
SELECT *
FROM sale.customer AS SC, sale.orders AS SO
WHERE order_date IN (
				SELECT SO.order_date
				FROM sale.customer AS SC, sale.orders AS SO
				WHERE first_name = 'Laurel' AND last_name='Goldammer'
				AND SC.customer_id=SO.customer_id)
				AND SC.customer_id=SO.customer_id
				AND SO.order_status = 4;
				
-- List products made in 2021 and their categories other than Game, GPS, or Home Theater.

--Çözüm1
SELECT *
FROM product.product
WHERE model_year = 2021 AND category_id NOT IN(
												SELECT category_id
												FROM product.category
												WHERE category_name IN ('Game', 'gps', 'Home Theater')
												);
--Çözüm2
SELECT *
FROM product.product
WHERE model_year = 2021 AND category_id IN(
												SELECT category_id
												FROM product.category
												WHERE category_name NOT IN ('Game', 'gps', 'Home Theater')
												);


-- 2020 model olup Receivers Amplifiers kategorisindeki en pahalý üründen daha pahalý ürünleri listeleyin.
-- Ürün adý, model_yýlý ve fiyat bilgilerini yüksek fiyattan düþük fiyata doðru sýralayýnýz.

--Çözüm1
select	*
from	product.product
where	model_year = 2020 and
		list_price > (
			select	max(B.list_price)
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
		);

---ALL

--Çözüm2

select	*
from	product.product
where	model_year = 2020 and
		list_price > ALL (     --- ALL yaparak bütün deðerlerinden büyük olmasý koþulunu koyduk.
			select	B.list_price  -- Multiple rowslarla tek tek kýyaslar ve hepsinden büyük olmasý gerekir.
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
			);

--ANY

-- List products made in 2020 and its prices more than any products in the Receivers Amplifiers category.


select	*
from	product.product
where	model_year = 2020 and
		list_price > ANY (                -- multiple rows'larla or olarak kýyaslar. Herhangi birinden büyükse koþul gerçekleþir.
			select	B.list_price
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' 
					and A.category_id = B.category_id)
;
