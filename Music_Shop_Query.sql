/* Q1: Who is the senior most employee based on job title? */

SELECT *
FROM employee
GROUP BY employee_id
ORDER BY levels desc
limit 1

/* Q2: Which countries have the most Invoices? */

SELECT COUNT(*) as c, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY c desc

/* Q3: What are top 3 values of total invoice? */

SELECT *
FROM invoice
ORDER BY total desc
limit 3

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

SELECT billing_city,SUM(total) as t
FROM invoice 
GROUP BY billing_city
ORDER BY t desc
limit 1

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT customer.customer_id,customer.first_name,customer.last_name,SUM(total) as total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total desc 
limit 1

/* Q6: Return the email, first name, last name, & Genre of all Rock Music listeners. 
Return the list ordered alphabetically by email starting with A. */

SELECT email,first_name,last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id in (
	SELECT track_id
	FROM track
	JOIN genre on genre.genre_id = track.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER by email 

/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT artist.artist_id AS id,artist.name,COUNT(artist.artist_id) as songs_number
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY id
ORDER BY songs_number DESC
limit 10;

/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

SELECT name,milliseconds
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) as avg_song_length
	FROM track
)

/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

WITH best_selling_artist AS (
    SELECT artist.artist_id as Id,artist.name AS ArtistName,
	SUM(invoice_line.unit_price*invoice_line.quantity) AS TotalSales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY Id
	ORDER BY TotalSales DESC
	LIMIT 1
)
SELECT c.customer_id AS CustomerID,c.first_name AS FirstName,c.last_name as LastName,BSA.ArtistName AS BSAName,
SUM(IL.unit_price*IL.quantity) AS TotalPrice
FROM invoice AS I
JOIN customer AS C ON C.customer_id = I.customer_id
JOIN invoice_line AS IL ON IL.invoice_id = I.invoice_id
JOIN track AS T ON T.track_id = IL.track_id
JOIN album as ALB ON ALB.album_id = T.album_id
JOIN best_selling_artist AS BSA ON BSA.Id = alb.artist_id
GROUP BY CustomerID,FirstName,LastName,BSAName
ORDER BY TotalPrice DESC






