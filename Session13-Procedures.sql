

------SESSION 14-----
---SQL PROGRAMMING---

---Stored Procedure---

---Procedure oluþturmak.
create procedure sp_sampleproc1
as
begin --procedure yi parantez içine alýyor gibi düþünðülebilir.

select 'hello world'

end  --begin i end ile sonlandýrmamýz gerekli

;


---Procedure çalýþtýrmak.
exec sp_sampleproc1

--Procedure silmek.
drop procedure sp_sampleproc1


--Procedure düzenlemek.
alter procedure sp_sampleproc1
as
begin 
select 'hello world 2 '
end
;

--Procedure çaðýrmak.
execute sp_sampleproc1
;

----Table üzerinden fonksiyon içeren procedure oluþturmak.

CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);

INSERT INTO ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )

select *
from ORDER_TBL

----------------------------
CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);

SET NOCOUNT ON
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )

-----------------------------
create procedure sp_sum_order
as
begin
	select count(*)
	from ORDER_TBL
end
;

execute sp_sum_order


---Procedure içinde parametre oluþturmak.
CREATE PROCEDURE sp_wantedday_order
	(
	@DAY DATE
	)
AS
BEGIN
	SELECT	COUNT(*) AS TOTAL_ORDER
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = @DAY
END
;

execute sp_wantedday_order '2022-06-22';

---Parametreler set ve select ile oluþturulmasý. (declare ile)
DECLARE
	@p1 INT,
	@p2 INT,
	@SUM INT
SET @p1 = 5

SELECT *
from ORDER_TBL
where ORDER_ID = @p1

-------------
DECLARE
	@order_id INT,
	@customer_name nvarchar(100)
SET @order_id = 5

SELECT @customer_name = customer_name
from ORDER_TBL
where ORDER_ID = @order_id

select @customer_name  --print @customer_name

---------------
select GETDATE()

declare 
	@day date

set @day = getdate()-2

execute sp_wantedday_order @day



----FONKSÝYONLAR---

----Metni büyük harfe çeviren bir fonksiyon yazalým.

CREATE FUNCTION fnc_uppertext
(
	@inputtext varchar (MAX)
)
RETURNS VARCHAR (MAX)
AS
BEGIN
	RETURN UPPER(@inputtext)
END
;

select dbo.fnc_uppertext('hello world');



select * 
from ORDER_TBL

---Müþteri adýnýn parametre olarak alýp o müþterinin alýþveriþlerini döndüren bir fonksiyon yazýnýz.

create function fnc_getordersbycustomer
(
@customer_name nvarchar(100)
)
returns table
as
	return
		select *
		from ORDER_TBL
		where customer_name=@customer_name
;

select *
from dbo.fnc_getordersbycustomer('Owen')


---IF / ELSE---
---Rakamsal deðeri çift ise Çift, ---
---tek ise Tek, ---
---eðer 0 ise Sýfýr döndüren bir fonksiyon yazýnýz. ---

--select 10 % 2  --10 ifadesinin 2 ile bölümünden kalaný

DECLARE
	@input int,
	@modulus int
SET @input = 5
SELECT @modulus = @input % 2
IF @input = 0
	BEGIN
	 print 'Sýfýr'
	END
ELSE IF @modulus = 0
	BEGIN
	 print 'Çift'
	END
ELSE print 'Tek'

---Fonksiyonu dinamik hale getirmek için:

create FUNCTION dbo.fnc_tekcift
(
	@input int
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE
		-- @input int,
		@modulus int,
		@return nvarchar(max)
	-- SET @input = 100
	SELECT @modulus = @input % 2
	IF @input = 0
		BEGIN
		 set @return = 'Sýfýr'
		END
	ELSE IF @modulus = 0
		BEGIN
		 set @return = 'Çift'
		END
	ELSE set @return = 'Tek'
	return @return
	
END
;

select dbo.fnc_tekcift(100) A, dbo.fnc_tekcift(9) B, dbo.fnc_tekcift(0) C


---WHILE---

DECLARE
	@counter int,
	@total int

set @counter = 1
set @total = 50

while @counter <= @total
	begin
		PRINT @counter
		set @counter += 1
	end
;



--Sipariþleri, tahmini teslim tarihleri ve gerçekleþen teslim tarihlerini kýyaslayarak
--'Late','Early' veya 'On Time' olarak sýnýflandýrmak istiyorum.
--Eðer sipariþin ORDER_TBL tablosundaki EST_DELIVERY_DATE' i (tahmini teslim tarihi) 
--ORDER_DELIVERY tablosundaki DELIVERY_DATE' ten (gerçekleþen teslimat tarihi) küçükse
--Bu sipariþi 'LATE' olarak etiketlemek,
--Eðer EST_DELIVERY_DATE>DELIVERY_DATE ise Bu sipariþi 'EARLY' olarak etiketlemek,
--Eðer iki tarih birbirine eþitse de bu sipariþi 'ON TIME' olarak etiketlemek istiyorum.

--Daha sonradan sipariþleri, sahip olduklarý etiketlere göre farklý iþlemlere tabi tutmak istiyorum.

--istenilen bir order' ýn status' unu tanýmlamak için bir scalar valued function oluþturacaðýz.
--çünkü girdimiz order_id, çýktýmýz ise bir string deðer olan statu olmasýný bekliyoruz.


create FUNCTION dbo.fnc_orderstatus
(
	@input int
)
RETURNS nvarchar(max)
AS
BEGIN
	declare
		@result nvarchar(100)
	-- set @input = 1
	select	@result =
				case
					when B.DELIVERY_DATE < A.EST_DELIVERY_DATE
						then 'EARLY'
					when B.DELIVERY_DATE > A.EST_DELIVERY_DATE
						then 'LATE'
					when B.DELIVERY_DATE = A.EST_DELIVERY_DATE
						then 'ON TIME'
				else NULL end
	from	ORDER_TBL A, ORDER_DELIVERY B
	where	A.ORDER_ID = B.ORDER_ID AND
			A.ORDER_ID = @input
	;
	return @result
end
;
select	dbo.fnc_orderstatus(3)
;
select	*, dbo.fnc_orderstatus(ORDER_ID) OrderStatus
from	ORDER_TBL
;

















