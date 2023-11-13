# 1. Which Employee has the Highest total number of Customers?

```sql
SELECT e.LastName || ' ' || e.FirstName AS Employee, COUNT(c.customerid) AS Total_Customer
FROM Employee e
JOIN Customer c
ON e.EmployeeId = c.SupportRepId
GROUP BY 1
ORDER BY 1 DESC;
```

# 2. Who are our top Customers according to Invoices?
  
SELECT C.FirstName || ' ' || C.LastName AS Customer_Name, 
		SUM(I.Total) AS Total_spent
FROM Invoice AS I
INNER JOIN Customer  AS C
ON C.CustomerId = I.CustomerId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
