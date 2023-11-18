### 1. Which Employee has the Highest total number of Customers?

### Solution:

- CONCATENATE the last name and first name of the Employees.
- COUNT the customer ID to get the total number of customers.
  
```sql
SELECT e.LastName || ' ' || e.FirstName AS Employee, COUNT(c.customerid) AS Total_Customer
FROM Employee AS e
INNER JOIN Customer AS c
ON e.EmployeeId = c.SupportRepId
GROUP BY 1
ORDER BY 1 DESC;
```
### Output

| Employee	 |Total_Customer |
| :--------      |-----------: 	
| Peacock Jane	 |21
| Park Margaret	 |20
| Johnson Steve	 |18

### Insight:
- There are three Sales support Reps managing the customers with Peacock Jane having the highest customers of 21 and Johnson Steve with 18 total customers.
#

### 2. Who are our top Customers according to Invoices?

### Solution:
- Select the first and last names of the customers and calculate the total Sum of their invoices.
  
```sql  
SELECT 	C.FirstName || ' ' || C.LastName AS Customer_Name, 
	SUM(I.Total) AS Total_spent
FROM Invoice AS I
INNER JOIN Customer  AS C
ON C.CustomerId = I.CustomerId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```
### Output
Customer_Name	|Total_spent
|:---           |-----:
Helena Holý	|49.62
Richard Cunningham |47.62
Luis Rojas	|46.62
Ladislav Kovács	|45.62
Hugh O'Reilly	|45.62

### Insight: 
- Helena Holy, Richard Cunningham, Luis Rojas, Ladislav Kovacs, and Hugh O’Reilly are the top five customers who have spent the highest amount of money according to the invoice.
#

### 3. Who are the Rock Music Listeners? We want to know all Rock Music listeners' email, first names, last names, and Genres
### Solution:
- Select the email, first and last names of the customers, and the Genre and filter the Genre to Rock music.
  
```sql
SELECT C.Email, C.FirstName, C.LastName, G.Name AS Genre
FROM Customer C
INNER JOIN Invoice AS I
ON I.CustomerId = C.CustomerId
INNER JOIN InvoiceLine AS Il
ON Il.InvoiceId = I.InvoiceId
INNER JOIN Track AS T
ON T.TrackId = Il.TrackId
INNER JOIN Genre AS G
ON G.GenreId = T.GenreId
WHERE Genre = 'Rock'
GROUP BY 1,2,3,4
ORDER BY 1;
```
### Output:
|Email			|FirstName	|LastName	|Genre
|:---   		|:------        |:-----         |:---
aaronmitchell@yahoo.ca	|Aaron		|Mitchell	|Rock
alero@uol.com.br	|Alexandre	|Rocha		|Rock
astrid.gruber@apple.at	|Astrid		|Gruber		|Rock
bjorn.hansen@yahoo.no	|Bjørn		|Hansen		|Rock
camille.bernard@yahoo.fr|Camille	|Bernard	|Rock
daan_peeters@apple.be	|Daan		|Peeters	|Rock
diego.gutierrez@yahoo.ar|Diego		|Gutiérrez	|Rock
dmiller@comcast.com	|Dan		|Miller		|Rock
dominiquelefebvre@gmail.com |Dominique	|Lefebvre	|Rock
edfrancis@yachoo.ca	|Edward		|Francis	|Rock

### Insight:  
- We found out that all the 59 customers in the database have listened to Rock Music.
#

### 4. Who is writing the rock music?

### Solution:
- Select the Artist's name and count the number of rock music they have written.

```sql
SELECT Ar.Name As Artist, COUNT(G.name) AS Total_rock
FROM Artist AS Ar
INNER JOIN Album AS Al
ON Al.ArtistId = Ar.ArtistId
INNER JOIN Track AS T
ON T.AlbumId = Al.AlbumId
INNER JOIN Genre AS G
ON G.GenreId = T.GenreId
WHERE G.Name = 'Rock'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```
### Output: 
|Artist		|Total_rock
|:---           |-----:
Led Zeppelin	|114
U2		|112
Deep Purple	|92
Iron Maiden	|81
Pearl Jam	|54
Van Halen	|52
Queen		|45
The Rolling Stones	|41
Creedence Clearwater Revival	|40
Kiss		|		35

### Insights:
- Led Zeppelin tops the list of Artists who have written the most Rock Music with 114 songs followed Closely by U2 with 112 music.
#

### 5.	Which artist has earned the most according to the Invoice Lines? Use this artist to find which customer spent the most on this artist.

### a.	Artist that has earned the most.
### Solution:
- Select the Artist’s name and
- calculate the Total earned by multiplying the unit price by the quantity.

```sql
SELECT 	Ar.Name As Artist, 
	ROUND(SUM(T.UnitPrice *Il.Quantity),2) AS Total_earned
FROM Artist AS Ar
JOIN Album AS Al
ON Al.ArtistId = Ar.ArtistId
INNER JOIN Track AS T
ON T.AlbumId = Al.AlbumId
INNER JOIN InvoiceLine AS Il
ON Il.TrackId = T.TrackId
INNER JOIN Invoice AS I 
ON I.InvoiceId = Il.InvoiceId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```
### Output:
|Artist		|Total_earned
|:---           |----:
Iron Maiden	|138.6
U2		|105.93
Metallica	|90.09
Led Zeppelin	|86.13
Lost		|81.59

### Insight:
- The Artist who has earned the most according to the invoice lines is Iron Maiden with a total of $138.6

### b.	Customer who spent most on Iron Maiden
- Use CTE to get the Artist name, Customer ID, Customer’s name, and the Amount spent by multiplying the unit price by the quantity.
- From the CTE, select the Artist, Customer ID, Customer name, and the Amount Spent
- Insert the query written in part as a Subquery in the WHERE clause to filter the result to only the artist that has earned the most.

```sql
WITH Customer_spending AS(
			SELECT  Ar.Name As Artist,
				C.CustomerId AS Customer_Id,
				C.FirstName AS First_Name,
				C.LastName AS Last_Name,
				T.UnitPrice* Il.Quantity AS Amount_spent
			FROM Artist AS Ar
			INNER JOIN Album AS Al
			ON Al.ArtistId = Ar.ArtistId
			INNER JOIN Track AS T
			ON T.AlbumId = Al.AlbumId
			INNER JOIN InvoiceLine AS Il
			INNER ON Il.TrackId = T.TrackId
			INNER JOIN Invoice AS I 
			ON I.InvoiceId = Il.InvoiceId
			INNER JOIN Customer AS C
			ON C.CustomerId = I.CustomerId
			ORDER BY 5 DESC)
SELECT  Artist,
	Customer_Id,
	First_Name,
	Last_Name,
	SUM(Amount_spent) AS Amount_spent
FROM Customer_spending
WHERE Artist =  (SELECT Artist
		 FROM(SELECT 	Ar.Name As Artist, 
				ROUND(SUM(T.UnitPrice *Il.Quantity),2) AS Total_earned
			FROM Artist AS Ar
			INNER JOIN Album AS Al
			ON Al.ArtistId = Ar.ArtistId
			INNER JOIN Track AS T
			ON T.AlbumId = Al.AlbumId
			INNER JOIN InvoiceLine AS Il
			ON Il.TrackId = T.TrackId
			INNER JOIN Invoice AS I 
			ON I.InvoiceId = Il.InvoiceId
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 1) t1)
GROUP BY 1,2,3,4
ORDER BY 5 DESC
LIMIT 6;
```
### Output:
|Artist		|Customer_Id	|First_Name	|Last_Name	|Amount_spent
|:---           |----:          |:---           |:-----         |-----:
Iron Maiden	|55		|Mark		|Taylor		|17.82
Iron Maiden	|35		|Madalena	|Sampaio	|15.84
Iron Maiden	|16		|Frank		|Harris		|13.86
Iron Maiden	|36		|Hannah		|Schneider	|13.86
Iron Maiden	|5		|František	|Wichterlová	|8.91
Iron Maiden	|27		|Patrick	|Gray		|8.91
### Insight:
- Mark Taylor is the customer with the highest spending on our highest-earning Artist. He spent a total of $17.82.
#

### 6.	List the Tracks that have a song length greater than the Average song length.
### Solution:
- Select the name and the Milliseconds.
- Use a subquery to find the Average Song length. 
- Insert the subquery in the WHERE clause to filter the result.

```sql
SELECT  Name,
	Milliseconds AS Song_length_ms		
FROM Track
WHERE Milliseconds > (SELECT ROUND(AVG(Milliseconds),2) AS Avg_Song_length FROM Track)
```
### Output:
|Name		               |Song_length_ms
|:----                         |------:
Occupation / Precipice	       |5286953
Through a Looking Glass		|5088838
Greetings from Earth, Pt. 1	|2960293
The Man With Nine Lives		|2956998
Battlestar Galactica, Pt. 2	|2956081
Battlestar Galactica, Pt. 1	|2952702
Murder On the Rising Star	|2935894
Battlestar Galactica, Pt. 3	|2927802
Take the Celestra		|2927677
Fire In Space			|2926593
#

### 7.	Find out the most popular genre for each Country.
### Solution:
- Use a Subquery to get the Country, Genre ID, Genre name, and the number of purchases.
- Write another subquery to select the Maximum Purchase from the first subquery.
- Use the first subquery as query 3 to join the second subquery.
- Select the Country, Genre ID, Genre name, and the maximum purchase from query 2 and query 3.

```sql
SELECT 	sub2.Country,
		sub2.Purchases,
		sub3.Genre_Id,
		sub3.Genre_Name
FROM	(SELECT 	Country, MAX(purchases) as Purchases    
		 FROM	(SELECT C.Country AS Country,
				G.GenreId AS Genre_Id,
				G.Name AS Genre_Name,
				COUNT(*) AS purchases
				FROM Customer C
				JOIN Invoice I 
				ON C.CustomerId = I.CustomerId
				JOIN InvoiceLine Il
				ON I.InvoiceId = Il.InvoiceId
				JOIN Track T
				ON Il.TrackId = T.TrackId
				JOIN Genre G
				ON G.GenreId = T.GenreId
				GROUP BY 1,2,3
				ORDER BY 1) sub1 -- first subquery
		GROUP BY 1
		ORDER BY 2) sub2      --- second subquery
JOIN	(SELECT C.Country AS Country,    
		G.GenreId AS Genre_Id,
		G.Name AS Genre_Name,
		COUNT(*) AS purchases
		FROM Customer C
		JOIN Invoice I 
		ON C.CustomerId = I.CustomerId
		JOIN InvoiceLine Il
		ON I.InvoiceId = Il.InvoiceId
		JOIN Track T
		ON Il.TrackId = T.TrackId
		JOIN Genre G
		ON G.GenreId = T.GenreId
		GROUP BY 1,2,3
		ORDER BY 1) sub3 --- third query
WHERE sub2.Country = sub3.Country AND sub2.Purchases = sub3.purchases		
ORDER BY 1,4;
```
### Output:
- There are 24 countries, below is the result for the first ten rows
  
|Country	|Purchases	|Genre_Id	|Genre_Name
|:---           |----:          |----:          |:---
Argentina	|9		|4		|Alternative & Punk
Argentina	|9		|1		|Rock
Australia	|22		|1		|Rock
Austria		|15		|1		|Rock
Belgium		|21		|1		|Rock
Brazil		|81		|1		|Rock
Canada		|107		|1		|Rock
Chile		|9		|1		|Rock
Czech Republic	|25		|1		|Rock
Denmark		|21		|1		|Rock
### Insight:
- Majority of the countries have Rock music as the most Listened music.
