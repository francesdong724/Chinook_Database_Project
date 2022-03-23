-- returns each country along with the top Genre. For countries where the maximum number of purchases is shared, return all Genres.
with etc as(SELECT count(Invoice.InvoiceId) as Purchases,Country,Genre.name,Genre.GenreId
FROM Invoice
JOIN Customer ON Customer.CustomerId=Invoice.CustomerId
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
JOIN Track ON Track.TrackId=InvoiceLine.TrackId
JOIN Genre ON Genre.GenreId=Track.GenreId
GROUP by 2,3,4
Order BY 2 ,1 DESC)
SELECT Purchases,Country,name,GenreId
FROM(
SELECT *,dense_rank() OVER (PARTITION BY Country Order BY Purchases DESC ) as rk
FROM etc) t1
WHERE t1.rk=1

--determines the customer that has spent the most on music for each country
with etc as (SELECT Country,FirstName,LastName,Customer.CustomerId,SUM(Total) as total_spend
FROM Customer
JOIN Invoice ON Invoice.CustomerId=Customer.CustomerId
GROUP BY 4)

SELECT Country,FirstName,LastName,CustomerId,total_spend
FROM(SELECT *,dense_rank() over (partition by Country order by total_spend desc) rk
FROM etc) t1
Where t1.rk=1

--Return all the track names that have a song length longer than the average song length. & Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
SELECT Name,Milliseconds
FROM Track
where milliseconds > (SELECT AVG(milliseconds) FROM Track)
ORDER BY 2 DESC

--Number of Customers served per Employee
SELECT Employee.FirstName,Employee.LastName,COUNT(InvoiceId)
FROM Employee
JOIN Customer ON Employee.EmployeeId=Customer.SupportRepId
JOIN Invoice ON Customer.CustomerId=Invoice.CustomerId
Group By Employee.EmployeeId

--the most famous music genre type in each Country
with etc as(SELECT count(Invoice.InvoiceId) as Purchases,Country,Genre.name,Genre.GenreId
FROM Invoice
JOIN Customer ON Customer.CustomerId=Invoice.CustomerId
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
JOIN Track ON Track.TrackId=InvoiceLine.TrackId
JOIN Genre ON Genre.GenreId=Track.GenreId
GROUP by 2,3,4
Order BY 2 ,1 DESC)
SELECT Purchases,Country,name,GenreId
FROM(
SELECT *,dense_rank() OVER (PARTITION BY Country Order BY Purchases DESC ) as rk
FROM etc) t1
WHERE t1.rk=1

-- analyse who is the most popular rock stars
with etc as (SELECT Artist.Name,count(Artist.ArtistId) as Purchases,Country,Genre.name,Genre.GenreId
FROM Invoice
JOIN Customer ON Customer.CustomerId=Invoice.CustomerId
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
JOIN Track ON Track.TrackId=InvoiceLine.TrackId
JOIN Genre ON Genre.GenreId=Track.GenreId
JOIN Album On Track.AlbumId=Album.AlbumId
JOIN Artist On Album.ArtistId=Artist.ArtistId
Group BY 3,1
HAVING genre.Name='Rock'
ORDER BY 2 DESC)

SELECT Name,Purchases,Country
FROM(
SELECT *,dense_rank() OVER (PARTITION BY Country Order BY Purchases DESC ) as rk
FROM etc) t1
WHERE t1.rk=1

--analyse the most popular music media type
SELECT MediaType.Name,count(Invoice.InvoiceId)
FROM Invoice
JOIN InvoiceLine On Invoice.InvoiceId=InvoiceLine.InvoiceId
JOIN Track ON InvoiceLine.TrackId=Track.TrackId
JOIN MediaType ON Track.MediaTypeId=MediaType.MediaTypeId
GROUP BY 1


