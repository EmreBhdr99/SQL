

SELECT	sc.customer_id, 
		sc.first_name, sc.last_name,
		pp.product_name
INTO	#main_table
FROM	sale.customer sc
JOIN	sale.orders so
		ON sc.customer_id=so.customer_id
JOIN	sale.order_item soi
		ON so.order_id=soi.order_id
JOIN	product.product pp
		ON soi.product_id=pp.product_id

select * from #main_table


--hdd table 109
select DISTINCT *
INTO	#hdd_table
from #main_table
WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' 

--hdd table 102
select DISTINCT *
INTO	#Woofer
from #main_table
WHERE product_name =  'Polk Audio - 50 W Woofer - Black' --

--hdd table  90
select DISTINCT *
INTO	#Subwoofer 
from #main_table
WHERE product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' 

--hdd table  95
select DISTINCT *
INTO	#Speakers
from #main_table
WHERE product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'  



select *
from		#hdd_table as hdd
LEFT JOIN	#Woofer as w
			ON hdd.customer_id=w.customer_id
LEFT JOIN	#Subwoofer as sw
			ON hdd.customer_id=sw.customer_id
LEFT JOIN	#Speakers as s
			ON hdd.customer_id=s.customer_id



select		hdd.customer_id, hdd.first_name, hdd.last_name,
			IIF(w.product_name='Polk Audio - 50 W Woofer - Black', 'Yes','No') as First_product,
			IIF(sw.product_name= 'SB-2000 12 500W Subwoofer (Piano Gloss Black)', 'Yes','No' ) as Second_product,
			IIF(s.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)', 'Yes','No'  ) as Third_product
from		#hdd_table as hdd
LEFT JOIN	#Woofer as w
			ON hdd.customer_id=w.customer_id
LEFT JOIN	#Subwoofer as sw
			ON hdd.customer_id=sw.customer_id
LEFT JOIN	#Speakers as s
			ON hdd.customer_id=s.customer_id