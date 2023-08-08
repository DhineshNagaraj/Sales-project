SELECT * FROM sql_project.sales_data_sample;
SELECT * FROM proj.sales_data_sample;
rename table proj.sales_data_sample to sample;
create database proj;
use proj;
select * from sample;

-- why cant i use the alias name in datediff and in concate--

-- checcking all the unqiue values -- 
select distinct(customername) from sample;
select distinct(productline) from sample;
select distinct(year_id) from sample;
select distinct(country) from sample;
select distinct(territory) from sample;
select distinct(dealsize) from sample;
select distinct(status) from sample;

-- which product has the most no of sales--
select  productline, sum(sales) revenue from sample group by 1 order by 2 desc;

-- which year made the most sales--
select  year_id, sum(sales) revenue from sample group by 1 order by 2 desc;

-- which deal size made the most sales--
select  dealsize, sum(sales) revenue from sample group by 1 order by 2 desc;

-- which month made most of the sales in each year--
select * from sample;
select year_id,month_id,sum(sales), count(ordernumber) from sample group by year_id,month_id order by 1,3 desc ;
select month_id,sum(sales),count(ordernumber) from sample where year_id = "2003" group by month_id order by sum(sales) desc ;
select month_id,sum(sales),count(ordernumber) from sample where year_id = "2004" group by month_id order by sum(sales) desc ;
select month_id,sum(sales),count(ordernumber) from sample where year_id = "2005" group by month_id order by sum(sales) desc ;

-- november has the most sales ans we are looking at the product line which makes the most sales in the given month --
select month_id, sum(sales), count(ordernumber), productline 
from sample where month_id = "11" group by productline order by sum(sales) desc ;

-- whos is the best customer --
select customername, orderdate, sum(ordernumber) volume, sum(sales) tot_sales 
from sample group by customername, orderdate order by volume desc,tot_sales desc;

select customername, max(orderdate), sum(ordernumber) volume, sum(sales) tot_sales 
from sample group by customername, orderdate order by volume desc,tot_sales desc;

select customername, min(orderdate), sum(ordernumber) volume, sum(sales) tot_sales 
from sample group by customername, orderdate order by volume desc,tot_sales desc;

select orderdate from sample order by orderdate desc;

SELECT max(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) AS converted_orderdate
FROM sample
ORDER BY converted_orderdate DESC;


SELECT ordernumber,CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE) AS converted_orderdate
FROM sample where year_id="2005"
ORDER BY 1,converted_orderdate DESC;

SELECT ordernumber,CAST(STR_TO_DATE(orderdate, '%d/%m/%Y') AS DATE) AS converted_orderdate
FROM sample where year_id="2005"
ORDER BY 1,converted_orderdate DESC;

-- BEST CUSTOMER --
select * from sample;
select customername, 
sum(quantityordered) volume, 
avg(sales) avg_sales , 
sum(sales) tot_sales, 
max(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) AS last_purchase_date, 
(select max(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) max_date from sample ) max_date,
datediff((select max(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) max_date from sample ),
max(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE))) as date_diff
from sample group by customername ;



SELECT 
    customername,
    SUM(ordernumber) AS Frequency,
    AVG(sales) AS avg_sales,
    SUM(sales) AS Monetary,
    MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) AS last_purchase_date,
    (SELECT MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) FROM sample) AS max_date,
    DATEDIFF((SELECT MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) FROM sample),
             MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE))) AS Recency
FROM sample
GROUP BY customername;


create view all_table as 
SELECT
    customername,
    Frequency,
    avg_sales AS avg_sales,
    Monetary,
    last_purchase_date,
    Recency,
    NTILE(3) OVER (ORDER BY Recency) AS R_Pct,
    NTILE(3) OVER (ORDER BY Frequency) AS F_Pct,
    NTILE(3) OVER (ORDER BY Monetary) AS M_Pct,
     concat(R_Pct, ' ', F_Pct, ' ', M_Pct, ' ') as combination
FROM (
    SELECT 
        customername,
        SUM(ordernumber) AS Frequency,
        AVG(sales) AS avg_sales,
        SUM(sales) AS Monetary,
        MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) AS last_purchase_date,
        DATEDIFF((SELECT MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) FROM sample), MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE))) AS Recency
    FROM sample
    GROUP BY customername
)as sub_query;

drop view all_table;
select *, concat(R_Pct, ' ', F_Pct, ' ', M_Pct, ' ') from all_table;

select * from all_table;









SELECT
    customername,
    Frequency,
    avg_sales AS avg_sales,
    Monetary,
    last_purchase_date,
    Recency,
    NTILE(3) OVER (ORDER BY Recency) AS R_Pct,
    NTILE(3) OVER (ORDER BY Frequency) AS F_Pct,
    NTILE(3) OVER (ORDER BY Monetary) AS M_Pct,
concat(R_Pct, ' ', F_Pct, ' ', M_Pct, ' ') as combination
FROM (
    SELECT 
        customername,
        SUM(ordernumber) AS Frequency,
        AVG(sales) AS avg_sales,
        SUM(sales) AS Monetary,
        MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) AS last_purchase_date,
        DATEDIFF((SELECT MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) FROM sample), MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE))) AS Recency,
        concat(R_Pct, ' ', F_Pct, ' ', M_Pct, ' ') as combination
    FROM sample
    GROUP BY customername
)as sub_query;


create view all_data as
SELECT
    customername,
    Frequency,
    avg_sales AS avg_sales,
    Monetary,
    last_purchase_date,
    Recency,
    NTILE(3) OVER (ORDER BY Recency desc ) AS R_Pct,
    NTILE(3) OVER (ORDER BY Frequency) AS F_Pct,
    NTILE(3) OVER (ORDER BY Monetary ) AS M_Pct ,
    NTILE(3) OVER (ORDER BY Recency desc) + NTILE(3) OVER (ORDER BY Frequency)  + NTILE(3) OVER (ORDER BY Monetary)  as sum_of_pct	,
    concat(NTILE(3) OVER (ORDER BY Recency desc), NTILE(3) OVER (ORDER BY Frequency), NTILE(3) OVER (ORDER BY Monetary)) as combination
FROM (
    SELECT 
        customername,
        count(ordernumber) AS Frequency,
        AVG(sales) AS avg_sales,
        SUM(sales) AS Monetary,
        MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) AS last_purchase_date,
        DATEDIFF((SELECT MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) FROM sample), MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE))) AS Recency
	
    FROM sample
    GROUP BY customername
) as sub_query;

select * from sample;

select distinct(combination) from all_data ;

select count(R_pct), R_pct from all_data group by 2 ;
select count(f_pct), f_pct from all_data group by 2 ;
select count(m_pct), m_pct from all_data group by 2 ;

select distinct(sum_of_pct) from all_data;

drop view all_data;

select 
case  
when sum_of_pct in (9,8,7) then "best customer"
when sum_of_pct in (6,5) then "new customer"
when sum_of_pct in (4,3) then "lost customer"
end as cutomer_type;

-- what products are sold together --
select * from sample;
select ordernumber,count(productline) from sample where status = "shipped" group by ordernumber;

-- how many products where placed in tat particular order --
select * from sample where ordernumber = 10107;

select ordernumber,a 
from (
	select ordernumber,count(productline) as a
    from sample 
    where status = "shipped" 
    group by ordernumber
    ) as subquery
 where a = 2;
 
 SELECT ordernumber
FROM (
    SELECT ordernumber, COUNT(productline) AS productline_count
    FROM sample
    WHERE status = 'shipped'
    GROUP BY ordernumber
) AS subquery
WHERE productline_count = 2;

ALTER DATABASE proj CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
use proj;
show tables;

select * from all_data;
create view all_table as  
SELECT
    customername,
    Frequency,
    avg_sales AS avg_sales,
    Monetary,
    last_purchase_date,
    Recency,
    NTILE(3) OVER (ORDER BY Recency desc ) AS R_Pct,
    NTILE(3) OVER (ORDER BY Frequency) AS F_Pct,
    NTILE(3) OVER (ORDER BY Monetary ) AS M_Pct ,
    NTILE(3) OVER (ORDER BY Recency desc) + NTILE(3) OVER (ORDER BY Frequency)  + NTILE(3) OVER (ORDER BY Monetary)  as sum_of_pct	,
    concat(NTILE(3) OVER (ORDER BY Recency desc), NTILE(3) OVER (ORDER BY Frequency), NTILE(3) OVER (ORDER BY Monetary)) as combination
FROM (
    SELECT 
        customername,
        count(ordernumber) AS Frequency,
        AVG(sales) AS avg_sales,
        SUM(sales) AS Monetary,
        MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) AS last_purchase_date,
        DATEDIFF((SELECT MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE)) FROM sample), MAX(CAST(STR_TO_DATE(orderdate, '%m/%d/%Y') AS DATE))) AS Recency
    FROM sample
    GROUP BY customername
) as sub_query;

create view customer_range as
select *,
case  
when sum_of_pct in (9,8,7) then "best customer"
when sum_of_pct in (6,5) then "new customer"
when sum_of_pct in (4,3) then "lost customer"
end as cutomer_type from all_table as cutomer_type;

select * , concate(addressline1," ", addressline2)  from sample;
select * from all_table;
select * from customer_range;
select *,concat(addressline1," ", addressline2) as full_address from sample ;
update state from sample as "others" where state = "" from sample;







 