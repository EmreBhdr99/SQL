

--- Session 12 ----


--Row_Number()

--Assign an ordinal number to the product prices for each category in ascending order

select	product_id, category_id, list_price,
		ROW_NUMBER() over(partition by category_id order by list_price ASC) RowNum
from	product.product

;



--- Rank() and Dense_Rank()

select	product_id, category_id, list_price,
		ROW_NUMBER() over(partition by category_id order by list_price ASC) RowNum,
		Rank() over(partition by category_id order by list_price ASC) [Rank],
		Dense_Rank() over(partition by category_id order by list_price ASC) [DenseRank]
from	product.product

;

--1. Herbir model_yili içinde ürünlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)

select product_id,model_year,list_price,
	   ROW_NUMBER() over(partition by model_year order by list_price ASC) RowNum,
		Rank() over(partition by model_year order by list_price ASC) [Rank],
		Dense_Rank() over(partition by model_year order by list_price ASC) [DenseRank]
from product.product


---CUME_DIST()

-- Write a query that returns the cumulative distribution of the list price in product table by brand.


select brand_id,list_price,
		ROUND(CUME_DIST() OVER(PARTITION BY brand_id ORDER BY list_price),3) CUMDIST
from product.product


--- Percent_Rank()

select brand_id,list_price,
      ROUND(CUME_DIST() OVER(PARTITION BY brand_id ORDER BY list_price),3) CUMDIST,
	  round(Percent_Rank() over(partition by brand_id order by list_price asc),3)
from product.product

-- Yukarýdaki sorguda CUMDIST alanýný CUME_DIST fonksyonunu kullanmadan hesaplayýnýz.

select brand_id,list_price,
		count(*) over(partition by brand_id) TotalProductInBrand,
		row_number () over(partition by brand_id order by list_price) RowNum,
		rank() over(partition by brand_id order by list_price)RankNum
from product.product
order by 1,2
;


with tbl as (
	select brand_id,list_price,
		count(*) over(partition by brand_id) TotalProductInBrand,
		row_number () over(partition by brand_id order by list_price) RowNum,
		rank() over(partition by brand_id order by list_price)RankNum
	from product.product
)
select *,
		round(cast(RowNum as float) / TotalProductInBrand,3) CumDistRowNum,  --Float data type can also be provided as in the following format.
		round(1.0*RankNum / TotalProductInBrand,3) CumDistRankNum  
from tbl 

;

--List orders for which the average product price is higher than the average net amount.

with tbl as (
        SELECT  distinct order_id
                ,AVG(list_price) OVER(partition by order_id) as Avg_price
                ,AVG(quantity*list_price*(1-discount)) OVER() as Avg_net_amounth
        FROM    sale.order_item
)
SELECT  *
FROM    tbl
WHERE   Avg_price>Avg_net_amounth
ORDER BY 2


--Calculate the stores weekly cumulative nomber of orders for 2018.

select distinct a.store_id, a.store_name, -- b.order_date,
	datepart(ISO_WEEK, b.order_date) WeekOfYear,
	COUNT(*) OVER(PARTITION BY a.store_id, datepart(ISO_WEEK, b.order_date)) weeks_order,
	COUNT(*) OVER(PARTITION BY a.store_id ORDER BY datepart(ISO_WEEK, b.order_date)) cume_total_order
from sale.store A, sale.orders B
where a.store_id=b.store_id and year(order_date)='2018'
ORDER BY 1, 3
;

-- Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'

with tbl as(
select B.order_date,sum(A.quantity) SumQuantity --A.order_id,A.product_id,A.quantity
from sale.order_item A, sale.orders B
where A.order_id = B.order_id
group by b.order_date
)
select *,
		avg(SumQuantity*1.0) over(order by order_date rows between 6 preceding and current row) sales_moving_avg
from tbl
where order_date between '2018-03-12' and '2018-04-12'
order by 1

-- Eksik tarihler

with tbl as (
	select	B.order_date, sum(A.quantity) SumQuantity --A.order_id, A.product_id, A.quantity
	from	sale.order_item A, sale.orders B
	where	A.order_id = B.order_id
	group by B.order_date
)
select	*
from	(
	select	*,
		avg(SumQuantity*1.0) over(order by order_date rows between 6 preceding and current row) sales_moving_average_7
	from	tbl
) A
where	A.order_date between '2018-03-12' and '2018-04-12'
order by 1