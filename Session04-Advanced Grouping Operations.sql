



select *
from product.brand
;

select count(*)
from product.brand 
;


select brand_id ,count(*) as CountOfProduct
from product.product
group by brand_id
;

-- count(column_name) column_name is null

-- Herbir kategorideki toplam ürün sayýsýný yazdýrýnýz.


select category_id, count(*) as CountOfProduct
from product.product
group by category_id
;

select category_id,category_name,count(*) as CountOfProduct
from product.product
group by category_id
;



--Herbir kategorideki toplam ürünü sayýsýný yazdýrýnýz.
--Sonuç olarak Category_id, Category_name ve Ürün miktarý bulunsun
SELECT pc.category_id, pc.category_name, COUNT(*) as CountOfCategory
FROM product.product pp
INNER JOIN product.category pc
ON pp.category_id = pc.category_id
GROUP BY pc.category_id, pc.category_name
ORDER BY CountOfCategory
;

-- Model yýlý 2016 'dan büyük olan ürünlerin liste fiyatlarýnýn ortalamasýnýn 1000'den fazla olduðu markalarý listeleyin.

SELECT b.brand_name,a.model_year,avg(a.list_price) AS AvgPrice               --- b.brand_name groupby'landýðý için selectlenmesi lazým.
FROM product.product a , product.brand b --INNER JOIN YAPMAK YERÝNE BÖYLE DAHA PRATÝK!!!
WHERE a.brand_id = b.brand_id and a.model_year >2016
GROUP BY b.brand_name, a.model_year
HAVING avg(a.list_price)  >1000
ORDER BY AvgPrice DESC  -- AvgPrice yerine sütün sýrasýndan 3 yazarsak da sýralar.

----Write a query that checks if any product id is repeated in more than one row in the product table.

SELECT product_id,COUNT(product_id)
FROM product.product
GROUP BY product_id                   --- Tekrar eden deðer olmadýðý için tablo vermez.
HAVING COUNT(product_id) >1 
;

-----maximum list price' ý 4000' in üzerinde olan veya minimum list price' ý 500' ün altýnda olan categori id' leri getiriniz
--category name' e gerek yok.
SELECT category_id, max(list_price) as max_price,min(list_price) AS mýn_price
FROM product.product
GROUP BY category_id
HAVING max(list_price) > 4000 or min(list_price)<500

--bir sipariþin toplam net tutarýný getiriniz. (müþterinin sipariþ için ödediði tutar)
--discount' ý ve quantity' yi ihmal etmeyiniz.

SELECT order_id, SUM(quantity*list_price*(1-discount)) as net_price
FROM sale.order_item
Group BY order_id

--GROUPING SETS

-- Herbir kategorideki toplam ürün sayýsý
--Herbir model yýlýndaki toplam ürün sayýsý
--Herbir kategorinin model yýlýndaki ürün sayýsý  bulunuz.

SELECT category_id, model_year, count(*) as CountOfProducts
FROM product.product
GROUP BY 
	GROUPING SETS (
				  (category_id),--1.group
				  (model_year),--2.group
				  (category_id,model_year)--3.group
	)
-- having model_year is null
ORDER BY 1,2
;

--ROLLUP

select	category_id, model_year, count(*) CountOfProducts
from	product.product
group by
	rollup (category_id, model_year)
;

--Herbir marka id, herbir category id ve herbir model yýlý için toplam ürün sayýlarýný getiriniz.
SELECT category_id, brand_id, model_year, COUNT(*) CountOfProducts
FROM product.product
GROUP BY
	ROLLUP(category_id, brand_id, model_year)
;



--CUBE

select	brand_id,category_id, model_year, count(*) CountOfProducts
from	product.product
group by
	cube (brand_id,category_id, model_year)

--PIVOT

-- Model yýllarýna göre toplam ürün sayýsý


SELECT *
FROM
			(
			SELECT product_id, Model_Year
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;
--
SELECT *
FROM
			(
			SELECT category_id, Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;