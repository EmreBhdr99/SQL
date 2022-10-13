
---- Session 13

--önce tablonun çatýsýný oluþturuyoruz.


create table website_visitor 
(
visitor_id int,
ad varchar(50),
soyad varchar(50),
phone_number bigint,
city varchar(50)
);

DECLARE @i int = 1
DECLARE @RAND AS INT
WHILE @i<200000
BEGIN
	SET @RAND = RAND()*81
	INSERT website_visitor
		SELECT @i , 'visitor_name' + cast (@i as varchar(20)), 'visitor_surname' + cast (@i as varchar(20)),
		5326559632 + @i, 'city' + cast(@RAND as varchar(2))
	SET @i +=1
END;

--Tabloyu kontrol ediniz.

SELECT top 10*
FROM
website_visitor

--Ýstatistikleri (Process ve time) açýyoruz, bunu açmak zorunda deðilsiniz sadece yapýlan iþlemlerin detayýný görmek için açtýk.
SET STATISTICS IO on
SET STATISTICS TIME on


-------Clustered Index

--herhangi bir index olmadan visitor_id' ye þart verip tüm tabloyu çaðýrýyoruz


SELECT *
FROM
website_visitor
where
visitor_id = 100
;

Create CLUSTERED INDEX CLS_INX_1 ON website_visitor (visitor_id);  --- index oluþturduktan sonra aradýðýmýz veriyi parçalar halinde inceleyip daha hýzlý sonuç verecek.


--- Non-Clustered Index

SELECT ad
FROM
website_visitor
where
ad = 'visitor_name17'
;

CREATE NONCLUSTERED INDEX ix_NoN_CLS_1 ON website_visitor (ad);

SELECT ad,soyad
FROM
website_visitor
where
ad = 'visitor_name17'
;

Create unique NONCLUSTERED INDEX ix_NoN_CLS_2 ON website_visitor (ad) include (soyad)
;

SELECT ad,soyad
FROM
website_visitor
where
ad = 'visitor_name17'
;

--clustered index(visitor_id)
--nonclustered index(ad)
--nonclustered index(ad) include(soyad)

SELECT soyad
FROM website_visitor
where soyad='visitor_name17'   ---soyad'a özel olarak index atýlmadýðý için Execution Plan yaptýðýmýzda Scan olarak çýktý.
;


