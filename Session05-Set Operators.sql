
--- SQL-6. ders_08.06.2022(session-5)

-- Geçen dersten kalan yeri bitireceðiz
-- VIEWS
-- Database de SQL serverýn yönettiði db ler var. Bu bir disk alaný. Verilerimiz tablolarda bulunuyor
-- .. fiziksel olarak. Tablolarda ayný þekilde. Tablolar üzerine kurulan bir mimari var (dashborad vs) 
-- .. Bu tablolardan birinde bir deðiþiklik olursa üst katmanda büyük sorun olabilir.
-- .. Bu katman arasýnda stabil katmana ihtiyacýmýz var. Bu katmaný saðladýðýmýz noktalardan birisi view
    --1.Bir tablonun görüntüsünü oluþturuyoruz. Bu görüntü fiziksel olarak ayrý bir yer kaplamýyor. Tablolara
        -- .. baðlantý saðlýyor
    -- 2.Bir sorgumuz var. Çok uzun bu sorgu ama ihtiyaç duyuyoruz diyelim. Bunu farklý bir yerde bir kural olarak tanýmlarsak
       -- .. Bu view üzerinden daha rahat bir þekilde sorgumuzu yapabiliriz
   -- CREATE VIEW view_name AS SELECT columns from tables [WHERE conditions];
-- Advantages of Views: Performance(bir uzun sorguyu view olarak kaydedip kullanma), Security, Storage, Simplicity

-- Soru: Ürün bilgilerini stok miktarlarý ile birlikte listeleyin demiþtik altta
SELECT	A.product_id, A.product_name, B.*
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310;

-- Bu sorguyu bir view olarak kaydedelim
CREATE VIEW ProductStock AS
SELECT	A.product_id, A.product_name, B.*
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310;

-- Hata. product_id 2 kere geçiyor
CREATE VIEW ProductStock AS
SELECT	A.product_id, A.product_name, B.store_id,B.quantity
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310;

-- Command completed sucsesfully
-- sampleretail-views-dbo.ProductStock

-- Bunu sorgularýmýn içinde tablo olarak kullanabilirim
SELECT * FROM dbo.ProductStock
--Sorgu sonucunun aynýsý geldi

-- Koþul da ekleyebiliriz
SELECT * FROM dbo.ProductStock
WHERE store_id=1

-- NOT: Bunu tek sorgu için yapabiliriz. Daha fazla sorgu için "procedure" kullanacaðýz ilerde
-- NOT: ProductStock sadece bir script, asýl tabloyla olan bir iliþkisi var. Depolamada büyük katkýsý var
-- NOT: Bunu tablo olarak create edemez miyiz? Edebiliriz. O tablo fiziksel bir tablodur, dinamik bir tablo olmaz
-- NOT: Tablonun hep son durumu(deðiþmeden önceki(eðer deðiþtiyse)) ile ilgili bilgi almak istersem view kullanmalýyýz
-- NOT: VIEW içerisinden ORDER BY kullanamayýz(VIEW OLUÞMAYACAKTI). VIEW oluþtuktan sonra ORDER BY ý kullanabiliriz
-- NOT: VIEW içindeki sorgu için sampleretail-->view-->dbo.ProductStock--> sað týk-->design

---------------------------------
SELECT	A.product_id, A.product_name, B.store_id, B.quantity
INTO	#ProductStock
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310;

SELECT * FROM #ProductStock;
-- Bu da diez ile bir baðlantý ile oluþturulan geçici view. Baðlantý kapanýnca bu gider


----------------------------

-- Hoca: Sizde buna VIEW yapýp alýþtýrma yapalým
-- Maðaza çalýþanlarýný çalýþtýklarý maðaza bilgileriyle birlikte listeleyin
-- Çalýþan adý, soyadý, maðaza adlarýný seçin
SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
	ON	A.store_id = B.store_id;
    
-- Çözüm
CREATE VIEW SaleStaff as
SELECT  A.first_name, A.last_name, B.store_name
FROM    sale.staff A
INNER JOIN sale.store B
    ON  A.store_id = B.store_id
    

--%% ADVANCED GROUPING FUNCTIONS
-- Table of Contents
-- Having clause
-- Grouping sets
-- Rollup
-- Cube
-- Pivot

--Örnek: bir maðazada toplam kaç tane ürün var(maðaza bazýnda)
-- Örnek: A kategorisindeki ürünlerin ortalama fiyatý vs
-- Bunlarý grouping functions la yapýyoruz
-- Group by + agregation kullanacaðýz
/*
A   0     
B   5      
C   10
A   5            -----  A 15
B   10           ------ B 30
C   15           ------ C 45
A   10
B   15
C   20
*/


-- Soru: Kaç farklý markaya ait ürünüm var
-- Brand tablosu : 40 satýr var. Gruplama yapmadan saydýralým
-- Marka: brand , Brand tablosu ve product tablosunda var
SELECT COUNT(*) FROM product.brand

-- Hangi markadan kaç tane ürün var
-- Gruplama yapalým
Select brand_id, count(*) as CountOfProduct from product.product
group by brand_id

-- Count(*): Satýrýn tamamýný sayar, eðer eksik verisi olan satýra count dersek eksik kalabilir


--Dersin 2. bölümü

--Soru: Kategori bazýndaki toplam ürün sayýsý
SELECT A.category_id, B.category_name, count(*) CountOfProduct 
from product.product A
INNER JOIN product.category B
on A.category_id = B.category_id
group by A.category_id, B.category_name


-------------------------
-- 1.Having Clause
-- Group by lý sorgu sonucunda olan filtrelemeleri HAVING ile yapýyoruz
-- SQL SERVER OKUMA SIRASI: FROM--> WHERE --> GROUP BY --> HAVING -- > SELECT --> ORDER BY


--Model yýlý 2016 dan büyük olan ürünlerin liste fiyatlarýnýn ortalamasýnýn 
-- .. 1000 den fazla olduðu markalarýn fiyatlarýný listeleyin
-- INNER JOIN yerine alltaki þekilde virgül koyarak yapabiliriz
select	b.brand_name, avg(a.list_price) AS AvgPrice
from	product.product a, product.brand b
where	a.brand_id = b.brand_id
		and a.model_year > 2016
group by b.brand_name
having avg(a.list_price) > 1000
order by 2 DESC

-- NOT: AVG(A.list_price) a Alias vermiþ olsaydýk bunu Having kýsmýnda kullanamam

--SORU: Write a query that checks if any product id is repeated in more than one row in the products table
-- Products id si 1 den fazla olan satýr var mý
SELECT	product_id, COUNT (product_id) num_of_rows
FROM	product.product
GROUP BY product_id
HAVING COUNT (product_id) > 1

-- SORU: max liste fiyatý 4000 üstü, min liste fiyatý 500 altýnda olan category_id leri getirin
SELECT	category_id, Min(list_price) min_ , Max(list_price) max_
FROM	product.product
GROUP BY category_id
HAVING Min(list_price) <500 or Max(list_price) > 4000

--Her bir sipariþteki toplam fiyat.discount' ý ve quantity' yi ihmal etmeyiniz.
SELECT	order_id, SUM((list_price * quantity)*(1-discount)) Net_Price 
FROM sale.order_item
GROUP BY order_id

-- Dersin 3. bölümü
-----
-- 2.Grouping Sets
-- Raporlama yaparken yüm gruplama sonuçlarýnýn tek bir sot

 --SELECT column1, column2, aggregate_fucntion(column3) FROM table_name
 --Group by GROUPING SETS...


-- Herbir kategorideki toplam ürün sayýsý
-- Herbir model yýlýndaki toplam ürün sayýsý
-- Herbir kategorinin model yýlýndaki toplam ürün sayýsý

-- grouping sets
select	category_id, model_year, count(*) CountOfProducts
from	product.product
group by
	grouping sets (
				(category_id), -- 1. group
				(model_year), -- 2. group
				(category_id, model_year) -- 3. group
	)

order by 1, 2

--NOT: "having model_year is null"  gibi filtrelemede ekleyebiliriz


---
-- 3.Rollup
--Sorgunun sonucunu istediðimiz sýrada sonuç getirir
-- Her bir grup kombinasyonunu oluþturup ona göre sonuç getirir
-- Select d1,d2,d3,aggregate_function(c4) FROM table_name Group by rollup(d1,d2,d3)


Select category_id,model_year, count(*) FROM product.product Group by rollup(category_id,model_year)

--Herbir marka id, herbir category id ve herbir model yýlý için toplam ürün sayýlarýný getiriniz.
-- Sonuç tablosunda tüm ihtimaller bulunsun

Select category_id,brand_id,model_year, count(*) FROM product.product
Group by rollup(category_id,brand_id,model_year)

-------------------------
-- 4.CUBE
-- Roll up 1. deðiþkeni alýyordu sýralýyordu sonra 2. vs 
-- Burada da tam tersten geliyor.
-- Roll up ile yazýmý ayný sadece CUBE yazýyoruz

-- Soru
Select category_id,model_year, count(*) FROM product.product Group by CUBE(category_id,model_year)

-------------------------
-- 5.PIVOT
-- Python da bir deðiþkenin içerisindeki veriler bilmeden pivot yapabiliyorduk
-- SQL de her bir sütun baþlýðýný tanýmlamamýz gerekiyor. Python la ayný sonucu veriyor
-- Pivota taþýyacaðýmýz sütunlarý biliyorsak python da yapýlabilir.


-- 2018 yýlýna ait 177 ürün , 2019 model yýlýna ait, 140 ürün varmýþ, 2020 yýlý 121, 2021 yýlý 82
-- Normalde bunu nasýl yapýyorduk
Select model_year,count(*) from product.product group by model_year

-- Pivot table ile 

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

--------------------
--3. deðiþken için

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


------------------
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
UNION ALL
SELECT NULL, *
FROM
			(
			SELECT Model_Year, product_id
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