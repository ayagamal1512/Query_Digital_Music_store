/* Query 1 */ Which countries have the most Invoices for each unit price?

SELECT
  i.BillingCountry, il.UnitPrice,
  COUNT(*) AS Invoices 
FROM invoice as i
JOIN InvoiceLine as il
ON il.InvoiceId = i.InvoiceId
GROUP BY 1 , 2
ORDER BY 3 DESC;

/* Query 2 */  Which city has the best customers ?
SELECT
  BillingCity AS city,c.Country,
  SUM(total) AS total_invoices
FROM Invoice i
JOIN Customer c
ON c.CustomerId = i.CustomerId
GROUP BY city
ORDER BY total_invoices DESC
LIMIT 1;

/* Query 3 */  Write a query that determines the customer that has spent the most on music for each country. 

WITH t1
AS (SELECT
  Country,
  FirstName,
  LastName,
  SUM(i.Total) AS TotalSpent,
  i.CustomerId
FROM Customer c
JOIN Invoice i
  ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId)

SELECT
  t1.*
FROM t1
JOIN (SELECT
  Country,
  MAX(TotalSpent) AS TotalSpent,
  CustomerId
FROM t1
GROUP BY Country) t2
  ON t1.Country = t2.Country
WHERE t1.TotalSpent = t2.TotalSpent
ORDER BY Country;

/* Query 4 */ Write a query that returns the Artist name and total track count of the top 10 rock bands.

 SELECT
  al.NAME AS Album_name,
  COUNT(t.NAME) Track_name
FROM TRACK t
JOIN GENRE g
  ON t.GENREID = g.GENREID
JOIN ALBUM al
  ON al.ALBUMID = t.ALBUMID
JOIN ARTIST a
  ON a.ARTISTID = al.ARTISTID
WHERE g.NAME = 'Rock'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10 ;


* Query 5 */ find which artist has earned the most according to the InvoiceLines?

SELECT
  t2.NAME AS artist_name,
  SUM(TOTAL) AS grand_total
FROM (SELECT
  t1.NAME,
  t1.UNITPRICE * t1.QUANTITY AS total
FROM (SELECT
  a.NAME,
  il.UNITPRICE,
  il.QUANTITY
FROM ARTIST a
JOIN ALBUM al
  ON a.ARTISTID = al.ARTISTID
JOIN TRACK t
  ON al.ALBUMID = t.ALBUMID
JOIN INVOICELINE il
  ON t.TRACKID = il.TRACKID
ORDER BY 1 DESC) AS t1) AS t2
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10 ;
 

/* Query 6 */ /*Use your query to return the email, first name, last name of listners and count of all Rock Music tracks.Return your list ordered alphabetically by email address starting with A.*/

SELECT DISTINCT
  c.EMAIL,
  c.FIRSTNAME,
  c.LASTNAME,
  g.NAME,
  COUNT(*) total_tracks
FROM CUSTOMER c
JOIN INVOICE i
  ON c.CUSTOMERID = i.CUSTOMERID
JOIN INVOICELINE il
  ON il.INVOICELINEID = i.INVOICEID
JOIN TRACK t
  ON il.TRACKID = t.TRACKID
JOIN GENRE g
  ON t.GENREID = g.GENREID
WHERE g.NAME = 'Rock'
GROUP BY 2,3
ORDER BY 1;

/*Query 7 What is the most popular music gener in each country?*/
-- the most popular music gener is determined by the highest purchases (the number of invoiceline)
with 
t1 as(SELECT c.country,g.Name as gener,count(*) as purchase_per_gener
FROM invoiceline il
JOIN invoice as i
ON i.InvoiceId = il.InvoiceId
JOIN customer as c
ON c.CustomerId = i.CustomerId
JOIN track as t 
ON t.TrackId = il.TrackId
JOIN genre as g 
ON g.GenreId = t.GenreId
group by 1,2
order by 3 desc),
--then we get the max number of gener invoiceline for each country to make sure that we get the "highest per country"
t2 as (select max(purchase_per_gener)as max_gener_per_country,country
from t1
group by 2
order by 1 desc)
--this is essential since we only interseted in one highest gener for one country  
SELECT t1.*
from t1
join t2 on t1.Country = t2.Country
where t1.purchase_per_gener = t2.max_gener_per_country 




